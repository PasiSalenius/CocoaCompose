import Cocoa

public class Stepper: NSStepper {
    public var onChange: ((Double) -> Void)?

    public init(value: Double = 0.0, minValue: Double = 0.0, maxValue: Double = 100.0, increment: Double = 1.0, valueWraps: Bool = false, controlSize: NSControl.ControlSize = .small, onChange: ((Double) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.controlSize = controlSize
        self.minValue = minValue
        self.maxValue = maxValue
        self.increment = increment
        self.valueWraps = valueWraps
        self.doubleValue = value

        self.target = self
        self.action = #selector(buttonAction)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var value: Double {
        get { doubleValue }
        set { doubleValue = newValue }
    }

    // MARK: - Actions

    @objc func buttonAction(_ sender: NSStepper) {
        onChange?(sender.doubleValue)
    }
}
