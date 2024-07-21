//
//  Profile.swift
//  Target
//
//  Created by Philippe Yong on 01/05/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct Profile: View {
    
    var mountainList1: [String] = ["mount_01", "mount_02", "mount_03"]
    var mountainList2: [String] = ["mount_04", "mount_05", "mount_06"]
    
    @State var mount_01 = true
    @State var mount_02 = false
    @State var mount_03 = false
    @State var mount_04 = false
    @State var mount_05 = false
    
    var body: some View {
        
        ZStack {
            Color(#colorLiteral(red: 0.9646790624, green: 0.9691432118, blue: 0.9800562263, alpha: 1))
            VStack {
                VStack {
                    Circle()
                        .stroke(lineWidth: 12)
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 200, height: 200)
                }
                
                VStack(spacing: 30) {
                    HStack(spacing: 30) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "triangle.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(Color.green)
                            }
                            Text("Badge")
                                .foregroundColor(Color.black)
                        }
                        VStack {
                            Text("Mount Danviel")
                                .font(.system(size: 24))
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.width / 2, height: 60)
                                .foregroundColor(Color.black)
                        }
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(20)
                    }
                    HStack(spacing: 30) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(Color(UIColor.systemRed))
                            }
                            Text("Record")
                                .foregroundColor(Color.black)
                        }
                        VStack {
                            Text("200 minute")
                                .font(.system(size: 24))
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .frame(width: UIScreen.main.bounds.width / 2, height: 60)
                        }
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(20)
                    }
                }
                .padding(.top, 20)
                
                VStack (spacing: 20){
                    Text("Mountain collection")
                        .fontWeight(.semibold)
                        .font(.system(size: 30))
                    VStack {
                        HStack(spacing: 25){
                            ForEach(mountainList1, id: \.self){ mountain in
                                Mountain(mountainImg: mountain)
                            }
                        }
                        HStack(spacing: 25) {
                            ForEach(mountainList2, id: \.self){ mountain in
                                Mountain(mountainImg: mountain)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.top, 50)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct Mountain: View {
    
    @State var mount_01 = true
    @State var mount_02 = false
    @State var mount_03 = false
    @State var mount_04 = false
    @State var mount_05 = false
    
    @State var mountainImg = ""
    @State var unlockMount = false
    
    var body: some View {
        ZStack {
            Image("\(self.mountainImg)")
                .resizable()
                .clipShape(Circle())
                .frame(width: 90, height: 90)
            
            if self.unlockMount {
                ZStack {
                    Color(UIColor.black)
                        .opacity(0.4)
                        .clipShape(Circle())
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 26))
                        .foregroundColor(Color.white)
                }
            }
        }
    }
    
    func checkBadege() {
        if self.mountainImg == "mountain_01" && mount_01 {
            self.unlockMount = true
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
