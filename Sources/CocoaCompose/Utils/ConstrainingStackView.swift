//
//  ConstrainingStackView.swift
//  CocoaCompose
//
//  Created by Pasi Salenius on 3.2.2025.
//

import Cocoa

public class ConstrainingStackView: NSStackView {
    private var edgeConstraints: [NSLayoutConstraint] = []
    
    public init(orientation: NSUserInterfaceLayoutOrientation = .vertical, alignment: NSLayoutConstraint.Attribute = .leading, views: [NSView]) {
        super.init(frame: .zero)
        
        self.orientation = orientation
        self.alignment = alignment
        
        addArrangedSubviews(views)
        updateEdgeConstraints()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        updateEdgeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var orientation: NSUserInterfaceLayoutOrientation {
        didSet {
            guard orientation != oldValue else { return }
            
            updateEdgeConstraints()
        }
    }

    public override var alignment: NSLayoutConstraint.Attribute {
        didSet {
            guard alignment != oldValue else { return }
            
            updateEdgeConstraints()
        }
    }

    public override func addArrangedSubview(_ view: NSView) {
        super.addArrangedSubview(view)
        
        updateEdgeConstraints()
    }
    
    public override func insertArrangedSubview(_ view: NSView, at index: Int) {
        super.insertArrangedSubview(view, at: index)
        
        updateEdgeConstraints()
    }
    
    public override func removeArrangedSubview(_ view: NSView) {
        super.removeArrangedSubview(view)
        
        updateEdgeConstraints()
    }

    private func updateEdgeConstraints() {
        NSLayoutConstraint.deactivate(edgeConstraints)

        if orientation == .vertical && alignment == .width {
            constrainToVerticalOrientation()
        } else if orientation == .horizontal && alignment == .height {
            constrainToHorizontalOrientation()
        }
    }
    
    private func constrainToVerticalOrientation() {
        if let topView = arrangedSubviews.first {
            let constraint = topView.topAnchor.constraint(equalTo: topAnchor)
            NSLayoutConstraint.activate([constraint])
            edgeConstraints.append(constraint)
        }

        for view in arrangedSubviews {
            let constraints = [
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
            
            NSLayoutConstraint.activate(constraints)
            edgeConstraints.append(contentsOf: constraints)
        }
        
        if let bottomView = views.last {
            let constraint = bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
            NSLayoutConstraint.activate([constraint])
            edgeConstraints.append(constraint)
        }
    }

    private func constrainToHorizontalOrientation() {
        if let leadingView = arrangedSubviews.first {
            let constraint = leadingView.leadingAnchor.constraint(equalTo: leadingAnchor)
            NSLayoutConstraint.activate([constraint])
            edgeConstraints.append(constraint)
        }

        for view in arrangedSubviews {
            let constraints = [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
            
            NSLayoutConstraint.activate(constraints)
            edgeConstraints.append(contentsOf: constraints)
        }
        
        if let trailingView = arrangedSubviews.last {
            let constraint = trailingView.trailingAnchor.constraint(equalTo: trailingAnchor)
            NSLayoutConstraint.activate([constraint])
            edgeConstraints.append(constraint)
        }
    }
}
