//  Copyright © 2018 Poikile Creations. All rights reserved.

import Combine
import Stylobate
import UIKit

public final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var modernTimeLabel: UILabel!
    @IBOutlet private weak var romanTimeLabel: UILabel!
    @IBOutlet fileprivate weak var modernSunriseLabel: UILabel!
    @IBOutlet fileprivate weak var modernSunsetLabel: UILabel!
    @IBOutlet fileprivate weak var clockView: RomanClockView!

    // MARK: - Internal Properties

    /// The app's settings. By default, this is `UserDefaults.standard`, but
    /// it can be set to another `UserDefaults` instance, such as for testing.
    var settings: UserDefaults = .standard

    private var sunriseSunset: SunriseSunset?

    private let sunriseSunsetProvider = SunriseSunsetDotOrgProvider()

    private var timeFormatter: DateFormatter {
        return settings.use24HourClock ? twelveHourTimeFormatter : twentyFourHourTimeFormatter
    }

    /// A `DateFormatter` for getting displaying 24-hour time for `Date`s,
    /// like `08:00` (as opposed to true military time, which doesn't use
    /// colons, like `0800`). The date information of the date is not displayed.
    private let twentyFourHourTimeFormatter = DateFormatter() <~ {
        $0.dateFormat = "HH:mm"
    }

    private let twelveHourTimeFormatter = DateFormatter() <~ {
        $0.dateFormat = "hh:mm a"
    }

    private var sunriseSunsetCancellable: AnyCancellable?

    // MARK: - UIViewController

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateTime()

        _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [unowned self] _ in
            updateTime()
        }

        sunriseSunsetCancellable = sunriseSunsetProvider.sunriseSunsetPublisher.sink(
            receiveCompletion: { (completion) in
                print("Completed? \(completion)")
            }, receiveValue: { [unowned self] (sunriseSunset) in
                self.sunriseSunset = sunriseSunset
                modernSunriseLabel?.text = timeFormatter.string(from: sunriseSunset.sunrise)
                modernSunsetLabel?.text = timeFormatter.string(from: sunriseSunset.sunset)
                clockView?.sunriseSunset = sunriseSunset
                updateTime()
            })

        sunriseSunsetProvider.start()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sunriseSunsetProvider.stop()
    }
    // MARK: - Actions and Selectors

    private func updateTime() {
        let now = Date()
        modernTimeLabel.text = timeFormatter.string(from: now)
        romanTimeLabel.text = sunriseSunset?.romanHour(forDate: now)?.string
    }

    @IBAction private func toggleTimeFormat() {
        settings.use24HourClock = !settings.use24HourClock
        updateTime()
    }

}
