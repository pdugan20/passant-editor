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
    }

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
        let locationData: [LocationData] = [
            LocationData(name: "Shorty's", latitude: 47.6134, longitude: -122.3477),
            LocationData(name: "The Croc", latitude: 47.6174, longitude: -122.3468),
            LocationData(name: "Unicorn", latitude: 47.6134, longitude: -122.3215),
            LocationData(name: "Delancey", latitude: 47.6488, longitude: -122.3425),
            LocationData(name: "Serious Pie", latitude: 47.6102, longitude: -122.3411),
            LocationData(name: "Dino's", latitude: 47.6742, longitude: -122.3156),
            LocationData(name: "Victrola Coffee", latitude: 47.6132, longitude: -122.3165),
            LocationData(name: "Analog Coffee", latitude: 47.6133, longitude: -122.3477),
            LocationData(name: "Elm Coffee Roasters", latitude: 47.6610, longitude: -122.3206)
        ]

        var locationMap: [String: Location] = [:]

        for data in locationData {
            let location = Location(name: data.name, latitude: data.latitude, longitude: data.longitude)
            context.insert(location)
            locationMap[data.name] = location
        }

        return locationMap
    }

    private static func createDiveBarsNote(locations: [String: Location]) -> Note {
        var content = AttributedString()

        // Heading
        var heading = AttributedString("Best Spots\n")
        heading.paragraphFormat = .heading2
        content.append(heading)

        // Bullet list with locations
        if let shortys = locations["Shorty's"] {
            var item1 = AttributedString("• ")
            var locationText = AttributedString("Shorty's")
            locationText.location = shortys.id
            item1.append(locationText)
            item1.append(AttributedString(" - "))
            var description = AttributedString("Pinball and hot dogs")
            description.font = .default.italic()
            item1.append(description)
            item1.append(AttributedString("\n"))
            content.append(item1)
        }

        if let croc = locations["The Croc"] {
            var item2 = AttributedString("• ")
            var locationText = AttributedString("The Croc")
            locationText.location = croc.id
            item2.append(locationText)
            item2.append(AttributedString(" - Live music venue with character\n"))
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
            item3.append(AttributedString(" - "))
            var bold = AttributedString("Carnival games")
            bold.font = .default.bold()
            item3.append(bold)
            item3.append(AttributedString(" and quirky atmosphere\n"))
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

        // Intro with bold
        var intro = AttributedString("The ")
        var bold = AttributedString("best pizza")
        bold.font = .default.bold()
        intro.append(bold)
        intro.append(AttributedString(" places in Seattle:\n\n"))
        content.append(intro)

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
            item1.append(AttributedString("\n   "))
            var italic = AttributedString("Wood-fired perfection")
            italic.font = .default.italic()
            item1.append(italic)
            item1.append(AttributedString("\n"))
            content.append(item1)
        }

        if let serious = locations["Serious Pie"] {
            var item2 = AttributedString("2. ")
            var locationText = AttributedString("Serious Pie")
            locationText.location = serious.id
            item2.append(locationText)
            item2.append(AttributedString("\n   Seasonal ingredients, "))
            var underline = AttributedString("amazing crust")
            underline.underlineStyle = .single
            item2.append(underline)
            item2.append(AttributedString("\n"))
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
            item3.append(AttributedString("\n   Classic NY-style slices\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Best Pizza",
            content: content,
            locations: Array(locations.values)
        )

        return note
    }

    private static func createCafesNote(locations: [String: Location]) -> Note {
        var content = AttributedString()

        // Main heading
        var mainHeading = AttributedString("Seattle Coffee Guide\n")
        mainHeading.paragraphFormat = .heading1
        content.append(mainHeading)

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
            item1.append(AttributedString("\n  Great for laptop work, "))
            var italic = AttributedString("excellent light roasts")
            italic.font = .default.italic()
            item1.append(italic)
            item1.append(AttributedString("\n"))
            content.append(item1)
        }

        if let analog = locations["Analog Coffee"] {
            var item2 = AttributedString("• ")
            var locationText = AttributedString("Analog Coffee")
            locationText.location = analog.id
            item2.append(locationText)
            item2.append(AttributedString("\n  Cozy vibes, great pastries\n"))
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
            item3.append(AttributedString("\n  "))
            var boldItalic = AttributedString("Outstanding")
            boldItalic.font = .default.bold().italic()
            item3.append(boldItalic)
            item3.append(AttributedString(" single origin options\n"))
            content.append(item3)
        }

        let note = Note(
            title: "Favorite Cafes in Seattle",
            content: content,
            locations: Array(locations.values)
        )

        return note
    }
}
