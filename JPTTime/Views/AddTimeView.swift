//
//  AddTimeView.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 07/02/2025.
//

import SwiftUI
import SwiftData

enum TimeViewStatus {
    case add
    case edit
    
    var screenTitle: String {
        switch self {
        case .add:
            return "Ajouter un pointage"
        case .edit:
            return "Modifier un pointage"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .add:
            return "Ajouter"
        case .edit:
            return "Modifier"
        }
    }
}

struct AddTimeView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var viewStatus: TimeViewStatus = .add
    
    @Query var myAccount: [Account]
    var item: Item?

    @State var baseEnteringHour: Date = Date.now
    @State var baseLeavingHour: Date = Date.now
    @State var date: Date = Date.now
    @State var isLeaving: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Mes horaires de travail aujourd'hui") {
                    HStack {
                        VStack {
                            Text("Entrée")
                            DatePicker("", selection: $baseEnteringHour, displayedComponents: .hourAndMinute)
                                .environment(\.locale, Locale.init(identifier: "fr_FR"))
                                .labelsHidden()
                        }
                        Spacer()
                        VStack {
                            Text("Sortie")
                            DatePicker("", selection: $baseLeavingHour, displayedComponents: .hourAndMinute)
                                .environment(\.locale, Locale.init(identifier: "fr_FR"))
                                .labelsHidden()
                        }
                    }
                }
                Section("J'enregistre mon heure...") {
                    HStack {
                        Text("D'entrée")
                        Spacer()
                        Toggle(isOn: $isLeaving, label: {
                            Text("Entering")
                        })
                        .labelsHidden()
                        Spacer()
                        Text("De sortie")
                    }
                }
                Section("Sélectionnez votre heure \(isLeaving ? "de départ" : "d'arrivée")") {
                    DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                        .labelsHidden()
                }
            }
            .padding(.bottom, 20)
            Button(viewStatus.buttonTitle) {
                if viewStatus == .add {
                    let newItem = Item(baseTime: isLeaving ? baseLeavingHour : baseEnteringHour,
                                       date: date,
                                       pointingKind: isLeaving ? .leaving : .entering)
                    modelContext.insert(newItem)
                } else {
                    item?.baseTime = isLeaving ? baseLeavingHour : baseEnteringHour
                    item?.date = date
                    item?.pointingKind = isLeaving ? .leaving : .entering
                }
                dismiss()
            }
            .frame(width: 150, height: 70)
            .background(.green)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .clipShape(.capsule)
            .shadow(radius: 10)
            .navigationTitle(viewStatus.screenTitle)
            .onAppear(perform: loadSettings)
        }
    }
    
    private func loadSettings() {
        
        let calendar = Calendar(identifier: .gregorian) // Assure l'utilisation du calendrier grégorien
        var adjustedCalendar = calendar
        adjustedCalendar.firstWeekday = 2 // Définit lundi comme premier jour de la semaine
        
        let currentDay = adjustedCalendar.component(.weekday, from: Date())
        let adjustedDay = (currentDay - adjustedCalendar.firstWeekday + 7) % 7 + 1
        
        if let item = item {
            
            date = item.date
            isLeaving = item.pointingKind == .leaving
            if item.pointingKind == .leaving {
                baseLeavingHour = item.baseTime
            } else {
                baseEnteringHour = item.baseTime
            }
            
        } else {
            
            guard let account = myAccount.first,
                  let enteringDate = account.weekSchedule[adjustedDay]?.enteringDate,
                  let leavingDate = account.weekSchedule[adjustedDay]?.leavingDate
            else { return }
            
            baseEnteringHour = enteringDate
            baseLeavingHour = leavingDate
            
        }
    }
}

#Preview {
    AddTimeView(date: Date.now, isLeaving: true)
        .modelContainer(for: Item.self, inMemory: true)
}
