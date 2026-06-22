import Cocoa

extension NSLayoutConstraint.Attribute {
    // Attributes valid as the cross-axis alignment of a vertical NSStackView (its cross axis is
    // horizontal).
    public static let verticalStackAlignments: Set<NSLayoutConstraint.Attribute> = [.leading, .trailing, .centerX, .width]

    // Attributes valid as the cross-axis alignment of a horizontal NSStackView (its cross axis is
    // vertical).
    public static let horizontalStackAlignments: Set<NSLayoutConstraint.Attribute> = [.top, .bottom, .centerY, .firstBaseline, .lastBaseline, .height]

    // Coerced to a value usable as the cross-axis alignment of a vertical stack, falling back to
    // .leading. Setting an out-of-axis attribute (e.g. .centerY) on a vertical stack silently breaks
    // its top-to-bottom layout, so guard against it.
    public var verticalStackAlignment: NSLayoutConstraint.Attribute {
        Self.verticalStackAlignments.contains(self) ? self : .leading
    }

    // Coerced to a value usable as the cross-axis alignment of a horizontal stack, falling back to
    // .centerY. Setting an out-of-axis attribute (e.g. .leading) on a horizontal stack silently breaks
    // its left-to-right layout, so guard against it.
    public var horizontalStackAlignment: NSLayoutConstraint.Attribute {
        Self.horizontalStackAlignments.contains(self) ? self : .centerY
    }

    // Coerced to a value usable as the cross-axis alignment of a stack with the given orientation.
    public func stackAlignment(for orientation: NSUserInterfaceLayoutOrientation) -> NSLayoutConstraint.Attribute {
        orientation == .vertical ? verticalStackAlignment : horizontalStackAlignment
    }
}
