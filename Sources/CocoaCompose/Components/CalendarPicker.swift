import Cocoa

public class CalendarPicker: NSDatePicker {
    public var onChange: ((Date) -> Void)?
    
    public init(date: Date = .now, minDate: Date? = nil, maxDate: Date? = nil, onChange: ((Date) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.datePickerStyle = .clockAndCalendar
        self.datePickerMode = .single
        self.datePickerElements = .yearMonthDay

        self.dateValue = date
        
        self.minDate = minDate
        self.maxDate = maxDate

        self.target = self
        self.action = #selector(buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    @objc func buttonAction(_ datePicker: NSDatePicker) {
        onChange?(datePicker.dateValue)
    }
}
