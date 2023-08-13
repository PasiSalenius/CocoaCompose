import Cocoa

public class Slider: NSSlider {
    public var onChange: ((Double) -> Void)?
    
    public init(type: NSSlider.SliderType = .linear, value: Double = 0.0, minValue: Double = 0.0, maxValue: Double = 1.0, numberOfTickMarks: Int = 5, onChange: ((Double) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)
        
        self.sliderType = type
        self.controlSize = .small
        
        self.allowsTickMarkValuesOnly = true
        self.numberOfTickMarks = numberOfTickMarks
        self.tickMarkPosition = .below
        
        self.minValue = minValue
        self.maxValue = maxValue
        self.doubleValue = value

        self.target = self
        self.action = #selector(buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    @objc func buttonAction(_ slider: NSSlider) {
        onChange?(slider.doubleValue)
    }
}
