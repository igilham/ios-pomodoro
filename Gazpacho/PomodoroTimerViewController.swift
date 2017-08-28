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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var estimateLabel: UILabel!
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var markTaskDoneToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("PomodoroTimer view loaded")
        // assign task fields to UI
        titleLabel.text = task!.title
        estimateLabel.text = String(task!.estimate)
        elapsedLabel.text = String(task!.elapsed)
        progressView.setProgress(0.0, animated: false)
        playPauseButton.setTitle("Start!", for: .normal)
        markTaskDoneToggle.isOn = false
        disableMarkDoneToggle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("memory warning")
    }
    
    // update model state when user marks a task as done
    @IBAction func handleMarkTaskDoneToggleChange(_ sender: Any) {
        task?.complete = markTaskDoneToggle.isOn
    }
    
    // Start/pause/resume the timer depending on what state we are in
    @IBAction func handlePlayPauseButtonClick(_ sender: Any) {
        NSLog("Play/Pause button clicked while in state " + String(describing: state))
        switch state {
        case .ready:
            state = TimerState.running
            playPauseButton.setTitle("Pause", for: .normal)
        case .running:
            state = TimerState.paused
            playPauseButton.setTitle("Resume", for: .normal)
            // allow user to mark task done while timer paused
            enableMarkDoneToggle()
        case .paused:
            state = TimerState.running
            playPauseButton.setTitle("Pause", for: .normal)
            disableMarkDoneToggle()
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
