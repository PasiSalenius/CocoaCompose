import Cocoa

public class PathControl: NSPathControl {
    public var onChange: ((URL?) -> Void)?

    public init(url: URL? = nil, pathStyle: NSPathControl.Style = .standard, isEditable: Bool = false, onChange: ((URL?) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.url = url
        self.pathStyle = pathStyle
        self.isEditable = isEditable

        self.target = self
        self.action = #selector(buttonAction)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func buttonAction(_ sender: NSPathControl) {
        // A single click selects a path item; reflect that item's URL when present, otherwise the
        // control's own URL (e.g. after an editable drop).
        onChange?(sender.clickedPathItem?.url ?? sender.url)
    }
}
