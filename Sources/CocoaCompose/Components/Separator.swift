import Cocoa

public class Separator: NSView {
    public init(orientation: NSUserInterfaceLayoutOrientation = .horizontal, color: NSColor = .gray.withAlphaComponent(0.3)) {
        super.init(frame: .zero)
        
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
        
        switch orientation {
        case .vertical:
            widthAnchor.constraint(equalToConstant: 1).isActive = true
        default:
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
