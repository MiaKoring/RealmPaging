//
//  RealmPagingApp.swift
//  RealmPaging
//
//  Created by Mia Koring on 27.06.24.
//

import SwiftUI
import RealmSwift

@main
struct RealmPagingApp: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            FirstView()
        }
    }
}

struct FirstView: View {
    @State var showMain: Bool = false
    var body: some View {
        if showMain {
            ContentView()
        }
        else {
            AppendingNotFlipped()
        }
    }
} 


struct GenView: View {
    @ObservedResults(Item.self) var items
    @Binding var showMain: Bool
    var body: some View {
        ProgressView().progressViewStyle(.circular)
            .onAppear(){
                if items.isEmpty {
                    for i in 0...500 {
                        $items.append(Item(name: "\(i)", color: .white, id: i))
                    }
                }
                showMain = true
            }
    }
}
