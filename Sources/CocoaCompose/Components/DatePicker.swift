import Cocoa

public class DatePicker: NSDatePicker {
    public var onChange: ((Date) -> Void)?
    
    public init(date: Date = .now, showStepper: Bool = true, showDays: Bool = true, minDate: Date? = nil, maxDate: Date? = nil, onChange: ((Date) -> Void)? = nil) {
        self.onChange = onChange

        super.init(frame: .zero)

        self.datePickerStyle = showStepper ? .textFieldAndStepper : .textField
        self.datePickerMode = .single
        self.datePickerElements = showDays ? .yearMonthDay : .yearMonth

        self.dateValue = date
        
        self.minDate = minDate
        self.maxDate = maxDate

        self.target = self
        self.action = #selector(buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var showStepper: Bool {
        get { datePickerStyle == .textFieldAndStepper }
        set {
            datePickerStyle = newValue ? .textFieldAndStepper : .textField
        }
    }

    public var showDays: Bool {
        get { datePickerElements == .yearMonthDay }
        set {
            datePickerElements = newValue ? .yearMonthDay : .yearMonth
        }
    }
    
    // MARK: - Actions

    @objc func buttonAction(_ datePicker: NSDatePicker) {
        onChange?(datePicker.dateValue)
    }
}
