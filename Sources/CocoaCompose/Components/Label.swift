import Cocoa

public class Label: NSTextField {
    public init(string: String? = nil, attributedString: NSAttributedString? = nil) {
        super.init(frame: .zero)
        
        if let string = attributedString {
            attributedStringValue = string
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
}
