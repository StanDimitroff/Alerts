//
//  Alert.swift
//  Alerts
//
//  Created by Stanislav Dimitrov on 22.11.17.
//

import UIKit

public typealias Action = Alert.Action
public typealias Responder = () -> ()

public class Alert: NSObject {

    public struct Action {
        let title: String
        let style: UIAlertActionStyle
        let textColor: UIColor?
        let responders: [Responder]?

        /// Construct the Action object
        ///
        /// - Parameters:
        ///   - title: action title (required)
        ///   - style: action style (optional). Defaults to .default
        ///   - textColor: action color (optional)
        ///   - responders: action responders (optional). Defaults to []
        public init(
            _ title: String,
            style: UIAlertActionStyle? = nil,
            textColor: UIColor? = nil,
            responders: [Responder]? = nil) {
            self.title      = title
            self.style      = style ?? .default
            self.textColor  = textColor
            self.responders = responders
        }
    }

    // MARK: - Properties
    private var alertController: UIAlertController!
    private var presenter: UIViewController
    private let style: UIAlertControllerStyle!

    /// Pass multiple actions to alert
    public var actions: [Action] = []

    init(
         title: String? = nil,
         message: String? = nil,
         style: UIAlertControllerStyle,
         presenter: UIViewController) {

        var alertTitle: String? = nil
        var alertMessage: String? = nil

        if let tlt = title {
            alertTitle = NSLocalizedString(tlt, comment: tlt)
        }

        if let msg = message {
            alertMessage = NSLocalizedString(msg, comment: msg)
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

            if let color = action.textColor {
                alertAction.setValue(color, forKey: "titleTextColor")
            }

            alertController.addAction(alertAction)
        }

        if style == .actionSheet {
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("Cancel", comment: "Cancel"),
                style: .cancel,
                handler: nil)

            alertController.addAction(cancelAction)
        }

        if style == .alert && actions.isEmpty {
            let okAction = UIAlertAction(
                title: NSLocalizedString("OK", comment: "OK"),
                style: .default,
                handler: nil)

            alertController.addAction(okAction)
        }
    }

    /// Create alert
    ///
    /// - Parameters:
    ///   - title: the desired title of alert (optional)
    ///   - message: the body of alert (optional)
    ///   - presenter: UIViewController instance to present on (required)
    /// - Returns: Alert object
    public static func makeAlert(
        title: String?,
        message: String?,
        presenter: UIViewController) -> Alert {
        let alert = Alert(
            title: title,
            message: message,
            style: .alert,
            presenter: presenter)

        return alert
    }

    /// Create action sheet
    ///
    /// - Parameter presenter: UIViewController instance to present on (required)
    /// - Returns: Alert object
    public static func makeActionSheet(presenter: UIViewController) -> Alert {
        let action = Alert(style: .actionSheet, presenter: presenter)

        return action
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    public func addActions(_ actions: Action...) {
        self.actions.append(contentsOf: actions)
    }

    /// Add single action to alert
    ///
    /// - Parameter action: action to add in actions
    public func addAction(_ action: Action) {
        actions.append(action)
    }

    /// Present the alert on the passed UIViewController
    public func show() {
        setActions()
        
        DispatchQueue.main.async {
            self.presenter.present(
                self.alertController,
                animated: true,
                completion: nil)
        }
    }
}

