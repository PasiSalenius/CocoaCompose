import Cocoa

public class ComboBox: NSComboBox, NSComboBoxDelegate {
    public var onChange: ((String) -> Void)?

    public init(items: [String] = [], value: String = "", placeholder: String? = nil, completes: Bool = true, controlSize: NSControl.ControlSize = .regular, onChange: ((String) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.controlSize = controlSize
        self.font = .systemFont(ofSize: NSFont.systemFontSize(for: controlSize))
        self.completes = completes
        self.placeholderString = placeholder

        addItems(withObjectValues: items)
        self.stringValue = value

        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var items: [String] {
        get { objectValues as? [String] ?? [] }
        set { update(items: newValue) }
    }

    public override var firstBaselineOffsetFromTop: CGFloat {
        // NSComboBox doesn't report a usable text baseline, so derive it from its vertically centred
        // single line of text. This lets a PreferenceSection / PreferenceGroup title firstBaseline-align
        // with the field, the same way it does with a TextField or PopUp.
        guard let font else { return super.firstBaselineOffsetFromTop }

        let lineHeight = font.ascender - font.descender
        let height = bounds.height > 0 ? bounds.height : intrinsicContentSize.height
        return (height - lineHeight) / 2 + font.ascender
    }

    public func update(items: [String], value: String? = nil) {
        removeAllItems()
        addItems(withObjectValues: items)

        if let value {
            stringValue = value
        }
    }

    // MARK: - Combo box delegate

    public func comboBoxSelectionDidChange(_ notification: Notification) {
        // The selected value is applied to the field after this notification, so read it on the
        // next run loop pass to report the committed selection.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onChange?(self.stringValue)
        }
    }

    public func controlTextDidChange(_ object: Notification) {
        onChange?(stringValue)
    }
}
