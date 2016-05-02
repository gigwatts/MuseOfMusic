//
//  CMajorViewController.swift
//  Muse of Music
//
//  Created by Dustin Watts on 4/29/16.
//  Copyright © 2016 Dustin Watts. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit



class ScaleViewController: UIViewController {
    
    
    //Audio Engine Variables
    var engine: AVAudioEngine!
    var tone: AVTonePlayerUnit!
    
    //AudioKit Variables
    var audioKitSetup = false
    var metronomeTimer:NSTimer!
    var freqCaptureTimer:NSTimer!
    var freqCaptureTimeInterval:NSTimeInterval!
    var metronomeTimeInterval:NSTimeInterval!
    
    
    var freqTracker: AKFrequencyTracker!
    var freqToGenerate = 440
    var sineWave:AKOperation!
    var generator:AKOperationGenerator!
    var volume:AKOperation!
    var akGeneratorSetup = false
    var mic:AKMicrophone!
    
    //app state variables
    var generatingNotes = false
    
    //Metronome
    var tempo:NSTimeInterval = 60
    var metronomeIsOn = false
    var metronomeBeatSound:AVAudioPlayer! //= AVAudioPlayer()
    var metronomeBeatSoundLoaded = false
    
    //Playtime
    var beat = 1
    var freqCapturedIndex = 0
    var freqDetected = 0.0
    var troubleStart: Int = 0
    var noteFreqLookup = ["G3":196, "A3":220, "B3":246, "C4":262, "D4":294, "E4":329, "F4":349, "FSharp4":370, "G4":392, "A4":440, "B4":495, "C5":523, "CSharp5":558, "D5": 588]
    
    //Accuracy Evaluations
    var freqExpectedArray = [String]()  //[294, 329, 370, 390, 440, 495, 558, 588] //formerly: freqExpectedArray
    var cMajorFreqExpectedArray = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]
    var gMajorFreqExpectedArray = ["G3", "A3", "B3", "C4", "D4", "E4", "FSharp4", "G4"]
    var freqPlayed = [Int]() //formerly: freqPlayed
    var freqDetectedAverage:Int!
    var accuracyMatrix = [Int]() //formerly: accuracyMatrix
    var noteOneArray = [Int]() //formerly: lowDArray
    var noteTwoArray = [Int]() //formerly: EArray
    var noteThreeArray = [Int]() //formerly: FSharpArray
    var noteFourArray = [Int]() //formerly: GArray
    var noteFiveArray = [Int]() //formerly: AArray
    var noteSixArray = [Int]() //formerly: BArray
    var noteSevenArray = [Int]() //formerly: CSharpArray
    var noteEightArray = [Int]() //formerly: highDArray
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTempo()
        
        captureFreqToggle()
        captureFreqToggle()
//        setupAudioKitGenerator()
        
        startAudioEngine()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playCMajorScale(sender: AnyObject) {
        freqExpectedArray = cMajorFreqExpectedArray
        resetNoteTrackers()
        captureFreqToggle()
        startMetronome()
    }
    
    @IBAction func playGMajorScale(sender: AnyObject) {
        freqExpectedArray = gMajorFreqExpectedArray
        resetNoteTrackers()
        captureFreqToggle()
        startMetronome()
    }
    
   
    
    func captureFreqToggle(){
        if(generatingNotes == false){
            setupAudioKitFreqTracker()
            AudioKit.start()
            freqCaptureTimeInterval = 0.005 //60.0 / (tempo)
            freqCaptureTimer = NSTimer.scheduledTimerWithTimeInterval(freqCaptureTimeInterval, target: self, selector: Selector("captureFreq"), userInfo: nil, repeats: true)
            generatingNotes = true
        } else{
            freqCaptureTimer.invalidate()
            mic.stop()
            AudioKit.stop()
            generatingNotes = false
            print("STOP CAPTURING FREQUENCIES")
        }
    }
    
    
    func setupAudioKitFreqTracker(){
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        mic.start()
        freqTracker = AKFrequencyTracker.init(mic, minimumFrequency: 25, maximumFrequency: 4200)
        let silence = AKBooster(freqTracker, gain: 0)
        AudioKit.output = silence    }
    
    
//    func setupAudioKitGenerator(){
////        sineWave = AKOperation.sineWave(frequency: freqToGenerate)
////        volume   = sineWave.scale(minimum: 0, maximum: 0.5)
////        generator = AKOperationGenerator(operation: sineWave)
////        AudioKit.output = generator
////        akGeneratorSetup = true
//////        AudioKit.start()
//    }
    
    
    func captureFreq(){
        freqDetected = freqTracker.frequency
        if ((beat >= 0) && ((troubleStart+beat) == 1)){
            noteOneTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(countdownBG, alpha: 0)
//            fadeIn(lowDBG)
            if(freqDetected > 100 && freqDetected < 2000){
                noteOneArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 2)){
            noteOneTracker.backgroundColor = UIColor.clearColor()
        
            noteTwoTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(lowDBG, alpha: 0)
//            fadeIn(EBG)
            evaluateNotePlayed(noteOneArray, noteExpected: noteFreqLookup[freqExpectedArray[0]]!, noteBeingEvaluated: noteOneTracker)
//            print("ACC MAT LAST INDEX: ", accuracyMatrix.count)
//            if (accuracyMatrix[accuracyMatrix.count] == 100){
//                noteOneTracker.backgroundColor = UIColor.greenColor()
//            }
            if(freqDetected > 100 && freqDetected < 2000){
                noteTwoArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 3)){
            noteTwoTracker.backgroundColor = UIColor.clearColor()
            noteThreeTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(EBG, alpha: 0)
//            fadeIn(FSharpBG)
            evaluateNotePlayed(noteTwoArray, noteExpected: noteFreqLookup[freqExpectedArray[1]]!, noteBeingEvaluated: noteTwoTracker)
            if(freqDetected > 100 && freqDetected < 2000){
                noteThreeArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 4)){
            noteThreeTracker.backgroundColor = UIColor.clearColor()
            noteFourTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(FSharpBG, alpha: 0)
//            fadeIn(GBG)
            evaluateNotePlayed(noteThreeArray, noteExpected: noteFreqLookup[freqExpectedArray[2]]!, noteBeingEvaluated: noteThreeTracker)
            if(freqDetected > 100 && freqDetected < 2000){
                noteFourArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 5)){
            noteFourTracker.backgroundColor = UIColor.clearColor()
            noteFiveTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(GBG, alpha: 0)
//            fadeIn(ABG)
            evaluateNotePlayed(noteFourArray, noteExpected: noteFreqLookup[freqExpectedArray[3]]!, noteBeingEvaluated: noteFourTracker)
            if(freqDetected > 100 && freqDetected < 2000){
                noteFiveArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 6)){
            noteFiveTracker.backgroundColor = UIColor.clearColor()
            noteSixTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(ABG, alpha: 0)
//            fadeIn(BBG)
            evaluateNotePlayed(noteFiveArray, noteExpected: noteFreqLookup[freqExpectedArray[4]]!, noteBeingEvaluated: noteFiveTracker)
            if(freqDetected > 100 && freqDetected < 2000){
                noteSixArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 7)){
            noteSixTracker.backgroundColor = UIColor.clearColor()
            noteSevenTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(BBG, alpha: 0)
//            fadeIn(CSharpBG)
            evaluateNotePlayed(noteSixArray, noteExpected: noteFreqLookup[freqExpectedArray[5]]!, noteBeingEvaluated: noteSixTracker)
            if(freqDetected > 100 && freqDetected < 2000){
                noteSevenArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 8)){
            noteSevenTracker.backgroundColor = UIColor.clearColor()
            noteEightTracker.backgroundColor = UIColor.lightGrayColor()
//            fadeOut(CSharpBG, alpha: 0)
//            fadeIn(highDBG)
            evaluateNotePlayed(noteSevenArray, noteExpected: noteFreqLookup[freqExpectedArray[6]]!, noteBeingEvaluated: noteSevenTracker)
            if(freqDetected > 100 && freqDetected < 2000){
                noteEightArray.append(Int(freqDetected))
            }
        }
        if ((beat >= 0) && ((troubleStart+beat) == 9)){
            noteEightTracker.backgroundColor = UIColor.clearColor()
            
            stopMetronome()
            captureFreqToggle()
//            fadeOut(highDBG, alpha: 0)
            evaluateNotePlayed(noteEightArray, noteExpected: noteFreqLookup[freqExpectedArray[7]]!, noteBeingEvaluated: noteEightTracker)
            
        }

        freqCapturedIndex = freqCapturedIndex + 1
//        print("Frequency ", freqCapturedIndex, ": ", freqTracker.frequency)
    }
    
    
    func evaluateNotePlayed(freqDetectedArray:Array<Int>, noteExpected: Int, noteBeingEvaluated: UILabel){
        freqDetectedAverage = averageArray(freqDetectedArray)
        if(abs(freqDetectedAverage - noteExpected)<40){
//            fadeOut(noteNode, alpha: 0.1)
            accuracyMatrix.append(100)
            noteBeingEvaluated.backgroundColor = UIColor.greenColor()
        } else{
            accuracyMatrix.append(0)
            noteBeingEvaluated.backgroundColor = UIColor.redColor()
        }
    }
    
    func averageArray(freqArray:Array<Int>) -> Int{
        var sum = 0
        var average:Int = 0
        if(freqArray.count > 0){
            for freq in freqArray{
                sum += freq
            }
            average = sum/freqArray.count
        }
        return average
    }
    
    
    
    
    
    @IBAction func listenToScale(sender: AnyObject) {
//        playTone()
        startMetronome()

        //FADEOUT ANIMATION
//        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//                self.metronomeTempo.alpha = 0.0
//            }, completion: nil)
        noteOneTracker.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    @IBOutlet weak var metronomeTempo: UIButton!
    
    func updateTempo(){
        metronomeTempo.setTitle(String(Int(tempo)), forState: UIControlState.Normal)
    }

    func startAudioEngine(){
        //Firing up the Audio Engine
        tone = AVTonePlayerUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print("audio engine started with sample rate of: ", format.sampleRate)
        engine = AVAudioEngine()
        engine.attachNode(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    
    func startMetronome(){
        if(metronomeIsOn == false){
            beat = -4
            metronomeIsOn = true
            metronomeTimeInterval = 60.0 / (tempo)
            metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("representBeat"), userInfo: nil, repeats: true)
            metronomeTimer?.fire()
        } else{
            metronomeIsOn = false
            metronomeTimer.invalidate()
            beat = -4
        }
    }
    
    func representBeat(){
        if(beat<0){
            noteOneTracker.text = String(beat * (-1))
            noteOneTracker.backgroundColor = UIColor.lightGrayColor()
        } else if (beat == 0){
            noteOneTracker.text = "."
        }
        
        if(!metronomeBeatSoundLoaded){
            beat = beat + 1
            let path = NSBundle.mainBundle().pathForResource("metronomeDownbeat", ofType:"wav")!
            let url = NSURL(fileURLWithPath: path)
            do {
                let sound = try AVAudioPlayer(contentsOfURL: url)
                metronomeBeatSound = sound
                sound.play()
            } catch {
                // couldn't load file :(
                print("could not load file")
            }
        } else{
            metronomeBeatSound.play()
        }
        //        var path = NSBundle.mainBundle().pathForResource("metronomeDownbeat", ofType: "mp3")
//        metronomeBeatSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), error: nil)
//        metronomeBeatSound.prepareToPlay()
    }
    
    func stopMetronome(){
        metronomeIsOn = false
        metronomeTimer.invalidate()
        beat = -4
        
        if(averageArray(accuracyMatrix) > 90){
            tempo = tempo + 10
            updateTempo()
        } else if(averageArray(accuracyMatrix) < 50){
            tempo = tempo - 5
            updateTempo()
        }
        
        print("low D (294): ", noteOneArray)
        print("E (329): ", noteTwoArray)
        print("F Sharp (370): ", noteThreeArray)
        print("G (390): ", noteFourArray)
        print("A (440): ", noteFiveArray)
        print("B (495): ", noteSixArray)
        print("C Sharp (558): ", noteSevenArray)
        print("high D (588): ", noteEightArray)
        print("Accuracy Matrix: ", accuracyMatrix)
        print("Percent Correct: ", averageArray(accuracyMatrix))
        clearFreqDataArrays()
    }
    
    
    func clearFreqDataArrays(){
        accuracyMatrix.removeAll()
        noteOneArray.removeAll()
        noteTwoArray.removeAll()
        noteThreeArray.removeAll()
        noteFourArray.removeAll()
        noteFiveArray.removeAll()
        noteSixArray.removeAll()
        noteSevenArray.removeAll()
        noteEightArray.removeAll()
    }
    
    
    func resetNoteTrackers(){
        noteOneTracker.backgroundColor = UIColor.clearColor()
        noteTwoTracker.backgroundColor = UIColor.clearColor()
        noteThreeTracker.backgroundColor = UIColor.clearColor()
        noteFourTracker.backgroundColor = UIColor.clearColor()
        noteFiveTracker.backgroundColor = UIColor.clearColor()
        noteSixTracker.backgroundColor = UIColor.clearColor()
        noteSevenTracker.backgroundColor = UIColor.clearColor()
        noteEightTracker.backgroundColor = UIColor.clearColor()
    }
    
    
    
    
    
    
    
    //Trackers - indicate problems and progress
    @IBOutlet weak var noteOneTracker: UILabel!
    @IBOutlet weak var noteTwoTracker: UILabel!
    @IBOutlet weak var noteThreeTracker: UILabel!
    @IBOutlet weak var noteFourTracker: UILabel!
    @IBOutlet weak var noteFiveTracker: UILabel!
    @IBOutlet weak var noteSixTracker: UILabel!
    @IBOutlet weak var noteSevenTracker: UILabel!
    @IBOutlet weak var noteEightTracker: UILabel!

    //PLAYING NOTES WHEN TAPPED
    
    @IBAction func playG3(sender: AnyObject) {
        tone.frequency = 196
        playTone()
    }
    
    @IBAction func stopG3(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playA3(sender: AnyObject) {
        tone.frequency = 220
        playTone()
    }
    
    @IBAction func stopA3(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playB3(sender: AnyObject) {
        tone.frequency = 246
        playTone()
    }
    
    @IBAction func stopB3(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playC4(sender: AnyObject) {
        tone.frequency = 261
        playTone()
    }
    
    @IBAction func stopC4(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playD4(sender: AnyObject) {
        tone.frequency = 293
        playTone()
    }
    
    @IBAction func stopD4(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playE4(sender: AnyObject) {
        tone.frequency = 329
        playTone()
    }
    
    @IBAction func stopE4(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playF4(sender: AnyObject) {
        tone.frequency = 349
        playTone()
    }
    
    
    @IBAction func stopF4(sender: AnyObject) {
        stopPlayingTone()
    }
    
    
    @IBAction func playFSharp4(sender: AnyObject) {
        tone.frequency = 370
        playTone()
    }
    
    @IBAction func stopFSharp4(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playG4(sender: AnyObject) {
        tone.frequency = 392
        playTone()
    }
    
    @IBAction func stopG4(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playA(sender: AnyObject) {
//        freqToGenerate = 440
        tone.frequency = 440
        playTone()
    }
    
    @IBAction func stopA(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playB(sender: AnyObject) {
//        AudioKit.stop()
//        freqToGenerate = 493
        tone.frequency = 493
//        sineWave = AKOperation.sineWave(frequency: freqToGenerate)
//        volume   = sineWave.scale(minimum: 0, maximum: 0.5)
//        generator = AKOperationGenerator(operation: sineWave)
//        AudioKit.output = generator
//        AudioKit.start()
        playTone()
    }
    
    @IBAction func stopB(sender: AnyObject) {
        stopPlayingTone()
    }
    
    @IBAction func playC5(sender: AnyObject) {
        tone.frequency = 523
        playTone()
    }
    
    @IBAction func stopC5(sender: AnyObject) {
        stopPlayingTone()
    }
    
    func playTone(){
        if tone.playing {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
        } else {
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
        }
        
        
        
//        if(akGeneratorSetup == false){
////            setupAudioKitGenerator()
////            AudioKit.start()
//        }
//        
//        
//        if(generatingNotes == false){
//            setupAudioKitGenerator()
//            AudioKit.start()
//            generator.start()
//            print("attempted to play")
//            generatingNotes = true
//        } else{
//            generator.stop()
//            AudioKit.stop()
//            generatingNotes = false
//        }
    }
    
    func stopPlayingTone(){
        if tone.playing {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
        }
        
        
        
//        generator.stop()
//        AudioKit.stop()
//        generatingNotes = false
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let metronomeViewController = segue.destinationViewController as! MetronomeViewController
        metronomeViewController.metronomeTempo = tempo
        
        if segue.identifier == "MetronomeViewControllerSegue" {
            (segue.destinationViewController as! MetronomeViewController).delegate = self
        }
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


extension ScaleViewController: MetronomeViewControllerDelegate {
    func updateData(metronomeTempo: NSTimeInterval) {
        self.tempo = metronomeTempo
    }
}