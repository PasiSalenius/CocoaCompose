import Cocoa

public class DisclosureGroup: ConstrainingStackView {
    private let button = NSButton()
    private let titleLabel = Label()
    private let content: ConstrainingStackView

    public var onChange: ((Bool) -> Void)?

    public init(title: String, isExpanded: Bool = false, spacing: CGFloat = 7, views: [NSView], onChange: ((Bool) -> Void)? = nil) {
        self.onChange = onChange
        self.content = ConstrainingStackView(orientation: .vertical, alignment: .leading, views: views)

        super.init(orientation: .vertical, alignment: .leading, views: [])

        self.distribution = .fill
        self.spacing = spacing

        button.setButtonType(.onOff)
        button.bezelStyle = .disclosure
        button.title = ""
        button.imagePosition = .imageOnly
        button.target = self
        button.action = #selector(buttonAction)

        titleLabel.stringValue = title
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .labelColor

        // Let clicking the title toggle the group as well as the triangle.
        let clickRecognizer = NSClickGestureRecognizer(target: self, action: #selector(toggle))
        titleLabel.addGestureRecognizer(clickRecognizer)

        let headerSpacing: CGFloat = 5

        let header = NSStackView(views: [button, titleLabel, .flexibleSpacer()])
        header.orientation = .horizontal
        header.alignment = .firstBaseline
        header.spacing = headerSpacing

        addArrangedSubview(header)

        // Indent the content so it lines up with the title, past the disclosure triangle.
        content.spacing = spacing
        content.edgeInsets = NSEdgeInsets(top: 0, left: button.intrinsicContentSize.width + headerSpacing, bottom: 0, right: 0)
        addArrangedSubview(content)

        self.isExpanded = isExpanded
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var isExpanded: Bool {
        get { button.state == .on }
        set {
            button.state = newValue ? .on : .off
            content.isHidden = !newValue
        }
    }

    public var isEnabled: Bool {
        get { button.isEnabled }
        set {
            button.isEnabled = newValue
            content.setSubviewControlsEnabled(newValue)
        }
    }

    public var contentViews: [NSView] {
        get { content.arrangedSubviews }
        set {
            content.removeAllArrangedSubviews()
            content.addArrangedSubviews(newValue)
        }
    }

    // MARK: - Actions

    @objc func toggle() {
        isExpanded.toggle()
        onChange?(isExpanded)
    }

    @objc func buttonAction(_ sender: NSButton) {
        content.isHidden = sender.state == .off
        onChange?(sender.state == .on)
    }
}
