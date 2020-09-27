//
//  ViewController.swift
//  Simon Says
//
//  Created by Steve Masterson on 2020-02-19.
//  Copyright © 2020 com.jrsm.entertainment. All rights reserved.
//

// i need to fix following:  High Score / no button press from user during playback  //  confirm mail is working

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var btnSpeed = 0.25
    var timer = 0.55
    var timerSpd = 0.55
    var gameMode = "Normal"
    var rndSpeed = "Normal"
    var toastTime = 1.0
    var gameSpeed = 1.0 // will make a switch to adjust game speed, using alert
    var soundOn = true
    var btnPresses = 0
    var errorCount = 0
    var currRound = 4
    var score = 0
    var highScore = 0
    var challenge = [Int]()
    var normalChallenge = [Int.random(in: 1..<5)]
    var answer = [Int]()
    var newChallenge = [Int]()
    var btnArray = [Int]()
    var indexChallenge = 0
    var indexElement = 0
    var button = 0
    var low = 1
    var high = 5
    var slidersValue = 4
    var gameIsOver = true
    
    @IBOutlet weak var maxSliderShow: UISlider!
    @IBOutlet weak var maxTileShow: UILabel!
    @IBOutlet weak var moves: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var soundS: UISwitch!
    @IBOutlet weak var jrsmLogo: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var currScoreText: UILabel!
    @IBOutlet weak var highScoreText: UILabel!
    @IBOutlet weak var rndText: UILabel!
    @IBOutlet weak var tmpChallenge: UITextField!
    @IBOutlet weak var uTurnPrompt: UILabel!
    @IBOutlet weak var btn_Num1: UIButton!
    @IBOutlet weak var btn_Num2: UIButton!
    @IBOutlet weak var btn_Num3: UIButton!
    @IBOutlet weak var btn_Num4: UIButton!
    @IBOutlet weak var starterGraphic: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //this prevents landscape mode, see AppDelegate
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
        // Do any additional setup after loading the view.
        // load highScoreObject and display it, add the object to highScore variable
     
        highScoreText.text = UserDefaults.standard.string(forKey: "highScores")
        highScore = UserDefaults.standard.integer(forKey: "highScores")
        
        // create the stored highScoreObject
        let highScoreObject = UserDefaults.standard.object(forKey: "highScores")
        if let highScores = highScoreObject as? String {
            highScoreText.text = UserDefaults.standard.string(forKey: "highScores")
        }
        infoText.isHidden = true
        uTurnPrompt.isHidden = true
            self.starterGraphic.isHidden = false
            self.btn_Num1.isHidden = true
            self.btn_Num2.isHidden = true
            self.btn_Num3.isHidden = true
            self.btn_Num4.isHidden = true
            self.moves.isHidden = true
            self.progressBar.isHidden = true
    }
        
    //button sounds
    var num1USound: AVAudioPlayer?
    var num2USound: AVAudioPlayer?
    var num3USound: AVAudioPlayer?
    var num4USound: AVAudioPlayer?
    var num1Sound: AVAudioPlayer?
    var num2Sound: AVAudioPlayer?
    var num3Sound: AVAudioPlayer?
    var num4Sound: AVAudioPlayer?
    var gameOverSound: AVAudioPlayer?
    
    //Slider used to select max tiles in easy mode
    @IBAction func sliderAction(_ sender: UISlider) {
        slidersValue = Int(sender.value)
        maxTileShow.text = String(slidersValue)
    }
    
    //On Game Load - Popup
    @IBAction func beginAGame(_ sender: Any) {
        moves.isHidden = true
        progressBar.isHidden = true
        btn_Num1.isHidden = false
        btn_Num2.isHidden = false
        btn_Num3.isHidden = false
        btn_Num4.isHidden = false
        starterGraphic.isHidden = true
        uTurnPrompt.isHidden = true
        let alert = UIAlertController(title: "Select Game Mode", message: "Brought to you by JRSM Entertainment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Easy", style: .default, handler: easyGame(_:)))
        alert.addAction(UIAlertAction(title: "Normal", style: .default, handler: normalGame(_:)))
        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: hardGame(_:)))
        alert.addAction(UIAlertAction(title: "About", style: .default, handler: aboutGo(_:)))
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: exitGame(_:)))
        self.present(alert, animated: true, completion: nil)
    }
   
    //Game Other
    func newRound() {
        moves.isHidden = true
        progressBar.isHidden = true
        rndText.text = "\(currRound)"
        currScoreText.text = "\(score)"
        btnPresses = 0
        currRound += 1
        indexElement = 0
        answer.removeAll()
        challenge.removeAll()
        newChallenge.removeAll()
    }
    
    //Game Mode Switch
    func gameSwitch() {
        switch (errorCount != 3) {
        case gameMode == "Easy":
            newRound()
            easyMode()
        case gameMode == "Normal":
            newRound()
            normalMode()
        case gameMode == "Hard":
            newRound()
            hardMode()
        default:
            print("Play Game?")
        }
    }    
    
    //New Game Clear
    func newGame() {
        moves.isHidden = true
        progressBar.isHidden = true
        challenge.removeAll()
        normalChallenge.removeAll()
        normalChallenge = [Int.random(in: 1..<5)]
        answer.removeAll()
        newChallenge.removeAll()
        low = 1
        high = 5
        errorCount = 0
        score = 0
        highScore = 0
        currRound = 1
        indexElement = 0
    }
    
    //Game System Buttons
    //    let soundOn = soundS.isOn
    @IBAction func soundSW(_ sender: Any) {
        if soundS.isOn {
            soundOn = true
        } else {
            soundOn = false
        }
    }
    
    @IBAction func exitGame(_ sender: Any) {
        self.gameOverSound?.stop()
        UIControl().sendAction(#selector(NSXPCConnection.suspend),to: UIApplication.shared, for: nil)
    }
    
    @IBAction func aboutGo(_ sender: Any) {
        self.gameOverSound?.stop()
        performSegue(withIdentifier: "about", sender: nil)
    }
    
    //Game Mode Buttons
    @IBAction func easyGame(_ sender: Any) {
        self.gameOverSound?.stop()
        gameMode = "Easy"
        newGame()
        gameSwitch()
        infoText.text = "\(gameMode) Mode"
    }
    
    @IBAction func normalGame(_ sender: Any) {
        self.gameOverSound?.stop()
        gameMode = "Normal"
        newGame()
        gameSwitch()
        infoText.text = "\(gameMode) Mode"
    }
    
    @IBAction func hardGame(_ sender: Any) {
        self.gameOverSound?.stop()
        gameMode = "Hard"
        newGame()
        gameSwitch()
        infoText.text = "\(gameMode) Mode"
    }
    
    //Colored Input Buttons
    @IBAction func btn_num1(_ sender: Any) {
            soundManager(btnFeedback: 1)
            let num1Array = [1]
            answer.append(contentsOf: num1Array)
            btnPresses += 1
            checkRound()
  }
    
    //soundsp-c
    @IBAction func btn_num2(_ sender: Any) {
            soundManager(btnFeedback: 2)
            let num2Array = [2]
            answer.append(contentsOf: num2Array)
            btnPresses += 1
            checkRound()
    }
    
    @IBAction func btn_num3(_ sender: Any) {
            soundManager(btnFeedback: 3)
            let num3Array = [3]
            answer.append(contentsOf: num3Array)
            btnPresses += 1
            checkRound()
    }
    
    @IBAction func btn_num4(_ sender: Any) {
            soundManager(btnFeedback: 4)
            let num4Array = [4]
            answer.append(contentsOf: num4Array)
            btnPresses += 1
            checkRound()
    }
    
    func gameOverMusic(){

        if soundOn == true {
            let path = Bundle.main.path(forResource: "gameover.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                self.gameOverSound = try AVAudioPlayer(contentsOf: url)
                self.gameOverSound?.play()
            } catch {
                //couldn't load file :(
                }
        } else {
            let path = Bundle.main.path(forResource: "blank.wav", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
            self.gameOverSound = try AVAudioPlayer(contentsOf: url)
                self.gameOverSound?.play()
            } catch {
                //couldn't load file :(
                }
        }
        
        let alert = UIAlertController(title: "Play Again?", message: "Brought to you by JRSM Entertainment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Easy", style: .default, handler: easyGame(_:)))
        alert.addAction(UIAlertAction(title: "Normal", style: .default, handler: normalGame(_:)))
        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: hardGame(_:)))
        alert.addAction(UIAlertAction(title: "About", style: .default, handler: aboutGo(_:)))
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: exitGame(_:)))
        self.present(alert, animated: true, completion: nil)
    }
    
    //I will build an upper and lower limit dial so that user can choose how many tiles each round, can be spinner
    func gameOver() {
        highScore = UserDefaults.standard.integer(forKey: "highScores")
        moves.isHidden = true
        progressBar.isHidden = true
        uTurnPrompt.isHidden = true
        infoText.isHidden = false
        infoText.text = "Game Over"
        if highScore == 0 && score == 0 {
            infoText.textColor = UIColor.yellow
            infoText.text = "Game Over!"
        } else if score > highScore {
            highScore = score
            UserDefaults.standard.set(score, forKey: "highScores")
            infoText.textColor = UIColor.yellow
            infoText.text = "Game Over, HighScore! \(highScore)"
            highScoreText.text = "\(score)"
        } else if score < highScore {
            infoText.textColor = UIColor.yellow
            infoText.text = "Game Over!"
        }
        gameOverMusic()
    }
    
    func easyMode() {
        uTurnPrompt.isHidden = true
        infoText.isHidden = false
                
        for _ in low...Int(slidersValue) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(timer)) {
                self.showChallenge()
            }
            low += 1
            timer += timerSpd
            self.showInfoToast(controller: self, message: "Wait...", seconds: Double(slidersValue))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(high)) {
            self.uTurnPrompt.isHidden = false
            self.infoText.isHidden = true
            self.moves.isHidden = false
            self.progressBar.isHidden = false
            self.progressBar.progress = 1.0
        }
        low = 1
        timer = timerSpd
    }
    
    func normalMode() {
        uTurnPrompt.isHidden = true
        infoText.isHidden = false
        indexElement = 0
        low = 0
            self.newChallenge = [Int.random(in: 1..<5)]
            self.normalChallenge.append(contentsOf: self.newChallenge)
            challenge.append(contentsOf: normalChallenge)
            while low != currRound {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(timer + timerSpd)) {
                    self.showChallenge()
                }
                low += 1
                timer += timerSpd
                self.showInfoToast(controller: self, message: "Wait...", seconds: (Double(currRound)))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(currRound)) {
                self.uTurnPrompt.isHidden = false
                self.infoText.isHidden = true
                self.moves.isHidden = false
                self.progressBar.isHidden = false
                self.progressBar.progress = 1.0
            }
            low = 1
            timer = timerSpd
    }
    
    func hardMode() {
        uTurnPrompt.isHidden = true
        infoText.isHidden = false
        while low != (currRound + 1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(timer + 1)) {
                self.showChallenge()
            }
            low += 1
            timer += timerSpd
            self.showInfoToast(controller: self, message: "Wait...", seconds: (Double(currRound)))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(currRound)) {
            self.uTurnPrompt.isHidden = false
            self.infoText.isHidden = true
            self.moves.isHidden = false
            self.progressBar.isHidden = false
            self.progressBar.progress = 1.0
        }
        low = 1
        timer = timerSpd
    }
    
    // function to play button sequence from array to UI
    func showChallenge () {
        switch "JRSM Ent." == "JRSM Ent." {
        case gameMode == "Normal":
        showFeedback(feedback: Int(normalChallenge[indexElement]))
        self.indexElement += 1
        default:
            newChallenge = [Int.random(in: 1..<5)]
            challenge.append(contentsOf: self.newChallenge)
            showFeedback(feedback: Int(newChallenge[indexElement]))
                }
                self.tmpChallenge.text = "Array: \(self.challenge)" //debugging
            }
           
    func showFeedback (feedback: Int) {
        switch "JRSM Ent." == "JRSM Ent." {
                case feedback == 1:
                    self.soundManager(btnFeedback: 1)
                    print("num1")
                    self.btn_Num1.alpha = 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.btnSpeed) {
                        self.btn_Num1.alpha = 1
                    }
                case feedback == 2:
                self.soundManager(btnFeedback: 2)
                    print("num2")
                    self.btn_Num2.alpha = 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.btnSpeed) {
                        self.btn_Num2.alpha = 1
                    }
                case feedback == 3:
                self.soundManager(btnFeedback: 3)
                    print("num3")
                    self.btn_Num3.alpha = 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.btnSpeed) {
                        self.btn_Num3.alpha = 1
                    }
                case feedback == 4:
                self.soundManager(btnFeedback: 4)
                    print("num4")
                    self.btn_Num4.alpha = 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.btnSpeed) {
                        self.btn_Num4.alpha = 1
                    }
                default:
                print("noise")
                }
                self.tmpChallenge.text = "Array: \(self.challenge)" //debugging
            }
    
    func soundManager(btnFeedback: Int) {
            switch ("JRSM Ent." == "JRSM Ent.") {
                case btnFeedback == 1:
                    //sound
                    switch "JRSM Ent." == "JRSM Ent." {
                    case self.soundOn == false:
                        let path = Bundle.main.path(forResource: "blank.wav", ofType: nil)!
                        let url = URL(fileURLWithPath: path)
                        do {
                            self.num1USound = try AVAudioPlayer(contentsOf: url)
                            self.num1USound?.play()
                        } catch {
                            //couldn't load file :(
                        }
                    default:
                        let path = Bundle.main.path(forResource: "num1Snd.wav", ofType: nil)!
                        let url = URL(fileURLWithPath: path)
                        
                        do {
                            self.num1Sound = try AVAudioPlayer(contentsOf: url)
                            self.num1Sound?.play()
                        } catch {
                            //couldn't load file :(
                        }
                    }
                case btnFeedback == 2:
                    //sound
                    switch "JRSM Ent." == "JRSM Ent." {
                    case self.soundOn == false:
                        let path = Bundle.main.path(forResource: "blank.wav", ofType: nil)!
                        let url = URL(fileURLWithPath: path)
                        do {
                            self.num2USound = try AVAudioPlayer(contentsOf: url)
                            self.num2USound?.play()
                        } catch {
                            //couldn't load file :(
                        }
                    default:
                        let path = Bundle.main.path(forResource: "num2Snd.wav", ofType: nil)!
                        let url = URL(fileURLWithPath: path)
                        
                        do {
                            self.num2USound = try AVAudioPlayer(contentsOf: url)
                            self.num2USound?.play()
                        } catch {
                            //couldn't load file :(
                        }
                    }
                case btnFeedback == 3:
                    //sound
                    switch "JRSM Ent." == "JRSM Ent." {
                    case self.soundOn == false:
                        let path = Bundle.main.path(forResource: "blank.wav", ofType: nil)!
                        let url = URL(fileURLWithPath: path)
                        
                        do {
                            self.num3USound = try AVAudioPlayer(contentsOf: url)
                            self.num3USound?.play()
                        } catch {
                            //couldn't load file :(
                        }
                    default:
                        let path = Bundle.main.path(forResource: "num3Snd.wav", ofType: nil)!
                        let url = URL(fileURLWithPath: path)
                        
                        do {
                            self.num3USound = try AVAudioPlayer(contentsOf: url)
                            self.num3USound?.play()
                        } catch {
                            //couldn't load file :(
                        }
                }
            case btnFeedback == 4:
                //sound
                switch "JRSM Ent." == "JRSM Ent." {
                case self.soundOn == false:
                    let path = Bundle.main.path(forResource: "blank.wav", ofType: nil)!
                    let url = URL(fileURLWithPath: path)
                    do {
                        self.num4USound = try AVAudioPlayer(contentsOf: url)
                        self.num4USound?.play()
                    } catch {
                        //couldn't load file :(
                    }
                default:
                    let path = Bundle.main.path(forResource: "num4Snd.wav", ofType: nil)!
                    let url = URL(fileURLWithPath: path)
                    do {
                        self.num4USound = try AVAudioPlayer(contentsOf: url)
                        self.num4USound?.play()
                    } catch {
                        //couldn't load file :(
                    }
                }
            default:
                print("sound")
        }
    }
    
    //Toasts for game feedback
    func showGoodToast(controller: UIViewController, message: String, seconds: Double) {
        infoText.isHidden = false
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.green
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showBadToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.red
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showInfoToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.systemBlue
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    //Game Functions
    func checkRound(){
        self.uTurnPrompt.isHidden = true
        self.infoText.isHidden = false
        if challenge.count - btnPresses >= 1 {
            moves.isHidden = false
            self.progressBar.progress = 1 - Float(1.0 - (Float(challenge.count - btnPresses)) / Float(challenge.count))
            infoText.textColor = UIColor.green
            infoText.text = "Keep Going! +\(challenge.count - btnPresses) more"
        } else {
            scoreRound()
            infoText.textColor = UIColor.orange
        }
    }
    
    func scoreRound(){
        infoText.isHidden = false
        tmpChallenge.text = "Array: \(challenge)"
        if answer.containsSameElements(as: challenge) == true {
            score += (challenge.reduce(0, +) * 2)
            infoText.text = "Good Job! +\((self.challenge.reduce(0, +)) * 2) Points"
            answer.removeAll()
            challenge.removeAll()
            newChallenge.removeAll()
            btnPresses = 0
            gameSwitch()
        } else {
            if gameMode == "Normal" && currRound > 1{
            currRound -= 1
            challenge.removeLast()
            normalChallenge.removeLast()
            errorCount += 1
                } else {
                    errorCount += 1
            }
            if (score - challenge.reduce(0, +)) < 0 {
                switch "JRSM Ent." == "JRSM Ent." {
                case errorCount == 1:
                    infoText.isHidden = false
                    infoText.text = "2 mistakes left, Score 0"
                    print (self.challenge.reduce(0, +))
                    score = 0
                    gameSwitch()
                case errorCount == 2:
                    infoText.isHidden = false
                    infoText.text = "1 mistake left, Score 0"                    
                    print (self.challenge.reduce(0, +))
                    score = 0
                    gameSwitch()
                case errorCount == 3:
                    gameOver()
                default:
                    print("error")
                }
            } else {
                switch "JRSM Ent." == "JRSM Ent." {
                case errorCount == 1:
                    infoText.isHidden = false
                    infoText.text = "2 mistakes left! -\(self.challenge.reduce(0, +)) Points"
                    score -= (self.challenge.reduce(0, +))
                    print (self.challenge.reduce(0, +))
                    gameSwitch()
                case errorCount == 2:
                    infoText.isHidden = false
                    infoText.text = "1 mistake left! -\(self.challenge.reduce(0, +)) Points"
                    score -= (self.challenge.reduce(0, +))
                    print (self.challenge.reduce(0, +))
                    gameSwitch()
                case errorCount == 3:
                    gameOver()
                default:
                    print("error")
                }
            }
        }
    }
}

// Used to compare user answer array to challenge array
extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
