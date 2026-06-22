import Cocoa

public class SegmentedControl: NSSegmentedControl {
    public var onChange: ((Int) -> Void)?

    public struct Item {
        var title: String?
        var image: NSImage?

        public init(title: String? = nil, image: NSImage? = nil) {
            self.title = title
            self.image = image
        }
    }

    public init(items: [Item] = [], selectedIndex: Int = 0, trackingMode: NSSegmentedControl.SwitchTracking = .selectOne, style: NSSegmentedControl.Style = .automatic, controlSize: NSControl.ControlSize = .regular, onChange: ((Int) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.segmentStyle = style
        self.trackingMode = trackingMode
        self.controlSize = controlSize
        self.segmentCount = items.count

        for (index, item) in items.enumerated() {
            setLabel(item.title ?? "", forSegment: index)
            setImage(item.image, forSegment: index)
        }

        if selectedIndex >= 0, selectedIndex < items.count {
            setSelected(true, forSegment: selectedIndex)
        }

        self.target = self
        self.action = #selector(buttonAction)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var selectedIndex: Int {
        get { selectedSegment }
        set { setSelected(true, forSegment: newValue) }
    }

    // MARK: - Actions

    @objc func buttonAction(_ sender: NSSegmentedControl) {
        onChange?(sender.selectedSegment)
    }
}
