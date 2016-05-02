//
//  VideosViewController.swift
//  Muse of Music
//
//  Created by Dustin Watts on 4/23/16.
//  Copyright © 2016 Dustin Watts. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {

    
    var videoID = ""
    
    @IBOutlet weak var videoWebView: UIWebView!
    
    
    override func viewDidLoad() {
        print("video ID: ", videoID)
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.blackColor()
        var link:String = "https://www.youtube.com/embed/"
        var screen = UIScreen.mainScreen().bounds
        let width = screen.size.width//*(3/4)
        let height = screen.size.height
        let frame = 0
        
        var Code:NSString = "<iframe width=\(width) height=\(height) src=\(link)\(videoID) frameborder=\(frame) allowfullscreen></iframe>"
        videoID = ""
        print("full iframe code: ", Code)
        print("videoID should be blank to facilitate proper reload: ", videoID)
        self.videoWebView.loadHTMLString(Code as String, baseURL: nil)
        
        Code = ""
        print("full iframe code after clearing: ", Code)
        
        let cookie = NSHTTPCookie.self
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in cookieJar.cookies! {
            // print(cookie.name+"="+cookie.value)
            cookieJar.deleteCookie(cookie)
        }
        
//        videoID = ""

        
        
//        // Set up your UIWebView
//        let webView = UIWebView(frame: self.view.frame) // or pass in your own custom frame rect
//        
//        self.view.addSubview(webView)
//        self.view.bringSubviewToFront(webView)
//        
//        // Set properties
//        webView.allowsInlineMediaPlayback = true
//        webView.mediaPlaybackRequiresUserAction = false
        
        // get the ID of the video you want to play
//        let videoID = videoID //"f_eiMKp4QW8" // https://www.youtube.com/watch?v=f_eiMKp4QW8
        

        
        // Set up your HTML.  The key URL parameters here are playsinline=1 and autoplay=1
        // Replace the height and width of the player here to match your UIWebView's  frame rect
//        let embededHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='https://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(self.view.frame.size.width)' height='\(self.view.frame.size.height)' src='https://www.youtube.com/embed/\(videoID)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
//        
//        // Load your webView with the HTML we just set up
//        webView.loadHTMLString(embededHTML, baseURL: NSBundle.mainBundle().bundleURL)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
