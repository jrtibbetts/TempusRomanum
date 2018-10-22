//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

public final class Tevye: NSObject {

    public typealias SunriseSunset = (Date, Date)

    public static var timeZoneOffset: Int = 0

    // MARK: - Private Properties

    fileprivate static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        return formatter
    }()

    // MARK: - Public Functions

    public func sunriseSunset() -> Promise<SolarAndLunarData> {
        return Promise<SolarAndLunarData>() { (promise) in
            CLLocationManager.requestLocation().then {
                URLSession.shared.dataTask(.promise,
                                           with: try Tevye.request(for: $0[0].coordinate)!).validate()
                }.done {
                    promise.fulfill(try JSONDecoder().decode(SolarAndLunarData.self, from: $0.data))
                }.catch { (error) in
                    promise.reject(error)
            }
        }
    }

    // MARK: - Utility Functions

    /// Example: http://api.usno.navy.mil/rstt/oneday?date=12/1/2016&coords=41.89N,12.48E&tz=1
    public static func url(for coordinate: CLLocationCoordinate2D,
                           date: Date) throws -> URL? {
        let urlPattern = "http://api.usno.navy.mil/rstt/oneday?date=%@&coords=%@,%@&tz=%d"

        // format the date, latitude, longitude, and time zone for the URL
        let dateString = dateFormatter.string(from: date)
        let latString = String(format: "%.2f", coordinate.latitude)
        let lonString = String(format: "%.2f", coordinate.longitude)
        let urlString = String(format: urlPattern, dateString, latString, lonString, Int(timeZoneOffset))

        return URL(string: urlString)
    }

    public static func request(for coordinate: CLLocationCoordinate2D,
                               date: Date = Date()) throws -> URLRequest? {

        if let url = try url(for: coordinate, date: date) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }

}
