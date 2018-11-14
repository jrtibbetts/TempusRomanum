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

    fileprivate let tevye = Tevye()

    // MARK: - UIViewController

    override public func viewDidLoad() {
        super.viewDidLoad()

        tevye.sunriseSunset().done { [weak self] (solarAndLunarData) in
            self?.modernSunriseLabel?.text = solarAndLunarData.sunriseString
            self?.modernSunsetLabel?.text = solarAndLunarData.sunsetString
            self?.clockView?.sunriseSunset = (solarAndLunarData.sunrise, solarAndLunarData.sunset)
            }.catch { (error) in
                self.presentAlert(for: error, title: "Error")
        }
    }

}
