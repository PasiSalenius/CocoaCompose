import Cocoa

public class Tabs: NSView {
    private let segmentedControl: NSSegmentedControl
    private let contentView = NSView()
    
    private let items: [Item]
    
    public var onChange: ((Int) -> Void)?
    
    public struct Item {
        public var title: String
        public var footer: String?
        public var orientation: NSUserInterfaceLayoutOrientation
        public var views: [NSView]
        
        public init(title: String, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView] = []) {
            self.title = title
            self.footer = footer
            self.orientation = orientation
            self.views = views
        }
    }

    public init(selectedIndex: Int = -1, items: [Item], onChange: ((Int) -> Void)? = nil) {
        self.items = items
        self.onChange = onChange
        
        let segmentedControl = NSSegmentedControl(labels: items.map { $0.title }, trackingMode: .selectOne, target: nil, action: nil)
        segmentedControl.segmentDistribution = .fillEqually

        segmentedControl.wantsLayer = true

        segmentedControl.layer?.cornerRadius = 8
        segmentedControl.layer?.masksToBounds = true

        self.segmentedControl = segmentedControl

        super.init(frame: .zero)
        
        contentView.wantsLayer = true
        
        contentView.layer?.borderWidth = 1
        contentView.layer?.cornerRadius = 5

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        segmentedControl.target = self
        segmentedControl.action = #selector(segmentedControlAction)
        
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            contentView.topAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            topAnchor.constraint(equalTo: segmentedControl.topAnchor),
            centerXAnchor.constraint(equalTo: segmentedControl.centerXAnchor),
        ])

        let width = contentView.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true

        self.selectedIndex = selectedIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout() {
        super.layout()
        
        segmentedControl.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        
        contentView.layer?.borderColor = NSColor.lightGray.withAlphaComponent(0.15).cgColor
        contentView.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.05).cgColor
    }
    
    public var selectedIndex: Int {
        get { segmentedControl.indexOfSelectedItem }
        set {
            segmentedControl.selectedSegment = newValue
            showItem(at: newValue)
        }
    }
    
    private func showItem(at index: Int) {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        guard index > -1, items.count > index else { return }

        let item = items[index]
        
        let stackView = NSStackView(views: item.views)
        stackView.distribution = .fill
        stackView.orientation = item.orientation
        stackView.alignment = item.orientation == .vertical ? .width : .height
        stackView.spacing = item.orientation == .vertical ? 7 : 10
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: - Actions
    
    @objc func segmentedControlAction(_ sender: NSSegmentedControl) {
        let index = sender.indexOfSelectedItem
        guard index > -1 else { return }
        
        showItem(at: index)
        onChange?(index)
    }
    
}
