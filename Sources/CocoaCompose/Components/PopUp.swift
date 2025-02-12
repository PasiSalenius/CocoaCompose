import Cocoa

public class PopUp: NSStackView {
    private let button = NSPopUpButton()
    private let label = Label()
    
    public var items: [Item] {
        didSet { update(items: items) }
    }

    public var onChange: ((Int, String) -> Void)?
    
    public struct Item {
        var title: String
        var image: NSImage?
        
        public init(title: String, image: NSImage? = nil) {
            self.title = title
            self.image = image
        }
    }
    
    public init(items: [Item] = [], selectedIndex: Int = -1, trailingText: String? = nil, isTruncating: Bool = false, onChange: ((Int, String) -> Void)? = nil) {
        self.items = items
        self.onChange = onChange
        
        super.init(frame: .zero)
        orientation = .horizontal
        alignment = .firstBaseline
        spacing = 7

        button.font = .preferredFont(forTextStyle: .body)
        button.target = self
        button.action = #selector(buttonAction)
        
        // allow button to take less width than selected item title
        button.cell?.lineBreakMode = .byTruncatingTail
        
        button.setContentCompressionResistancePriority(isTruncating ? .init(rawValue: 1) : .defaultHigh, for: .horizontal)
        
        items.forEach {
            button.addItem(withTitle: "\($0.title)")
            button.lastItem?.image = $0.image
        }
        
        button.selectItem(at: selectedIndex)

        addArrangedSubview(button)

        label.stringValue = trailingText ?? ""
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .labelColor
        label.isHidden = trailingText == nil

        addArrangedSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var isEnabled: Bool {
        get { button.isEnabled }
        set { button.isEnabled = newValue }
    }

    public var selectedIndex: Int {
        get { button.indexOfSelectedItem }
        set { button.selectItem(at: newValue) }
    }

    public var selectedTitle: String? { button.titleOfSelectedItem }
    
    public var trailingText: String? {
        get { label.stringValue }
        set {
            label.stringValue = newValue ?? ""
            label.isHidden = newValue == nil
        }
    }

    private func update(items: [Item]) {
        button.removeAllItems()
        
        items.forEach {
            button.addItem(withTitle: "\($0.title)")
            button.lastItem?.image = $0.image
        }
        
        self.selectedIndex = -1
    }

    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSMenuItem) {
        onChange?(button.indexOfSelectedItem, button.titleOfSelectedItem ?? "")
    }
}
