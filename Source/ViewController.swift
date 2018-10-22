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
            self?.romanTimeLabel?.text = solarAndLunarData.sunriseString
            }.catch { (error) in
                self.presentAlert(for: error, title: "Error")
        }
    }


}

