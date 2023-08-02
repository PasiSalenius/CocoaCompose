import Cocoa

public class Radio: NSStackView {
    private let items: [Item]
    private var buttons: [NSButton] = []

    public private(set) var selectedIndex: Int

    public var onChange: ((Int, Int) -> Void)?

    public struct Item {
        public var title: String?
        public var attributedString: NSAttributedString?
        public var footer: String?
        public var views: [NSView]
        public var orientation: NSUserInterfaceLayoutOrientation
        
        public init(title: String? = nil, attributedString: NSAttributedString? = nil, footer: String? = nil, views: [NSView] = [], orientation: NSUserInterfaceLayoutOrientation = .horizontal) {
            self.title = title
            self.attributedString = attributedString
            self.footer = footer
            self.views = views
            self.orientation = orientation
        }
    }

    public init(items: [Item] = [], selectedIndex: Int = -1, onChange: ((Int, Int) -> Void)? = nil) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.onChange = onChange

        super.init(frame: .zero)
        
        self.distribution = .fill
        self.orientation = .vertical
        self.alignment = .leading
        self.spacing = 7
        
        let width = self.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true
        
        for index in 0 ..< items.count {
            let item = items[index]
            
            let button = NSButton()
            button.font = .preferredFont(forTextStyle: .body)
            button.setButtonType(.radio)
            button.target = self
            button.action = #selector(buttonAction)
            button.tag = index

            if let string = item.attributedString {
                button.attributedTitle = string
            } else {
                button.title = item.title ?? ""
            }

            buttons.append(button)
            
            let stackView = NSStackView(views: [button] + item.views)
            stackView.distribution = .fill
            stackView.orientation = item.orientation
            stackView.alignment = item.orientation == .vertical ? .leading : .height
            stackView.spacing = item.orientation == .vertical ? 7 : 10
            
            addArrangedSubview(stackView)
            
            let width = stackView.widthAnchor.constraint(equalToConstant: 10_000)
            width.priority = .defaultLow
            width.isActive = true

            if let footer = item.footer {
                let footerLabel = Label()
                footerLabel.stringValue = footer
                footerLabel.font = .preferredFont(forTextStyle: .subheadline)
                footerLabel.textColor = .secondaryLabelColor
                footerLabel.usesSingleLineMode = false

                footerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                
                addArrangedSubview(footerLabel)
            }
        }
        
        set(selectedIndex: selectedIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        
        for index in 0 ..< items.count {
            buttons[index].state = selectedIndex == index ? .on : .off
            items[index].views.forEach { $0.enableSubviews(selectedIndex == index) }
        }
    }

    public func set(enabled: Bool) {
        for index in 0 ..< items.count {
            buttons[index].isEnabled = enabled
            items[index].views.forEach { $0.enableSubviews(enabled) }
        }
        
        if enabled {
            set(selectedIndex: selectedIndex)
        }
    }

    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSButton) {
        for index in 0 ..< buttons.count where index != sender.tag {
            buttons[index].state = .off
            items[index].views.forEach { $0.enableSubviews(false) }
        }

        items[sender.tag].views.forEach { $0.enableSubviews(true) }

        let previousIndex = selectedIndex
        selectedIndex = sender.tag

        onChange?(selectedIndex, previousIndex)
    }
}
