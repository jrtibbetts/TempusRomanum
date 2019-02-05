//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import UIKit

public final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var modernTimeLabel: UILabel!
    @IBOutlet private weak var romanTimeLabel: UILabel!
    @IBOutlet fileprivate weak var romanSunriseLabel: UILabel!
    @IBOutlet fileprivate weak var romanSunsetLabel: UILabel!
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

    // MARK: - UIViewController

    override public func viewDidLoad() {
        super.viewDidLoad()

        updateTime()

        _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.updateTime()
        }

        sunriseSunsetProvider.sunriseSunset().done { [weak self] (sunriseSunset) in
            guard let self = self else { return }
            self.sunriseSunset = sunriseSunset
            self.modernSunriseLabel?.text = self.timeFormatter.string(from: sunriseSunset.sunrise)
            self.modernSunsetLabel?.text = self.timeFormatter.string(from: sunriseSunset.sunset)
            self.clockView?.sunriseSunset = sunriseSunset
            self.updateTime()
            }.catch { (error) in
                self.presentAlert(for: error, title: "Error")
        }
    }

    // MARK: - Actions and Selectors

    @objc private func updateTime() {
        let now = Date()
        modernTimeLabel.text = timeFormatter.string(from: now)
        romanTimeLabel.text = sunriseSunset?.romanHour(forDate: now)?.string
    }

    @IBAction private func toggleTimeFormat() {
        settings.use24HourClock = !settings.use24HourClock
        updateTime()
    }

}
