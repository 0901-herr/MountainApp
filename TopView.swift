//
//  topView.swift
//  Target
//
//  Created by Philippe Yong on 12/04/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct TopView: View {

    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Yellow.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Yellow.createdAt, ascending: true)]) var yellow: FetchedResults<Yellow>
    @FetchRequest(entity: Orange.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Orange.createdAt, ascending: true)]) var orange: FetchedResults<Orange>
    @FetchRequest(entity: Green.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Green.createdAt, ascending: true)]) var green: FetchedResults<Green>
    @FetchRequest(entity: Blue.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Blue.createdAt, ascending: true)]) var blue: FetchedResults<Blue>

    @FetchRequest(entity: YellowData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \YellowData.createdAt, ascending: true)]) var yellowData: FetchedResults<YellowData>
    @FetchRequest(entity: OrangeData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \OrangeData.createdAt, ascending: true)]) var orangeData: FetchedResults<OrangeData>
    @FetchRequest(entity: GreenData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \GreenData.createdAt, ascending: true)]) var greenData: FetchedResults<GreenData>
    @FetchRequest(entity: BlueData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BlueData.createdAt, ascending: true)]) var blueData: FetchedResults<BlueData>
    @FetchRequest(entity: HistoryTimeData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \HistoryTimeData.createdAtDate, ascending: true)]) var historyTimeData: FetchedResults<HistoryTimeData>

    @State var showAddTask: Bool = false
    @State var showTaskOption: Bool = false
    
    @State var travelledTimeMin = 0
    
    @Binding var taskColorChoosen: UIColor
    @Binding var activatedTask: String
    @Binding var activatedTaskColor: String
    @Binding var activatedSliderValue: Int
    @Binding var startTaskRecord: [Bool]
    @Binding var viewProvider: Int
    
    let tasks: [taskItems] = [.yellow, .orange, .green, .blue]

    func calTraveledTime(travelTime: Int) -> Int {
        
        var totalTime = 0

        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy MM/dd"
        let formattedDate = format.string(from: date)
        
        var historyData: [HistoryData] = []
        var historyFinData: [HistoryData] = []
        
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
        
        for x in historyFinData {
            if x.createdAtStr == formattedDate {
                totalTime += (Int(truncating: x.second) / 60)
            }
        }
        
        print("Traveled Time Today \(totalTime)")
        return totalTime
    }
    
    func identifyMountImg() -> String {
        
        var mountImg = ""
        
        if self.taskColorChoosen == UIColor.systemYellow {
            mountImg = "mount_01"
        }
        
        else if self.taskColorChoosen == UIColor.systemOrange {
            mountImg = "mount_02"
        }

        else if self.taskColorChoosen == UIColor.systemGreen {
            mountImg = "mount_03"
        }

        else if self.taskColorChoosen == UIColor.systemBlue {
            mountImg = "mount_04"
        }
        
        return mountImg
    }


    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    VStack {
                        
                        if self.taskColorChoosen == UIColor.systemYellow {
                            VStack {
                                List {
                                    ForEach(self.yellow, id: \.self) { items in
                                        TaskView(title: items.taskTitle ?? "", color: UIColor.systemYellow, activatedTask: self.$activatedTask, activatedTaskColor: self.$activatedTaskColor, activatedSliderValue: self.$activatedSliderValue, startTaskRecord: self.$startTaskRecord, viewProvider: self.$viewProvider)
                                    }
                                    .onDelete{ indexSet in
                                        let deleteItem = self.yellow[indexSet.first!]
                                        self.moc.delete(deleteItem)
                                    
                                        do{
                                            try self.moc.save()
                                                } catch{
                                                    print(error)
                                                }
                                    }
                                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 7.4)
                                }
                                .colorMultiply(Color(#colorLiteral(red: 0.9313978553, green: 0.9258610606, blue: 0.9356539845, alpha: 1)))
                            }
                        }

                        else if self.taskColorChoosen == UIColor.systemOrange {
                            VStack {
                                List {
                                    ForEach(self.orange, id: \.self) { items in
                                        TaskView(title: items.taskTitle ?? "", color: UIColor.systemOrange, activatedTask: self.$activatedTask, activatedTaskColor: self.$activatedTaskColor, activatedSliderValue: self.$activatedSliderValue, startTaskRecord: self.$startTaskRecord, viewProvider: self.$viewProvider)
                                    }
                                    .onDelete{ indexSet in
                                        let deleteItem = self.orange[indexSet.first!]
                                        self.moc.delete(deleteItem)
                                    
                                        do{
                                            try self.moc.save()
                                                } catch{
                                                    print(error)
                                                }
                                    }
                                    .frame(width: geo.size.width / 1.15, height: geo.size.height / 7.4)
                                }
                                .colorMultiply(Color(#colorLiteral(red: 0.9313978553, green: 0.9258610606, blue: 0.9356539845, alpha: 1)))
                            }
                        }
                        
                        else if self.taskColorChoosen == UIColor.systemGreen {
                            VStack {
                                List {
                                    ForEach(self.green, id: \.self) { items in
                                        TaskView(title: items.taskTitle ?? "", color: UIColor.systemGreen, activatedTask: self.$activatedTask, activatedTaskColor: self.$activatedTaskColor, activatedSliderValue: self.$activatedSliderValue, startTaskRecord: self.$startTaskRecord, viewProvider: self.$viewProvider)
                                    }
                                    .onDelete{ indexSet in
                                        let deleteItem = self.green[indexSet.first!]
                                        self.moc.delete(deleteItem)
                                    
                                        do{
                                            try self.moc.save()
                                                } catch{
                                                    print(error)
                                                }
                                    }
                                    .frame(width: geo.size.width / 1.15, height: geo.size.height / 7.4)
                                }
                                .colorMultiply(Color(#colorLiteral(red: 0.9313978553, green: 0.9258610606, blue: 0.9356539845, alpha: 1)))
                            }
                        }

                        else if self.taskColorChoosen == UIColor.systemBlue {
                            VStack {
                                List {
                                    ForEach(self.blue, id: \.self) { items in
                                        TaskView(title: items.taskTitle ?? "", color: UIColor.systemBlue, activatedTask: self.$activatedTask, activatedTaskColor: self.$activatedTaskColor, activatedSliderValue: self.$activatedSliderValue, startTaskRecord: self.$startTaskRecord, viewProvider: self.$viewProvider)
                                    }
                                    .onDelete{ indexSet in
                                        let deleteItem = self.blue[indexSet.first!]
                                        self.moc.delete(deleteItem)
                                    
                                        do{
                                            try self.moc.save()
                                                } catch{
                                                    print(error)
                                                }
                                    }
                                    .frame(width: geo.size.width / 1.15, height: geo.size.height / 7.4)
                                }
                                .colorMultiply(Color(#colorLiteral(red: 0.9313978553, green: 0.9258610606, blue: 0.9356539845, alpha: 1)))
                            }
                        }
                    }
                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.28)
                    .padding(.top, geo.size.height / 6)
                    
                    VStack {
                        HStack {
                            HStack {
                                if self.showTaskOption {
                                    HStack {
                                        ForEach(self.tasks, id: \.self) { task in
                                            Task(showTaskOption: self.$showTaskOption, taskColorChoosen: self.$taskColorChoosen, taskColor: task)
                                        }
                                    }
                                    .frame(width: geo.size.width / 1.1, height: 90)
                                    .background(Color(UIColor.systemGray4))
                                    .cornerRadius(geo.size.width / 4.4)
                                    .padding(.leading, 4)
                                }

                                else {
                                    Button(action: {
                                        withAnimation {
                                            self.showTaskOption.toggle()
                                        }
                                    }){
                                        ZStack {
                                            Circle()
                                                .fill(Color(UIColor.systemGray5))
                                                .frame(width: 90)
                                            Image("\(self.identifyMountImg())")                           .resizable()
                                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                                .frame(height: 80)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }

                            if !self.showTaskOption {
                                VStack {
                                    HStack {
                                        VStack {
                                            Text("Traveled Time")
                                        }
                                        .frame(width: geo.size.width / 2.4)
                                        VStack {
                                            Text("\(self.calTraveledTime(travelTime: self.travelledTimeMin)) min")
                                        }
                                        .frame(width: geo.size.width / 5)
                                    }
                                }
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 14)
                                .background(Color(UIColor.systemGray4))
                                .cornerRadius(16)
                            }
                        }
                    }
                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 6)
                    .padding(.bottom, geo.size.height / 1.3)
                }
            }
        }
    }
}

enum taskItems {
    
   case yellow, orange, green, blue
    
    var color: String{
        switch self{
        case .yellow: return "yellow"
        case .orange: return "orange"
        case .green: return "green"
        case .blue: return "blue"
        }
    }
    
    var mountain: String{
        switch self{
        case .yellow: return "mount_01"
        case .orange: return "mount_02"
        case .green: return "mount_03"
        case .blue: return "mount_04"
        }
    }
}

struct Task: View {
    
    func idtenfiedColor(color: String) -> UIColor {
        
        var chosenColor = UIColor.systemGray
        
        if self.taskColor.color == "yellow" {
            chosenColor = UIColor.systemYellow
        }
        
        else if self.taskColor.color == "orange" {
            chosenColor = UIColor.systemOrange
        }

        else if self.taskColor.color == "green" {
            chosenColor = UIColor.systemGreen
        }

        else if self.taskColor.color == "blue" {
            chosenColor = UIColor.systemBlue
        }
        
        return chosenColor
    }
    
    func identifyMountImg(img: String) -> String {
        
        var mountImg = ""
        
        if self.taskColor.color == "yellow" {
            mountImg = "mount_01"
        }
        
        else if self.taskColor.color == "orange" {
            mountImg = "mount_02"
        }

        else if self.taskColor.color == "green" {
            mountImg = "mount_03"
        }

        else if self.taskColor.color == "blue" {
            mountImg = "mount_04"
        }
        
        return mountImg
    }

    
    @Binding var showTaskOption: Bool
    @Binding var taskColorChoosen: UIColor
    @State var taskColor: taskItems

    var body: some View {
        GeometryReader { geo in
            Button(action: {
                withAnimation {
                    self.showTaskOption.toggle()
                    self.taskColorChoosen = self.idtenfiedColor(color: self.taskColor.color)
                }
            }) {
                Image("\(self.identifyMountImg(img: self.taskColor.color))")
                    .resizable()
                    .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                    .frame(height: geo.size.width / 1.1)
                    .clipShape(Circle())
            }
        }
    }
}
 
