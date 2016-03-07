//
//  ViewController.swift
//  LittleMonsters
//
//  Created by Otto on 3/6/16.
//  Copyright © 2016 Otto. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var hammerImg: DragImg!
    
    @IBOutlet weak var lblPlayAgain: UILabel!
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy =  false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxHammer: AVAudioPlayer!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gameInit()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped:", object: nil)
        
        do {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxHammer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("hammer2", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxHammer.prepareToPlay()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
        startTimer()
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true;
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        hammerImg.alpha = DIM_ALPHA
        hammerImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        }else if currentItem == 1{
            sfxBite.play()
        } else {
            sfxHammer.play()
        }
    }
    
    func startTimer() {
        if timer != nil{
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }

    func changeGameState(){
        
        if !monsterHappy{
        
        
        penalties++
            sfxSkull.play()
        if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2{
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(3)
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true;
            
            hammerImg.alpha = DIM_ALPHA
            hammerImg.userInteractionEnabled = false;
        }else if rand == 1{
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true;
            
            hammerImg.alpha = DIM_ALPHA
            hammerImg.userInteractionEnabled = false;
        } else {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false;
            
            hammerImg.alpha = OPAQUE
            hammerImg.userInteractionEnabled = true;
            
        }
        
        
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver(){
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        btnPlayAgain.hidden = false
        lblPlayAgain.hidden = false
    }
    
    @IBAction func onBtnPlayAgainTapped(sender: AnyObject) {
        btnPlayAgain.hidden = true
        lblPlayAgain.hidden = true
        startTimer()
        monsterImg.playIdleAnimation()
        penalties = 0;
        gameInit()
    }
    
    func gameInit(){
        foodImg.dropTarget = monsterImg;
        heartImg.dropTarget = monsterImg;
        hammerImg.dropTarget = monsterImg;
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
    }
    

}

