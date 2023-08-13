import Cocoa

public class FontPicker: NSButton {
    private let fontPanel = NSFontPanel.shared
    private let fontManager = NSFontManager.shared
    
    private var buttonTitle: String? {
        didSet { updateButton() }
    }

    public var onClick: ((NSFont) -> Void)?
    
    var selectedFont: NSFont {
        didSet { fontManager.setSelectedFont(selectedFont, isMultiple: false) }
    }
    
    public init(title: String? = nil, font: NSFont = .systemFont(ofSize: NSFont.systemFontSize), onClick: ((NSFont) -> Void)? = nil) {
        self.buttonTitle = title
        self.selectedFont = font
        
        super.init(frame: .zero)

        self.onClick = onClick

        self.bezelStyle = .rounded
        self.font = .preferredFont(forTextStyle: .body)

        self.target = self
        self.action = #selector(buttonAction)

        fontManager.setSelectedFont(selectedFont, isMultiple: false)

        fontManager.target = self
        fontManager.action = #selector(selectFont)

        updateButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButton() {
        if let buttonTitle {
            title = buttonTitle

        } else {
            let displayName = selectedFont.displayName ?? "Untitled"
            let string = "\(displayName)  \(Int(selectedFont.pointSize)) pts"

            let attributedString = NSMutableAttributedString(string: string)
            
            if let adjustedFont = NSFont(name: selectedFont.fontName, size: min(selectedFont.pointSize, 15)) {
                let range = NSString(string: string).range(of: displayName)
                attributedString.addAttribute(.font, value: adjustedFont, range: range)
            }

            self.attributedTitle = attributedString
        }

        sizeToFit()
    }
    
    // MARK: - Actions

    @objc func buttonAction() {
        fontManager.orderFrontFontPanel(self)
    }
    
    @objc func selectFont() {
        guard let newFont = fontManager.selectedFont else { return }
        
        selectedFont = fontPanel.convert(newFont)
        
        onClick?(selectedFont)
        updateButton()
    }
}
