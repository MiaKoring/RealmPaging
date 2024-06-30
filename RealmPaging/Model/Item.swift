import RealmSwift
import SwiftUI

class Item: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var color: String
    @Persisted var itemID: Int
    
    override init() {
        super.init()
    }
    
    init(name: String, color: AvailableColors, id: Int) {
        self.name = name
        self.color = color.rawValue
        self.itemID = id
    }
    
    init(name: String, color: String, id: Int) {
        self.name = name
        self.color = color
        self.itemID = id
    }
}
