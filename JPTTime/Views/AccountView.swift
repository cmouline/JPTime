//
//  AccountView.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 09/02/2025.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    
    @Environment(\.modelContext) private var modelContext
        
    @State var isWorkingOnMonday: Bool = false
    @State var isWorkingOnTuesday: Bool = false
    @State var isWorkingOnWednesday: Bool = false
    @State var isWorkingOnThursday: Bool = false
    @State var isWorkingOnFriday: Bool = false
    
    @State var mondayStartTime: Date = Date.now
    @State var mondayEndTime: Date = Date.now
    @State var tuesdayStartTime: Date = Date.now
    @State var tuesdayEndTime: Date = Date.now
    @State var wednesdayStartTime: Date = Date.now
    @State var wednesdayEndTime: Date = Date.now
    @State var thursdayStartTime: Date = Date.now
    @State var thursdayEndTime: Date = Date.now
    @State var fridayStartTime: Date = Date.now
    @State var fridayEndTime: Date = Date.now
    
    @Query var myAccount: [Account]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Mes horaires habituelles") {
                    HStack {
                        Text(WorkDays.monday.text)
                        Spacer()
                        Toggle(isOn: $isWorkingOnMonday.animation(), label: {})
                    }
                    if isWorkingOnMonday {
                        DatePicker("Entrée", selection: $mondayStartTime, displayedComponents: [.hourAndMinute])
                            .listRowSeparator(.hidden)
                        DatePicker("Sortie", selection: $mondayEndTime, displayedComponents: [.hourAndMinute])
                    }
                    HStack {
                        Text(WorkDays.tuesday.text)
                        Spacer()
                        Toggle(isOn: $isWorkingOnTuesday.animation(), label: {})
                    }
                    if isWorkingOnTuesday {
                        DatePicker("Entrée", selection: $tuesdayStartTime, displayedComponents: [.hourAndMinute])
                            .listRowSeparator(.hidden)
                        DatePicker("Sortie", selection: $tuesdayEndTime, displayedComponents: [.hourAndMinute])
                    }
                    HStack {
                        Text(WorkDays.wednesday.text)
                        Spacer()
                        Toggle(isOn: $isWorkingOnWednesday.animation(), label: {})
                    }
                    if isWorkingOnWednesday {
                        DatePicker("Entrée", selection: $wednesdayStartTime, displayedComponents: [.hourAndMinute])
                            .listRowSeparator(.hidden)
                        DatePicker("Sortie", selection: $wednesdayEndTime, displayedComponents: [.hourAndMinute])
                    }
                    HStack {
                        Text(WorkDays.thursday.text)
                        Spacer()
                        Toggle(isOn: $isWorkingOnThursday.animation(), label: {})
                    }
                    if isWorkingOnThursday {
                        DatePicker("Entrée", selection: $thursdayStartTime, displayedComponents: [.hourAndMinute])
                            .listRowSeparator(.hidden)
                        DatePicker("Sortie", selection: $thursdayEndTime, displayedComponents: [.hourAndMinute])
                    }
                    HStack {
                        Text(WorkDays.friday.text)
                        Spacer()
                        Toggle(isOn: $isWorkingOnFriday.animation(), label: {})
                    }
                    if isWorkingOnFriday {
                        DatePicker("Entrée", selection: $fridayStartTime, displayedComponents: [.hourAndMinute])
                            .listRowSeparator(.hidden)
                        DatePicker("Sortie", selection: $fridayEndTime, displayedComponents: [.hourAndMinute])
                    }
                }
            }
            .navigationTitle("Mon compte")
            .onAppear(perform: loadSchedule)
            .onDisappear(perform: saveSchedule)
        }
    }
    
    private func loadSchedule() {
        guard let account = myAccount.first else {
            let newItem = Account(workingDays: [:], weekSchedule: [:])
            modelContext.insert(newItem)
            return
        }
        
        let myWorkingDays = account.workingDays
        
        if let workingOnMonday = myWorkingDays[WorkDays.monday.rawValue] {
            isWorkingOnMonday = workingOnMonday
        }
        if let workingOnTuesday = myWorkingDays[WorkDays.tuesday.rawValue] {
            isWorkingOnTuesday = workingOnTuesday
        }
        if let workingOnWednesday = myWorkingDays[WorkDays.wednesday.rawValue] {
            isWorkingOnWednesday = workingOnWednesday
        }
        if let workingOnThursday = myWorkingDays[WorkDays.thursday.rawValue] {
            isWorkingOnThursday = workingOnThursday
        }
        if let workingOnFriday = myWorkingDays[WorkDays.friday.rawValue] {
            isWorkingOnFriday = workingOnFriday
        }
        
        let mySchedule = account.weekSchedule
        
        if let mondaySchedule = mySchedule[WorkDays.monday.rawValue] {
            mondayStartTime = mondaySchedule.enteringDate
            mondayEndTime = mondaySchedule.leavingDate
        }
        if let tuesdaySchedule = mySchedule[WorkDays.tuesday.rawValue] {
            tuesdayStartTime = tuesdaySchedule.enteringDate
            tuesdayEndTime = tuesdaySchedule.leavingDate
        }
        if let wednesdaySchedule = mySchedule[WorkDays.wednesday.rawValue] {
            wednesdayStartTime = wednesdaySchedule.enteringDate
            wednesdayEndTime = wednesdaySchedule.leavingDate
        }
        if let thursdaySchedule = mySchedule[WorkDays.thursday.rawValue] {
            thursdayStartTime = thursdaySchedule.enteringDate
            thursdayEndTime = thursdaySchedule.leavingDate
        }
        if let fridaySchedule = mySchedule[WorkDays.friday.rawValue] {
            fridayStartTime = fridaySchedule.enteringDate
            fridayEndTime = fridaySchedule.leavingDate
        }
    }
    
    private func saveSchedule() {
        myAccount.first?.workingDays = [
            WorkDays.monday.rawValue: isWorkingOnMonday,
            WorkDays.tuesday.rawValue: isWorkingOnTuesday,
            WorkDays.wednesday.rawValue: isWorkingOnWednesday,
            WorkDays.thursday.rawValue: isWorkingOnThursday,
            WorkDays.friday.rawValue: isWorkingOnFriday
        ]
        
        myAccount.first?.weekSchedule = [
            WorkDays.monday.rawValue: DaySchedule(enteringDate: mondayStartTime,
                                                  leavingDate: mondayEndTime),
            WorkDays.tuesday.rawValue: DaySchedule(enteringDate: tuesdayStartTime,
                                                   leavingDate: tuesdayEndTime),
            WorkDays.wednesday.rawValue: DaySchedule(enteringDate: wednesdayStartTime,
                                                     leavingDate: wednesdayEndTime),
            WorkDays.thursday.rawValue: DaySchedule(enteringDate: thursdayStartTime,
                                                    leavingDate: thursdayEndTime),
            WorkDays.friday.rawValue: DaySchedule(enteringDate: fridayStartTime,
                                                  leavingDate: fridayEndTime),
        ]
    }
}

#Preview {
    AccountView()
        .modelContainer(for: Account.self, inMemory: true)
}
