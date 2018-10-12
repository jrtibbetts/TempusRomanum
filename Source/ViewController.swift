//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import UIKit

public final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet fileprivate weak var romanTimeLabel: UILabel!
    @IBOutlet fileprivate weak var modernTimeLabel: UILabel!
    @IBOutlet fileprivate weak var clockView: UIView!

    // MARK: - Private Properties

    fileprivate let tevye = Tevye()

    // MARK: - UIViewController

    override public func viewDidLoad() {
        super.viewDidLoad()

        tevye.sunriseSunset().done { [weak self] (solarAndLunarData) in
            let sunrise = solarAndLunarData.solarData.filter { $0.phenomenon == "U" }.first?.time
            self?.romanTimeLabel?.text = sunrise
            }.catch { (error) in
                self.presentAlert(for: error, title: "Error")
        }
    }


}

