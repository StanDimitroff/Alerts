import UIKit
import Alerts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showAlert(_ sender: UIButton) {
        Alert()
            .makeAlert(
            title: "Change background",
            message: "Background colour will be changed",
            presenter: self)
            .addActions(Action("Confirm", style: .destructive, responders:
                [
                    {
                        self.view.backgroundColor = .cyan
                    }
                ]),
                Action("Cancel", style: .cancel)
            )
            .show(withCompletion: { print("COMPLETION AFTER SHOW") })
    }

    @IBAction func showAction(_ sender: UIButton) {
        Alert()
            .makeActionSheet(presenter: self)
            .config {
                $0.dismissActionsEnabled = true
            }
            .addAction(Action("Change background", responders:
                [
                    {
                        self.view.backgroundColor = .magenta
                    }
                ]))
            .show()
    }
}

