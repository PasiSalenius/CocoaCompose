import Cocoa

extension NSView {
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
        case let component as DatePicker:
            component.isEnabled = enabled
        case let component as FontPicker:
            component.isEnabled = enabled
        case let component as Level:
            component.isEnabled = enabled
        case let component as PopUp:
            component.isEnabled = enabled
        case let component as Radio:
            component.isEnabled = enabled
        case let component as Slider:
            component.isEnabled = enabled
        case let component as Switch:
            component.isEnabled = enabled
        case let component as TextField:
            component.isEnabled = enabled
        case let component as TimePicker:
            component.isEnabled = enabled
        default:
            subviews.forEach { $0.setSubviewControlsEnabled(enabled) }
        }
    }
}
