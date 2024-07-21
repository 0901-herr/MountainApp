//
//  Process.swift
//  Target
//
//  Created by Philippe Yong on 02/04/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct Process: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: HistoryTimeData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \HistoryTimeData.createdAtDate, ascending: true)]) var historyTimeData: FetchedResults<HistoryTimeData>

    
    @State var historyData: [HistoryData] = []
    @State var todayData: [[Data]] = []
    @State var pickerSelectedData = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(#colorLiteral(red: 0.9238370061, green: 0.9125515819, blue: 0.9125822186, alpha: 0.6023116438))
                NavigationView {
                    List {
                        VStack {
                            VStack {
                                Text("")
                                Picker(selection: self.$pickerSelectedData, label: Text("")){
                                    Text("Today").tag(0)
                                    Text("History").tag(1)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal, 16)
                            }
                            .navigationBarTitle("Process")
                        
                            // History Data display
                            if self.pickerSelectedData == 1 {
                                VStack (spacing: 20) {
                                    ForEach(self.historyData, id: \.self){ data in
                                        HisProcessView(title: data.title, second: Int16(truncating: data.second), createdAt: data.createdAtStr, color: data.color)
                                    }
                                    .frame(height: geo.size.height / 12)
                                }
                                .padding(.top, 20)
                            }
                            
                            // Today Data display
                            else {
                                VStack (spacing: 30) {
                                    
                                    if self.todayData[0].count != 0 {
                                    VStack {
                                        VStack {
                                            Text("Yellow")
                                                .foregroundColor(Color(UIColor.systemYellow))
                                                .font(.system(size: 18))
                                        }
                                        .frame(width:( UIScreen.main.bounds.width / 2) - 80, height: 30, alignment: .center)
                                        .background(
                                            Capsule()
                                                .stroke(Color(UIColor.systemYellow), lineWidth: 2)
                                        )
                                        .padding(.bottom, 10)
                                        .padding(.trailing, geo.size.width / 1.6)
                                        
                                        VStack {
                                            ForEach(self.todayData[0], id: \.self) { data in
                                                TodProcessView(title: data.title, second: Int16(truncating: data.second))
                                            }
                                            .frame(width: geo.size.width / 1.3, height: geo.size.height / 12)
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    }
                                    
                                    if self.todayData[1].count != 0 {
                                        VStack {
                                            VStack {
                                                Text("Orange")
                                                    .foregroundColor(Color(UIColor.systemOrange))
                                                    .font(.system(size: 18))
                                            }
                                            .frame(width:( UIScreen.main.bounds.width / 2) - 80, height: 30, alignment: .center)
                                            .background(
                                                Capsule()
                                                    .stroke(Color(UIColor.systemOrange), lineWidth: 2)
                                            )
                                            .padding(.bottom, 10)
                                            .padding(.trailing, geo.size.width / 1.6)
                                            
                                            VStack {
                                                ForEach(self.todayData[1], id: \.self) { data in
                                                    TodProcessView(title: data.title, second: Int16(truncating: data.second))
                                                }
                                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 12)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }

                                    
                                    if self.todayData[2].count != 0 {
                                        VStack {
                                            VStack {
                                                Text("Green")
                                                    .foregroundColor(Color(UIColor.systemGreen))
                                                    .font(.system(size: 18))
                                            }
                                            .frame(width:( UIScreen.main.bounds.width / 2) - 80, height: 30, alignment: .center)
                                            .background(
                                                Capsule()
                                                    .stroke(Color(UIColor.systemGreen), lineWidth: 2)
                                            )
                                            .padding(.bottom, 10)
                                            .padding(.trailing, geo.size.width / 1.6)
                                            
                                            VStack {
                                                ForEach(self.todayData[2], id: \.self) { data in
                                                    TodProcessView(title: data.title, second: Int16(truncating: data.second))
                                                }
                                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 12)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }

                                    if self.todayData[3].count != 0 {
                                        VStack {
                                            VStack {
                                                Text("blue")
                                                    .foregroundColor(Color(UIColor.systemBlue))
                                                    .font(.system(size: 18))
                                            }
                                            .frame(width:( UIScreen.main.bounds.width / 2) - 80, height: 30, alignment: .center)
                                            .background(
                                                Capsule()
                                                    .stroke(Color(UIColor.systemBlue), lineWidth: 2)
                                            )
                                            .padding(.bottom, 10)
                                            .padding(.trailing, geo.size.width / 1.6)
                                            
                                            VStack {
                                                ForEach(self.todayData[3], id: \.self) { data in
                                                    TodProcessView(title: data.title, second: Int16(truncating: data.second))
                                                }
                                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 12)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }
                                }
                                .padding(.top, 20)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HisProcessView: View {
    
    @State var title = ""
    @State var second: Int16
    @State var createdAt = ""
    @State var color = ""
    
    func idtenfiedColor(color: String) -> UIColor {
        
        var chosenColor = UIColor.systemGray
        
        if self.color == "Yellow" {
            chosenColor = UIColor.systemYellow
        }
        
        else if self.color == "Orange" {
            chosenColor = UIColor.systemOrange
        }

        else if self.color == "Green" {
            chosenColor = UIColor.systemGreen
        }

        else if self.color == "Blue" {
            chosenColor = UIColor.systemBlue
        }
        
        return chosenColor
    }

    var body: some View {
        VStack {
            GeometryReader { geo in
                HStack {
                    VStack {
                        Text(self.createdAt)
                    }
                    .frame(width: geo.size.width / 6.2, height: 60)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                    
                    VStack (alignment: .leading, spacing: 6){
                        HStack (spacing: 14){
                            Circle()
                                .fill(Color(self.idtenfiedColor(color: self.color)))
                                .frame(width: 20, height: 20)
                            Text(self.title)
                                .frame(maxWidth: geo.size.width, maxHeight: geo.size.height / 3 ,alignment: .leading)
                        }
                        .padding(.leading, geo.size.width / 7)
                        
                        HStack (spacing: -geo.size.width / 8){
                            ZStack (alignment: .leading){
                                Rectangle()
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(width: geo.size.width * 0.5, height: geo.size.height / 9)
                                Rectangle()
                                    .fill(Color(UIColor.systemGray3))
                                    .frame(width: geo.size.width * 0.5 / 180 * CGFloat(self.second / 60), height: geo.size.height / 9)
                            }
                            .frame(width: geo.size.width * 5 / 6, height: geo.size.height / 10)
                            
                            VStack {
                                Text("\(self.second / 60) m")
                            }
                            .frame(width: geo.size.width / 5)
                            .padding(.trailing, 16)
                        }
                        .frame(width: geo.size.width / 1.1, height: geo.size.height / 10)
                    }
                    .frame(width: geo.size.width / 1.2, height: 60)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                }
            }
        }
    }
}


struct TodProcessView: View {
    
    @State var title = ""
    @State var second: Int16
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack (alignment: .leading, spacing: 6){
                    HStack (spacing: 6){
                        VStack {
                            VStack {
                                Text(self.title)
                            }
                            .frame(width: geo.size.width, alignment: .leading)
                            .padding(.leading, geo.size.width / 3.6)

                            VStack {
                                ZStack (alignment: .leading){
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray5))
                                        .frame(width: geo.size.width * 0.6, height: geo.size.height / 10)
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray3))
                                        .frame(width: geo.size.width * 0.6 / 180 * (CGFloat(self.second) / 60), height: geo.size.height / 10)
                                }
                            }
                            .frame(width: geo.size.width)
                        }
                        .frame(width: geo.size.width / 1.1, height: 60)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(16)
                        
                        VStack {
                            Text("\(self.second / 60) m ")
                        }
                        .frame(width: geo.size.width / 5, height: 60)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(16)
                    }
                }
                .frame(width: geo.size.width / 1.1)
            }
        }
    }
}

struct Process_Previews: PreviewProvider {
    static var previews: some View {
        Process()
    }
}
