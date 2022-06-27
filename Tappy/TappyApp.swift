//
//  TappyTestMVVMApp.swift
//  TappyTestMVVM
//
//  Created by Vadim Archer on 17.05.2022.
//

import SwiftUI

@main
struct TappyApp: App {
    //MARK: Since we're doing Background fetching Initialising here
    @StateObject var tappyModel: TappyModel = .init()
    //MARK: Scene Phase
    @Environment(\.scenePhase) var phase
    
    //MARK: Storing last time stamp
    @State var lastActiveTimeStamp: Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tappyModel)
        }
        .onChange(of: phase){ newValue in
            if tappyModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
                    //MARK: to find difference
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if tappyModel.totalSeconds - Int(currentTimeStampDiff) <= 0{
                        tappyModel.isStarted = false
                        tappyModel.totalSeconds = 0
                        tappyModel.isFinished = true
                    } else {
                        tappyModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
