import SwiftAA
import CoreLocation

var str = "Hello, playground"

// Let computes the day light hours in Paris on summer solstice:

let paris = GeographicCoordinates(positivelyWestwardLongitude: Degree(.minus, 2, 21, 07), latitude: Degree(.plus, 48, 51, 24))
let jd = JulianDay(year: 2020, month: 6, day: 21)
let times = Earth(julianDay: jd).twilights(forSunAltitude: 0, coordinates: paris)

print("The sun rises on \(times.riseTime!.date.description(with: Locale.current))")
print("The sun transit occurs on \(times.transitTime!.date.description(with: Locale.current))")
print("The sun sets on \(times.setTime!.date.description(with: Locale.current))")


// Likewise, let computes the rise, transit and set times of Sirius of "today":

let sirius = AstronomicalObject(
    name: "Sirius",
    coordinates: EquatorialCoordinates(
        rightAscension: Hour(.plus, 6, 45, 9.25),
        declination: Degree(.minus, 16, 42, 47.3)
    ),
    julianDay: JulianDay(Date())
)
let results = sirius.riseTransitSetTimes(
    for: GeographicCoordinates(
        positivelyWestwardLongitude: Degree(.plus, 7, 46, 42),
        latitude: Degree(.plus, 49, 9, 3),
        altitude: 210)
)

print("Sirius rises on \(results.riseTime!.date.description(with: Locale.current))")
print("Sirius transit occurs on \(results.transitTime!.date.description(with: Locale.current))")
print("Sirius sets on \(results.setTime!.date.description(with: Locale.current))")

let singapore = GeographicCoordinates(CLLocation(latitude: 1.290, longitude: 103.852))
let today = JulianDay(year: 2020, month: 9, day: 6)
let todayTimes = Earth(julianDay: today).twilights(forSunAltitude: ArcMinute(-50).inDegrees, coordinates: singapore)

let timeFormatter = DateComponentsFormatter()
timeFormatter.unitsStyle = .short
timeFormatter.allowedUnits = [.hour, .minute, .second]
timeFormatter.allowsFractionalUnits = false

print(timeFormatter.string(from: todayTimes.setTime!.date, to: todayTimes.riseTime!.date)!)
// 11 hr, 58 min, 43 sec

let polaris = AstronomicalObject(
    name: "Polaris",
    coordinates: EquatorialCoordinates(rightAscension: Hour(.plus, 2, 31, 47.08), declination: Degree(.plus, 89, 15, 50.9)
    ),
    julianDay: JulianDay(year: 2020, month: 9, day: 6)
)
let results2 = polaris.riseTransitSetTimes(
    for: GeographicCoordinates(
        positivelyWestwardLongitude: Degree(.plus, 7, 46, 42),
        latitude: Degree(.plus, 49, 9, 3),
        altitude: 210)
)
