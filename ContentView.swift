//
//  ContentView.swift
//  Target
//
//  Created by Philippe Yong on 23/03/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        
    @State var showAddTask: Bool = false
    @State var showTaskOption: Bool = false
    
    @State var taskColorChoosen: UIColor = UIColor.systemYellow
    @State var currentPage = 0
    
    @State var activatedTask = ""
    @State var activatedTaskColor = ""
    @State var activatedSliderValue = 0
    @State var startTaskRecord = [false]
    @State var historyData: [HistoryData] = []
    @State var mountainImg = ""

    init() {
           UITableView.appearance().separatorStyle = .none
       }

    var body: some View {
        PagerView(pageCount: 2, currentIndex: $currentPage) {
            VStack {
                VStack {
                    HomeView(activatedTask: self.$activatedTask, activatedTaskColor: self.$activatedTaskColor, activatedSliderValue: self.$activatedSliderValue, startTaskRecord: self.$startTaskRecord, viewProvider: self.$currentPage)
                }
            }
            
            ZStack {
                NavigationView {
                    ZStack {
                        Color(#colorLiteral(red: 0.9313978553, green: 0.9258610606, blue: 0.9356539845, alpha: 1))
                        VStack {
                            GeometryReader { geo in
                                ZStack {
                                    TopView(taskColorChoosen: self.$taskColorChoosen, activatedTask: self.$activatedTask, activatedTaskColor: self.$activatedTaskColor, activatedSliderValue: self.$activatedSliderValue, startTaskRecord: self.$startTaskRecord, viewProvider: self.$currentPage)
                                    .frame(height: geo.size.height - geo.size.height / 6)
                                    .padding(.top, -geo.size.height / 15)

                                    BottomView(showAddTask: self.$showAddTask)
                                        .frame(height: geo.size.height / 6)
                                        .padding(.top, geo.size.height / 1.2)
                                }
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                
                if self.showAddTask {
                    GeometryReader{_ in
                        AddTask(showAddTask: self.$showAddTask,taskColor: self.taskColorChoosen)
                    }.background(
                        Color.black.opacity(0.20)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation{
                                    self.showAddTask.toggle()
                                }
                            }
                        )
                    }
            }
        }
    }
}
  
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = 2
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    if self.currentIndex == 1 && value.translation.width > 50 {
                        state = value.translation.width
                    }
                    else{}
                    if self.currentIndex == 0 && -value.translation.width > 50 {
                        state = value.translation.width
                    }
                    else{}
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
    
                }
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}
