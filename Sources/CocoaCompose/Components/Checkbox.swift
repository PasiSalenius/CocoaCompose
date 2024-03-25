import Cocoa

public class Checkbox: NSStackView {
    private let button = NSButton()
    private let associatedViews: [NSView]
    
    public var onChange: ((Bool) -> Void)?
    
    private let checkboxWidth: CGFloat = 21
    
    public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, isOn: Bool = false, orientation: NSUserInterfaceLayoutOrientation = .horizontal, views: [NSView] = [], onChange: ((Bool) -> Void)? = nil) {
        self.associatedViews = views
        self.onChange = onChange
        
        super.init(frame: .zero)
        self.orientation = orientation
        self.alignment = orientation == .vertical ? .leading : .firstBaseline
        self.spacing = orientation == .vertical ? 7 : 5
        
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
        
        if orientation == .horizontal {
            views.forEach { addArrangedSubview($0) }
            
        } else {
            views.forEach { view in
                let spacer = NSView()
                spacer.addConstraint(spacer.widthAnchor.constraint(equalToConstant: checkboxWidth))
                
                let stackView = NSStackView(views: [spacer, view])
                stackView.orientation = .horizontal
                stackView.spacing = 0
                
                addArrangedSubview(stackView)
            }
        }
        
        self.isOn = isOn
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var isOn: Bool {
        get {
            button.state == .on
        }
        set {
            button.state = newValue ? .on : .off
            associatedViews.forEach { $0.enableSubviews(newValue) }
        }
    }
    
    public var title: String {
        get { button.title }
        set { button.title = newValue }
    }

    public var attributedTitle: NSAttributedString {
        get { button.attributedTitle }
        set { button.attributedTitle = newValue }
    }
    
    public var font: NSFont? {
        get { button.font }
        set { button.font = newValue }
    }

    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSButton) {
        associatedViews.forEach { $0.enableSubviews(sender.state == .on) }
        onChange?(sender.state == .on)
    }
}
