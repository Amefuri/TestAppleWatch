//
//  InterfaceController.swift
//  TestAppleWatch WatchKit Extension
//
//  Created by peerapat atawatana on 11/30/2559 BE.
//  Copyright © 2559 DaydreamClover. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion
import CoreLocation

class InterfaceController: WKInterfaceController, WCSessionDelegate, CLLocationManagerDelegate {

    // MARK : Local variable
    
    var counter:Int = 0
    var session:WCSession!
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    
    // MARK : IBOutlet
    
    @IBOutlet weak var debugLbl:WKInterfaceLabel!
    @IBOutlet weak var fetchDataLbl:WKInterfaceLabel!
    @IBOutlet weak var selfCounterLbl:WKInterfaceLabel!
    
    // MARK : IBAction
    
    @IBAction func didClickOnSend() {
        let message = ["Param1":counter]
        session.sendMessage(message, replyHandler: nil , errorHandler: errorHandler)
    }
    
    @IBAction func didClickOnIncrease() {
        increaseCounter()
    }
    
    @IBAction func didClickOnGo() {
        pushController(withName: "ScreenMockCompass", context: nil)
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
    }
    
    // MARK : Application lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        motionManager.gyroUpdateInterval = 0.1
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session             = WCSession.default()
            session.delegate    = self
            session.activate()
        }
        
        //setDebugText(text: motionManager.gyroData?.description ?? "")
        
        //if(motionManager.isGyroAvailable) {
         //   print(motionManager.gyroData ?? "NO gyro data")
          //  setDebugText(text:  (motionManager.gyroData?.description) ?? "")
        //}
        
        
        /*let queue = OperationQueue.main
        motionManager.startGyroUpdates(to: queue) {
            (data, error) in
            self.setDebugText(text: data?.description ?? "")
        }*/
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestLocation()
        //locationManager.startUpdatingLocation()
        
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchDataFromApp), userInfo: nil, repeats: true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK : Action
    
    func increaseCounter() {
        counter += 1
        setCounterText(counter: counter)
    }
    
    func setDebugText(text:String) {
        debugLbl.setText("Recieved Message : " + text)
    }
    
    func setCounterText(counter:Int) {
        selfCounterLbl.setText("Self Counter : " + counter.description)
    }
    
    func fetchDataFromApp() {
        session.sendMessage([:], replyHandler: fetchDataReplyHandler, errorHandler: fetchDataErrorHandler)
    }
    
    func fetchDataReplyHandler(resultDict:[String:Any]) {
        print(resultDict)
        if let recievedDateTime = resultDict["CurrentDateTime"] as? Date {
            fetchDataLbl.setText(Helper.stringFromDate(date: recievedDateTime, format: "HH:mm:ss.SSS"))
            //fetchDataLbl.setText(recievedDateTime)
        }
    }
    
    func fetchDataErrorHandler(error:Error) {
        print(error)
    }
    
    // MARK : Delegate
    
    @available(watchOSApplicationExtension 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    /*func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let recievedCounter = message["Param1"] as? Int {
            setDebugText(text: recievedCounter.description)
        }
    }*/
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Message = " + message.description)
        
        if let recievedCounter = message["Param1"] as? Int {
            setDebugText(text: recievedCounter.description)
        }
    }
    
    // MARK : Location delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("1")
        guard locations.count > 0 else { return }
        setDebugText(text:  locations[0].coordinate.latitude.description + " , " + locations[0].coordinate.longitude.description)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        setDebugText(text: error.localizedDescription)
    }
    
    
}
