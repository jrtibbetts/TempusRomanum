//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

/// Provides sunrise and sunset times for a given date at a given location. It
/// obtains them from a [REST API hosted by the US Naval
/// Observatory](http://api.usno.navy.mil/rstt/oneday).
public final class USNOSunriseSunsetProvider: NSObject, SunriseSunsetProvider {

    /// The current location's time zone offset from UMT.
    public static var timeZoneOffset: Int {
        return (TimeZone.autoupdatingCurrent.secondsFromGMT() / 60 / 60)
    }

    // MARK: - Private Properties

    /// Formats dates like `09/24/1489`.
    fileprivate static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        return formatter
    }()

    // MARK: - Public Functions

    /// Get a promise that will contain the sunrise & sunset data, when it's
    /// calculated.
    ///
    /// - returns: The solar & lunar data promise.
    fileprivate func solarData() -> Promise<USNOSolarAndLunarData> {
        return Promise<USNOSolarAndLunarData> { (promise) in
            CLLocationManager.requestLocation().then { (locations) -> Promise<(data: Data, response: URLResponse)> in
                let request = try USNOSunriseSunsetProvider.request(for: locations[0].coordinate)!
                return URLSession.shared.dataTask(.promise, with: request).validate()
                }.done {
                    let solarAndLunarData = try JSONDecoder().decode(USNOSolarAndLunarData.self, from: $0.data)
                    promise.fulfill(solarAndLunarData)
                }.catch { (error) in
                    promise.reject(error)
            }
        }
    }

    /// Get a promise that will contain the sunrise & sunset data, when it's
    /// calculated.
    ///
    /// - returns: The solar & lunar data promise.
    public func sunriseSunset() -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            self.solarData().done {
                let midnight = Calendar.autoupdatingCurrent.startOfDay(for: Date())
                let rawSunrise = $0.sunrise
                let rawMidnight = Calendar.autoupdatingCurrent.startOfDay(for: rawSunrise)
                let sunrise = rawSunrise.addingTimeInterval(midnight.timeIntervalSince(rawMidnight))
                let rawSunset = $0.sunset
                let sunset = rawSunset.addingTimeInterval(midnight.timeIntervalSince(rawMidnight))
                promise.fulfill(SunriseSunset(sunrise: sunrise, sunset: sunset))
                }.catch { (error) in
                    promise.reject(error)
            }
        }
    }

    // MARK: - Utility Functions

    /// Generate the URL that will provide the sunrise and sunset data.
    ///
    /// Example: http://api.usno.navy.mil/rstt/oneday?date=12/1/2016&coords=41.89N,12.48E&tz=1
    ///
    /// - parameter: coordinate - The location for which sunrise and sunset
    ///              data is desired.
    /// - parameter: date - The date whose data is being requested.
    ///
    /// - returns: The US Naval Observatory URL with the coordinates, date, and
    ///            time zone properly formatted.
    internal static func url(for coordinate: CLLocationCoordinate2D,
                             date: Date) throws -> URL? {
        let urlPattern = "http://api.usno.navy.mil/rstt/oneday?date=%@&coords=%@,%@&tz=%d"

        // format the date, latitude, longitude, and time zone for the URL
        let dateString = dateFormatter.string(from: date)
        let latString = String(format: "%.2f", coordinate.latitude)
        let lonString = String(format: "%.2f", coordinate.longitude)
        let urlString = String(format: urlPattern, dateString, latString, lonString, Int(timeZoneOffset))

        return URL(string: urlString)
    }

    /// Get the `URLRequest` that will be used to get sunrise & sunset info.
    ///
    /// - parameter: coordinate - The location for which sunrise and sunset
    ///              data is desired.
    /// - parameter: date - The date whose data is being requested.
    ///
    /// - returns: The request for the US Naval Observatory's API, with the
    ///            coordinates, date, and ime zone properly formatted.
    internal static func request(for coordinate: CLLocationCoordinate2D,
                                 date: Date = Date()) throws -> URLRequest? {
        if let url = try url(for: coordinate, date: date) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }

}
