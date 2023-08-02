import Cocoa

public class PopUp: NSStackView {
    private let button = NSPopUpButton()
    private let label = Label()

    public var onChange: ((Int, String) -> Void)?
    
    public struct Item {
        var title: String
        var image: NSImage?
        
        public init(title: String, image: NSImage? = nil) {
            self.title = title
            self.image = image
        }
    }
    
    public init(items: [Item] = [], selectedIndex: Int = -1, text: String? = nil, onChange: ((Int, String) -> Void)? = nil) {
        self.onChange = onChange
        
        super.init(frame: .zero)
        orientation = .horizontal
        alignment = .firstBaseline
        spacing = 7

        button.font = .preferredFont(forTextStyle: .body)
        button.target = self
        button.action = #selector(buttonAction)
        
        items.forEach {
            button.addItem(withTitle: "\($0.title)")
            button.lastItem?.image = $0.image
        }
        
        button.selectItem(at: selectedIndex)

        addArrangedSubview(button)

        label.stringValue = text ?? ""
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .labelColor
        label.isHidden = text == nil

        addArrangedSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var selectedIndex: Int { button.indexOfSelectedItem }

    public var selectedTitle: String? { button.titleOfSelectedItem }
    
    public func set(items: [Item], selectedIndex: Int = -1) {
        button.removeAllItems()
        
        items.forEach {
            button.addItem(withTitle: "\($0.title)")
            button.lastItem?.image = $0.image
        }

        button.selectItem(at: selectedIndex)
    }
    
    public func set(selectedIndex: Int) {
        button.selectItem(at: selectedIndex)
    }
    
    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSMenuItem) {
        onChange?(button.indexOfSelectedItem, button.titleOfSelectedItem ?? "")
    }
}
