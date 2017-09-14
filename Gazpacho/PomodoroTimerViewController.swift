//
//  PomodoroTimerViewController.swift
//  Gazpacho
//
//  Created by Ian Gilham on 28/08/2017.
//  Copyright © 2017 Ian Gilham. All rights reserved.
//

import Foundation
import UIKit

enum TimerState {
    case ready
    case running
    case paused
    case finished
}

class PomodoroTimerViewController : UIViewController {
    let settings: Settings = Settings()
    var state: TimerState = TimerState.ready
    var task: Task?
    var timer: Timer?
    var elapsed: TimeInterval = 0.0
    var interval: TimeInterval = 0.0
    var max: TimeInterval = 0.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var estimateLabel: UILabel!
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var markTaskDoneToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("PomodoroTimer view loaded")
        initFields()
        updateLabels()
        progressView.setProgress(0.0, animated: false)
        playPauseButton.setTitle("Start!", for: .normal)
        markTaskDoneToggle.isOn = false
        disableMarkDoneToggle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // prevent leaking a timer and it's interrupts when hiding the view
        pause()
    }
    
    // initialise any non-default fields
    func initFields() {
        // TODO: make the max period configurable to support breaks etc.
        max = settings.workDuration
        
        // increment timer in 100th's of the total period
        interval = TimeInterval(max / 100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("memory warning")
    }
    
    // update model state when user marks a task as done
    @IBAction func handleMarkTaskDoneToggleChange(_ sender: Any) {
        task?.complete = markTaskDoneToggle.isOn
    }
    
    func updateLabels() {
        titleLabel.text = task!.title
        estimateLabel.text = String(task!.estimate)
        elapsedLabel.text = String(task!.elapsed)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(PomodoroTimerViewController.setProgress),
                                     userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer!.invalidate()
        timer = nil
    }
    
    func start() {
        NSLog("Starting pomodoro timer")
        state = TimerState.running
        
        playPauseButton.setTitle("Pause", for: .normal)
        startTimer()
    }
    
    func pause() {
        NSLog("Pausing pomodoro timer")
        stopTimer()
        state = TimerState.paused
        
        playPauseButton.setTitle("Resume", for: .normal)
        enableMarkDoneToggle()
    }
    
    func resume() {
        NSLog("Resuming pomodoro timer")
        state = TimerState.running
        
        playPauseButton.setTitle("Pause", for: .normal)
        disableMarkDoneToggle()
        startTimer()
    }
    
    func finish() {
        NSLog("Pomodoro timer completed")
        stopTimer()
        state = .finished
        
        playPauseButton!.isEnabled = false
        playPauseButton!.setTitle("Done", for: .normal)
        task?.elapsed += 1
        updateLabels()
        enableMarkDoneToggle()
    }
    
    func setProgress() {
        elapsed += interval
        let progress = Float(elapsed / max)
        NSLog("Timer elapsed: \(elapsed), max: \(max), progress: \(progress)")
        
        progressView!.setProgress(progress, animated: true)
        if elapsed >= max {
            finish()
        }
    }
    
    // Start/pause/resume the timer depending on what state we are in
    @IBAction func handlePlayPauseButtonClick(_ sender: Any) {
        NSLog("Play/Pause button clicked while in state " + String(describing: state))
        switch state {
        case .ready:
            start()
        case .running:
            pause()
        case .paused:
            resume()
        default:
            NSLog("Unsupported state " + String(describing: state) + " - nothing to do")
        }
    }
    
    private func enableMarkDoneToggle() {
        markTaskDoneToggle.isUserInteractionEnabled = true
        markTaskDoneToggle.isEnabled = true
    }
    
    private func disableMarkDoneToggle() {
        markTaskDoneToggle.isUserInteractionEnabled = false
        markTaskDoneToggle.isEnabled = false
    }
    
}
