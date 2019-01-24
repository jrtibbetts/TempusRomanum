//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

/// A `SunriseSunsetProvider` that gets its data by calling
/// https://api.sunrise-sunset.org/json, a free service.
///
/// @see https://sunrise-sunset.org/api
public struct SunriseSunsetDotOrgProvider: SunriseSunsetProvider {

    // MARK: - Private Properties

    /// The formatter for date strings returned by `sunrise-sunset.org`. These
    /// are in the `.medium` time style, like `"7:27:02 AM"` and
    /// `"12:16:28 PM"`.
    private let dateFormatter = DateFormatter() <~ {
        $0.timeStyle = .medium
    }

    /// The JSON decoder, which converts snake_case keys to CamelCase ones.
    private let jsonDecoder = JSONDecoder() <~ {
        // At the moment, all snake-case properties of ResponseData.Results are
        // commented out, but if they're ever uncommented, it'll be handy to
        // have already set this.
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }

    // MARK: - SunriseSunsetProvider

    public func sunriseSunset() -> Promise<SunriseSunset> {
        return CLLocationManager.requestLocation().then { (locations) -> Promise<SunriseSunset> in
            return self.sunriseSunset(for: locations[0].coordinate)
        }
    }

    /// Get a `Promise` with sunrise & sunset information for a specific date.
    ///
    /// - parameter coordinate: The latitude & longitude.
    /// - parameter date: The date to use for calculating sunrise and sunset
    ///             times. By default, this is the date when the function is
    ///             called.
    public func sunriseSunset(for coordinate: CLLocationCoordinate2D,
                              date: Date = Date()) -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            // Construct the request.
            guard let url = try type(of: self).url(for: coordinate) else {
                promise.reject(ResponseData.Status.INVALID_REQUEST)
                return
            }

            let request = URLRequest(url: url)

            // Call the server.
            URLSession.shared.dataTask(.promise, with: request).validate().done {
                let responseData = try self.jsonDecoder.decode(ResponseData.self, from: $0.data)

                if responseData.status == .OK,
                    var sunrise = self.dateFormatter.date(from: responseData.results.sunrise),
                    var sunset = self.dateFormatter.date(from: responseData.results.sunset) {

                    // Returned dates are in UMT. Adjust the times for the
                    // user's time zone.
                    let offset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT())
                    sunrise = sunrise.addingTimeInterval(offset)
                    sunset = sunset.addingTimeInterval(offset)

                    // Fulfill the promise!
                    let sunriseSunset = SunriseSunset(sunrise: sunrise, sunset: sunset)
                    promise.fulfill(sunriseSunset)
                } else {
                    promise.reject(responseData.status)
                }
                }.catch {
                    promise.reject($0)
            }
        }
    }

    // MARK: - Utility Functions

    static func url(for coordinate: CLLocationCoordinate2D,
                    date: Date = Date()) throws -> URL? {
        let urlPattern = "https://api.sunrise-sunset.org/json?lat=%@&lng=%@"
        let coordinateStrings = coordinate.strings
        let urlString = String(format: urlPattern,
                               coordinateStrings.latitude,
                               coordinateStrings.longitude)

        return URL(string: urlString)
    }

    // MARK: - JSON Types

    /// The response JSON that's returned from
    /// https://api.sunrise-sunset.org/json.
    struct ResponseData: Codable {

        /// The sunrise and sunset times. This will be empty if `status` is not
        /// `"OK"`.
        var results: Results

        /// The return code of the server call.
        var status: Status

        /// The status codes that can be returned by the server. They can all
        /// be used as `Error`s (yes, including `OK`).
        enum Status: String, Error, Codable {
            case OK
            case INVALID_REQUEST
            case INVALID_DATE
            case UNKNOWN_ERROR
        }

        /// The various astronomical times for the given date and location. ALL
        /// times are specified as UTC.
        struct Results: Codable {
            var sunrise: String
            var sunset: String
            /*
             var solar_noon: String
             var day_length: String
             var civil_twilight_begin: String
             var civil_twilight_end: String
             var nautical_twilight_begin: String
             var nautical_twilight_end: String
             var astronomical_twilight_begin: String
             var astronomical_twilight_end: String
             */
        }
    }

}
