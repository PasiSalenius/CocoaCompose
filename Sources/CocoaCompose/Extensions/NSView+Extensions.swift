import Cocoa

extension NSView {
    /// A flexible trailing spacer for use in a `.fill` horizontal stack. It absorbs surplus width, so
    /// the real controls keep their natural size on the leading edge instead of being stretched
    /// arbitrarily. See `FlexibleSpacer`.
    public static func flexibleSpacer() -> FlexibleSpacer {
        FlexibleSpacer()
    }

    func setSubviewControlsEnabled(_ enabled: Bool) {
        switch self {
        case let component as Button:
            component.isEnabled = enabled
        case let component as CalendarPicker:
            component.isEnabled = enabled
        case let component as Checkbox:
            component.isEnabled = enabled
        case let component as ClockPicker:
            component.isEnabled = enabled
        case let component as ColorWell:
            component.isEnabled = enabled
        case let component as ComboBox:
            component.isEnabled = enabled
        case let component as DatePicker:
            component.isEnabled = enabled
        case let component as DisclosureGroup:
            component.isEnabled = enabled
        case let component as FontPicker:
            component.isEnabled = enabled
        case let component as Level:
            component.isEnabled = enabled
        case let component as PathControl:
            component.isEnabled = enabled
        case let component as PopUp:
            component.isEnabled = enabled
        case let component as Radio:
            component.isEnabled = enabled
        case let component as SearchField:
            component.isEnabled = enabled
        case let component as SegmentedControl:
            component.isEnabled = enabled
        case let component as Slider:
            component.isEnabled = enabled
        case let component as Stepper:
            component.isEnabled = enabled
        case let component as Switch:
            component.isEnabled = enabled
        case let component as TextField:
            component.isEnabled = enabled
        case let component as TimePicker:
            component.isEnabled = enabled
        case let component as TokenField:
            component.isEnabled = enabled
        default:
            subviews.forEach { $0.setSubviewControlsEnabled(enabled) }
        }
    }
}
