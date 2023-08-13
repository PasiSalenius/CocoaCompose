import Cocoa

public class ColorWell: NSColorWell {
    public var onChange: ((NSColor) -> Void)?
    
    public enum Style {
        case `default`
        @available(macOS 13.0, *) case minimal
        @available(macOS 13.0, *) case expanded

        @available(macOS 13.0, *)
        var colorWellStyle: NSColorWell.Style {
            switch self {
            case .default:  return .default
            case .minimal:  return .minimal
            case .expanded: return .expanded
            }
        }
    }
    
    public init(color: NSColor? = nil, style: Style = .default, onChange: ((NSColor) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)
        
        if #available(macOS 13.0, *) {
            self.colorWellStyle = style.colorWellStyle
        }

        if let color {
            self.color = color
        }
        
        self.target = self
        self.action = #selector(colorChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func colorChanged(_ colorWell: NSColorWell) {
        onChange?(colorWell.color)
    }
}
