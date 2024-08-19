//
//  BlockingForm.swift
//  SleepBlockerApp
//
//  Created by Saketh Koona on 8/9/24.
//

import SwiftUI
import FamilyControls


struct BlockingForm: View {
    @State var isFamilyPickerPresented: Bool = false
    
    // all of these bindings are passed back into SchedulingForm.swift to be sent to the model
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var daysActive: [String]
    @Binding var blockedApps: FamilyActivitySelection
        
    let daysOfTheWeek: [String] = ["Su", "M", "T", "W", "Th", "F", "S"] // constant to access later
    
    var body: some View {
        VStack(spacing: 20) {
            timeSelectors
            daysSelector
            appsToBlockPicker // Add this view to show the button
        }
        .familyActivityPicker(isPresented: $isFamilyPickerPresented, selection: $blockedApps)
    }

    
    var appsToBlockPicker: some View {
        Button {
            self.isFamilyPickerPresented = true
        } label: {
            CardView(content: {
                HStack {
                    
                    VStack {
                        Text("Saved Selection")
                    }
                    
                    Spacer()
                    
                    Text("Edit")
                }
            }, width: 358, height: 88, fillColor: Color.gray)
        }

    }
    
    var timeSelectors: some View {
        return VStack {
            Text("Blocking Hours")
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                RoundBox(content: "")
                    .overlay {
                        DatePicker("From: ", selection: $startTime, displayedComponents: .hourAndMinute) // the default value is the binding which is Date.now initially
                            .labelsHidden()
                    }
                
                RoundBox(content: "")
                    .overlay {
                        DatePicker("To: ", selection: $endTime, displayedComponents: .hourAndMinute) // the default value is the binding which is Date.now initially
                            .labelsHidden()
                    }
            }
        }
    }
    
    var daysSelector: some View {
        VStack {
            Text("Select Days")
            
            HStack {
                ForEach(self.daysOfTheWeek, id: \.self) { day in
                    DayCircle(daysActive: $daysActive, content: day)
                }
            }
        }
    }
}

struct DayCircle: View {
    
    @Binding var daysActive: [String]
    let content: String
    
    var isSelected: Bool {
        daysActive.contains(content)
    }
    
    var body: some View {
        Circle()
            .fill(isSelected ? Color.orange : Color.teal)
            .frame(width: 40)
            .overlay {
                Text(content)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }.onTapGesture {
                if let index = daysActive.firstIndex(of: content) {
                    daysActive.remove(at: index)
                } else {
                    daysActive.append(content)
                }
            }
    }
}


struct RoundBox: View {
    
    var content: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 35.0)
            .fill(Color.gray)
            .frame(width: 145, height: 50)
            .overlay {
                Text(self.content)
            }
    }
}

