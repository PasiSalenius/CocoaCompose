import Cocoa

public class ProgressIndicator: NSProgressIndicator {
    public enum Style {
        case bar
        case spinner

        var indicatorStyle: NSProgressIndicator.Style {
            switch self {
            case .bar: return .bar
            case .spinner: return .spinning
            }
        }
    }

    public init(style: Style = .bar, value: Double = 0.0, minValue: Double = 0.0, maxValue: Double = 1.0, isIndeterminate: Bool = false, controlSize: NSControl.ControlSize = .regular) {
        super.init(frame: .zero)

        self.style = style.indicatorStyle
        self.controlSize = controlSize
        self.isIndeterminate = isIndeterminate

        self.minValue = minValue
        self.maxValue = maxValue
        self.doubleValue = value

        if isIndeterminate {
            startAnimation(nil)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var value: Double {
        get { doubleValue }
        set { doubleValue = newValue }
    }

    public func startAnimation() {
        startAnimation(nil)
    }

    public func stopAnimation() {
        stopAnimation(nil)
    }
}
