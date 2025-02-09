//
//  FullWidthStackView.swift
//  CocoaCompose
//
//  Created by Pasi Salenius on 3.2.2025.
//

import Cocoa

public class FullWidthStackView: NSStackView {
    private var sideConstraints: [NSLayoutConstraint] = []
    
    public init(views: [NSView]) {
        super.init(frame: .zero)
        
        addArrangedSubviews(views)

        if orientation == .vertical {
            views.forEach { constrainToWidth(view: $0) }
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var orientation: NSUserInterfaceLayoutOrientation {
        didSet {
            guard orientation != oldValue else { return }
            
            switch orientation {
            case .horizontal:
                NSLayoutConstraint.deactivate(sideConstraints)
            case .vertical:
                views.forEach { constrainToWidth(view: $0) }
            @unknown default:
                break
            }
        }
    }
    
    public override func addArrangedSubview(_ view: NSView) {
        super.addArrangedSubview(view)
        
        if orientation == .vertical {
            constrainToWidth(view: view)
        }
    }
    
    public override func insertArrangedSubview(_ view: NSView, at index: Int) {
        super.insertArrangedSubview(view, at: index)
        
        if orientation == .vertical {
            constrainToWidth(view: view)
        }
    }
    
    private func constrainToWidth(view: NSView) {
        let constraints = [
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        sideConstraints.append(contentsOf: constraints)
    }
}
