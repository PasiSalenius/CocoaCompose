import Cocoa

final class FlippedClipView: NSClipView {
    override var isFlipped: Bool {
        return true
    }
}
