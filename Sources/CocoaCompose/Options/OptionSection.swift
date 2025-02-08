import Cocoa

public class OptionSection: NSStackView {
    public init(title: String? = nil, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, distribution: NSStackView.Distribution = .fill, alignment: NSLayoutConstraint.Attribute? = nil, spacing: Double? = nil, views: [NSView]) {
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .vertical
        self.alignment = .leading
        self.spacing = 7
        
        if let title {
            let label = Label()
            label.stringValue = title
            label.font = .preferredFont(forTextStyle: .body)
            label.textColor = .labelColor
            label.alignment = .left
            
            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)

            addArrangedSubview(label)
        }

        self.wantsLayer = true
        self.layer?.masksToBounds = false

        let itemStack = NSStackView(views: views)
        itemStack.orientation = orientation
        itemStack.distribution = distribution
        itemStack.alignment = alignment ?? (orientation == .vertical ? .leading : .top)
        itemStack.spacing = spacing ?? (orientation == .vertical ? 7 : 12)

        addArrangedSubview(itemStack)

        if orientation == .horizontal, let view = views.first {
            switch view {
            case is Button, is Checkbox, is DatePicker, is FontPicker, is PopUp, is TextField, is TimePicker:
                itemStack.alignment = .firstBaseline
            default:
                break
            }
        }

        if let footer {
            let label = Label()
            label.stringValue = footer
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabelColor
            label.usesSingleLineMode = false
            
            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            addArrangedSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
