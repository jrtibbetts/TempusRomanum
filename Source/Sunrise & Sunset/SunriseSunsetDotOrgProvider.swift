//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

/// Retrieves `SunriseSunset` dates from the [Sunrise-Sunset.org
/// API](https://sunrise-sunset.org/api).
public struct SunriseSunsetDotOrgProvider: SunriseSunsetProvider {

    /// The service's API endpoint.
    fileprivate static let endpoint = URL(string: "https://api.sunrise-sunset.org/json")!

    /// The formatter for formatting dates passed to the server.
    fileprivate static let requestDateFormatter = DateFormatter() <~ {
        $0.dateFormat = "yyyy-MM-dd"
    }

    /// The formatter for parsing "formatted" dates from the server.
    fileprivate static let responseFormattedDateFormatter = DateFormatter() <~ {
        $0.dateStyle = .medium
    }

    /// The formatter for parsing "unformatted" dates from the server.
    fileprivate static let responseUnformattedDateFormatter = DateFormatter() <~ {
        $0.dateFormat = "yyyy-MM-ddTkk:mm:ss+00:00"
    }

    // MARK: - SunriseSunset

    public func sunriseSunset() -> Promise<SunriseSunset> {
        return sunriseSunset(date: Date(), formatDates: false)
    }

    public func sunriseSunset(date: Date = Date(),
                              formatDates: Bool = false) -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            CLLocationManager.requestLocation().then { (locations) -> Promise<(data: Data, response: URLResponse)> in
                let request = try SunriseSunsetDotOrgProvider.request(for: locations[0].coordinate, date: date, formatDates: formatDates)!
                return URLSession.shared.dataTask(.promise, with: request).validate()
                }.done {
                    let sunriseSunset = try JSONDecoder().decode(SunriseSunset.self, from: $0.data)
                    promise.fulfill(sunriseSunset)
                }.catch { (error) in
                    promise.reject(error)
            }
        }
    }

    // MARK: - Other Functions

    internal static func request(for coordinate: CLLocationCoordinate2D,
                                 date: Date,
                                 formatDates: Bool) throws -> URLRequest? {
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "lat", value: "\(coordinate.latitude)"))
        queryItems.append(URLQueryItem(name: "lng", value: "\(coordinate.longitude)"))
        queryItems.append(URLQueryItem(name: "date", value: requestDateFormatter.string(from: date)))
        queryItems.append(URLQueryItem(name: "formatted", value: "\(formatDates)"))
        components.queryItems = queryItems

        if let requestUrl = components.url {
            return URLRequest(url: requestUrl)
        } else {
            return nil
        }
    }

}
