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

    public init(id: Int, title: String) {
        self.id = id
        self.title = title
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
        LabeledContent(item.title, value: item.id, format: .number)
    }
}

struct ContentView: View {
    var items: [Item] = Item.previewCollection()

    @State private var visibleItems = Set<Item>()

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
        VStack(spacing: 0) {
            HStack {
                Text("Visible: ")
                    .bold()
                Text(visibleItemRangeDescription)
                    .monospaced()
            }
            .padding()

            List {
                ForEach(items) { item in
                    ItemView(item: item)
                        .animation(.easeOut, value: visibleItems)
                        .onAppear { visibleItems.insert(item) }
                        .onDisappear { visibleItems.remove(item) }
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
