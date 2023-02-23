//
//  ContentView.swift
//  SwiftUIListOnAppear
//
//  Created by Matt Bonney on 2/22/23.
//

import SwiftUI

public struct Item: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let date: Date

    public init(id: Int, title: String) {
        self.id = id
        self.title = title

        // Generate the timestamp.
        self.date = Calendar.current.date(byAdding: .day, value: -1 * id, to: Date.now) ?? .now
    }
}

extension Item {
    static func previewCollection() -> [Item] {
        let indices = Array(0..<50)
        return indices.map { Item(id: $0, title: "Item #\($0)") }
    }
}

struct ItemView: View {
    let item: Item

    var body: some View {
        LabeledContent(item.title, value: item.date, format: .dateTime.month().day())
    }
}

struct ContentView: View {
    var items: [Item] = Item.previewCollection()

    @State private var visibleItems = Set<Item>()

    var visibleItemRange: ClosedRange<Int> {
        let items = Array(visibleItems)
                        .sorted { $0.id < $1.id }
                        .compactMap { $0.id }

        let low = items.first ?? 0
        let high = items.last ?? 0

        return low...high
    }

    var visibleItemsAtStart: Bool {
        visibleItemRange.contains(0)
    }

    var visibleItemDateRangeText: Text {
        let items = Array(visibleItems)
            .sorted { $0.id < $1.id }
            .compactMap { $0.date }

        let first = items.first ?? Date.now
        let last = items.last ?? Date.now

        let t1 = Text(first, format: .dateTime.month().day())
        let t2 = Text(last, format: .dateTime.month().day())
        return t1 + Text(" to ") + t2
    }

    var visibleItemDescription: String {
        Array(visibleItems)
            .sorted {
                $0.id < $1.id
            }
            .compactMap { item in
                String(describing: item.id)
            }
            .joined(separator: ",")
    }

    var visibleItemRangeDescription: String {
        let items = Array(visibleItems)
            .sorted {
                $0.id < $1.id
            }
            .compactMap { item in
                String(describing: item.id)
            }

        let first = items.first ?? "-"
        let last = items.last ?? "-"

        return first + " to " + last
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(items) { item in
                        ItemView(item: item)
                            .animation(.easeOut, value: visibleItems)
                            .onAppear { visibleItems.insert(item) }
                            .onDisappear { visibleItems.remove(item) }
                    }
                } header: {
                    Text(visibleItemRangeDescription)
                }
            }
            .listStyle(.plain)
            .navigationTitle(visibleItemDateRangeText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
