import Cocoa

public class Separator: NSView {
    public enum Orientation {
        case horizontal
        case vertical
    }
    
    public init(orientation: Orientation = .horizontal, color: NSColor = .gray.withAlphaComponent(0.3)) {
        super.init(frame: .zero)
        
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
        
        switch orientation {
        case .horizontal:
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .vertical:
            widthAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
