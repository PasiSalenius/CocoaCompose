import Cocoa

public class Tabs: NSStackView {
    private let segmentedControl: NSSegmentedControl
    private let contentView = NSView()
    
    private let items: [Item]

    public var onChange: ((Int) -> Void)?
    
    public struct Item {
        public var title: String
        public var footer: String?
        public var views: [NSView]
        public var orientation: NSUserInterfaceLayoutOrientation
        
        public init(title: String, footer: String? = nil, views: [NSView] = [], orientation: NSUserInterfaceLayoutOrientation = .vertical) {
            self.title = title
            self.footer = footer
            self.views = views
            self.orientation = orientation
        }
    }

    public init(items: [Item], onChange: ((Int) -> Void)? = nil) {
        self.items = items
        self.onChange = onChange
        
        let segmentedControl = NSSegmentedControl(labels: items.map { $0.title }, trackingMode: .selectOne, target: nil, action: nil)
        segmentedControl.segmentDistribution = .fillEqually
        
        self.segmentedControl = segmentedControl

        super.init(frame: .zero)
        
        segmentedControl.target = self
        segmentedControl.action = #selector(segmentedControlAction)
        
        addArrangedSubview(segmentedControl)
        addArrangedSubview(contentView)
        
        orientation = .vertical
        distribution = .fill
        alignment = .centerX
        spacing = 20
        
        let width = contentView.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true

        set(selectedIndex: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(selectedIndex index: Int) {
        segmentedControl.selectedSegment = index
        updateContent(index: index)
    }
    
    private func updateContent(index: Int) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let item = items[index]
        
        let stackView = NSStackView(views: item.views)
        stackView.distribution = .fill
        stackView.orientation = item.orientation
        stackView.alignment = item.orientation == .vertical ? .width : .height
        stackView.spacing = item.orientation == .vertical ? 7 : 10
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc func segmentedControlAction(_ sender: NSSegmentedControl) {
        let index = sender.indexOfSelectedItem
        guard index > -1 else { return }
        
        updateContent(index: index)
        onChange?(index)
    }
    
}
