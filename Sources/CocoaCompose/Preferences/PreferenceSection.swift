import Cocoa

public class PreferenceSection: NSStackView {
    private var leadingView: NSView?
    
    var leadingWidthAnchor: NSLayoutDimension? { leadingView?.widthAnchor }

    public init(title: String? = nil, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, alignment: NSLayoutConstraint.Attribute = .leading, spacing: Double? = nil, views: [NSView]) {
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .horizontal
        self.alignment = .top
        self.spacing = title == nil ? 0 : 7
        
        if let view = views.first {
            switch view {
            case is Button, is Checkbox, is DatePicker, is FontPicker, is PopUp, is TextField, is TimePicker:
                self.alignment = .firstBaseline
            case is NSButton, is NSTextField:
                self.alignment = .firstBaseline
            default:
                break
            }
        }

        self.wantsLayer = true
        self.layer?.masksToBounds = false

        let itemStack = ConstrainingStackView(orientation: orientation, alignment: orientation == .vertical ? .leading : .top, views: views)
        itemStack.distribution = distribution
        itemStack.spacing = spacing ?? (orientation == .vertical ? 7 : 12)
        
        let stackView = ConstrainingStackView(orientation: .vertical, alignment: alignment, views: [itemStack])
        stackView.distribution = .fill
        stackView.spacing = 7
        
        if let title {
            let label = Label()
            label.stringValue = title
            label.font = .preferredFont(forTextStyle: .body)
            label.textColor = .labelColor
            label.alignment = .right

            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)

            addArrangedSubview(label)
            
            self.leadingView = label
            
        } else {
            let view = NSView()
            
            let width = view.widthAnchor.constraint(equalToConstant: 0)
            width.priority = .defaultLow
            width.isActive = true

            addArrangedSubview(view)
            
            self.leadingView = view
        }

        if let footer {
            let label = Label()
            label.stringValue = footer
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabelColor
            label.usesSingleLineMode = false

            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
            label.setContentCompressionResistancePriority(.init(rawValue: 1), for: .horizontal)
            
            stackView.addArrangedSubview(label)
        }
        
        addArrangedSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
