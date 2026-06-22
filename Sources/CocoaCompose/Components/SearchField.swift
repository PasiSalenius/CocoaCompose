import Cocoa

public class SearchField: NSSearchField, NSSearchFieldDelegate {
    public var onChange: ((String) -> Void)?
    public var onEndEditing: ((String) -> Void)?

    public init(value: String = "", placeholder: String? = nil, sendsSearchImmediately: Bool = true, onChange: ((String) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.stringValue = value
        self.placeholderString = placeholder
        self.sendsWholeSearchString = !sendsSearchImmediately
        self.sendsSearchStringImmediately = sendsSearchImmediately

        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Search field delegate

    public func controlTextDidChange(_ object: Notification) {
        guard let field = object.object as? NSSearchField else { return }

        onChange?(field.stringValue)
    }

    public func controlTextDidEndEditing(_ object: Notification) {
        guard let field = object.object as? NSSearchField else { return }

        onEndEditing?(field.stringValue)
    }
}
