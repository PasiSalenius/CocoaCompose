import Cocoa

public class HelpButton: NSButton {
    public var onClick: (() -> Void)?
    
    public init(controlSize: NSControl.ControlSize = .regular, onClick: (() -> Void)? = nil) {
        self.onClick = onClick

        super.init(frame: .zero)

        self.bezelStyle = .helpButton
        self.title = ""
        self.controlSize = controlSize
        self.target = self
        self.action = #selector(buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func buttonAction() {
        onClick?()
    }
}
