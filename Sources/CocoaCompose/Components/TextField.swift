import Cocoa

public class TextField: NSStackView, NSTextFieldDelegate {
    private let textField = NSTextField()
    private let label = Label()

    public var onChange: ((String) -> Void)?

    public init(value: String = "", text: String? = nil, onChange: ((String) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)
        orientation = .horizontal
        alignment = .firstBaseline
        spacing = 7
        
        textField.stringValue = value
        textField.font = .preferredFont(forTextStyle: .body)
        textField.textColor = .labelColor
        textField.isEditable = true
        textField.isBordered = true
        textField.maximumNumberOfLines = 1
        
        textField.delegate = self
        
        textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addArrangedSubview(textField)
        
        label.stringValue = text ?? ""
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .labelColor
        label.isHidden = text == nil
        
        addArrangedSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(value: String) {
        textField.stringValue = value
    }
    
    public func set(font: NSFont) {
        textField.font = font
    }
    
    // MARK: - Text field delegate
    
    public func controlTextDidEndEditing(_ object: Notification) {
        guard let textField = object.object as? NSTextField else { return }
        
        onChange?(textField.stringValue)
    }
}
