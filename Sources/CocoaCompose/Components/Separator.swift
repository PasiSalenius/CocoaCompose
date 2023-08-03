import Cocoa

public class Separator: NSBox {
    public init() {
        super.init(frame: .zero)
        
        boxType = .separator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
