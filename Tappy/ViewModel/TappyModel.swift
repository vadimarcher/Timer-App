//
//  TappyModel.swift
//  TappyTestMVVM
//
//  Created by Vadim Archer on 19.05.2022.
//

import SwiftUI

class TappyModel: NSObject,ObservableObject,UNUserNotificationCenterDelegate {
    // MARK: Metronome Propeties
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    
    //MARK: Total Seconds
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    //MARK: Post Timer properties
    
    @Published var isFinished: Bool = false
    
    //MARK: Since its NSobject
    override init() {
        super.init()
            self.authorizeNotification()
    }
    
    //MARK: Requesting Notification Access
    func authorizeNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]){_, _ in
        }
        
        //MARK: shows inApp notification
        UNUserNotificationCenter.current().delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    //MARK: Starting timer
    func startTimer(){
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
        //MARK: String timer value
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        //MARK: Calc total seconds for timer Animation
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    //MARK: Stop timer
    func stopTimer(){
        withAnimation{
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1 }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
        }

    //MARK: Updating timer
    func updateTimer() {
    totalSeconds -= 1
    progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
    progress = (progress < 0 ? 0 : progress )
    //MARK: 60 min * 60 sec
    hour = totalSeconds / 3600
    minutes = (totalSeconds / 60) % 60
    seconds = (totalSeconds % 60)
    timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
    if hour == 0 && seconds == 0 && minutes == 0 {
        isStarted = false
        print("Finished")
        isFinished = true
        }
    }
    
    func addNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "Well done 🔥🔥🔥"
        content.sound = UNNotificationSound.default
         
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        UNUserNotificationCenter.current().add(request)
        
    }
}
  
