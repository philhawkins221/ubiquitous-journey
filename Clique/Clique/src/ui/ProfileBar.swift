//
//  ProfileBar.swift
//  Clique
//
//  Created by Phil Hawkins on 12/5/17.
//  Copyright © 2017 Phil Hawkins. All rights reserved.
//

import UIKit

class ProfileBar: UIView {
    
    //MARK: - storyboard outlets

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var usernamelabel: UIButton!
    @IBOutlet weak var sublinelabel: UILabel!
    @IBOutlet weak var profpic: UIImageView!
    @IBOutlet weak var opencloselabel: UIButton!
    
    //MARK: - properties
    
    var controller = UIViewController()
    var client: User?
    
    enum Message: String {
        case generic = "start a wave"
        case peopleListening
        case nowPlaying
        case requests
        case listening
        case createUsername = "tap to change"
    }
    
    //MARK: - initializers
    
    override init(frame: CGRect) { //editing in code
        super.init(frame: frame)
        create()
    }
    
    required init?(coder aDecoder: NSCoder) { //editing in interface builder
        super.init(coder: aDecoder)
        create()
    }
    
    //MARK: - factory
    
    private func create() {
        Bundle.main.loadNibNamed("ProfileBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        usernamelabel.contentVerticalAlignment = .bottom
        
        profpic.layer.cornerRadius = profpic.frame.size.width / 2
        profpic.clipsToBounds = true
    }
    
    //MARK: - actions
    
    func manage(profile: User) {
        client = profile
        
        display(username: profile.username)
        
        if profile.username == "anonymous" && profile.me() {
            display(subline: .createUsername)
        } else if profile.queue.current != nil && profile.queue.listeners.count < 2 {
            display(subline: .nowPlaying)
        } else if profile.queue.current != nil && profile.queue.listeners.count > 1 {
            display(subline: .peopleListening)
        }
        
        display(subline: .generic)
    }
    
    func display(username: String) {
        DispatchQueue.main.async { [unowned self] in
            self.usernamelabel.setTitle("@" + username, for: .normal)
        }
    }
    
    func display(subline: Message) {
        let execute: () -> ()
        
        switch subline {
        case .generic:
            execute = { [unowned self] in
                self.sublinelabel.text = Message.generic.rawValue
            }
            
        case .peopleListening:
            if let client = client {
                execute = { [unowned self] in self.sublinelabel.text = client.queue.listeners.count.description + " people listening" }
            } else {
                execute = { [unowned self] in self.sublinelabel.text = "0 people listening" }
            }
                
        case .nowPlaying:
            if let current = client?.queue.current {
                execute = { [unowned self] in self.sublinelabel.text = "🔊" + current.artist.name + " - " + current.title }
            } else {
                display(subline: .generic)
                execute = { return }
            }
                
        case .requests: execute = { return }
            
        case .createUsername:
            execute = { [unowned self] in self.sublinelabel.text = Message.createUsername.rawValue }
            
        case .listening:
            if let leader = q.manager?.client(), !leader.me() {
                execute = { [unowned self] in self.sublinelabel.text = "listening to @" + leader.username }
            } else if let leader = q.manager?.client(), leader.me() {
                display(subline: .nowPlaying)
                execute = { return }
            } else {
                display(subline: .generic)
                execute = { return }
            }
        }
        
        DispatchQueue.main.async { execute() }
    }
    
    //MARK: - storyboard actions
    
    @IBAction func usernametap(_ sender: Any) {
        guard let client = client else { return }
        if client.me() { Alerts.rename(user: self, on: controller) }
    }
    
    @IBAction func openclose(_ sender: Any) {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}