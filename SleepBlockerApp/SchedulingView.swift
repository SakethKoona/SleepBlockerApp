//
//  MainScreen.swift
//  SleepBlockerApp
//
//  Created by Saketh Koona on 8/4/24.
//



import SwiftUI
import FamilyControls
import SwiftData


struct SchedulingView: View {
    // Note to self: @Query only works if you have a list of schedules
    @Query var schedules: [SleepSchedule]
    @Environment(\.modelContext) var context

    @State var showSheet: Bool = false
    @State var scheduleButtonState: Int = 0
    @State var from: Date
    @State var to: Date
        
    var body: some View {
        VStack { /// when using tabs, make sure everything is nested inside some sort of stack
            Text("Sleep Goal - 8 h")
                .font(.caption)
                .padding(.top, 20)

            Spacer()
            // Center of page content
            VStack(spacing: 20) {
                Text("Enhance your sleep \nSet apps for blocking hours")
                    .multilineTextAlignment(.center)
                
                Text("From")
                
                // from and to become whatever we have in the time-box here
                TimeBox(content: "", fontSize: 28)
                    .overlay {
                        DatePicker("", selection: $from, displayedComponents: .hourAndMinute)
                            .frame(alignment: .center)
                    }
                
                Text("To")
                
                TimeBox(content: "", fontSize: 28)
                    .overlay {
                        DatePicker("", selection: $to, displayedComponents: .hourAndMinute)
                            .frame(alignment: .center)
                    }
                
                debuggingStuff
            }

            Spacer()
            
            scheduleSession

        }
        .padding()
    }
    
    var scheduleSession: some View {
        Button(action: {
            showSheet.toggle()
        }, label: {
            TimeBox(content:  scheduleButtonState == 0 ? "Schedule App Blocking" : "Edit Schedule", defaultHeight: 50, radius: 97)
        }).sheet(isPresented: $showSheet, content: {
            // we pass the values of from and to into the scheduling form
            SchedulingForm(showSheet: $showSheet,
                           scheduleButtonState: $scheduleButtonState,
                           startTime: $from,
                           endTime: $to,
                           daysActive: schedules.first?.daysActive ?? [],
                           blockedApps: schedules.first?.selectionToDiscourage ?? FamilyActivitySelection())
        })
    }
    
    var debuggingStuff: some View {
        VStack {
            Text(schedules.first?.startTime.formatted() ?? "No from time selected yet")
            Text(schedules.first?.endTime.formatted() ?? "No to time selected yet")

            if let cats = schedules.first?.selectionToDiscourage.categories { /// this segment doesn't work in perviews because we never asked permission
                ForEach(Array(cats), id: \.self) { cat in
                    Text(cat.localizedDisplayName ?? "Didn't get anything")
                }
            } else {
                Text("No apps blocked")
            }
            
            if let days = schedules.first?.daysActive {
                ForEach(days, id: \.self) { day in
                    Text(day)
                }
            } else {
                Text("No days selected yet")
            }
        }
    }
}


struct TimeBox: View {
    var content: String
    
    // default values for the width and height
    var defaultWidth: CGFloat = 358
    var defaultHeight: CGFloat = 60
    
    //value for font size
    var fontSize: CGFloat = 17
    
    // value for corner radius
    var radius: CGFloat = 75
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .strokeBorder(lineWidth: 2.0)
            .frame(width: defaultWidth, height: defaultHeight)
            .overlay {
                Text(content)
                    .font(.system(size: fontSize))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
    }
}
