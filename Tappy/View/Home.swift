//
//  Home.swift
//  TappyTestMVVM
//
//  Created by Vadim Archer on 19.05.2022.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var tappyModel:TappyModel
    var body: some View {
        VStack {
            Text ("Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
            GeometryReader{proxy in
                VStack(spacing: 15){
                    //MARK: Main ring
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: tappyModel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 80)
                            .blur(radius: 0.6)
                            
                        //MARK: Shadow for cirle
                        Circle()
                            .stroke(Color("Purple"), lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        Circle()
                            .fill(Color("BG"))
                        
                        // MARK: Main moving circle
                        Circle()
                            .trim(from: 0, to: tappyModel.progress)
                            .stroke(Color("Purple").opacity(0.8), lineWidth: 10)
                          
                                                    
                        //MARK: Knob
                        GeometryReader {proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Purple"))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .blur(radius: 0.1)
                                //MARK: View is rotating using X
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: tappyModel.progress * 360))
                        }
                        Text(tappyModel.timerStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: tappyModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: tappyModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        if tappyModel.isStarted {
                            tappyModel.stopTimer()
                            //MARK: Cancelling All notifications
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }else{
                            tappyModel.addNewTimer = true
                        }
                    } label:  {
                        Image(systemName: !tappyModel.isStarted ? "timer" : "stop.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background{
                                Circle()
                                    .fill(Color("Purple"))
                                    .shadow(color: Color("DarkPurple"), radius: 10, x: 0, y: 0)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background{
            Color("BG")
        
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack{
                Color.black
                    .opacity(tappyModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        tappyModel.hour = 0
                        tappyModel.minutes = 0
                        tappyModel.seconds = 0
                        tappyModel.addNewTimer = false
                    }
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: tappyModel.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: tappyModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
            _ in
            if tappyModel.isStarted {
                tappyModel.updateTimer()
            }
    }
        .alert("Well done 🔥🔥🔥", isPresented: $tappyModel.isFinished) {
            Button("Start New",role: .cancel) {
                tappyModel.stopTimer()
                tappyModel.addNewTimer = true
                
            }
            Button("Close", role: .destructive) {
                tappyModel.stopTimer()
            }
        }
}
    //MARK: NEW TIMER
    @ViewBuilder
    func NewTimerView()-> some View{
        VStack(spacing: 15){
            Text ("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top,10)
            
            HStack(spacing: 15){
                Text("\(tappyModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal,20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "hr") { value in tappyModel.hour = value
                                                    }
                    }
                    
                
                        Text("\(tappyModel.minutes) min")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.horizontal,20)
                            .padding(.vertical, 12)
                            .background{
                                Capsule()
                                    .fill(.white.opacity(0.07))
                            }
                            .contextMenu{
                                ContextMenuOptions(maxValue: 60, hint: "min") { value in tappyModel.minutes = value
                                    }
                            }
                                Text("\(tappyModel.seconds) sec")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.3))
                                    .padding(.horizontal,20)
                                    .padding(.vertical, 12)
                                    .background{
                                        Capsule()
                                            .fill(.white.opacity(0.07))
                                    }
                                    .contextMenu{
                                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in tappyModel.seconds = value
                                    }
                            }
                    }
            .padding(.top, 20)
            
            Button {
                tappyModel.startTimer()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background{
                        Capsule()
                            .fill(Color("Purple"))
                    }
            }
            .disabled(tappyModel.seconds == 0)
            .opacity(tappyModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("BG"))
                .ignoresSafeArea()
        }
    }

    //MARK: Reusable context menu
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int,hint: String, onClick: @escaping (Int) -> ())->some View{
        ForEach(0...maxValue, id: \.self){value in
            Button("\(value) \(hint)") {
               onClick(value)
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(TappyModel())
                .previewInterfaceOrientation(.portrait)
        }
    }
}

