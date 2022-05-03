import UIKit

class Utils {

    static var deviceIsIPAD: Bool {
      return UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
}
