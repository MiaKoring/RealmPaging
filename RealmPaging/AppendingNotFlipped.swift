import RealmSwift
import SwiftUI

struct AppendingNotFlipped: View {
    @State var rendered: [Item] = []
    @ObservedResults(Item.self, sortDescriptor: SortDescriptor(keyPath: "itemID", ascending: false)) var items
    @State var currentID = 0
    
    var body: some View {
        ScrollView {
            LazyVStack {
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
                ForEach(rendered) { item in
                    Text(item.name)
                        .id(item._id)
                }
            }
        }
        .defaultScrollAnchor(.bottom)
        .onAppear() {
            rendered = items[0...min(50, items.count)].reversed()
            currentID = rendered.first?.itemID ?? items.count - 1
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
        print(startIndex)
        let appendBy = items[max(0, startIndex)...min(startIndex + 50, items.count - 1)].reversed()
        rendered.insert(contentsOf: appendBy, at: 0)
        currentID = rendered.first?.itemID ?? items.count - 1
    }
    
    func add() {
        let item = Item(name: "\((items.max(of: \.itemID) ?? 10000) + 1)", color: .blue, id: (items.max(of: \.itemID) ?? 10000) + 1)
        $items.append(item)
        withAnimation {
            rendered.insert(item, at: rendered.count - 1)
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
