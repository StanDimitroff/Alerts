import UIKit

class Utils {

    static var deviceIsIPAD: Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
}
