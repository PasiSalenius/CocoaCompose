import Cocoa

public class Checkbox: NSStackView {
    private let button = NSButton()
    private let associatedViews: [NSView]
    
    public var onChange: ((Bool) -> Void)?
    
    public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, on: Bool = false, views: [NSView] = [], onChange: ((Bool) -> Void)? = nil) {
        self.associatedViews = views
        self.onChange = onChange
        
        super.init(frame: .zero)
        self.orientation = .horizontal
        self.alignment = .firstBaseline
        self.spacing = 5
        
        button.setButtonType(.switch)
        button.font = .preferredFont(forTextStyle: .body)
        button.target = self
        button.action = #selector(buttonAction)

        if let title = attributedTitle {
            button.attributedTitle = title
        } else {
            button.title = title ?? ""
        }

        addArrangedSubview(button)
        
        views.forEach { addArrangedSubview($0) }
        
        set(on: on)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(on: Bool) {
        button.state = on ? .on : .off
        associatedViews.forEach { $0.enableSubviews(on) }
    }
    
    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSButton) {
        associatedViews.forEach { $0.enableSubviews(sender.state == .on) }
        onChange?(sender.state == .on)
    }
}
