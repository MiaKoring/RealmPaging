//
//  ContentView.swift
//  RealmPaging
//
//  Created by Mia Koring on 27.06.24.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedResults(Item.self, sortDescriptor: SortDescriptor(keyPath: "itemID", ascending: true)) var items
    @State var range: Range<Int> = Range(0...0)
    @State var rendered: [Item] = []
    
    var body: some View {
        ScrollView {
            ScrollViewReader { reader in
                LazyVStack {
                    if range.upperBound != items.count - 1{
                        Rectangle()
                            .frame(height: 0)
                        //Funktioniert nur manchmal, meistens "stottert" es
                            .onAppear() {
                                let diff = range.upperBound <= items.count - 1 - 20 ? 20 : items.count - 1 - range.upperBound
                                range = Range(range.lowerBound + diff...range.upperBound + diff)
                                if diff > 0 {
                                    for i in 0...diff {
                                        rendered.remove(at: rendered.count - 1)
                                        rendered.insert(items[range.upperBound - 1 - diff + i], at: 0)
                                    }
                                }
                            }
                    }
                    ForEach(rendered) {item in
                        Text(item.name)
                            .font(.title)
                            .id(item._id)
                            .rotationEffect(.degrees(180))
                    }
                    if range.lowerBound != 0 {
                        Rectangle()
                            .frame(height: 0)
                            .onAppear() {
                                let diff = range.lowerBound >= 20 ? 20 : range.lowerBound
                                range = Range(range.lowerBound - diff...range.upperBound - diff)
                                if diff > 0 {
                                    for i in 0...diff {
                                        rendered.remove(at: 0)
                                        rendered.append(items[range.lowerBound + diff - i])
                                    }
                                }
                            }
                    }
                }
            }
        }
        .rotationEffect(.degrees(180))
        .onAppear() {
            range = Range(max(items.count - 51, 0)...items.count - 1)
            rendered = items[range].reversed()
        }
    }
}

#Preview {
    ContentView()
}
