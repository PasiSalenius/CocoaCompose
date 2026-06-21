import Cocoa

public class PreferenceList: NSView {
    public enum Style {
        case center
        case fullWidth
    }
    
    public init(style: Style, alignment: NSLayoutConstraint.Attribute = .leading, views: [NSView]) {
        super.init(frame: .zero)
        
        // Under .fullWidth the inner stack stretches each child to the container width (via the
        // .width path in ConstrainingStackView), so groups/sections fill the available width. Under
        // .center it hugs its content and is centered, so .leading alignment is kept.
        let stackAlignment: NSLayoutConstraint.Attribute = style == .fullWidth ? .width : alignment
        let stackView = ConstrainingStackView(orientation: .vertical, alignment: stackAlignment, views: views)
        stackView.distribution = .fill
        stackView.spacing = 14
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .center:
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])

        case .fullWidth:
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
        
        alignLeadAnchors(views: views)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        guard window != nil else { return }
        configureKeyViewLoop()
    }

    // Wire Tab / Shift-Tab navigation between the focusable controls in the order they were laid out,
    // so forms are keyboard-navigable without each view setting up its own key view loop. Windows that
    // autorecalculate their own loop (e.g. the main window) ignore this; it makes Tab work in the ones
    // that don't.
    private func configureKeyViewLoop() {
        let views = keyableViews(in: self)
        guard views.count > 1 else { return }

        for (index, view) in views.enumerated() {
            view.nextKeyView = views[(index + 1) % views.count]
        }
    }

    private func keyableViews(in view: NSView) -> [NSView] {
        let children = (view as? NSStackView)?.arrangedSubviews ?? view.subviews

        var result: [NSView] = []
        for child in children {
            if child.canBecomeKeyView {
                result.append(child)
            } else {
                result.append(contentsOf: keyableViews(in: child))
            }
        }
        return result
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
            return preferenceSection.leadingWidthAnchor
        } else if let preferenceGroup = view as? PreferenceGroup {
            return preferenceGroup.leadingWidthAnchor
        }
        
        return nil
    }
}
