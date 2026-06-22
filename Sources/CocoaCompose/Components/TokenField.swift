import Cocoa

public class TokenField: NSTokenField, NSTokenFieldDelegate {
    public var onChange: (([String]) -> Void)?
    public var onEndEditing: (([String]) -> Void)?

    public init(tokens: [String] = [], placeholder: String? = nil, tokenStyle: NSTokenField.TokenStyle = .rounded, onChange: (([String]) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.tokenStyle = tokenStyle
        self.placeholderString = placeholder
        self.font = .preferredFont(forTextStyle: .body)
        self.objectValue = tokens

        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var tokens: [String] {
        get { objectValue as? [String] ?? [] }
        set { objectValue = newValue }
    }

    // MARK: - Token field delegate

    public func controlTextDidChange(_ object: Notification) {
        onChange?(tokens)
    }

    public func controlTextDidEndEditing(_ object: Notification) {
        onEndEditing?(tokens)
    }
}
