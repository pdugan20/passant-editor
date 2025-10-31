/*
Abstract:
Location model for representing places that can be mentioned in notes as pills.
*/

import Foundation
import SwiftData

@Model
final class Location: Identifiable {
    var name: String
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var type: String?

    init(name: String, latitude: Double? = nil, longitude: Double? = nil, address: String? = nil, type: String? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.type = type
    }
}
