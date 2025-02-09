import Cocoa

public class PreferenceList: NSView {
    public enum Style {
        case center
        case fullWidth
        
        var spacing: CGFloat {
            switch self {
            case .center:
                return 14
            case .fullWidth:
                return 20
            }
        }
    }
    
    public init(style: Style, views: [NSView]) {
        super.init(frame: .zero)
        
        let stackView = FullWidthStackView(views: views)
        stackView.distribution = .fill
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.spacing = style.spacing
        
        alignLeadAnchors(views: views)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .center:
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])

        case .fullWidth:
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func alignLeadAnchors(views: [NSView]) {
        let anchors = views.compactMap { leadAnchor(view: $0) }
        if let first = anchors.first {
            for anchor in anchors where anchor != first {
                anchor.constraint(equalTo: first).isActive = true
            }
        }
    }
    
    private func leadAnchor(view: NSView) -> NSLayoutDimension? {
        if let preferenceSection = view as? PreferenceSection {
            return preferenceSection.leadAnchor
        } else if let preferenceGroup = view as? PreferenceGroup {
            return preferenceGroup.leadAnchor
        }
        
        return nil
    }
}
