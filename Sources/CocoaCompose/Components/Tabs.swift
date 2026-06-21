import Cocoa

public class Tabs: NSView, NSTabViewDelegate {
    private let tabView = NSTabView()

    private let items: [Item]
    private var selectedTabIndex: Int = -1
    private var suppressCallback = false

    public var onChange: ((Int) -> Void)?

    public struct Item {
        public var title: String
        public var orientation: NSUserInterfaceLayoutOrientation
        public var views: [NSView]

        public init(title: String, orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView] = []) {
            self.title = title
            self.orientation = orientation
            self.views = views
        }
    }

    public init(selectedIndex: Int = -1, items: [Item], onChange: ((Int) -> Void)? = nil) {
        self.items = items
        self.onChange = onChange

        super.init(frame: .zero)

        // `.topTabsBezelBorder` draws the native tabs straddling the bezel's top border
        // (thin border + subtle fill) — the same look a storyboard-instantiated tab view
        // gets by default.
        tabView.tabViewType = .topTabsBezelBorder
        tabView.delegate = self

        for item in items {
            let tabViewItem = NSTabViewItem()
            tabViewItem.label = item.title
            tabViewItem.view = contentView(for: item)
            tabView.addTabViewItem(tabViewItem)
        }

        addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            tabView.topAnchor.constraint(equalTo: topAnchor),
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        self.selectedIndex = selectedIndex
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var selectedIndex: Int {
        get { selectedTabIndex }
        set {
            selectedTabIndex = newValue

            if newValue >= 0, newValue < items.count {
                tabView.isHidden = false

                suppressCallback = true
                tabView.selectTabViewItem(at: newValue)
                suppressCallback = false
            } else {
                tabView.isHidden = true
            }
        }
    }

    private func contentView(for item: Item) -> NSView {
        let container = NSView()

        let stackView = ConstrainingStackView(orientation: item.orientation, alignment: item.orientation == .vertical ? .width : .height, views: item.views)
        stackView.distribution = .fill
        stackView.spacing = item.orientation == .vertical ? 7 : 10

        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
        ])

        return container
    }

    // MARK: - NSTabViewDelegate

    public func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard !suppressCallback, let tabViewItem else { return }

        let index = tabView.indexOfTabViewItem(tabViewItem)
        guard index >= 0 else { return }

        selectedTabIndex = index
        onChange?(index)
    }
}
