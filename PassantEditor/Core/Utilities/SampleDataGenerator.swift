/*
Abstract:
Generates sample notes with rich formatting and location mentions.
*/

import Foundation
import SwiftData
import SwiftUI

enum SampleDataGenerator {
    private struct LocationData {
        let name: String
        let latitude: Double?
        let longitude: Double?
        let address: String?
        let type: String?
    }

    private static let seattleLocations: [LocationData] = [
        LocationData(
            name: "Shorty's",
            latitude: 47.6134,
            longitude: -122.3477,
            address: "2222 2nd Ave, Seattle, WA 98121",
            type: "Bar"
        ),
        LocationData(
            name: "The Croc",
            latitude: 47.6174,
            longitude: -122.3468,
            address: "2200 2nd Ave, Seattle, WA 98121",
            type: "Music Venue"
        ),
        LocationData(
            name: "Unicorn",
            latitude: 47.6134,
            longitude: -122.3215,
            address: "1118 E Pike St, Seattle, WA 98122",
            type: "Bar"
        ),
        LocationData(
            name: "Delancey",
            latitude: 47.6488,
            longitude: -122.3425,
            address: "1415 NW 70th St, Seattle, WA 98117",
            type: "Restaurant"
        ),
        LocationData(
            name: "Serious Pie",
            latitude: 47.6102,
            longitude: -122.3411,
            address: "316 Virginia St, Seattle, WA 98121",
            type: "Restaurant"
        ),
        LocationData(
            name: "Dino's",
            latitude: 47.6742,
            longitude: -122.3156,
            address: "6906 15th Ave NW, Seattle, WA 98117",
            type: "Restaurant"
        ),
        LocationData(
            name: "Victrola Coffee",
            latitude: 47.6132,
            longitude: -122.3165,
            address: "310 E Pike St, Seattle, WA 98122",
            type: "Cafe"
        ),
        LocationData(
            name: "Analog Coffee",
            latitude: 47.6133,
            longitude: -122.3477,
            address: "235 Summit Ave E, Seattle, WA 98102",
            type: "Cafe"
        ),
        LocationData(
            name: "Elm Coffee Roasters",
            latitude: 47.6610,
            longitude: -122.3206,
            address: "240 N 65th St, Seattle, WA 98103",
            type: "Cafe"
        )
    ]

    @MainActor
    static func generateSampleData(context: ModelContext) {
        // Clear existing data
        try? context.delete(model: Note.self)
        try? context.delete(model: Location.self)

        // Create locations
        let locations = createLocations(context: context)

        // Create notes
        let notes = [
            createDiveBarsNote(locations: locations),
            createPizzaNote(locations: locations),
            createCafesNote(locations: locations)
        ]

        for note in notes {
            context.insert(note)
        }

        try? context.save()
    }

    @MainActor
    private static func createLocations(context: ModelContext) -> [String: Location] {
        var locationMap: [String: Location] = [:]

        for data in seattleLocations {
            let location = Location(
                name: data.name,
                latitude: data.latitude,
                longitude: data.longitude,
                address: data.address,
                type: data.type
            )
            context.insert(location)
            locationMap[data.name] = location
        }

        return locationMap
    }

    private static func createDiveBarsNote(locations: [String: Location]) -> Note {
        var content = AttributedString()

        // Bullet list with locations
        if let shortys = locations["Shorty's"] {
            var item1 = AttributedString("• ")
            var locationText = AttributedString("Shorty's")
            locationText.location = shortys.id
            item1.append(locationText)
            item1.append(AttributedString(" - Pinball paradise with over 30 machines, cheap beer, and surprisingly good hot dogs. "))
            item1.append(AttributedString("A Belltown institution since 1983.\n"))
            content.append(item1)
        }

        if let croc = locations["The Croc"] {
            var item2 = AttributedString("• ")
            var locationText = AttributedString("The Croc")
            locationText.location = croc.id
            item2.append(AttributedString(" - Historic music venue that's hosted everyone from Nirvana to local indie bands. "))
            item2.append(AttributedString("Intimate stage with solid sound system and cheap drinks.\n"))
            content.append(item2)
        }

        // Subheading
        var subheading = AttributedString("\nCapitol Hill\n")
        subheading.paragraphFormat = .heading3
        content.append(subheading)

        if let unicorn = locations["Unicorn"] {
            var item3 = AttributedString("• ")
            var locationText = AttributedString("Unicorn")
            locationText.location = unicorn.id
            item3.append(locationText)
            item3.append(AttributedString(" - Carnival games meet craft cocktails in this weird and wonderful Capitol Hill spot. "))
            item3.append(AttributedString("The photo booth is a must, and don't miss corn dog Thursdays.\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Favorite Dive Bars",
            content: content,
            locations: Array(locations.values)
        )

        return note
    }

    private static func createPizzaNote(locations: [String: Location]) -> Note {
        var content = AttributedString()

        // Heading
        var heading = AttributedString("Capitol Hill\n")
        heading.paragraphFormat = .heading2
        content.append(heading)

        // Numbered list
        if let delancey = locations["Delancey"] {
            var item1 = AttributedString("1. ")
            var locationText = AttributedString("Delancey")
            locationText.location = delancey.id
            item1.append(locationText)
            item1.append(AttributedString("\n  Wood-fired Neapolitan perfection in Ballard. "))
            item1.append(AttributedString("Their margherita showcases simple ingredients done right. "))
            item1.append(AttributedString("Cozy neighborhood vibe with communal seating.\n"))
            content.append(item1)
        }

        if let serious = locations["Serious Pie"] {
            var item2 = AttributedString("2. ")
            var locationText = AttributedString("Serious Pie")
            locationText.location = serious.id
            item2.append(locationText)
            item2.append(AttributedString("\n  Tom Douglas's serious approach to pizza. "))
            item2.append(AttributedString("The chanterelle mushroom and truffle cheese pizza is legendary. "))
            item2.append(AttributedString("Great happy hour deals at the downtown location.\n"))
            content.append(item2)
        }

        // Another heading
        var heading2 = AttributedString("\nFremont\n")
        heading2.paragraphFormat = .heading2
        content.append(heading2)

        if let dinos = locations["Dino's"] {
            var item3 = AttributedString("3. ")
            var locationText = AttributedString("Dino's")
            locationText.location = dinos.id
            item3.append(locationText)
            item3.append(AttributedString("\n  Late-night NY-style slices in Fremont. Huge portions, crispy crust, open till 4am on weekends. "))
            item3.append(AttributedString("A Seattle institution since 2006.\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Seattle's Best Pizza",
            content: content,
            locations: Array(locations.values)
        )

        return note
    }

    private static func createCafesNote(locations: [String: Location]) -> Note {
        var content = AttributedString()

        // Intro paragraph
        var intro = AttributedString("My go-to spots for ")
        var strikethrough = AttributedString("working")
        strikethrough.strikethroughStyle = .single
        intro.append(strikethrough)
        intro.append(AttributedString(" "))
        var bold = AttributedString("procrastinating")
        bold.font = .default.bold()
        intro.append(bold)
        intro.append(AttributedString(":\n\n"))
        content.append(intro)

        // Subheading
        var subheading = AttributedString("Capitol Hill Favorites\n")
        subheading.paragraphFormat = .heading3
        content.append(subheading)

        // Bullet list
        if let victrola = locations["Victrola Coffee"] {
            var item1 = AttributedString("• ")
            var locationText = AttributedString("Victrola Coffee")
            locationText.location = victrola.id
            item1.append(locationText)
            item1.append(AttributedString("\n  Spacious Capitol Hill location perfect for laptop sessions. "))
            item1.append(AttributedString("Their light roasts are exceptional - try the Ethiopian pour-over. "))
            item1.append(AttributedString("Plenty of outlets and good wifi. Gets busy on weekend mornings but there's usually seating.\n"))
            content.append(item1)
        }

        if let analog = locations["Analog Coffee"] {
            var item2 = AttributedString("• ")
            var locationText = AttributedString("Analog Coffee")
            locationText.location = analog.id
            item2.append(locationText)
            item2.append(AttributedString("\n  Tiny neighborhood spot with a warm, lived-in feel. Their house blend is smooth and balanced. "))
            item2.append(AttributedString("Pastries from Bakery Nouveau are always fresh. Limited seating but worth the cozy squeeze. Cash only.\n"))
            content.append(item2)
        }

        // Another subheading
        var subheading2 = AttributedString("\nPhinney Ridge\n")
        subheading2.paragraphFormat = .heading3
        content.append(subheading2)

        if let elm = locations["Elm Coffee Roasters"] {
            var item3 = AttributedString("• ")
            var locationText = AttributedString("Elm Coffee Roasters")
            locationText.location = elm.id
            item3.append(locationText)
            item3.append(AttributedString("\n  Outstanding single origin options that rotate seasonally. "))
            item3.append(AttributedString("The baristas really know their stuff and are happy to recommend based on your taste. "))
            item3.append(AttributedString("Bright, airy space with garage door that opens in summer. Their Kenya AA is legendary.\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Seattle Coffee Guide",
            content: content,
            locations: Array(locations.values)
        )

        return note
    }
}
