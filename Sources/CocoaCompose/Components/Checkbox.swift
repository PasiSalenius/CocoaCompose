import Cocoa

public class Checkbox: NSStackView {
    private let button = NSButton()
    private let associatedViews: [NSView]
    
    public var onChange: ((Bool) -> Void)?
    
    private let checkboxWidth: CGFloat = 22

    private let footerSpacing: CGFloat = 4
    
    public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, footer: String? = nil, isOn: Bool = false, orientation: NSUserInterfaceLayoutOrientation = .horizontal, views: [NSView] = [], onChange: ((Bool) -> Void)? = nil) {
        self.associatedViews = views
        self.onChange = onChange

        super.init(frame: .zero)

        button.setButtonType(.switch)
        button.font = .preferredFont(forTextStyle: .body)
        button.target = self
        button.action = #selector(buttonAction)

        if let attributedTitle {
            button.attributedTitle = attributedTitle
        } else {
            button.title = title ?? ""
        }

        if let footer {
            // Block layout: the control row sits above the footer, which is indented to align with the
            // title text. Stay left-aligned (.leading) and avoid a flexible spacer so the checkbox does
            // not turn greedy and get pushed around inside a PreferenceSection / PreferenceList.
            self.orientation = .vertical
            self.alignment = .leading
            self.spacing = 7

            let mainStack = NSStackView()
            mainStack.distribution = .fill
            mainStack.orientation = orientation
            mainStack.alignment = orientation == .vertical ? .leading : .firstBaseline
            mainStack.spacing = orientation == .vertical ? 7 : 5

            mainStack.addArrangedSubview(button)

            if orientation == .horizontal {
                mainStack.addArrangedSubviews(views)
            } else {
                addIndentedViews(views, to: mainStack)
            }

            addArrangedSubview(mainStack)
            setCustomSpacing(footerSpacing, after: mainStack)

            let footerLabel = Label()
            footerLabel.stringValue = footer
            footerLabel.font = .preferredFont(forTextStyle: .subheadline)
            footerLabel.textColor = .secondaryLabelColor
            footerLabel.usesSingleLineMode = false
            footerLabel.setContentCompressionResistancePriority(.init(rawValue: 1), for: .horizontal)

            if views.isEmpty || orientation == .horizontal {
                // Indent the footer so it lines up with the title text after the checkbox. Horizontal
                // views share the button's row, so the footer still sits directly below the title;
                // vertical views stack between the title and footer, so it is not indented.
                let spacer = NSView()
                spacer.addConstraint(spacer.widthAnchor.constraint(equalToConstant: checkboxWidth))

                let footerRow = NSStackView(views: [spacer, footerLabel])
                footerRow.orientation = .horizontal
                footerRow.distribution = .fill
                footerRow.spacing = 0

                addArrangedSubview(footerRow)

            } else {
                addArrangedSubview(footerLabel)
            }

        } else {
            self.orientation = orientation
            self.alignment = orientation == .vertical ? .leading : .firstBaseline
            self.spacing = orientation == .vertical ? 7 : 5

            addArrangedSubview(button)

            if orientation == .horizontal {
                addArrangedSubviews(views)
            } else {
                addIndentedViews(views, to: self)
            }
        }

        self.isOn = isOn
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addIndentedViews(_ views: [NSView], to stack: NSStackView) {
        views.forEach { view in
            let spacer = NSView()
            spacer.addConstraint(spacer.widthAnchor.constraint(equalToConstant: checkboxWidth))

            let stackView = NSStackView(views: [spacer, view])
            stackView.orientation = .horizontal
            stackView.spacing = 0

            stack.addArrangedSubview(stackView)
        }
    }
    
    public var isEnabled: Bool {
        get {
            button.isEnabled
        }
        set {
            button.isEnabled = newValue
            associatedViews.forEach { $0.setSubviewControlsEnabled(newValue && isOn) }
        }
    }

    public var isOn: Bool {
        get {
            button.state == .on
        }
        set {
            button.state = newValue ? .on : .off
            associatedViews.forEach { $0.setSubviewControlsEnabled(newValue && isEnabled) }
        }
    }
    
    public var title: String {
        get { button.title }
        set { button.title = newValue }
    }

    public var attributedTitle: NSAttributedString {
        get { button.attributedTitle }
        set { button.attributedTitle = newValue }
    }
    
    public var font: NSFont? {
        get { button.font }
        set { button.font = newValue }
    }

    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSButton) {
        associatedViews.forEach { $0.setSubviewControlsEnabled(sender.state == .on && isEnabled) }
        onChange?(sender.state == .on)
    }
}
