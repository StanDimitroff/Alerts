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

    @IBAction func showAlertWithTextField(_ sender: UIButton) {
        Alert()
            .makeAlert(
                title: "Alert with text field",
                message: "Please enter your name",
                presenter: self)
            .addTextField(withPlaceholder: "First name")
            .addTextField(withPlaceholder: "Last name")
            .addActions(FieldAction("Done", style: .default, responders:
                [
                    {
                        textFields in
                        
                        print(textFields?[0].text ?? "")
                        print(textFields?[1].text ?? "")
                    }
                ]),
                    FieldAction("Cancel", style: .cancel)
            )
            .show()
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

