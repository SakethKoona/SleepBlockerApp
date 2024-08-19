//
//  SchedulingForm.swift
//  SleepBlockerApp
//
//  Created by Saketh Koona on 8/5/24.
//

import SwiftUI
import FamilyControls
import SwiftData
import DeviceActivity
import ManagedSettings

struct SchedulingForm: View {    
    @Environment(\.modelContext) var context
    @Query var schedules: [SleepSchedule]

    @Binding var showSheet: Bool
    @Binding var scheduleButtonState: Int
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    @State var daysActive: [String]
    @State var blockedApps: FamilyActivitySelection
    
    var body: some View {
        VStack {
            exitButtons.padding()
            Spacer()
            
            BlockingForm(startTime: $startTime, // -> from
                         endTime: $endTime, // -> to
                         daysActive: $daysActive,
                         blockedApps: $blockedApps)
            
            Spacer()
            if schedules.first != nil {
                deleteCurrentSchedule
            }
        }
    }
    
    var deleteCurrentSchedule: some View {
        Button(action: {
            if let m = schedules.first { context.delete(m) }
            showSheet = false
            scheduleButtonState = 0
        }, label: {
            Text("Delete Session Setup")
                .foregroundColor(.red)
        })
    }
    
    var exitButtons: some View {
        HStack {
            Button(action: {
                showSheet = false
            }, label: {
                Text("Cancel")
            })
            
            Spacer()
            Text("Set App Blocking")
            Spacer()
            
            Button(action: { // Done Button
                scheduleButtonState += 1
                showSheet = false
                
                /// Note to self: There's a bug in swiftdata, tihs will crash in preview, but work perfectly fine in simulation
                if let m = schedules.first {
                    print(m)
                    print("we're good till here")
                    context.delete(m)
                } else {
                    print("Container is currently empty")
                }
                
                let modifiedSchedule = SleepSchedule(startTime: startTime, endTime: endTime, selectionToDiscourage: blockedApps, daysActive: daysActive, notifyTime: 0)
                context.insert(modifiedSchedule)
                
                print("Hello there")
                startBlockingApps()

            }, label: {
                Text("Done")
                    .fontWeight(.bold)
            })
        }
    }
    
    // MARK: Functions
    
    
    private let store = ManagedSettingsStore()
    
    private func startBlockingApps() {
        let monitoringSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: Calendar.current.component(.hour, from: startTime), minute: Calendar.current.component(.minute, from: startTime)),
            intervalEnd: DateComponents(hour: Calendar.current.component(.hour, from: endTime), minute: Calendar.current.component(.minute, from: endTime)),
            repeats: true)
        
        let eventName = "SleepShield"
        
        let activityCenter = DeviceActivityCenter()
        
        do {
            try activityCenter.startMonitoring(DeviceActivityName(eventName), during: monitoringSchedule)
        } catch(let error) {
            print("Couldn't actually block apps: \(error.localizedDescription)")
        }
        
        store.shield.applications = schedules.first?.selectionToDiscourage.applicationTokens
        print(schedules.first?.selectionToDiscourage.applicationTokens ?? "Couldn't print out the application tokens")
        
    }
}
