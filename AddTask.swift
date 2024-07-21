//
//  AddTask.swift
//  Target
//
//  Created by Philippe Yong on 24/03/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import SwiftUI

struct AddTask: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Yellow.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Yellow.createdAt, ascending: true)]) var yellow: FetchedResults<Yellow>
    @FetchRequest(entity: Orange.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Orange.createdAt, ascending: true)]) var orange: FetchedResults<Orange>
    @FetchRequest(entity: Green.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Green.createdAt, ascending: true)]) var green: FetchedResults<Green>
    @FetchRequest(entity: Blue.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Blue.createdAt, ascending: true)]) var blue: FetchedResults<Blue>

    @Binding var showAddTask: Bool
    @State var taskColor: UIColor = UIColor.systemYellow
    
    @State var createdAt: Date = Date()
    @State var title: String = ""
    @State var alarm: Date = Date()
    @State var percentage: Float = 20

    @State var showDatePicker = false
    @State var showTaskOption = true
    @State var showAlert = false
    
    func saveTask() {
        if self.taskColor == UIColor.systemYellow && self.title != "" {
            let taskItems = Yellow(context: self.moc)
            taskItems.taskTitle = self.title
            taskItems.createdAt = self.createdAt
            taskItems.alarm = self.alarm
            taskItems.taskColor = "yellow"
            
            do{
                try self.moc.save()
                } catch{
                    print(error)
                }
        }
            
        else if self.taskColor == UIColor.systemOrange && self.title != "" {
            let taskItems = Orange(context: self.moc)
            taskItems.taskTitle = self.title
            taskItems.createdAt = self.createdAt
            taskItems.alarm = self.alarm
            taskItems.taskColor = "orange"
            
            do{
                try self.moc.save()
                } catch{
                    print(error)
                }
        }
            
        else if self.taskColor == UIColor.systemGreen && self.title != "" {
            let taskItems = Green(context: self.moc)
            taskItems.taskTitle = self.title
            taskItems.createdAt = self.createdAt
            taskItems.alarm = self.alarm
            taskItems.taskColor = "green"
            
            do{
                try self.moc.save()
                } catch{
                    print(error)
                }
        }
            
      else if self.taskColor == UIColor.systemBlue && self.title != "" {
            let taskItems = Blue(context: self.moc)
            taskItems.taskTitle = self.title
            taskItems.createdAt = self.createdAt
            taskItems.alarm = self.alarm
            taskItems.taskColor = "blue"
            
            do{
                try self.moc.save()
                } catch{
                    print(error)
                }
        }
        title = ""
    }
    
    func checkTitle() {
        for i in yellow {
            if self.title == i.taskTitle {
                self.showAlert = true
            }
        }
        for i in orange {
            if self.title == i.taskTitle {
                self.showAlert = true
            }
        }
        for i in green {
            if self.title == i.taskTitle {
            }
        }
        for i in blue {
            if self.title == i.taskTitle {
                self.showAlert = true
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack {
                    if self.showTaskOption {
                        ZStack{
                            VStack {
                                VStack {
                                    
                                    //MARK: - Save Task
                                    
                                    Button(action: {
                                        self.checkTitle()
                                        if self.showAlert {}
                                        else {
                                            self.saveTask()
                                        }
                                        withAnimation {
                                            self.showAddTask.toggle()
                                        }
                                    }){
                                        HStack {
                                            Text("Add")
                                                .foregroundColor(Color.black)
                                                .font(.system(size: 16))
                                            Image(systemName: "paperplane")
                                                .foregroundColor(Color.black)
                                                .font(.system(size: 16))
                                        }
                                        .frame(width: geo.size.width / 4.2, height: 40, alignment: .center)
                                        .background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                                        .cornerRadius(18)
                                    }
                                    .alert(isPresented: self.$showAlert) {
                                               Alert(title: Text("Task already exist"), message: Text("Change another task name"), dismissButton: .default(Text("Got it!")))
                                    }
                                }
                                .frame(height: geo.size.height / 14)
                                .padding(.leading, geo.size.width / 1.9)
                                
                                // MARK: - Text Field
                                
                                VStack{
                                    TextView(text: self.$title)
                                        .font(.system(size: 30))
                                        .frame(maxWidth: geo.size.width / 1.4, maxHeight: 200, alignment: .top)
                                }
                                .cornerRadius(16)

                                HStack (spacing: 0) {
                                    VStack {
                                        Image(systemName: "alarm")
                                            .font(.system(size: 24))
                                            .frame(width: 50, height: 50)
                                    }
                                    .background(Color(#colorLiteral(red: 1, green: 0.7759538293, blue: 0.07127160579, alpha: 1)))
                                    .clipShape(Circle())
                                    VStack {
                                        Button(action: {
                                            withAnimation {
                                                self.showDatePicker.toggle()
                                                self.showTaskOption.toggle()
                                            }
                                                
                                            // Notification
                                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                                if success {
                                                    print("All set!")
                                                } else if let error = error {
                                                    print(error.localizedDescription)
                                                }
                                            }

                                        }){
                                            Text("Remind me at?")
                                                .frame(width: 230, height: 46)
                                                .foregroundColor(Color.black)
                                        }
                                    }
                                    .frame(width: 180, height: 46)
                                    .background(Color(#colorLiteral(red: 1, green: 0.7759538293, blue: 0.07127160579, alpha: 1)))
                                    .cornerRadius(18)
                                    .padding()
                                }
                                .frame(width: geo.size.width / 1.1)
                            }
                        }
                    }
            }
                            
                if self.showDatePicker {
                    VStack {
                        
                        VStack {
                            HStack (spacing: geo.size.width / 4.2){
                                Text("Set Alarm")
                                    .font(.system(size: 28))
                                    .fontWeight(.bold)
                                    .frame(width: 150, alignment: .leading)
                                    .padding(.leading, 30)
                                
                                Button(action: {
                                    withAnimation {
                                        self.showDatePicker.toggle()
                                        self.showTaskOption.toggle()
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(UIColor.systemGray5))
                                            .frame(height: 70)
                                        Image(systemName: "arrow.uturn.left")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 22))
                                    }
                                    .frame(alignment: .trailing)
                                }
                                .padding(.trailing, 20)
                            }
                            .padding(.bottom, 15)

                            DatePicker("", selection: self.$alarm, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(height: 190)
                        }
                        
                        VStack {
                            Button(action: {
                                withAnimation {
                                    self.showDatePicker.toggle()
                                    self.showTaskOption.toggle()
                                }
                                let content = UNMutableNotificationContent()
                                content.title = "Time to start your task!"
                                content.subtitle = "start \(self.title) now"
                                content.sound = UNNotificationSound.default
                                    
                                var date = DateComponents()
                                let components = Calendar.current.dateComponents([.hour, .minute], from: self.alarm)
                                date.hour = components.hour ?? 0
                                date.minute = components.minute ?? 0
                                    
                                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                UNUserNotificationCenter.current().add(request)
                            }){
                                Text("Set Alarm")
                                    .frame(width: 100, height: 40)
                                    .font(.system(size:18))
                                    .foregroundColor(Color.black)
                                    .background(Color(self.taskColor))
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.top, 15)
                    }
                }
            }
            .frame(width: geo.size.width / 1.2, height: 380)
            .background(Color.white)
            .cornerRadius(24)
            .padding(.bottom, 240)
        }
    }
}

 struct CustomTextField: UIViewRepresentable {

     class Coordinator: NSObject, UITextFieldDelegate {

         @Binding var text: String
         var didBecomeFirstResponder = false

         init(text: Binding<String>) {
             _text = text
         }

         func textFieldDidChangeSelection(_ textField: UITextField) {
             text = textField.text ?? ""
         }
     }

     @Binding var text: String
     var isFirstResponder: Bool = false

     func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
         let textField = UITextField(frame: .zero)
         textField.delegate = context.coordinator
         return textField
     }

     func makeCoordinator() -> CustomTextField.Coordinator {
         return Coordinator(text: $text)
     }

     func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
         if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
             uiView.becomeFirstResponder()
             context.coordinator.didBecomeFirstResponder = true
         }
     }
 }

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "HelveticaNeue", size: 22)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor.white

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextView>) {
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

    class Coordinator : NSObject, UITextViewDelegate {
        var didBecomeFirstResponder = false

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}

