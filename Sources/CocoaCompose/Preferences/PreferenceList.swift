import Cocoa

public class PreferenceList: NSStackView {
    public init(views: [NSView], distribution: NSStackView.Distribution = .fill) {
        super.init(frame: .zero)
        
        self.distribution = distribution
        orientation = .vertical
        alignment = .leading
        spacing = 14
        
        views.forEach { addArrangedSubview($0) }
        
        alignLeadAnchors(views: views)
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
