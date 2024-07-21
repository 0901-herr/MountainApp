//
//  BottomView.swift
//  Target
//
//  Created by Philippe Yong on 12/04/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct BottomView: View {
    
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

    @Binding var showAddTask: Bool
    @State var showProcess: Bool = false

    @State var historyData: [HistoryData] = []
    @State var todayData: [[Data]] = []
    
    func getTodData(processData: [[Data]]) -> [[Data]] {
        
        var finalData: [[Data]] = []
            var yelData: [Data] = []
            var oraData: [Data] = []
            var greData: [Data] = []
            var bluData: [Data] = []
        
            var yelFinData: [Data] = []
            var oraFinData: [Data] = []
            var greFinData: [Data] = []
            var bluFinData: [Data] = []
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy MM/dd"
            let formattedDate = format.string(from: date)

            for data in yellowData {
                if data.title != nil && data.createdAt != nil && data.second != nil && data.createdAt! == formattedDate {
                yelData.append(Data(title: data.title!, second: data.second!))
                }
            }
        
            for data in orangeData {
                if data.title != nil && data.createdAt != nil && data.second != nil && data.createdAt! == formattedDate {
                    oraData.append(Data(title: data.title!, second: data.second!))
                }
            }
            
            for data in greenData {
                if data.title != nil && data.createdAt != nil && data.second != nil && data.createdAt! == formattedDate {
                    greData.append(Data(title: data.title!, second: data.second!))
                }
            }
        
            for data in blueData {
                if data.title != nil && data.createdAt != nil && data.second != nil && data.createdAt! == formattedDate {
                    bluData.append(Data(title: data.title!, second: data.second!))
                }
            }
         
            let yellowDic = Dictionary(grouping: yelData, by: { $0.title})
            let orangeDic = Dictionary(grouping: oraData, by: { $0.title})
            let greenDic = Dictionary(grouping: greData, by: { $0.title})
            let blueDic = Dictionary(grouping: bluData, by: { $0.title})

            for i in yellowDic {
                let title = i.key
                var second = 0
            
                for x in 0...i.value.count - 1 {
                    second += Int(truncating: i.value[x].second)
                }
                yelFinData.append(Data(title: title, second: NSNumber(value: second)))
            }
                
            for i in orangeDic {
                let title = i.key
                var second = 0
                
                for x in 0...i.value.count - 1 {
                    second += Int(truncating: i.value[x].second)
                }
                oraFinData.append(Data(title: title, second: NSNumber(value: second)))
            }
                
            for i in greenDic {
                let title = i.key
                var second = 0
            
                for x in 0...i.value.count - 1 {
                    second += Int(truncating: i.value[x].second)
                }
                greFinData.append(Data(title: title, second: NSNumber(value: second)))
            }
                
            for i in blueDic {
                let title = i.key
                var second = 0
                
                for x in 0...i.value.count - 1 {
                    second += Int(truncating: i.value[x].second)
                }
                bluFinData.append(Data(title: title, second: NSNumber(value: second)))
            }
                
            print("Yellow Data: \(yelFinData) at \(formattedDate)")
            print("Orange Data: \(oraData) at \(formattedDate)")
            print("Green Data: \(greData) at \(formattedDate)")
            print("\(bluData) at \(formattedDate)")

            finalData.append(yelFinData)
            finalData.append(oraFinData)
            finalData.append(greFinData)
            finalData.append(bluFinData)

            return finalData
    }
    
    func getHistoryData(processData: [HistoryData]) -> [HistoryData] {
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
            print(historyTitleDic)
        }
        
        historyFinData.sort(by: { $0.createdAtDate > $1.createdAtDate })
        print("History Final Data Stored: \(historyFinData)")
        return historyFinData
    }

    var body: some View {
        VStack (alignment: .trailing){
            GeometryReader { geo in
                VStack {
                    HStack (spacing: 14){
                        VStack {
                            Button(action: {
                                self.showProcess.toggle()
                                self.historyData = self.getHistoryData(processData: self.historyData)
                                self.todayData = self.getTodData(processData: self.todayData)
                            }){
                                Image(systemName: "chart.bar")
                                .foregroundColor(Color.black)
                                .font(.system(size:26))
                            }.sheet(isPresented: self.$showProcess){
                                Process(historyData: self.historyData, todayData: self.todayData).environment(\.managedObjectContext, self.moc)
                            }
                        }
                        .frame(width: 70, height: 70)
                        .background(Color(UIColor.systemYellow))
                        .clipShape(Circle())
                        
                        VStack {
                            Button(action: {
                                withAnimation {
                                    self.showAddTask.toggle()
                                }
                            }){
                                Image(systemName: "plus")
                                .foregroundColor(Color.black)
                                .font(.system(size:26))
                                }
                        }
                        .frame(width: 70, height: 70)
                        .background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                        .clipShape(Circle())
                    }
//                    .padding(.bottom, geo.size.height / 4.8)
                    .padding(.leading, geo.size.width / 2.1)
                    .frame(width: geo.size.width / 1.1, height: geo.size.height)
                    .cornerRadius(20)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Data: Hashable {
    var title: String
    var second: NSNumber
}

struct HistoryData: Hashable {
    var title: String
    var second: NSNumber
    var createdAtStr: String
    var createdAtDate: Date
    var color: String
}
