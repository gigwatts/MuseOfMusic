//
//  VideoListViewController.swift
//  Muse of Music
//
//  Created by Dustin Watts on 4/23/16.
//  Copyright © 2016 Dustin Watts. All rights reserved.
//

import UIKit

var youTubeVideoID = ""

class VideoListViewController: UIViewController {

    
//    @IBOutlet weak var introViolinVideoButton: UIButton!
    
    @IBAction func introViolinButton(sender: AnyObject) {
        youTubeVideoID = "3Dece6fAivw"
    }
    @IBAction func pizzacatoButton(sender: AnyObject) {
        youTubeVideoID = "dcrJEGRrU-c"
    }
    @IBAction func addingBowButton(sender: AnyObject) {
        youTubeVideoID = "3BDIgJPvyHk"
    }
    @IBAction func playingOpenStringsButton(sender: AnyObject) {
        youTubeVideoID = "7Gzepxisl2Y" //"-w0c0g4I9fo" //
    }
    @IBAction func playingNotesButton(sender: AnyObject) {
        youTubeVideoID = "Q8MMsAaLEnw"
    }
    @IBAction func playingScalesButton(sender: AnyObject) {
        youTubeVideoID = "YuuqmsAymqY"
    }
    @IBAction func playSongsButton(sender: AnyObject) {
        youTubeVideoID = "_lbXHxLA9BQ" //dYfMQF0-pHU
    }
    @IBAction func performanceButton(sender: AnyObject) {
        youTubeVideoID = "V3aloHY7I_g"
    }
    @IBAction func maintenanceButton(sender: AnyObject) {
        youTubeVideoID = "aNMTKA8twi8"
    }
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    // This function is called before the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        let viewer = segue.destinationViewController as! VideosViewController
        
        // set a variable in the second view controller with the String to pass
        viewer.videoID = youTubeVideoID  //Intro to Violin
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
