import Cocoa

public class Button: NSButton {
    public var onClick: (() -> Void)?
    
    public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, image: NSImage? = nil, symbolConfiguration: NSImage.SymbolConfiguration? = nil, controlSize: NSControl.ControlSize = .regular, onClick: (() -> Void)? = nil) {
        self.onClick = onClick

        super.init(frame: .zero)

        if let attributedTitle {
            self.attributedTitle = attributedTitle
        } else {
            self.title = title ?? ""
        }

        self.bezelStyle = .rounded
        self.controlSize = controlSize
        self.image = image
        self.symbolConfiguration = symbolConfiguration
        self.imagePosition = .imageLeading
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
