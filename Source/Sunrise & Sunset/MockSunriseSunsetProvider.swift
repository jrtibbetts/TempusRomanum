//  Copyright © 2018 Poikile Creations. All rights reserved.

import Combine
import UIKit

struct SimpleSunriseSunset: SunriseSunset, Codable {

    var sunrise: Date

    var sunset: Date

    init(sunrise: Date = Date(), sunset: Date = Date()) {
        self.sunrise = sunrise
        self.sunset = sunset
    }

}

open class MockSunriseSunsetProvider: SunriseSunsetProvider {

    public var sunriseSunset: SunriseSunset = SimpleSunriseSunset(sunrise: Date(), sunset: Date())

    public lazy var sunriseSunsetPublisher: PassthroughSubject<SunriseSunset, Error> = {
        return PassthroughSubject<SunriseSunset, Error>()
    }()

    public func start() {
        sunriseSunset = generateSunriseSunset()

        timer = Timer.scheduledTimer(withTimeInterval: 4 * 60 * 60,
                                     repeats: true) { [unowned self] (timer) in
            self.sunriseSunset = self.generateSunriseSunset()
        }
    }

    public func stop() {
        timer?.invalidate()
    }

    private var timer: Timer?

    private func generateSunriseSunset() -> SunriseSunset {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let sunrise = startOfToday.addingTimeInterval(5.3 * 60.0 * 60.0)
        let sunset = startOfToday.addingTimeInterval(19.12 * 60.0 * 60.0)

        return SimpleSunriseSunset(sunrise: sunrise, sunset: sunset)
    }

}
