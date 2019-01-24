//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import UIKit

public final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet fileprivate weak var romanSunriseLabel: UILabel!
    @IBOutlet fileprivate weak var romanSunsetLabel: UILabel!
    @IBOutlet fileprivate weak var modernSunriseLabel: UILabel!
    @IBOutlet fileprivate weak var modernSunsetLabel: UILabel!
    @IBOutlet fileprivate weak var clockView: RomanClockView!

    // MARK: - Private Properties

    fileprivate let sunriseSunsetProvider = SunriseSunsetDotOrgProvider()

    fileprivate var timeFormatter: DateFormatter!
    
    /// A `DateFormatter` for getting displaying 24-hour time for `Date`s,
    /// like `08:00` (as opposed to true military time, which doesn't use
    /// colons, like `0800`). The date information of the date is not displayed.
    fileprivate let twentyFourHourTimeFormatter = DateFormatter() <~ {
        $0.dateFormat = "HH:mm"
    }
    
    fileprivate let twelveHourTimeFormatter = DateFormatter() <~ {
        $0.dateFormat = "hh:mm a"
    }

    // MARK: - UIViewController

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        timeFormatter = twelveHourTimeFormatter

        sunriseSunsetProvider.sunriseSunset().done { [weak self] (sunriseSunset) in
            guard let self = self else { return }
            self.modernSunriseLabel?.text = self.timeFormatter.string(from: sunriseSunset.sunrise)
            self.modernSunsetLabel?.text = self.timeFormatter.string(from: sunriseSunset.sunset)
            self.clockView?.sunriseSunset = sunriseSunset
            }.catch { (error) in
                self.presentAlert(for: error, title: "Error")
        }
    }

}
