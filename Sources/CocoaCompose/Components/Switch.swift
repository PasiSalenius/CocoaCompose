import Cocoa

public class Switch: NSSwitch {
    public var onChange: ((Bool) -> Void)?
    
    public init(isOn: Bool = false, onChange: ((Bool) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.state = isOn ? .on : .off
        
        self.target = self
        self.action = #selector(buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    @objc func buttonAction(_ sender: NSSwitch) {
        onChange?(sender.state == .on)
    }
}
