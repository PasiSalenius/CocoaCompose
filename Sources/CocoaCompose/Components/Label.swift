import Cocoa

public class Label: NSTextField {
    public init(_ string: String = "") {
        super.init(frame: .zero)

        stringValue = string
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
