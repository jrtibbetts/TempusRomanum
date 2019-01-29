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

    class SunriseSunsetDotOrgJSONDecoder: JSONDecoder {

        /// The formatter for date strings returned by `sunrise-sunset.org`.
        /// These are in the `.medium` time style, like `"7:27:02 AM"` and
        /// `"12:16:28 PM"`.
        let dateFormatter = DateFormatter() <~ {
            $0.timeStyle = .medium
        }

        init(offset: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT())) {
            super.init()
            keyDecodingStrategy = .convertFromSnakeCase
            dateDecodingStrategy = .custom { (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let date = self.dateFormatter.date(from: dateString)

                if var date = date {
                    date.addTimeInterval(offset)

                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container,
                                                           debugDescription: """
Date values must be formatted like \"7:27:02 AM\". No other format is accepted.
""")
                }
            }
        }
    }

    // MARK: - Private Properties

    /// The JSON decoder, which converts snake_case keys to CamelCase ones.
    private let jsonDecoder = SunriseSunsetDotOrgJSONDecoder()

    // MARK: - SunriseSunsetProvider

    public func sunriseSunset() -> Promise<SunriseSunset> {
        return CLLocationManager.requestLocation().then { (locations) -> Promise<SunriseSunset> in
            return self.sunriseSunset(for: locations[0].coordinate)
        }
    }

    // MARK: - Public Functions
    
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
            guard let request = type(of: self).urlRequest(for: coordinate, date: date) else {
                promise.reject(ResponseData.Status.invalidRequest)
                return
            }

            // Call the server.
            URLSession.shared.dataTask(.promise, with: request).validate().done { (response) in
                let responseData = try self.jsonDecoder.decode(ResponseData.self,
                                                               from: response.data)
                self.handle(response: responseData, promise: promise)
                }.catch {
                    promise.reject($0)
            }
        }
    }

    // MARK: - Private Functions

    func handle(response responseData: ResponseData, promise: Resolver<SunriseSunset>) {
        if responseData.status == .OK {
            promise.fulfill(responseData.results)
        } else {
            promise.reject(responseData.status)
        }
    }

    // MARK: - Static Utility Functions

    /// Construct a URL request for getting astronomical data from
    /// `sunrise-sunset.org`.
    ///
    /// - parameter coordinate: The latitude & longitude.
    /// - parameter date: The date to use for calculating sunrise and sunset
    ///             times.
    static func urlRequest(for coordinate: CLLocationCoordinate2D,
                           date: Date) -> URLRequest? {
        let urlPattern = "https://api.sunrise-sunset.org/json?lat=%@&lng=%@"
        let coordinateStrings = coordinate.strings
        let urlString = String(format: urlPattern,
                               coordinateStrings.latitude,
                               coordinateStrings.longitude)

        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }

    // MARK: - JSON Types

    /// The response JSON that's returned from
    /// https://api.sunrise-sunset.org/json.
    struct ResponseData: Codable {

        /// The sunrise and sunset times. This will be empty if `status` is not
        /// `"OK"`.
        var results: SunriseSunsetDotOrgTimes

        /// The return code of the server call.
        var status: Status

        /// The status codes that can be returned by the server. They can all
        /// be used as `Error`s (yes, including `OK`).
        enum Status: String, Error, Codable {
            case OK
            case invalidRequest
            case invalidDate
            case unknownError

            private enum CodingKeys: String, CodingKey {
                case OK
                case invalidRequest = "INVALID_REQUEST"
                case invalidDate = "INVALID_DATE"
                case unknownError = "UNKNOWN_ERROR"
            }
        }
    }

}
