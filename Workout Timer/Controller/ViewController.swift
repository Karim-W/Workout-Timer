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
    let center =  CGPoint(x: Int(UIScreen.main.bounds.width/2), y:Int(UIScreen.main.bounds.height/2)) //y: 350)
    let Aftercenter =  CGPoint(x: Int(UIScreen.main.bounds.width/2), y: 350 + Int((UIScreen.main.bounds.width)/2 - 20))
    var audioPlayer = AVAudioPlayer()
    let goSound: SystemSoundID = 1030
    let getReadySound: SystemSoundID = 1016
    var countDownTimer: Timer?
    var times = Double()
    var adder = ""
    var pressed = false
    var setsToDo = Int()
    var setsDone = Int()
    var workout_started = false

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
    var stopButton : UIButton = {
        let t = UIButton()
        t.setTitle("Stop", for: .normal)
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
    var sliderLbl: UILabel = {
        let t = UILabel()
        t.text = "Select the number of sets:"
        t.isEnabled = false
        t.textAlignment = .center
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    var slidee:UISlider = {
        let t = UISlider()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.maximumValue = 20
        t.minimumValue = 0.0
        return t
    }()
    var setProgress:UIProgressView = {
        let t = UIProgressView()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    
//MARK: setups
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupview()
    }//1030//1016
    
    func setupview()
    {
        let tempsize = (UIScreen.main.bounds.width)/4
        introLabel.text = "Welcome"
        introLabel.font = UIFont.systemFont(ofSize: 37, weight: .heavy)
        view.addSubview(introLabel)
        introLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        introLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        introLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        introLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        view.addSubview(sliderLbl)
        sliderLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderLbl.topAnchor.constraint(equalTo: introLabel.bottomAnchor,constant: 40).isActive = true
        view.addSubview(slidee)
        slidee.widthAnchor.constraint(equalToConstant: 300).isActive = true
        slidee.bottomAnchor.constraint(equalTo: sliderLbl.bottomAnchor,constant: 40).isActive = true
        slidee.tintColor = UIColor.systemOrange
        slidee.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slidee.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
        restTimer.text = "Select rest time:"
        view.addSubview(restTimer)
        restTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restTimer.topAnchor.constraint(equalTo: slidee.bottomAnchor,constant: 10).isActive = true
        restTimer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timePicker)
        //timePicker.topAnchor.constraint(equalTo: restTimer.bottomAnchor, constant: 60).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        restTime.text = "Rest Time: "
        view.addSubview(restTime)
        restTime.font = UIFont.systemFont(ofSize: 72, weight: .heavy)
        restTime.isHidden = true
        restTime.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restTime.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //restTime.topAnchor.constraint(equalTo: timePicker.bottomAnchor).isActive = true
        //restTime.topAnchor.constraint(equalTo: introLabel.bottomAnchor,constant: 10).isActive = true
        restTime.heightAnchor.constraint(equalToConstant: tempsize*4).isActive = true
       
        view.addSubview(submitButton)
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -tempsize).isActive = true
        //submitButton.topAnchor.constraint(equalTo: restTime.bottomAnchor,constant: tempsize).isActive = true
        submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: tempsize*2.4).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: tempsize).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: tempsize).isActive = true
        submitButton.layer.cornerRadius = tempsize/2
        submitButton.addTarget(self, action: #selector(handleSubmitTime), for: .touchDown)
        submitButton.backgroundColor = UIColor.init(red: 50/255, green: 150/255, blue: 93/255, alpha: 1)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(stopButton)
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: tempsize).isActive = true
        //stopButton.topAnchor.constraint(equalTo: restTime.bottomAnchor,constant: tempsize).isActive = true
        stopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: tempsize*2.4).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: tempsize).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: tempsize).isActive = true
        stopButton.layer.cornerRadius = tempsize/2
        stopButton.addTarget(self, action: #selector(handleStop), for: .touchDown)
        stopButton.backgroundColor = UIColor.init(red: 172/255, green: 32/255, blue: 53/255, alpha: 0.9)
        stopButton.setTitleColor(UIColor.white, for: .normal)
        let tracklayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: (UIScreen.main.bounds.width)/2 - 20, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        tracklayer.path = circularPath.cgPath
        tracklayer.strokeColor = UIColor.gray.cgColor
        tracklayer.lineWidth = 10
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.lineCap = .round
        view.layer.addSublayer(tracklayer)
        view.addSubview(remainder)
        remainder.topAnchor.constraint(equalTo: view.topAnchor, constant: 380 + ((UIScreen.main.bounds.width)/2 - 20)).isActive = true
        remainder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true


    }
    //MARK: Handlers
    @objc func handleSlider(){
        setsToDo = Int(slidee.value)
        sliderLbl.text = "Select the number of sets: \(setsToDo)"
    }
    func updateRemTime(tim:Double) -> String{
        var m = Int()
        var s = Double()
        if tim > 60{
            m = Int(tim/60)
            s = tim - Double((m * 60))
            return String(m) + ":"+String(Int(s))+":"+String(format: "%.00f",(tim - Double(Int(tim)))*100)
        }else{return "0:"+String(Int(tim))+":"+String(format: "%.00f",(tim - Double(Int(tim)))*100)}
        
    }
    @objc func handleStop(){
        killtimer()
    }
    @objc func keepup(){
        times -= 0.1
        restTime.text = updateRemTime(tim:times)
        remainder.text = adder + " Remaining Time: " + updateRemTime(tim:times)
        if (times < 0.1) {
            countDownTimer!.invalidate()
        }
    }
    @objc func handleSubmitTime(){
        slidee.isUserInteractionEnabled = false
        slidee.value = slidee.value - 1
        if (setsToDo > 0){setsToDo -= 1}else{slidee.isUserInteractionEnabled = true}
        sliderLbl.text = "Select the number of sets: \(setsToDo)"
        if (countDownTimer != nil){
            countDownTimer!.invalidate()
            countDownTimer = nil
        }
        if(workout_started==false){
            workout_started = true
        }
        timePicker.isHidden = true
        restTime.isHidden = false
        pressed = true
        let t:Double = Double(60*setMin) + Double(setSec)
        let circularPath = UIBezierPath(arcCenter: center, radius: (UIScreen.main.bounds.width)/2 - 20, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = UIColor.systemOrange.cgColor
        shapelayer.lineWidth = 10
        shapelayer.fillColor = UIColor.clear.cgColor
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
        if (t > 12)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + t-10) {
                AudioServicesPlaySystemSound (self.getReadySound)
                self.adder = "Get Ready\n"
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + t) {
            self.remainder.text = "All Done, Go!"
            self.killtimer()
            self.restTime.isHidden = true
        }
    }
    //MARK:Functions
    func killtimer(){
        slidee.isUserInteractionEnabled = true
        restTime.isHidden = true
        if(countDownTimer != nil){
        countDownTimer!.invalidate()
        countDownTimer = nil
        }
        timePicker.isHidden = false
        handleDone()
    }
    func handleDone(){
        AudioServicesPlaySystemSound (goSound)
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
    
    


}
