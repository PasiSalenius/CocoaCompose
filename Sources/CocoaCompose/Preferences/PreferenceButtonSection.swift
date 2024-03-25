import Cocoa

public class PreferenceButtonSection: NSStackView {
    public init(buttons: [Button]) {
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .vertical
        self.alignment = .right
        self.spacing = 0
        
        self.wantsLayer = true
        self.layer?.masksToBounds = false

        let stackView = NSStackView(views: buttons)
        stackView.orientation = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.spacing = 10
        
        let width = stackView.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true
        
        let spacer = NSView()
        spacer.addConstraint(spacer.heightAnchor.constraint(equalToConstant: 10))

        addArrangedSubview(spacer)
        addArrangedSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
