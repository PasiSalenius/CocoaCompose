import Cocoa

public class PreferenceSection: NSStackView {
    private var titleLabel: Label?
    
    var leadAnchor: NSLayoutDimension? { titleLabel?.widthAnchor }

    public init(title: String? = nil, titleAlignment: NSLayoutConstraint.Attribute = .firstBaseline, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView]) {
        super.init(frame: .zero)

        self.orientation = .horizontal
        self.alignment = titleAlignment
        self.spacing = 8

        self.wantsLayer = true
        self.layer?.masksToBounds = false
                                                                
        let itemStack = NSStackView(views: views)
        itemStack.orientation = orientation
        itemStack.alignment = orientation == .vertical ? .leading : .centerY
        itemStack.spacing = orientation == .vertical ? 7 : 10

        let stackView = NSStackView(views: [itemStack])
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.spacing = 7

        if let footer {
            let footerLabel = Label()
            footerLabel.stringValue = footer
            footerLabel.font = .preferredFont(forTextStyle: .subheadline)
            footerLabel.textColor = .secondaryLabelColor
            footerLabel.usesSingleLineMode = false
            
            footerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            stackView.addArrangedSubview(footerLabel)
        }
        
        if let title {
            let titleLabel = Label()
            titleLabel.stringValue = title
            titleLabel.font = .preferredFont(forTextStyle: .body)
            titleLabel.textColor = .labelColor
            titleLabel.alignment = .right

            addArrangedSubview(titleLabel)
            
            self.titleLabel = titleLabel
        }

        addArrangedSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
