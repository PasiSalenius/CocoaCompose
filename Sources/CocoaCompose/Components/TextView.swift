import Cocoa

public class TextView: NSView, NSTextViewDelegate {
    private let scrollView: NSScrollView
    private let textView: NSTextView

    public var onChange: ((String) -> Void)?
    
    public init(text: String = "", isFieldEditor: Bool = false, onChange: ((String) -> Void)? = nil) {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .bezelBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView = scrollView
        
        let contentSize = scrollView.contentSize

        let textLayoutManager = NSTextLayoutManager()
        let textContentStorage = NSTextContentStorage()
        textContentStorage.addTextLayoutManager(textLayoutManager)

        let textContainer = NSTextContainer(size: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        textLayoutManager.textContainer = textContainer

        let textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask = .width
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.drawsBackground = true
        textView.font = font
        textView.isRichText = false
        textView.isEditable = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.textColor = NSColor.labelColor
        
        // https://github.com/mathiasbynens/dotfiles/issues/465
        textView.layoutManager?.showsControlCharacters = false
        
        textView.layoutManager?.showsInvisibleCharacters = false
        textView.layoutManager?.allowsNonContiguousLayout = true
        
        textView.textContainerInset = NSSize(width: 4, height: 5)
        
        textView.isAutomaticDataDetectionEnabled = false
        textView.isAutomaticLinkDetectionEnabled = false
        textView.isAutomaticTextCompletionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        
        textView.allowsUndo = true
        textView.usesFindPanel = true
        textView.isIncrementalSearchingEnabled = true
        
        textView.isFieldEditor = isFieldEditor
        
        self.textView = textView
        
        scrollView.documentView = textView
        
        super.init(frame: .zero)
        
        textView.string = text

        textView.delegate = self

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var text: String {
        get { textView.string }
        set { textView.string = newValue }
    }
    
    public var isEditable = false {
        didSet { textView.isEditable = isEditable }
    }

    public var font: NSFont? = .monospacedSystemFont(ofSize: 11, weight: .regular) {
        didSet { textView.font = font }
    }

    public var borderType: NSBorderType = .bezelBorder {
        didSet { scrollView.borderType = borderType }
    }

    public var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }
            
            textView.selectedRanges = selectedRanges
        }
    }
    
    // MARK: - Text view delegate
    
    public func textDidChange(_ notification: Notification) {
        onChange?(textView.string)
    }
}
