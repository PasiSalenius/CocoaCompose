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
            case is Button, is Checkbox, is ComboBox, is DatePicker, is FontPicker, is PathControl, is PopUp, is SearchField, is SegmentedControl, is StatusIndicator, is Stepper, is Switch, is TextField, is TimePicker, is TokenField:
                self.alignment = .firstBaseline
            case is NSButton, is NSTextField:
                self.alignment = .firstBaseline
            case is ColorWell:
                // A colour swatch has no text baseline (its first baseline is just its top edge), so
                // centre it vertically with the title instead.
                self.alignment = .centerY
            default:
                break
            }
        }

        self.wantsLayer = true
        self.layer?.masksToBounds = false

        // A horizontal row aligns on its cross (vertical) axis: honor the caller's alignment, or fall
        // back to the baseline default chosen above when none was given. A vertical column uses .leading.
        let baselineAlignment = self.alignment
        let callerProvidedAlignment = alignment != .leading

        let itemAlignment: NSLayoutConstraint.Attribute
        switch orientation {
        case .vertical:
            itemAlignment = .leading
        default:
            itemAlignment = callerProvidedAlignment ? alignment.horizontalStackAlignment : baselineAlignment
        }

        let itemStack = ConstrainingStackView(orientation: orientation, alignment: itemAlignment, views: views)
        itemStack.distribution = .fill
        itemStack.spacing = spacing ?? (orientation == .vertical ? 7 : 12)

        // The wrapper stacks the item row above the footer. Being vertical, it only honors the caller's
        // alignment for a vertical section; a horizontal section keeps the footer left-aligned below.
        let columnAlignment = orientation == .vertical ? alignment : .leading
        let wrapperAlignment = columnAlignment.verticalStackAlignment

        let stackView = ConstrainingStackView(orientation: .vertical, alignment: wrapperAlignment, views: [itemStack])
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
