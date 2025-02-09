import Cocoa

extension NSStackView {
    func addArrangedSubviews(_ views: [NSView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
