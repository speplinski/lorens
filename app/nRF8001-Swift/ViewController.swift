//
//  ViewController.swift
//  nRF8001-Swift
//
//  Created by Michael Teeuw on 31-07-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit



class ViewController: UIViewController, NRFManagerDelegate {
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    var nrfManager:NRFManager!
    //var feedbackView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nrfManager = NRFManager(
            onConnect: {
                self.log("C: ★ Connected")
            },
            onDisconnect: {
                self.log("C: ★ Disconnected")
            },
            onData: {
                (data:NSData?, string:String?)->() in
                self.log("C: ⬇ Received data - String: \(string) - Data: \(data)")
            },
            autoConnect: true
        )

        nrfManager.verbose = true
        nrfManager.delegate = self

        setupUI()
    }
    
    var timer2 = NSTimer();
    var timer3 = NSTimer();
    var timer4 = NSTimer();
    
    func onPress2()
    {
        timer2 = NSTimer.scheduledTimerWithTimeInterval( 0.1, target:self, selector: Selector("sendData2"), userInfo: nil, repeats: true )
    }
    
    func onPress3()
    {
        timer3 = NSTimer.scheduledTimerWithTimeInterval( 0.1, target:self, selector: Selector("sendData3"), userInfo: nil, repeats: true )
    }
    
    func onPress4()
    {
        timer4 = NSTimer.scheduledTimerWithTimeInterval( 0.1, target:self, selector: Selector("sendData4"), userInfo: nil, repeats: true )
    }
    
    func onRelease2()
    {
        timer2.invalidate()
    }
    
    func onRelease3()
    {
        timer3.invalidate()
    }
    
    func onRelease4()
    {
        timer4.invalidate()
    }
    
    func sendData2()
    {
        let string = "2"
        let result = self.nrfManager.writeString(string)
        log("⬆ Sent string: \(string) - Result: \(result)")
    }
    
    func sendData3()
    {
        let string = "3"
        let result = self.nrfManager.writeString(string)
        log("⬆ Sent string: \(string) - Result: \(result)")
    }
    
    func sendData4()
    {
        let string = "4"
        let result = self.nrfManager.writeString(string)
        log("⬆ Sent string: \(string) - Result: \(result)")
    }
}

extension ViewController
{
    func nrfDidConnect(nrfManager:NRFManager)
    {
        self.log("D: ★ Connected")
    }
    
    func nrfDidDisconnect(nrfManager:NRFManager)
    {
        self.log("D: ★ Disconnected")
    }
    
    func nrfReceivedData(nrfManager:NRFManager, data: NSData?, string: String?) {
        self.log("D: ⬇ Received data - String: \(string) - Data: \(data)")
    }
}

extension ViewController {
    func setupUI()
    {
        button2.addTarget(self, action: "onPress2", forControlEvents: UIControlEvents.TouchDown)
        button2.addTarget(self, action: "onRelease2", forControlEvents: UIControlEvents.TouchUpInside)
        button2.addTarget(self, action: "onRelease2", forControlEvents: UIControlEvents.TouchUpOutside)
        
        button3.addTarget(self, action: "onPress3", forControlEvents: UIControlEvents.TouchDown)
        button3.addTarget(self, action: "onRelease3", forControlEvents: UIControlEvents.TouchUpInside)
        button3.addTarget(self, action: "onRelease3", forControlEvents: UIControlEvents.TouchUpOutside)
        
        button4.addTarget(self, action: "onPress4", forControlEvents: UIControlEvents.TouchDown)
        button4.addTarget(self, action: "onRelease4", forControlEvents: UIControlEvents.TouchUpInside)
        button4.addTarget(self, action: "onRelease4", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    func log(string:String)
    {
        println(string)
    }
    
}

