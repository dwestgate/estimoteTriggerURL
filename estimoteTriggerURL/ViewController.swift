//
//  ViewController.swift
//  estimoteTriggerURL
//
//  Created by David Westgate on 8/6/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, ESTBeaconManagerDelegate {
    
    var webView: WKWebView!
    var currentWebSite = ""

    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    let websitesByBeacons = [
        "16402:37673": "https://dwestgate.github.io/Lemon/",
        "22371:9501": "https://dwestgate.github.io/Candy/",
        "49028:65076": "https://dollop.github.io/beetroot/"
        
    ]
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    
    
    func placesNearBeacon(beacon: CLBeacon) -> String? {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.websitesByBeacons[beaconKey] {
            let sortedPlaces = places
            return sortedPlaces
        }
        return nil
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon],
                       inRegion region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first, places = placesNearBeacon(nearestBeacon) {
            if (places != currentWebSite) {
                print(places)
                let url = NSURL(string: places)!
                webView.loadRequest(NSURLRequest(URL: url))
                webView.allowsBackForwardNavigationGestures = true
                currentWebSite = places
            }
            

        }
    }
    
}

