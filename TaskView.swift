//
//  TaskView.swift
//  Target
//
//  Created by Philippe Yong on 24/03/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}

struct CustomSliderComponents {
    let barLeft: CustomSliderModifier
    let barRight: CustomSliderModifier
    let knob: CustomSliderModifier
}

struct CustomSliderModifier: ViewModifier {
    enum Name {
        case barLeft
        case barRight
        case knob
    }
    let name: Name
    let size: CGSize
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
        .frame(width: size.width)
            .position(x: size.width*0.5, y: size.height*0.5)
        .offset(x: offset)
    }
}

struct CustomSlider<Component: View>: View {

    @Binding var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (CustomSliderComponents) -> Component

    init(value: Binding<Double>, range: (Double, Double), knobWidth: CGFloat? = nil,
         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        _value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
    }

    var body: some View {
      return GeometryReader { geometry in
        self.view(geometry: geometry) // function below
      }
    }
    
    private func view(geometry: GeometryProxy) -> some View {
      let frame = geometry.frame(in: .global)
      let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
        self.onDragChange(drag, frame) }
      )
      let offsetX = self.getOffsetX(frame: frame)

      let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
      let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
      let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)

      let modifiers = CustomSliderComponents(
          barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
          barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
          knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX))

      return ZStack { viewBuilder(modifiers).gesture(drag) }
    }
    
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.value = value
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}

struct TaskView: View {
    
    // Core data
    @State var title = ""
    @State var minutes = 0
    @State var createdAt = ""
    @State var color: UIColor
    @State var value: Double = 30
    @State var startTask: Bool = false
    
    @Binding var activatedTask: String
    @Binding var activatedTaskColor: String
    @Binding var activatedSliderValue: Int
    @Binding var startTaskRecord: [Bool]
    @Binding var viewProvider: Int
    
    func identifyColor(color: UIColor) ->  String{
        
        var chosenColor = ""
        
        if self.color == UIColor.systemYellow {
            chosenColor = "Yellow"
        }
        
        else if self.color == UIColor.systemOrange {
            chosenColor = "Orange"
        }

        else if self.color == UIColor.systemGreen {
            chosenColor = "Green"
        }

        else if self.color == UIColor.systemBlue {
            chosenColor = "Blue"
        }
        
        return chosenColor
    }

    var body: some View {
        
        GeometryReader { geo in
            return ZStack {
                HStack (spacing: 10){
                    
                    ZStack {
                        CustomSlider(value: self.$value, range: (1, 90), knobWidth: 0) { modifiers in
                            
                        ZStack {
                            if self.startTaskRecord.last! == false {
                                ZStack {
                                    Group  {
                                        Color(self.color)
                                    }
                                    .modifier(modifiers.barLeft)
                                
                                    HStack {
                                        VStack {
                                            Text(self.title)
                                                .foregroundColor(.black)
                                                .font(.system(size: 22))
                                                .frame(maxWidth: geo.size.width, maxHeight: geo.size.height / 3 ,alignment: .leading)
                                        }
                                        .frame(width: geo.size.width / 3)
                                        
                                        HStack {
                                            Text(("\(Int(self.value)) m"))
                                                .font(.system(size: 22))
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color.black)
                                                .frame(width: 64)
                                                .animation(.none)
                                        }
                                        .frame(width: geo.size.width / 3)
                                    }
                                }
                                .background(Color(UIColor.systemGray6))
                            }
                            
                            else {
                                ZStack {
                                    Color(self.color)
                                    
                                    HStack {
                                        VStack {
                                            Text(self.title)
                                                .frame(maxWidth: geo.size.width, maxHeight: geo.size.height / 3 ,alignment: .leading)
                                                .foregroundColor(.black)
                                                .font(.system(size: 22))
                                                .padding(.leading, geo.size.width / 6)
                                        }
                                        .frame(width: geo.size.width)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: geo.size.width / 1.3, height: geo.size.width / 4)
                .cornerRadius(20)
                    
                 if self.startTaskRecord.last! == false {
                    Button(action: {
                        withAnimation {
                            self.startTask.toggle()
                            
                            if self.startTaskRecord.last! == false {
                                self.startTaskRecord.append(true)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.viewProvider = 0
                            }
                        }
                        self.activatedTask = self.title
                        self.activatedTaskColor = self.identifyColor(color: self.color)
                        self.activatedSliderValue = Int(self.value)
                        
                    }){
                        VStack {
                            Image(systemName: self.startTaskRecord.last! ? "circle.fill" : "circle")
                                .foregroundColor(Color(self.color))
                                .font(.system(size: geo.size.width / 7))
                        }
                    }
                    .frame(width: geo.size.width / 6)
                    .buttonStyle(BorderlessButtonStyle())
                    }
                 else {
                    VStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color(self.color))
                            .font(.system(size: geo.size.width / 7))
                    }
                }
                    
                }
                .frame(width: geo.size.width)
            }
            .padding(.trailing, 20)
        }
    }
}

struct TaskView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/*
 HStack {
     VStack {
         Text(self.minValue)
             .font(.system(size: 22))
             .fontWeight(.semibold)
             .foregroundColor(Color.black)
     }
     .frame(width: 34)
     
     VStack {
         Text("\(self.secValue)")
             .font(.system(size: 22))
             .fontWeight(.semibold)
             .foregroundColor(Color.black)
         }
         .frame(width: 34)
     }
 .frame(width: geo.size.width / 3)

 */
