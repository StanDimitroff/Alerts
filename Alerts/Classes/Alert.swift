//
//  Alert.swift
//  Alerts
//
//  Created by Stanislav Dimitrov on 22.11.17.
//

import UIKit

public typealias Action = Alert.Action
public typealias Responder = () -> ()

public class Alert {

    public struct Action {
        let title: String
        let style: UIAlertAction.Style
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
            style: UIAlertAction.Style? = nil,
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
    private var presenter: UIViewController?
    private var title: String?
    private var message: String?
    private var style: UIAlertController.Style = .alert

    private var actions: [Action] = []
    
    public init() { }

    // MARK: - Private API
    private func createAlert(
        _ title: String?,
        message: String?,
        style: UIAlertController.Style,
        presenter: UIViewController) {
        
        self.title      = title
        self.message    = message
        self.style      = style
        self.presenter  = presenter
    }
    
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
    ///   - presenter: UIViewController instance where to present (required)
    /// - Returns: Alert object
    public func makeAlert(
        title: String? = nil,
        message: String? = nil,
        presenter: UIViewController) -> Alert {
        createAlert(title, message: message, style: .alert, presenter: presenter)
        
        return self
    }

    /// Create action sheet
    ///
    /// - Parameters:
    ///   - title: the desired title of action sheet (optional)
    ///   - message: the body of action sheet (optional)
    ///   - presenter: UIViewController instance where to present (required)
    /// - Returns: Alert object
    public func makeActionSheet(
        title: String? = nil,
        message: String? = nil,
        presenter: UIViewController) -> Alert {
        createAlert(title, message: message, style: .actionSheet, presenter: presenter)
        
        return self
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    /// - Returns: the created alert
    public func addActions(_ actions: Action...) -> Alert {
        self.actions.append(contentsOf: actions)
        
        return self
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    /// - Returns: the created alert
    public func addActions(_ actions: [Action]) -> Alert {
        self.actions.append(contentsOf: actions)

        return self
    }

    /// Add single action to alert
    ///
    /// - Parameter action: action to add in actions
    /// - Returns: the created alert
    @discardableResult
    public func addAction(_ action: Action) -> Alert {
        actions.append(action)
        
        return self
    }

    /// Present the alert on the passed UIViewController
    ///
    /// - Parameter completion: completion handler
    public func show(withCompletion completion: (() -> Void)? = nil) {
        var alertTitle: String? = nil
        var alertMessage: String? = nil

        if let tlt = title {
            alertTitle = NSLocalizedString(tlt, comment: tlt)
        }

        if let msg = message {
            alertMessage = NSLocalizedString(msg, comment: msg)
        }
        
        alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: style)
        
        setActions()
        
        DispatchQueue.main.async {
            self.presenter?.present(
                self.alertController,
                animated: true,
                completion: completion
            )
        }
    }
}

