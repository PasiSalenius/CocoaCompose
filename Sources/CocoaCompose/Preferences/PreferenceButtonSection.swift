import Cocoa

public class PreferenceButtonSection: NSStackView {
    private let buttonMinWidth: CGFloat = 70
    
    public init(buttons: [Button]) {
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .vertical
        self.alignment = .width
        self.spacing = 0
        
        self.wantsLayer = true
        self.layer?.masksToBounds = false

        let stackView = NSStackView(views: [NSView()] + buttons)
        stackView.orientation = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.spacing = 12
        
        let width = stackView.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true
        
        let spacer = NSView()
        spacer.addConstraint(spacer.heightAnchor.constraint(equalToConstant: 10))
        
        addArrangedSubview(spacer)
        addArrangedSubview(stackView)
        
        if let first = buttons.first {
            first.addConstraint(first.widthAnchor.constraint(greaterThanOrEqualToConstant: buttonMinWidth))
            
            for button in buttons where button != first {
                addConstraint(button.widthAnchor.constraint(equalTo: first.widthAnchor))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
