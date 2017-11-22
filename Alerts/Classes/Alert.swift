//
//  Alert.swift
//  Alerts
//
//  Created by Stanislav Dimitrov on 22.11.17.
//


import UIKit

public typealias ActionResponder = () -> ()

public class Alert: NSObject {

    public struct Action {
        let title: String
        let style: UIAlertActionStyle
        let responders: [ActionResponder]?

        /// Construct the Alert.Action object
        ///
        /// - Parameters:
        ///   - title: action title (required)
        ///   - style: action style
        ///   - responders: action responders (optional)
        public init(
            _ title: String,
            style: UIAlertActionStyle,
            responders: [ActionResponder]? = nil) {
            self.title      = title
            self.style      = style
            self.responders = responders
        }
    }

    // MARK: - Properties
    private var alertController: UIAlertController!
    private var presenter: UIViewController
    private let style: UIAlertControllerStyle!

    /// Pass multiple actions to alert
    public var actions: [Action] = []

    /// Construct the Alert object
    ///
    /// - Parameters:
    ///   - title: the desired title of alert (optional)
    ///   - message: the body of alert (optional)
    ///   - style: the desired UIAlertControllerStyle (required)
    ///   - presenter: UIViewController instance to present on (required)
    public init(title: String? = nil,
         message: String? = nil,
         style: UIAlertControllerStyle,
         presenter: UIViewController) {

        var alertTitle: String? = nil
        var alertMessage: String? = nil

        if title != nil {
            alertTitle = NSLocalizedString(title!, comment: title!)
        }

        if message != nil {
            alertMessage = NSLocalizedString(message!, comment: message!)
        }

        alertController = UIAlertController(title: alertTitle,
                                            message: alertMessage,
                                            preferredStyle: style)
        self.style      = style
        self.presenter = presenter
    }

    // MARK: - Private API
    private func setActions() {
        for action in actions {
            let alertAction = UIAlertAction(
                title: NSLocalizedString(action.title, comment: action.title),
                style: action.style,
                handler: { [weak presenter] _ in
                    guard presenter != nil else { return }

                    action.responders?.forEach { $0() }
            })

            alertController.addAction(alertAction)
        }

        if style == .actionSheet {
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("Cancel", comment: "Cancel"),
                style: .cancel,
                handler: nil)
            alertController.addAction(cancelAction)
        }
    }

    /// Add single action to to alert
    ///
    /// - Parameter action: action to add
    public func addAction(_ action: Action) {
        actions.append(action)
    }

    /// Present the alert on the passed UIViewController
    func show() {
        setActions()
        
        DispatchQueue.main.async {
            self.presenter.present(
                self.alertController,
                animated: true,
                completion: nil)
        }
    }
}

