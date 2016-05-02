//
//  MetronomeViewController.swift
//  Muse of Music
//
//  Created by Dustin Watts on 5/1/16.
//  Copyright © 2016 Dustin Watts. All rights reserved.
//

import UIKit

protocol MetronomeViewControllerDelegate {
    func updateData(metronomeTempo: NSTimeInterval)
}


class MetronomeViewController: UIViewController {
    
    var delegate: MetronomeViewControllerDelegate?

    var metronomeTempo:NSTimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tempo passed through: ", metronomeTempo)
        updateTempoLabel()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTempoLabel(){
        tempoLabel.text = String(Int(metronomeTempo))
        self.delegate?.updateData(metronomeTempo)
    }
    
    
    @IBOutlet weak var tempoLabel: UILabel!
    
    @IBAction func increaseTempo(sender: AnyObject) {
        metronomeTempo = metronomeTempo + 5
        updateTempoLabel()
    }
    
    @IBAction func decreaseTempo(sender: AnyObject) {
        metronomeTempo = metronomeTempo - 5
        updateTempoLabel()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let scaleViewController = segue.destinationViewController as! ScaleViewController
        scaleViewController.tempo = metronomeTempo
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
