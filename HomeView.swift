//
//  HomeView.swift
//  Target
//
//  Created by Philippe Yong on 24/04/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var moc
        
    @FetchRequest(entity: YellowData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \YellowData.createdAt, ascending: true)]) var yellowData: FetchedResults<YellowData>
    @FetchRequest(entity: OrangeData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \OrangeData.createdAt, ascending: true)]) var orangeData: FetchedResults<OrangeData>
    @FetchRequest(entity: GreenData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \GreenData.createdAt, ascending: true)]) var greenData: FetchedResults<GreenData>
    @FetchRequest(entity: BlueData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BlueData.createdAt, ascending: true)]) var blueData: FetchedResults<BlueData>
    @FetchRequest(entity: HistoryTimeData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \HistoryTimeData.createdAtDate, ascending: true)]) var historyTimeData: FetchedResults<HistoryTimeData>
    
    @FetchRequest(entity: Yellow.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Yellow.createdAt, ascending: true)]) var yellow: FetchedResults<Yellow>
    @FetchRequest(entity: Orange.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Orange.createdAt, ascending: true)]) var orange: FetchedResults<Orange>
    @FetchRequest(entity: Green.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Green.createdAt, ascending: true)]) var green: FetchedResults<Green>
    @FetchRequest(entity: Blue.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Blue.createdAt, ascending: true)]) var blue: FetchedResults<Blue>
    
    // Timer
    @State var start = false
    @State var to: CGFloat = 0
    @State var second = 0
    @State var minstr = "00"
    @State var secstr = "00"
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var createdAt = ""
    
    @State var textSlideShow = 0
    @State var mountImg = ""
    
    @Binding var activatedTask: String
    @Binding var activatedTaskColor: String
    @Binding var activatedSliderValue: Int

    @State var showProfile = false
    @Binding var startTaskRecord: [Bool]
    @Binding var viewProvider: Int
    
    @State var mount_01 = true
    @State var mount_02 = false
    @State var mount_03 = false
    @State var mount_04 = false
    @State var mount_05 = false
    
    @State var mountainDic = [["mount": "mount_01", "unlock": true],
                              ["mount": "mount_02", "unlock": false],
                              ["mount": "mount_03", "unlock": false],
                              ["mount": "mount_04", "unlock": false],
                              ["mount": "mount_05", "unlock": false],
                              ["mount": "mount_06", "unlock": false]]
    
    func setMountImg() -> String {
        
        var mountImg = ""
        
        if self.activatedTaskColor == "Yellow" {
            mountImg = "mount_01"
        }
        else if self.activatedTaskColor == "Orange" {
            mountImg = "mount_02"
        }
        else if self.activatedTaskColor == "Green" {
            mountImg = "mount_03"
        }
        else if self.activatedTaskColor == "Blue" {
            mountImg = "mount_04"
        }
        else {
            mountImg = "mount_01"
        }
        
        return mountImg
    }
    var body: some View {
        
        ZStack {
            Color(#colorLiteral(red: 0.9313978553, green: 0.9258610606, blue: 0.9356539845, alpha: 1))
                //.black.opacity(0.06)
                .edgesIgnoringSafeArea(.all)
            
           VStack {
                VStack {
                    if self.startTaskRecord.last! == false && textSlideShow == 0 {
                        Text("No task right now")
                            .foregroundColor(Color(UIColor.systemYellow))
                            .font(.system(size: 26))
                    }
                    else {//if self.textSlideShow == 1 {
                        Text("Climb time  \(self.activatedSliderValue) min")
                        .foregroundColor(Color(UIColor.systemYellow))
                        .font(.system(size: 26))
                    }
//                    else if self.textSlideShow == 2 {
//                        Text("Focusing on \(self.activatedTask)")
//                        .foregroundColor(Color(UIColor.systemYellow))
//                        .font(.system(size: 26))
//                    }
//                    else {
//                        Text("Done!")
//                        .foregroundColor(Color(UIColor.systemYellow))
//                        .font(.system(size: 26))
//                    }
                }
                .frame(width: UIScreen.main.bounds.width / 1.3, height: UIScreen.main.bounds.height / 10)
                .padding(.bottom, 30)
            
                HStack {
                    VStack {
                        Text("\(self.minstr)")
                            .font(.system(size: 65))
                            .fontWeight(.bold)
                            .animation(.none)
                    }
                    .frame(width: 100)
                    VStack {
                        Text("\(self.secstr)")
                            .font(.system(size: 65))
                            .fontWeight(.bold)
                            .animation(.none)
                    }
                    .frame(width: 100)
                }
                .frame(height: UIScreen.main.bounds.height / 12)

                VStack {
                    ZStack {
//                        if self.mountImg == "" {
//                            Image("mount_01")
//                                .resizable()
//                                .clipShape(Circle())
//                                .frame(width: 210, height: 210)
//                        }
//                        else {
                            Image(self.setMountImg())
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 210, height: 210)
//                        }
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.black.opacity(0.06), style: StrokeStyle(lineWidth: 22, lineCap: .round))
                            .frame(width: 230, height: 230)

                        Circle()
                            .trim(from: 0, to: self.to)
                            .stroke(Color(UIColor.systemYellow), style: StrokeStyle(lineWidth: 22, lineCap: .round))
                            .frame(width: 230, height: 230)
                            .rotationEffect(.init(degrees: -90))
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 4)
                
                VStack {
                    if self.startTaskRecord.last! && self.second != self.activatedSliderValue * 60 {
                        HStack (spacing: 20){
                            Button(action: {
                                
                                withAnimation(.default) {
                                    self.start.toggle()
                                    self.to = 0
                                }

                            }) {
                                HStack(spacing: 15) {
                                    Image(systemName: self.start ? "pause.fill" : "play.fill")
                                        .foregroundColor(.white)
                                    
                                    Text(self.start ? "Pause" : "Play")
                                        .foregroundColor(.white)
                                        
                                }
                                .padding(.vertical)
                                .frame(width: (UIScreen.main.bounds.width / 2) - 70)
                                .background(Color(UIColor.systemYellow))
                                .clipShape(Capsule())
                            }
                            
                            if self.start == false {
                                Button(action: {
                                    self.second = 0
                                    self.minstr = "00"
                                    self.secstr = "00"
                                    
                                    withAnimation(.default){
                                        self.to = 0
                                        self.startTaskRecord.append(false)
                                    }
                                }) {
                                    HStack(spacing: 15) {
                                        
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(Color(UIColor.systemYellow))
                                        
                                        Text("Quit")
                                            .foregroundColor(Color(UIColor.systemYellow))
                                    }
                                    .padding(.vertical)
                                    .frame(width:( UIScreen.main.bounds.width / 2) - 70)
                                    .background(
                                        Capsule()
                                            .stroke(Color(UIColor.systemYellow), lineWidth: 2)
                                    )
                                }
                            }
                        }
                    }
                        
                    else if self.startTaskRecord.last! && self.second == self.activatedSliderValue * 60 {
                        Button(action: {
                            self.saveTaskValue()
                            self.start.toggle()
                            self.minstr = "00"
                            self.secstr = "00"
                            self.Notify()
                            self.second = 0
                            self.activatedTask = ""
                            self.activatedTaskColor = ""

                            withAnimation(.default) {
                                self.to = 0
                                self.startTaskRecord.append(false)
                            }
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.white)
                                
                                Text("Finish")
                                    .foregroundColor(.white)
                                    
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 70)
                            .background(Color(UIColor.systemYellow))
                            .clipShape(Capsule())
                        }
                    }
                    
                    else {
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.viewProvider = 1
                            }
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .foregroundColor(.white)
                                
                                Text("Start a task")
                                    .foregroundColor(.white)
                                    
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                            .background(Color(UIColor.systemYellow))
                            .clipShape(Capsule())
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 12)
                .padding(.top, 40)

            }
            .frame(height: UIScreen.main.bounds.height / 1.2)
            .padding(.bottom, 140)
            
            VStack {
                Button(action: {
                    withAnimation {
                        self.showProfile.toggle()
                    }
                    self.checkBadge()
                }){
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemYellow))
                            .frame(height: 70, alignment: .leading)
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.black)
                            .font(.system(size: 26))
                    }
                    .sheet(isPresented: self.$showProfile){
                        Profile()
                    }
                }
            }
            .padding(.top, UIScreen.main.bounds.height / 1.16)
            .padding(.trailing, UIScreen.main.bounds.width / 1.36)
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
            }
        })
        .onReceive(self.timer) { (_) in
            
            if self.start {

                if self.second != Int(self.activatedSliderValue * 60) {
                    self.second += 1
                    print("\(self.second) sec")
                    
                    if (self.second / 60) < 10 {
                        self.minstr = "0\(self.second / 60)"
                    }
                    else {
                        self.minstr = "\(self.second / 60)"
                    }
                    
                    if (self.second % 60) < 10 {
                        self.secstr = "0\(self.second % 60)"
                    }
                    else {
                        self.secstr = "\(self.second % 60)"
                    }
                    
                    withAnimation(.default) {
                        self.to = CGFloat(self.second) / (CGFloat(self.activatedSliderValue * 60))
                    }
                }
                
//                else {
//                    self.textSlideShow = 3
//                }
            }
            
//            for time in 0..<self.activatedSliderValue {
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
//                    self.textSlideShow = 1
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() +  Double(time + 2)) {
//                    self.textSlideShow = 2
//                }
//            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                   
               if self.start {
//                    self.start.toggle()
                    let content = UNMutableNotificationContent()
                    content.title = "Your journey has been paused"
                    content.subtitle = "Resume your journey now."
                    content.sound = UNNotificationSound.default
                       
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request)
               }
               print("User resign app")
           }
    }
    
    func saveTaskValue(){
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy MM/dd"
        let formattedDate = format.string(from: date)

        self.createdAt = formattedDate
        
        let allData = HistoryTimeData(context: self.moc)
        allData.title = self.activatedTask
        allData.color = self.activatedTaskColor
        allData.second = NSNumber(value: self.second)
        allData.createdAtStr = self.createdAt
        allData.createdAtDate = Date()

        do  {
            try self.moc.save()
            print("Value saved in HistoryTimeData")
        } catch {
            print(error)
        }

        if self.activatedTaskColor == "Yellow" {
            let data = YellowData(context: self.moc)
            data.second = NSNumber(value: self.second)
            data.title = self.activatedTask
            data.createdAt = self.createdAt
            
            do  {
                try self.moc.save()
                print("Value saved in YellowData TodayData")
            } catch {
                print(error)
            }
        }
            
        else if self.activatedTaskColor == "Orange" {
            let data = OrangeData(context: self.moc)
            data.second = NSNumber(value: self.second)
            data.title = self.activatedTask
            data.createdAt = self.createdAt
            
            do  {
                try self.moc.save()
                print("Value saved in OrangeData TodayData")
            } catch {
                print(error)
            }
        }
            
        else if self.activatedTaskColor == "Green" {
            let data = GreenData(context: self.moc)
            data.second = NSNumber(value: self.second)
            data.title = self.activatedTask
            data.createdAt = self.createdAt
            
            do  {
                try self.moc.save()
                print("Value saved in GreenData TodayData")
            } catch {
                print(error)
            }
        }
        
        else if self.activatedTaskColor == "Blue" {
            let data = BlueData(context: self.moc)
            data.second = NSNumber(value: self.second)
            data.title = self.activatedTask
            data.createdAt = self.createdAt
            
            do  {
                try self.moc.save()
                print("Value saved in BlueData TodayData")
            } catch {
                print(error)
            }
        }
    }
        
    func IdentifyColor(color: String) -> UIColor {
        
        var chosenColor = UIColor.systemGray
        
        if self.activatedTaskColor == "Yellow" {
            chosenColor = UIColor.systemYellow
        }
        
        else if self.activatedTaskColor == "Orange" {
            chosenColor = UIColor.systemOrange
        }

        else if self.activatedTaskColor == "Green" {
            chosenColor = UIColor.systemGreen
        }

        else if self.activatedTaskColor == "Blue" {
            chosenColor = UIColor.systemBlue
        }
        
        return chosenColor
    }

    func Notify() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Timer is completed successfully in backgroud!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    func checkBadge(){
        var historyData: [HistoryData] = []
        var historyFinData: [HistoryData] = []
        var totalTime = 0
            
        for data in historyTimeData {
            if data.title != nil && data.createdAtDate != nil && data.createdAtStr != nil && data.color != nil && data.second != nil {
                historyData.append(HistoryData(title: data.title!, second: data.second!, createdAtStr: data.createdAtStr!, createdAtDate: data.createdAtDate!, color: data.color!))
            }
        }
            
        let historyDateDic = Dictionary(grouping: historyData, by: { $0.createdAtStr })
            
        for i in historyDateDic {

                let historyTitleDic = Dictionary(grouping: i.value, by: { $0.title })

                    for x in historyTitleDic {

                    let title = x.key
                    let createdAtStr = i.key
                    var createdAtDate = Date()
                    var second = 0
                    var color = ""

                    for y in 0...x.value.count - 1 {
                        second += Int(truncating: i.value[y].second)
                    }
                    for y in 0...x.value.count - 1 {
                        color = x.value[y].color
                        print(color)
                    }
                    for y in 0...x.value.count - 1 {
                        createdAtDate = x.value[y].createdAtDate
                    }

                    historyFinData.append(HistoryData(title: title, second: NSNumber(value: second), createdAtStr: createdAtStr, createdAtDate: createdAtDate, color: color))
                }
            }
            
        for i in historyFinData {
            totalTime += Int(truncating: i.second)
        }
        
        if totalTime >= 86400 {
            self.mount_02 = true
        }
        else if totalTime >= 86400 * 3 {
            self.mount_03 = true
        }
        else if totalTime >= 86400 * 7 {
            self.mount_04 = true
        }
        else if totalTime >= 86400 * 12 {
            self.mount_05 = true
        }
        else if totalTime >= 86400 * 20 {
            self.mount_05 = true
        }
    }
    
}

