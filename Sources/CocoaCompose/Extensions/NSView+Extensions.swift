import Cocoa

extension NSView {
    func enableSubviews(_ enabled: Bool) {
        if let control = self as? NSControl {
            control.isEnabled = enabled
        } else if let textView = self as? NSTextView {
            textView.isEditable = enabled
            textView.textColor = enabled ? .labelColor : .secondaryLabelColor
        }
        
        subviews.forEach { $0.enableSubviews(enabled) }
    }
}
