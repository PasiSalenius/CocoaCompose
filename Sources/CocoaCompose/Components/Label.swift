import Cocoa

public class Label: NSTextField {
    public init() {
        super.init(frame: .zero)

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
