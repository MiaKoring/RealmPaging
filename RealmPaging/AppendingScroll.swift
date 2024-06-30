import RealmSwift
import SwiftUI

struct ContentView: View {
    @State var rendered: [Item] = []
    @ObservedResults(Item.self, sortDescriptor: SortDescriptor(keyPath: "itemID", ascending: true)) var items
    @State var currentID = 0
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(rendered) { item in
                    Text(item.name)
                        .id(item._id)
                        .rotationEffect(.degrees(180))
                }
                if rendered.count != items.count && rendered.count <= 100000 && !(items.isEmpty || rendered.isEmpty) {
                    ProgressView().progressViewStyle(.circular)
                        .onAppear() {
                            loadMore()
                        }
                }
                else if rendered.count != items.count {
                    Text("max loaded items reached")
                }
                else {
                    Rectangle()
                        .frame(height: 0)
                        .hidden()
                }
            }
        }
        .rotationEffect(.degrees(180))
        .onAppear() {
            rendered = items[max(0, items.count - 50)...(items.count - 1)].reversed()
            currentID = rendered.last?.itemID ?? items.count - 1
        }
        .overlay(alignment: .bottomTrailing) {
            VStack{
                Circle()
                    .frame(height: 50)
                    .onTapGesture {
                        add()
                    }
                Rectangle()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        update()
                    }
            }
        }
    }
    
    func loadMore() {
        let startIndex = items.index(before: items.firstIndex(where: {
            $0.itemID == currentID
        })!)
        let appendBy = items[max(0, startIndex - 50)...min(startIndex, items.count - 1)].reversed()
        rendered.append(contentsOf: appendBy)
        currentID = rendered.last?.itemID ?? items.count - 1
    }
    
    func add() {
        let item = Item(name: "\((items.max(of: \.itemID) ?? 10000) + 1)", color: .blue, id: (items.max(of: \.itemID) ?? 10000) + 1)
        $items.append(item)
        withAnimation {
            rendered.insert(item, at: 0)
        }
    }
    
    func update() {
        guard let realmIndex = items.index(matching: {
            $0.itemID == 540
        }) else { return }
        guard let renIndex = rendered.firstIndex(where: {$0.itemID == 540}) else { return }
        try! Realm().write {
            let items = items.thaw()!
            items[realmIndex].name = "Changed"
        }
        rendered[renIndex].name = "Changed"
    }
}
