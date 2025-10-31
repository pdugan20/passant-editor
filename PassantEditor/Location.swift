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

    init(name: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
