//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

public final class Tevye: NSObject, CLLocationManagerDelegate {

    public typealias SunriseSunset = (Date, Date)

    // MARK: - Private Properties

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        return formatter
    }()
    fileprivate var latitudeString: String = ""
    fileprivate var longitudeString: String = ""
    fileprivate var timezoneOffset: Int = 0  // GMT
    // Example: http://api.usno.navy.mil/rstt/oneday?date=12/1/2016&coords=41.89N,12.48E&tz=1
    fileprivate let urlPattern = "http://api.usno.navy.mil/rstt/oneday?date=%@&coords=%@,%@&tz=%@"

    // MARK: - Public Functions

    public func sunriseSunset() -> Promise<SolarAndLunarData> {
        return Promise<SolarAndLunarData>() { (seal) in
            CLLocationManager.requestLocation().then {
                URLSession.shared.dataTask(.promise, with: try self.request(for: $0[0].coordinate)!).validate()
                }.done {
                    seal.fulfill(try JSONDecoder().decode(SolarAndLunarData.self, from: $0.data))
                }.catch { (error) in
                    seal.reject(error)
            }
        }
    }

    // MARK: - Private Functions

    fileprivate func request(for coordinate: CLLocationCoordinate2D) throws -> URLRequest? {
        let (latString, longString) = coordinate.degreesMinutesSeconds
        let urlString = String(format: urlPattern, latString, longString)
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }

}
