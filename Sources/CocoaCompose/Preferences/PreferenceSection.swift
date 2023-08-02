import Cocoa

public class PreferenceSection: NSStackView {
    private var titleLabel: Label?
    
    var leadAnchor: NSLayoutDimension? { titleLabel?.widthAnchor }

    public init(title: String? = nil, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView]) {
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .horizontal
        self.alignment = .top
        self.spacing = 8
        
        if let view = views.first {
            switch view {
            case is TextField, is Button, is PopUp:
                self.alignment = .firstBaseline
            default:
                break
            }
        }

        self.wantsLayer = true
        self.layer?.masksToBounds = false

        let itemStack = NSStackView(views: views)
        itemStack.distribution = .fill
        itemStack.orientation = orientation
        itemStack.alignment = orientation == .vertical ? .leading : .top
        itemStack.spacing = orientation == .vertical ? 7 : 10
        
        let stackView = NSStackView(views: [itemStack])
        stackView.distribution = .fill
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.spacing = 7
        
        let width = stackView.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true

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
