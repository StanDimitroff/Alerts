import UIKit

public typealias Action = Alert.Action
public typealias FieldAction = Alert.FieldAction
public typealias Responder = () -> ()
public typealias FieldResponder = ([UITextField]?) -> ()

public class Alert: NSObject {

    /// An UIBarButtonItem to hook with the UIPopoverPresentationController if device is iPad
    public var anchorButton: UIBarButtonItem?
    
    /// CGRect to present UIPopoverPresentationController if device is iPad
    public var anchorRect: CGRect?

    /// UIPopoverArrowDirection option set for UIPopoverPresentationController if device is iPad
    public var arrowDirections: UIPopoverArrowDirection?

    /// If true shows `Cancel` action. If false you can pass your own dismiss action.
    public var dismissActionsEnabled: Bool = false

    private var textFields: [UITextField]? {
        return alertController.textFields
    }

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

    public struct FieldAction {
        let title: String
        let style: UIAlertAction.Style
        let textColor: UIColor?
        let responders: [FieldResponder]?

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
            responders: [FieldResponder]? = nil) {
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
    private var fieldActions: [FieldAction] = []

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

        var alertTitle: String? = nil
        var alertMessage: String? = nil

        if let tilte = self.title {
            alertTitle = tilte
        }

        if let message = self.message {
            alertMessage = message
        }

        alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: style)
    }
    
    private func setActions() {
        for action in actions {
            let alertAction = UIAlertAction(
                title: action.title,
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

        for action in fieldActions {
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { [weak presenter] _ in
                    guard presenter != nil else { return }

                    action.responders?.forEach { $0(self.textFields) }
            })

            if let color = action.textColor {
                alertAction.setValue(color, forKey: "titleTextColor")
            }

            alertController.addAction(alertAction)
        }

        if style == .actionSheet && dismissActionsEnabled {
            var actionStyle: UIAlertAction.Style = .cancel
            if Utils.deviceIsIPAD { actionStyle = .default }
            
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("Cancel", comment: "Cancel"),
                style: actionStyle,
                handler: nil)

            alertController.addAction(cancelAction)
        }

        if style == .alert && actions.isEmpty && dismissActionsEnabled {
            let okAction = UIAlertAction(
                title: NSLocalizedString("OK", comment: "OK"),
                style: .default,
                handler: nil)

            alertController.addAction(okAction)
        }
    }

    private func configurePresentation() {
        if Utils.deviceIsIPAD {
            if let popoverController = alertController.popoverPresentationController {
                guard let view = presenter?.view else { return }
                popoverController.sourceView = view

                if let anchorButton = self.anchorButton {
                    popoverController.barButtonItem = anchorButton
                }

                var sourceRect: CGRect!
                if let anchorRect = self.anchorRect {
                    sourceRect = anchorRect
                } else {
                    sourceRect = CGRect(
                        x: view.bounds.midX,
                        y: view.bounds.maxY,
                        width: 0,
                        height: 0
                    )
                }
                popoverController.sourceRect = sourceRect

                var arrowDirections: UIPopoverArrowDirection!
                if let directions = self.arrowDirections {
                    arrowDirections = directions
                } else {
                    arrowDirections = []
                }
                popoverController.permittedArrowDirections = arrowDirections
            }
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
        presenter: UIViewController) -> Self {
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
        presenter: UIViewController) -> Self {
        createAlert(title, message: message, style: .actionSheet, presenter: presenter)
        
        return self
    }

    /// Config `Alert` object
    ///
    /// - Parameter block: Block of actions to perform (set parameters)
    /// - Returns: Alert object
    /// - Throws: Error if cannot execute block
    public func config(_ block: (Alert) throws -> Void) rethrows -> Self {
        try block(self)

        return self
    }

    /// Adds text field to alert
    ///
    /// - Parameter placeholder: the text field placeholder text
    /// - Returns: Alert object
  public func addTextField(_ closure: @escaping (UITextField) -> Void) -> Self {
        if case .actionSheet = style { return self }

        alertController.addTextField(configurationHandler: { textField in
            closure(textField)
        })

        return self
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    /// - Returns: the created alert
    public func addActions(_ actions: Action...) -> Self {
        self.actions.append(contentsOf: actions)
        
        return self
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    /// - Returns: the created alert
    public func addActions(_ actions: [Action]) -> Self {
        self.actions.append(contentsOf: actions)

        return self
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    /// - Returns: the created alert
    public func addActions(_ actions: FieldAction...) -> Self {
        fieldActions.append(contentsOf: actions)

        return self
    }

    /// Add multiple actions to alert
    ///
    /// - Parameter actions: actions to add
    /// - Returns: the created alert
    public func addActions(_ actions: [FieldAction]) -> Self {
        fieldActions.append(contentsOf: actions)

        return self
    }

    /// Add single action to alert
    ///
    /// - Parameter action: action to add in actions
    /// - Returns: the created alert
    @discardableResult
    public func addAction(_ action: Action) -> Self {
        actions.append(action)
        
        return self
    }

    /// Add single action to alert
    ///
    /// - Parameter action: action to add in actions
    /// - Returns: the created alert
    @discardableResult
    public func addAction(_ action: FieldAction) -> Self {
        fieldActions.append(action)

        return self
    }

    /// Present the alert on the passed UIViewController
    ///
    /// - Parameter completion: completion handler
    public func show(withCompletion completion: (() -> Void)? = nil) {

        setActions()
        configurePresentation()
        
        DispatchQueue.main.async {
            self.presenter?.present(
                self.alertController,
                animated: true,
                completion: completion
            )
        }
    }
}
