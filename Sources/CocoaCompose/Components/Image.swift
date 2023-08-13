import Cocoa

public class Image: NSImageView {
    public var onClick: (() -> Void)?

    public init(image: NSImage?, size: CGSize? = nil, onClick: (() -> Void)? = nil) {
        self.onClick = onClick

        super.init(frame: .zero)
        
        self.image = image

        if let size {
            let widthConstraint = self.widthAnchor.constraint(equalToConstant: size.width)
            widthConstraint.isActive = true

            let heightConstraint = self.heightAnchor.constraint(equalToConstant: size.height)
            heightConstraint.isActive = true
        }
        
        self.target = self
        self.action = #selector(buttonAction)
    }

    public convenience init(named name: String, size: CGSize? = nil, onClick: (() -> Void)? = nil) {
        self.init(image: NSImage(named: name), size: size, onClick: onClick)
    }

    public convenience init(systemSymbolName: String, size: CGSize? = nil, onClick: (() -> Void)? = nil) {
        self.init(image: NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: nil), size: size, onClick: onClick)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    @objc func buttonAction() {
        onClick?()
    }
}
