import Cocoa

public class Button: NSButton {
    public var onClick: (() -> Void)?
    
    public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, image: NSImage? = nil, symbolConfiguration: NSImage.SymbolConfiguration? = nil, onClick: (() -> Void)? = nil) {
        self.onClick = onClick

        super.init(frame: .zero)

        if let title = attributedTitle {
            self.attributedTitle = title
        } else {
            self.title = title ?? ""
        }

        self.bezelStyle = .rounded
        self.font = .preferredFont(forTextStyle: .body)
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
