//  Copyright © 2018 Poikile Creations. All rights reserved.

import Combine
import CoreLocation
import Foundation
import Stylobate

/// A `SunriseSunsetProvider` that gets its data by calling
/// https://api.sunrise-sunset.org/json, a free service.
///
/// @see https://sunrise-sunset.org/api
public class SunriseSunsetDotOrgProvider: NSObject, ObservableObject, SunriseSunsetProvider {

    public var sunriseSunsetPublisher = PassthroughSubject<SunriseSunset, Error>()

    public func start() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()

        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 4 * 60 * 60,
                                                   repeats: true) { [unowned self] (timer) in
            locationManager?.requestLocation()
        }
    }

    public func stop() {
        locationManager?.stopUpdatingLocation()
        locationUpdateTimer?.invalidate()
    }

    // MARK: - Internal, Testable Properties

    static var urlPattern = "https://api.sunrise-sunset.org/json?lat=%@&lng=%@&date=%@&formatted=0"

    // MARK: - Private Properties

    private var locationUpdateTimer: Timer?

    /// The JSON decoder, which converts snake_case keys to CamelCase ones.
    public static let jsonDecoder = JSONDecoder() <~ {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.dateDecodingStrategy = .iso8601
    }

    private static let queryDateFormatter = ISO8601DateFormatter() <~ {
        $0.formatOptions = .withFullDate
    }

    private var locationManager: CLLocationManager?

    // MARK: - Initialization

    public override init() {
        sunriseSunset = SimpleSunriseSunset(sunrise: Date(), sunset: Date())
        isTrackingLocation = false

        super.init()
    }

    // MARK: - SunriseSunsetProvider

    @Published public private(set) var sunriseSunset: SunriseSunset {
        didSet {
            sunriseSunsetPublisher.send(sunriseSunset)
        }
    }

    @Published public var isTrackingLocation: Bool = false

    private var sunriseSunsetCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    public func updateSunriseSunset() {
        guard let locationCoordinate = locationManager?.location?.coordinate else {
            return
        }

        updateSunriseSunset(for: locationCoordinate, date: Date())
    }

    public func updateSunriseSunset(for coordinate: CLLocationCoordinate2D,
                                    date: Date = Date()) {
        // Construct the request.
        guard let request = type(of: self).urlRequest(for: coordinate, date: date) else {
//            completion(Result<SunriseSunset, Error>.rejected(ResponseStatus.invalidRequest))
            return
        }

        sunriseSunsetCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ResponseData.self, decoder: type(of: self).jsonDecoder)
            .map { $0.results }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [unowned self] (completion) in
                    // No more values will come in.
                    locationManager?.stopUpdatingLocation()
                }, receiveValue: { [unowned self] (times) in
                    sunriseSunset = times
                })
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
        let coordinateStrings = coordinate.strings
        let urlString = String(format: urlPattern,
                               coordinateStrings.latitude,
                               coordinateStrings.longitude,
                               queryDateFormatter.string(from: date))

        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }

    // MARK: - JSON Types

    /// The response JSON that's returned from
    /// https://api.sunrise-sunset.org/json.
    private struct ResponseData: Codable {

        /// The sunrise and sunset times. This will be empty if `status` is not
        /// `"OK"`.
        var results: SunriseSunsetDotOrgTimes

        /// The return code of the server call.
        var status: ResponseStatus
    }

    /// The status codes that can be returned by the server. They can all
    /// be used as `Error`s (yes, including `OK`).
    private enum ResponseStatus: String, Error, Codable {
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

extension SunriseSunsetDotOrgProvider: CLLocationManagerDelegate {

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isTrackingLocation = (manager.authorizationStatus == .authorizedWhenInUse)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get a location! \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        guard let firstLocationCoordinate = locations.first?.coordinate else {
            return
        }

        updateSunriseSunset(for: firstLocationCoordinate, date: Date())
    }

}
