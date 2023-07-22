import Cocoa

extension NSView {
    func enableSubviews(_ enabled: Bool) {
        (self as? NSControl)?.isEnabled = enabled
        subviews.forEach { $0.enableSubviews(enabled) }
    }
}
