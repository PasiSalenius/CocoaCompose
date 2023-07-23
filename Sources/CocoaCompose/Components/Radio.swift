import Cocoa

public class Radio: NSStackView {
    private let items: [Item]
    private var buttons: [NSButton] = []

    public var onChange: ((Int) -> Void)?

    public struct Item {
        public var title: String
        public var views: [NSView]
        public var orientation: NSUserInterfaceLayoutOrientation
        
        public init(title: String, views: [NSView] = [], orientation: NSUserInterfaceLayoutOrientation = .horizontal) {
            self.title = title
            self.views = views
            self.orientation = orientation
        }
    }

    public init(items: [Item] = [], selectedIndex: Int = -1, onChange: ((Int) -> Void)? = nil) {
        self.items = items
        self.onChange = onChange

        super.init(frame: .zero)
        
        self.orientation = .vertical
        self.alignment = .leading
        self.spacing = 7
        
        for index in 0 ..< items.count {
            let item = items[index]
            
            let button = NSButton()
            button.font = .preferredFont(forTextStyle: .body)
            button.setButtonType(.radio)
            button.title = item.title
            button.target = self
            button.action = #selector(buttonAction)
            button.tag = index
            
            buttons.append(button)
            
            let stackView = NSStackView(views: [button] + item.views)
            stackView.orientation = item.orientation
            stackView.alignment = item.orientation == .vertical ? .leading : .centerY
            stackView.spacing = item.orientation == .vertical ? 7 : 10
            
            addArrangedSubview(stackView)
        }
        
        set(selectedIndex: selectedIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(selectedIndex: Int) {
        for index in 0 ..< items.count {
            buttons[index].state = selectedIndex == index ? .on : .off
            items[index].views.forEach { $0.enableSubviews(selectedIndex == index) }
        }
    }
    
    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSButton) {
        for index in 0 ..< buttons.count where index != sender.tag {
            buttons[index].state = .off
            items[index].views.forEach { $0.enableSubviews(false) }
        }

        items[sender.tag].views.forEach { $0.enableSubviews(true) }

        onChange?(sender.tag)
    }
}
