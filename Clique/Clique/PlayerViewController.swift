//
//  PlayerViewController.swift
//  Clique
//
//  Created by Phil Hawkins on 1/20/16.
//  Copyright © 2016 Phil Hawkins. All rights reserved.
//

import UIKit
import MediaPlayer
import youtube_ios_player_helper
import SwiftyJSON
import SDWebImage

class PlayerViewController: UIViewController, YTPlayerViewDelegate {
    
    //let system = MPMusicPlayerController.applicationMusicPlayer()
    //let list = MPMediaItemCollection()
    
    var isyoutube = true
    var ytid = String()
    var picurl = String()

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var player: YTPlayerView!
    
    @IBOutlet weak var songlabel: UILabel!
    @IBOutlet weak var artistlabel: UILabel!
    @IBOutlet weak var albumlabel: UILabel!
    
    @IBOutlet weak var videobutton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        image.image = UIImage(named: "genericart.png")
        //image.contentMode = .ScaleAspectFit
        
        player.delegate = self

        player.loadWithVideoId("oMP-X1USOFE", playerVars: ["playsinline": 1, "autohide": 1, "autoplay": 1, "rel": 0, "showinfo": 0, "modestbranding": 1])
        /*
        player.loadWithPlayerParams(["playsinline": 1, "autohide": 1, "autoplay": 1, "rel": 0, "showinfo": 0, "modestbranding": 1])
        //player.webView.allowsInlineMediaPlayback = true
        //player.cueVideoById("oMP-X1USOFE", startSeconds: 0, suggestedQuality: YTPlaybackQuality.Auto)
        //player.playVideo()
        */
        
        fetch()
    }
    
    func fetch() {
        //pull db into list mediacollection
        //if its a local song, add it to list, set is youtube to false
        //if its a youtube song, add a nil to list, pull from ytlist, set isyoutube to true
        
        if isyoutube {
            videobutton.enabled = true
        } else {
            videobutton.title = "Show Video"
            videobutton.enabled = false
        }
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
        session.dataTaskWithURL(NSURL(string: "https://api.spotify.com/v1/search?q=track:given+the+chance%20artist:the+kite+string+tangle&type=track&limit=1")!, completionHandler: {(data, response, error) in
            if data == nil {
                print("no data")
                return
            }
            let json = JSON(data: data!)
            
            var song = String?()
            var artist = String?()
            var album = String?()
            var cover = String?()
            
            song = json["tracks"]["items"][0]["name"].string
            artist = json["tracks"]["items"][0]["artists"][0]["name"].string
            album = json["tracks"]["items"][0]["album"]["name"].string
            cover = json["tracks"]["items"][0]["album"]["images"][0]["url"].string
            
            dispatch_async(dispatch_get_main_queue(), {
                if song != nil {self.songlabel.text = song} else {self.songlabel.text = "No Title"}
                if artist != nil {self.artistlabel.text = artist} else {self.artistlabel.text = "No Artist"}
                if album != nil {self.albumlabel.text = album} else {self.albumlabel.text = "No Album"}
                
                if cover != nil {self.image.sd_setImageWithURL(NSURL(string: cover!))}
                
                currentsong = (self.songlabel.text!, self.artistlabel.text!, cover)
                //print("poop")
            })
        }).resume()
        
        nowplaying = true
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        player.playVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func videoButton(sender: AnyObject) {
        if videobutton.title == "Show Video" {
            player.hidden = false
            videobutton.title = "Hide Video"
        } else if videobutton.title == "Hide Video" {
            player.hidden = true
            videobutton.title = "Show Video"
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        if isyoutube {
            let warning = UIAlertController(title: "Warning", message: "Leaving the Player while a YouTube link is playing will stop playback", preferredStyle: .ActionSheet)
            warning.addAction(UIAlertAction(title: "Leave Anyways", style: UIAlertActionStyle.Destructive, handler: {action in self.dismissViewControllerAnimated(true, completion: nil)}))
            warning.addAction(UIAlertAction(title: "Nevermind", style: .Cancel, handler: {action in }))
            self.showViewController(warning, sender: self)
            return
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
