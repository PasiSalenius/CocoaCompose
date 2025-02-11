import Cocoa

public class PreferenceGroup: ConstrainingStackView {
    private var leadingViews: [NSView] = []
    
    var leadingWidthAnchor: NSLayoutDimension? { leadingViews.first?.widthAnchor }

    public struct Item {
        public var title: String?
        public var views: [NSView]
        
        public init(title: String? = nil, views: [NSView] = []) {
            self.title = title
            self.views = views
        }
    }

    public init(footer: String? = nil, alignment: NSLayoutConstraint.Attribute = .leading, items: [Item]) {
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .vertical
        self.alignment = alignment
        self.spacing = 7
        
        self.wantsLayer = true
        self.layer?.masksToBounds = false

        for item in items {
            let stackView = NSStackView()
            stackView.distribution = .fill
            stackView.orientation = .horizontal
            stackView.alignment = .top
            stackView.spacing = 7
            
            if let title = item.title {
                let label = Label()
                label.stringValue = title
                label.font = .preferredFont(forTextStyle: .body)
                label.textColor = .labelColor
                label.alignment = .right

                leadingViews.append(label)

                stackView.addArrangedSubview(label)

            } else {
                let view = NSView()
                leadingViews.append(view)

                stackView.addArrangedSubview(view)
            }

            let rowStack = NSStackView(views: item.views)
            rowStack.distribution = .fill
            rowStack.orientation = .horizontal
            rowStack.alignment = .firstBaseline
            rowStack.spacing = 12
            
            stackView.addArrangedSubview(rowStack)

            addArrangedSubview(stackView)
            
            if let view = item.views.first {
                switch view {
                case is Button, is Checkbox, is DatePicker, is FontPicker, is PopUp, is TextField, is TimePicker:
                    stackView.alignment = .firstBaseline
                case is NSButton, is NSTextField:
                    stackView.alignment = .firstBaseline
                default:
                    break
                }
            }
        }
        
        if let footer {
            let label = Label()
            label.stringValue = footer
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabelColor
            label.usesSingleLineMode = false

            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
            label.setContentCompressionResistancePriority(.init(rawValue: 1), for: .horizontal)
            
            let view = NSView()
            leadingViews.append(view)

            let stackView = NSStackView(views: [view, label])
            stackView.distribution = .fill
            stackView.orientation = .horizontal
            stackView.alignment = .top
            stackView.spacing = 7

            addArrangedSubview(stackView)
        }
        
        alignLeadAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func alignLeadAnchors() {
        let anchors = leadingViews.map { $0.widthAnchor }
        if let first = anchors.first {
            for anchor in anchors where anchor != first {
                anchor.constraint(equalTo: first).isActive = true
            }
        }
    }
}
