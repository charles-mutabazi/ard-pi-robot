//
//  ViewController.swift
//  ArdRasp
//
//  Created by Charl on 5/6/16.
//  Copyright © 2016 Octans Corp. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class ViewController: UIViewController {
    let socket = SocketIOClient(socketURL: NSURL(string:"http://10.10.1.100:3030")!)
    
    @IBOutlet weak var socStatus: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var backward: UIButton!
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    var stopped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        forward.addTarget(self, action: #selector(ViewController.fbReleased(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        backward.addTarget(self, action: #selector(ViewController.fbReleased(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        left.addTarget(self, action: #selector(ViewController.leftRightRelease(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        right.addTarget(self, action: #selector(ViewController.leftRightRelease(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        
        forward.addTarget(self, action: #selector(ViewController.forwardPressed(_:)), forControlEvents: UIControlEvents.TouchDown)
        backward.addTarget(self, action: #selector(ViewController.backPressed(_:)), forControlEvents: UIControlEvents.TouchDown)
        left.addTarget(self, action: #selector(ViewController.leftPressed(_:)), forControlEvents: UIControlEvents.TouchDown)
        right.addTarget(self, action: #selector(ViewController.rightPressed(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        socket.on("connect") {data, ack in
            print("socket connected")
            self.socStatus.text = "Connected 😀"
        }
        
        socket.on("server_exit") { (data, ack) in
            self.socStatus.text = "Reconnecting... 😔"
        }
        
        socket.connect()
    }
    
    func forwardPressed(sender: UIButton) {
        if !stopped {
            socket.emit("forward", "Forward")
            messageLabel.text = "Forward"
        }
    }
    
    func backPressed(sender: UIButton) {
        if !stopped {
            socket.emit("backward", "Backward")
            messageLabel.text = "Backwards"
        }
    }
    
    func leftPressed(sender: UIButton) {
        if !stopped {
            socket.emit("left_turn", "Left Turn")
            messageLabel.text = "Left Turn"
        }
    }
    
    func rightPressed(sender: UIButton) {
        if !stopped {
            socket.emit("right_turn", "Right Turn")
            messageLabel.text = "Right Turn"
        }
    }
    
    func leftRightRelease(sender: UIButton) {
        if !stopped {
            socket.emit("centre", "Centered Motor")
            messageLabel.text = ""
        }
    }
    
    func fbReleased(sender: UIButton) {
        if !stopped {
            socket.emit("brake", "Brake")
            messageLabel.text = "Brakes"
        }
    }
    
    
    
    @IBAction func stopBtn(sender: UIButton) {
        // print("button clicked....")
        if stopped {
            socket.emit("ignite", "Ignited")
            stopped = false
            sender.setTitle("Stop", forState: .Normal)
            sender.backgroundColor = UIColor.orangeColor()
            //sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            messageLabel.text = "Ignited"
            
            
        }else{
            socket.emit("stop", "Stopped")
            stopped = true
            sender.setTitle("Ignite", forState: .Normal)
            sender.backgroundColor = UIColor.redColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            messageLabel.text = "Stopped"
        }
    }

}

