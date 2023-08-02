import Cocoa

public class Box: NSView {
    private let contentView = NSView()
    private let titleLabel = Label()

    public init(title: String = "", orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView]) {
        super.init(frame: .zero)
        
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabelColor
        titleLabel.stringValue = title
        
        let spacer = NSView()
        spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
        
        let titleStack = NSStackView(views: [spacer, titleLabel])
        titleStack.orientation = .horizontal
        titleStack.spacing = 0
        
        contentView.wantsLayer = true
        
        contentView.layer?.borderWidth = 1
        contentView.layer?.borderColor = NSColor.separatorColor.cgColor
        contentView.layer?.backgroundColor = NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.1).cgColor
        contentView.layer?.cornerRadius = 5

        let stackView = NSStackView(views: [titleStack, contentView])
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5

        stackView.addArrangedSubview(titleStack)
        stackView.addArrangedSubview(contentView)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let itemStack = NSStackView(views: views)
        itemStack.distribution = .fill
        itemStack.orientation = orientation
        itemStack.alignment = orientation == .vertical ? .leading : .top
        itemStack.spacing = orientation == .vertical ? 7 : 10
        
        contentView.addSubview(itemStack)
        itemStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            itemStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            itemStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            itemStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout() {
        super.layout()
        
        contentView.layer?.borderColor = NSColor.separatorColor.cgColor
        contentView.layer?.backgroundColor = NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.1).cgColor
    }
}
