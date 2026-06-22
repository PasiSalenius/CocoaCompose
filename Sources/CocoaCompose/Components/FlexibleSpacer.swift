import Cocoa

/// An empty, low-priority spacer for arranging controls in a horizontal `.fill` stack. It absorbs
/// surplus width, so the real controls keep their natural size instead of being stretched. Place one
/// in a `PreferenceSection` row to arrange the distribution yourself (e.g. pin a control to the
/// trailing edge); a horizontal `PreferenceSection` inserts one automatically only when the row
/// doesn't already contain a `FlexibleSpacer`.
public final class FlexibleSpacer: NSView {
    public init() {
        super.init(frame: .zero)

        setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
