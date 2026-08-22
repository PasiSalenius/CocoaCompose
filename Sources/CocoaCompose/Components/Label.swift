import Cocoa

public class Label: NSTextField {
    public init(string: String? = nil, attributedString: NSAttributedString? = nil) {
        super.init(frame: .zero)
        
        if let attributedString {
            attributedStringValue = attributedString
        } else {
            stringValue = string ?? ""
        }

        font = .preferredFont(forTextStyle: .body)
        textColor = .labelColor
        usesSingleLineMode = true
        alignment = .left
        drawsBackground = false
        isBordered = false
        isEditable = false
        isSelectable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setAttributes(_ attributes: [NSAttributedString.Key: Any], forSubstring substring: String) {
        let range = NSString(string: stringValue).range(of: substring)
        
        guard range.location != NSNotFound else { return }
        
        setAttributes(attributes, range: range)
    }
    
    public func setAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange) {
        let string = NSMutableAttributedString(attributedString: attributedStringValue)
        
        guard range.location != NSNotFound, NSMaxRange(range) <= string.length else { return }
        
        string.addAttributes(attributes, range: range)
        
        attributedStringValue = string
    }
}
