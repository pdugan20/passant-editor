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

        // Create and save locations first to get stable IDs
        let locations = createLocations(context: context)
        try? context.save()

        // Create notes (now location IDs are stable)
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

        // Belltown subheading
        var belltownHeading = AttributedString("Belltown\n")
        belltownHeading.paragraphFormat = .heading3
        content.append(belltownHeading)

        if let shortys = locations["Shorty's"] {
            var item1 = AttributedString("• ")
            var locationText = AttributedString("Shorty's")
            locationText.location = shortys.id
            item1.append(locationText)
            item1.append(AttributedString(" - Pinball and cheap beer\n"))
            content.append(item1)
        }

        if let croc = locations["The Croc"] {
            var item2 = AttributedString("• ")
            var locationText = AttributedString("The Croc")
            locationText.location = croc.id
            item2.append(locationText)
            item2.append(AttributedString(" - Historic music venue with cheap drinks\n"))
            content.append(item2)
        }

        // Capitol Hill subheading
        var subheading = AttributedString("\nCapitol Hill\n")
        subheading.paragraphFormat = .heading3
        content.append(subheading)

        if let unicorn = locations["Unicorn"] {
            var item3 = AttributedString("• ")
            var locationText = AttributedString("Unicorn")
            locationText.location = unicorn.id
            item3.append(locationText)
            item3.append(AttributedString(" - Carnival games and craft cocktails\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Favorite Dive Bars",
            content: content,
            locations: [locations["Shorty's"], locations["The Croc"], locations["Unicorn"]].compactMap { $0 }
        )

        return note
    }

    private static func createPizzaNote(locations: [String: Location]) -> Note {
        var content = AttributedString()

        // Heading
        var heading = AttributedString("Ballard\n")
        heading.paragraphFormat = .heading3
        content.append(heading)

        // Numbered list
        if let delancey = locations["Delancey"] {
            var item1 = AttributedString("1. ")
            var locationText = AttributedString("Delancey")
            locationText.location = delancey.id
            item1.append(locationText)
            item1.append(AttributedString("\n  Wood-fired Neapolitan pizza\n"))
            content.append(item1)
        }

        // Downtown heading
        var downtownHeading = AttributedString("\nDowntown\n")
        downtownHeading.paragraphFormat = .heading3
        content.append(downtownHeading)

        if let serious = locations["Serious Pie"] {
            var item2 = AttributedString("2. ")
            var locationText = AttributedString("Serious Pie")
            locationText.location = serious.id
            item2.append(locationText)
            item2.append(AttributedString("\n  Tom Douglas's chanterelle mushroom pizza\n"))
            content.append(item2)
        }

        // Fremont heading
        var heading2 = AttributedString("\nFremont\n")
        heading2.paragraphFormat = .heading3
        content.append(heading2)

        if let dinos = locations["Dino's"] {
            var item3 = AttributedString("3. ")
            var locationText = AttributedString("Dino's")
            locationText.location = dinos.id
            item3.append(locationText)
            item3.append(AttributedString("\n  Late-night NY-style slices\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Seattle's Best Pizza",
            content: content,
            locations: [locations["Delancey"], locations["Serious Pie"], locations["Dino's"]].compactMap { $0 }
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
            item1.append(AttributedString("\n  Light roasts and laptop-friendly\n"))
            content.append(item1)
        }

        if let analog = locations["Analog Coffee"] {
            var item2 = AttributedString("• ")
            var locationText = AttributedString("Analog Coffee")
            locationText.location = analog.id
            item2.append(locationText)
            item2.append(AttributedString("\n  Cozy spot with Bakery Nouveau pastries\n"))
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
            item3.append(AttributedString("\n  Rotating single origins and expert baristas\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Seattle Coffee Guide",
            content: content,
            locations: [locations["Victrola Coffee"], locations["Analog Coffee"], locations["Elm Coffee Roasters"]].compactMap { $0 }
        )

        return note
    }
}
