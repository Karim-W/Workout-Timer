//
//  ViewController.swift
//  Workout Timer
//
//  Created by Karim Wael on 6/26/20.
//  Copyright © 2020 Karim Wael. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    //MARK:Variables
    let secs:[Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    let mins:[Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    var setMin = Int()
    var setSec = Int()
    let shapelayer = CAShapeLayer()
    let center =  CGPoint(x: Int(UIScreen.main.bounds.width/2), y: 350)
    let Aftercenter =  CGPoint(x: Int(UIScreen.main.bounds.width/2), y: 350 + Int((UIScreen.main.bounds.width)/2 - 20))
    var audioPlayer = AVAudioPlayer()
    let goSound: SystemSoundID = 1030
    let getReadySound: SystemSoundID = 1016
    var countDownTimer: Timer?
    var times = Double()
    var adder = ""
    var pressed = false

    //MARK:PickerView stuff
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return mins.count
        }else {
            return secs.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setMin = pickerView.selectedRow(inComponent: 0)
        setSec = pickerView.selectedRow(inComponent: 1)
        restTime.text = "Rest Time: \(setMin) Minutes \(setSec) Seconds"
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return String(mins[row]) + " Minute(s)"
        }else {
            return String(secs[row]) + " Second(s)"
        }
    }
    
//MARK: UI elements
    var introLabel : UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    var restTimer : UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    var timePicker = UIPickerView()
    var restTime : UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    var submitButton : UIButton = {
        let t = UIButton()
        t.setTitle("Submit", for: .normal)
        t.setTitleColor(UIColor.systemBlue, for: .normal)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    var remainder: UILabel = {
        let t = UILabel()
        t.text = ""
        t.isEnabled = false
        t.numberOfLines = 3
        t.textAlignment = .center
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    var slidee:UISlider = {
        let t = UISlider(frame:CGRect(x: 0, y: 0, width: 300, height: 20))
        t.maximumValue = 50
        t.minimumValue = 0.0
        return t
    }()
    var sliderLbl: UILabel = {
        let t = UILabel()
        t.text = ""
        t.isEnabled = false
        t.textAlignment = .center
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
//MARK: setups
    func setupview()
    {
        introLabel.text = "Welcome"
        introLabel.font = UIFont.systemFont(ofSize: 37, weight: .heavy)
        view.addSubview(introLabel)
        introLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        introLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        introLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        introLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        restTimer.text = "Select rest time:"
        view.addSubview(restTimer)
        restTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restTimer.topAnchor.constraint(equalTo: introLabel.bottomAnchor,constant: 10).isActive = true
        restTimer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timePicker)
        timePicker.topAnchor.constraint(equalTo: restTimer.bottomAnchor, constant: 60).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restTime.text = "Rest Time: "
        view.addSubview(restTime)
        restTime.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restTime.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 0).isActive = true
        restTime.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(submitButton)
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: restTime.bottomAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
        submitButton.addTarget(self, action: #selector(handleSubmitTime), for: .touchDown)
        let tracklayer = CAShapeLayer()
        //view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: (UIScreen.main.bounds.width)/2 - 20, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        tracklayer.path = circularPath.cgPath
        tracklayer.strokeColor = UIColor.gray.cgColor
        tracklayer.lineWidth = 10
        tracklayer.shadowColor = UIColor.gray.cgColor
        tracklayer.shadowRadius = 20
        tracklayer.shadowOpacity = 100
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.lineCap = .round
        view.layer.addSublayer(tracklayer)
        view.addSubview(remainder)
        remainder.topAnchor.constraint(equalTo: view.topAnchor, constant: 380 + ((UIScreen.main.bounds.width)/2 - 20)).isActive = true
        remainder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true


    }
    //MARK: Handlers
    func updateRemTime(tim:Double) -> String{
        var m = Int()
        var s = Double()
        if tim > 60{
            m = Int(tim/60)
            s = tim - Double((m * 60))
            return String(m) + " min, "+String(format: "%.02f",s) + " Seconds"
        }else{return String(format: "%.02f",tim) + " Seconds"}
        
    }
    @objc func keepup(){
        times -= 0.1
        remainder.text = adder + " Remaining Time: " + updateRemTime(tim:times)
        if (times < 0.1) {
            countDownTimer!.invalidate()
        }
    }
    @objc func handleSubmitTime(){
        if pressed == true{
            countDownTimer!.invalidate()
            countDownTimer = nil
        }
        pressed = true
        let t:Double = Double(60*setMin) + Double(setSec)
        let circularPath = UIBezierPath(arcCenter: center, radius: (UIScreen.main.bounds.width)/2 - 20, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = UIColor.systemPink.cgColor
        shapelayer.lineWidth = 10
        shapelayer.fillColor = UIColor.clear.cgColor
        //shapelayer.shadowColor = UIColor.systemPink.cgColor
        //shapelayer.shadowRadius = 20
        //shapelayer.shadowOpacity = 1000
        shapelayer.strokeEnd = 0
        shapelayer.lineCap = .round
        view.layer.addSublayer(shapelayer)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = t + (t*0.25)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapelayer.add(basicAnimation, forKey: "wtv")
        times = t
        countDownTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(keepup), userInfo: nil, repeats: true)
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            times -= 0.1
//            self.remainder.text = adder + " Remaining Time: " + updateRemTime(tim:times)//String(format: "%.02f",times)
//            if (times < 0.1||keep == false) {
//                timer.invalidate()
//            }
//        }
//        if (t<0.1){
//            c
//        }
        if (t > 12)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + t-10) {
                AudioServicesPlaySystemSound (self.getReadySound)
                self.adder = "Get Ready\n"
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + t) {
            self.remainder.text = "All Done, Go!"
            //playSound()
            handleDone()
        }
        func handleDone(){
            AudioServicesPlaySystemSound (goSound)
        }
        
        
        
        func playSound() {

            // to play sound
            
        }
    }
    func displaySoundsAlert() {
        let alert = UIAlertController(title: "Play Sound", message: nil, preferredStyle: UIAlertController.Style.alert)
        for i in 1000...1032 {
            alert.addAction(UIAlertAction(title: "\(i)", style: .default, handler: {_ in
                AudioServicesPlayAlertSound(UInt32(i))
                self.displaySoundsAlert()
                
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupview()
    }//1030//1016


}
