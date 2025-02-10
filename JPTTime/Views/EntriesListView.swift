//
//  EntriesListView.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 07/02/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct EntriesListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Item.date, order: .reverse) private var items: [Item]
    @Query(filter: Item.currentMonthPredicate()) private var currentMonthEntries: [Item]
    @Query(filter: Item.lastMonthPredicate()) private var lastMonthEntries: [Item]

    @State var date: Date = Date.now

    var body: some View {
        NavigationView {
            VStack {
                
                VStack {
                    Text(getCurrentMonthTotalTime())
                        .font(.custom("", size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text(getLastMonthTotalTime())
                        .font(.caption)
                }
                
                List {
                    if items.isEmpty {
                        Text("No items yet")
                    }
                    ForEach(items) { item in
                        NavigationLink {
                            AddTimeView(viewStatus: .edit, item: item)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: item.pointingKind == .entering ? "airplane.arrival" :"airplane.departure")
                                    Text("\(item.pointingKind == .entering ? "Arrivée" : "Sortie") à \(getFormattedCellTime(item))")
                                    Spacer()
                                    Text(getFormattedTimeDifference(item))
                                        .fontWeight(.bold)
                                        .foregroundStyle(item.timeDifference > 0 ? Color.green : Color.red)
                                }
                                Text("\(getFormattedCellDate(item))")
                                    .font(.caption)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination: {
                            AccountView()
                        }, label: {
                            Image(systemName: "person.crop.circle")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        NavigationLink(destination: {
                            AddTimeView()
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
        }
    }

    private func getFormattedCellDate(_ item: Item) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateStyle = .short
        
        return dateFormatter.string(from: item.date)
    }

    private func getFormattedCellTime(_ item: Item) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "fr_FR")
        timeFormatter.timeStyle = .short
        
        return timeFormatter.string(from: item.date)
    }
    
    private func getFormattedTimeDifference(_ item: Item) -> String {
        var string = ""
        
        if item.timeDifference > 0 {
            string += "+"
        }
        
        string += String(item.timeDifference)
        
        return string
    }
    
    private func getLastMonthTotalTime() -> String {
        var totalTime: Int = 0
        
        for item in lastMonthEntries {
            totalTime += item.timeDifference
        }
        
        var string = ""
        
        if totalTime > 0 && totalTime > 60 {
            string += "+\(totalTime / 60)h\(totalTime % 60)"
        } else if totalTime > 0 {
            string += "+\(totalTime)mn"
        } else if totalTime < 0 {
            string += "\(totalTime)mn"
        }
        
        return "Last month credit: \(string)"
    }
    
    private func getCurrentMonthTotalTime() -> String {
        var totalTime: Int = 0
        
        for item in currentMonthEntries {
            totalTime += item.timeDifference
        }
        
        var string = ""
        
        if totalTime > 0 && totalTime > 60 {
            string += "+\(totalTime / 60)h\(totalTime % 60)"
        } else if totalTime > 0 {
            string += "+\(totalTime)mn"
        } else if totalTime < 0 {
            string += "\(totalTime)mn"
        }
        
        return string
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    EntriesListView()
}
