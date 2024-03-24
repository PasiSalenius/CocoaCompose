import Cocoa

public class TextField: NSStackView, NSTextFieldDelegate {
    private let textField = NSTextField()
    private let label = Label()

    public var onChange: ((String) -> Void)?
    public var shouldEnd: ((String) -> Bool)?
    public var onEndEditing: ((String) -> Void)?

    public init(value: String? = nil, attributedValue: NSAttributedString? = nil, placeholder: String? = nil, trailingText: String? = nil, width: CGFloat? = nil, shouldEnd: ((String) -> Bool)? = nil, onChange: ((String) -> Void)? = nil, onEndEditing: ((String) -> Void)? = nil) {
        self.onChange = onChange
        self.shouldEnd = shouldEnd
        self.onEndEditing = onEndEditing

        super.init(frame: .zero)
        orientation = .horizontal
        alignment = .firstBaseline
        spacing = 7
        
        if let value = attributedValue {
            textField.attributedStringValue = value
        } else {
            textField.stringValue = value ?? ""
        }
        
        textField.placeholderString = placeholder
        textField.font = .preferredFont(forTextStyle: .body)
        textField.textColor = .labelColor
        textField.isEditable = true
        textField.isBordered = true
        textField.maximumNumberOfLines = 1
        
        textField.cell?.truncatesLastVisibleLine = true
        
        textField.delegate = self
        
        if let width {
            let constraint = textField.widthAnchor.constraint(equalToConstant: width)
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
        
        addArrangedSubview(textField)
        
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
        get { textField.isEnabled }
        set { textField.isEnabled = newValue }
    }
    
    public var stringValue: String {
        get { textField.stringValue }
        set { textField.stringValue = newValue }
    }

    public var attributedValue: NSAttributedString {
        get { textField.attributedStringValue }
        set { textField.attributedStringValue = newValue }
    }
    
    public var trailingText: String? {
        get { label.stringValue }
        set {
            label.stringValue = newValue ?? ""
            label.isHidden = newValue == nil
        }
    }

    public var placeholder: String? {
        get { textField.placeholderString }
        set { textField.placeholderString = newValue }
    }

    public var font: NSFont? {
        get { textField.font }
        set { textField.font = newValue }
    }
    
    // MARK: - Text field delegate
    
    public func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        return shouldEnd?(fieldEditor.string) ?? true
    }
    
    public func controlTextDidChange(_ object: Notification) {
        guard let textField = object.object as? NSTextField else { return }
        
        onChange?(textField.stringValue)
    }
    
    public func controlTextDidEndEditing(_ object: Notification) {
        guard let textField = object.object as? NSTextField else { return }
        
        onEndEditing?(textField.stringValue)
    }
}
