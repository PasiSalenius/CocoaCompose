import Cocoa

public class PreferenceBlock: ConstrainingStackView {
    public init(title: String? = nil, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, alignment: NSLayoutConstraint.Attribute = .leading, spacing: Double? = nil, views: [NSView]) {
        super.init(orientation: .vertical, alignment: alignment, views: [])

        self.distribution = .fill
        self.spacing = 7
        
        self.wantsLayer = true
        self.layer?.masksToBounds = false

        if let title {
            let label = Label()
            label.stringValue = title
            label.font = .preferredFont(forTextStyle: .body)
            label.textColor = .labelColor
            label.alignment = .left
            
            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)

            addArrangedSubview(label)
        }

        let itemStack = NSStackView(views: views)
        itemStack.orientation = orientation
        itemStack.alignment = orientation == .vertical ? .leading : .top
        itemStack.distribution = .fill
        itemStack.spacing = spacing ?? (orientation == .vertical ? 7 : 12)
        
        addArrangedSubview(itemStack)

        if let footer {
            let label = Label()
            label.stringValue = footer
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabelColor
            label.usesSingleLineMode = false

            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
            label.setContentCompressionResistancePriority(.init(rawValue: 1), for: .horizontal)
            
            addArrangedSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
