//
//  ViewController.swift
//  TestAppleWatch
//
//  Created by peerapat atawatana on 11/30/2559 BE.
//  Copyright © 2559 DaydreamClover. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreLocation

class ViewController: UIViewController, WCSessionDelegate, CLLocationManagerDelegate {

    // MARK : Local variable
    
    var counter:Int = 0
    var session:WCSession!
    let locationManager = CLLocationManager()
    
    // MARK : IBOutlet
    
    @IBOutlet weak var debugLbl:UILabel!
    @IBOutlet weak var selfCounterLbl:UILabel!
    @IBOutlet weak var locationCoorLbl:UILabel!
    
    // MARK : IBAction
    
    @IBAction func didClickOnSend() {
        let message = ["Param1":counter]
        session.sendMessage(message, replyHandler: nil , errorHandler: errorHandler)
    }
    
    @IBAction func didClickOnIncrease() {
        increaseCounter()
    }
    
    
    
    // MARK : Handler
    
    func replyHandler(recievedDict:[String:Any]) {
        print(recievedDict)
        
        if let recievedCounter = recievedDict["Param1"] as? Int {
            setDebugText(text: recievedCounter.description)
        }
    }
    
    func errorHandler(error:Error) {
        print(error)
        
        
        print("MY Error = "  + error.localizedDescription)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Session Support = " + WCSession.isSupported().description)
        
        //if (WCSession.isSupported()) {
            session             = WCSession.default()
            session.delegate    = self
            session.activate()
        //}
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK : Action
    
    func increaseCounter() {
        counter += 1
        setCounterText(counter: counter)
    }
    
    func setDebugText(text:String) {
        debugLbl.text = "Recieved Message : " + text
    }
    
    func setCounterText(counter:Int) {
        selfCounterLbl.text = "Self Counter : " + counter.description
    }

    // MARK : Delegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        /*if let recievedCounter = message["Param1"] as? Int {
            setDebugText(text: recievedCounter.description)
        }*/
        //print("Call")
        replyHandler(["CurrentDateTime":Date()])
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Message = " + message.description)
        
        
        DispatchQueue.main.async {
            if let recievedCounter = message["Param1"] as? Int {
                self.setDebugText(text: recievedCounter.description)
            }
        }
    }
    
    // MARK : Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }
        
        print(locations[0].coordinate)
        
        locationCoorLbl.text = locations[0].coordinate.latitude.description + " , " + locations[0].coordinate.longitude.description
        //setDebugText(text:  locations[0].coordinate.latitude.description + " , " + locations[0].coordinate.longitude.description)
    }
}

