import Cocoa

public class PopUp: NSStackView {
    private let button = NSPopUpButton()
    private let label = Label()

    public var onChange: ((String) -> Void)?
    
    public init(items: [String] = [], selectedIndex: Int = -1, text: String? = nil, onChange: ((String) -> Void)? = nil) {
        self.onChange = onChange
        
        super.init(frame: .zero)
        orientation = .horizontal
        alignment = .firstBaseline
        spacing = 7

        button.font = .preferredFont(forTextStyle: .body)
        button.target = self
        button.action = #selector(buttonAction)
        
        items.forEach { button.addItem(withTitle: "\($0)") }
        
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
    
    public var selectedItem: String? { button.titleOfSelectedItem }
    
    public func set(items: [String], selectedIndex: Int = -1) {
        button.removeAllItems()
        
        items.forEach { button.addItem(withTitle: "\($0)") }
        button.selectItem(at: selectedIndex)
    }
    
    public func set(selectedIndex: Int) {
        button.selectItem(at: selectedIndex)
    }
    
    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSMenuItem) {
        onChange?(sender.title)
    }
}
