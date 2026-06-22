import Cocoa

public class StatusIndicator: NSStackView {
    private let dot = NSView()
    private let label = Label()

    private let dotSize: CGFloat

    public enum State {
        case active
        case idle
        case warning
        case error

        var color: NSColor {
            switch self {
            case .active:   return .systemGreen
            case .idle:     return .secondaryLabelColor
            case .warning:  return .systemOrange
            case .error:    return .systemRed
            }
        }
    }

    public var color: NSColor {
        didSet { updateDotColor() }
    }

    public init(color: NSColor = .systemGreen, title: String? = nil, controlSize: NSControl.ControlSize = .regular) {
        self.color = color
        self.dotSize = StatusIndicator.dotSize(for: controlSize)

        super.init(frame: .zero)
        orientation = .horizontal
        alignment = .centerY
        spacing = 6

        dot.wantsLayer = true
        dot.layer?.cornerRadius = dotSize / 2
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.addConstraints([
            dot.widthAnchor.constraint(equalToConstant: dotSize),
            dot.heightAnchor.constraint(equalToConstant: dotSize),
        ])

        addArrangedSubview(dot)

        label.stringValue = title ?? ""
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .labelColor
        label.isHidden = title == nil

        addArrangedSubview(label)

        updateDotColor()
    }

    public convenience init(state: State, title: String? = nil, controlSize: NSControl.ControlSize = .regular) {
        self.init(color: state.color, title: title, controlSize: controlSize)
    }

    private static func dotSize(for controlSize: NSControl.ControlSize) -> CGFloat {
        switch controlSize {
        case .mini:         return 8
        case .small:        return 10
        case .regular:      return 13
        case .large:        return 16
        case .extraLarge:   return 19
        @unknown default:   return 13
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layout() {
        super.layout()

        // The cgColor is resolved against the current appearance, so refresh it on layout to stay
        // correct against light/dark changes (mirrors Box).
        updateDotColor()
    }

    public override var firstBaselineOffsetFromTop: CGFloat {
        // The leading dot has no text baseline, so expose the label's baseline instead. This lets a
        // PreferenceSection / PreferenceGroup title firstBaseline-align with the status text.
        guard label.frame.height > 0 else { return super.firstBaselineOffsetFromTop }
        return bounds.maxY - label.frame.maxY + label.firstBaselineOffsetFromTop
    }

    public var title: String? {
        get { label.stringValue }
        set {
            label.stringValue = newValue ?? ""
            label.isHidden = newValue == nil
        }
    }

    public func setState(_ state: State, title: String? = nil) {
        color = state.color
        if let title { self.title = title }
    }

    private func updateDotColor() {
        dot.layer?.backgroundColor = color.cgColor
    }
}
