//
//  ViewController.swift
//  Example
//
//  Created by Pasi Salenius on 23.12.2023.
//

import Cocoa
import CocoaCompose

class ViewController: NSViewController {
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        
        title = "Test"
        
        let list1 = PreferenceList(style: .center, views: [
            PreferenceSection(title: "Enable:", views: [
                Switch(isOn: true) { isOn in
                    
                }
            ]),
            PreferenceSection(title: "Choose One:", views: [
                Radio(items: [
                    .init(title: "One"),
                    .init(title: "Two", views: [
                        PopUp(items: ["12", "13"].map { .init(title: $0) }, selectedIndex: 0, trailingText: "points") { index, title in
                            
                        }
                    ]),
                    .init(title: "Three", views: [
                        TextField(value: "15.0", trailingText: "milliseconds", width: 50, onEndEditing: { text in
                            
                        })
                    ])], selectedIndex: 0) { index, previousIndex in
                        
                    },
            ]),
            Separator(),
            PreferenceGroup(items: [
                .init(title: "First:", views: [
                    PopUp(items: ["One", "Two"].map { .init(title: $0) }, selectedIndex: 0) { index, title in
                        
                    }
                ]),
                .init(title: "Second:", views: [
                    PopUp(items: ["Foobar", "Plop"].map { .init(title: $0) }, selectedIndex: 0) { index, title in
                        
                    }
                ]),
            ]),
            Separator(),
            PreferenceSection(title: "Test:", footer: "This here demonstrates some footer text that is shown below a section of items.", views: [
                Checkbox(title: "Click me", isOn: true) { enabled in
                    
                },
                Checkbox(title: "Me too", isOn: true) { enabled in
                    
                },
            ]),
        ])
        
        let list2 = PreferenceList(style: .center, views: [
            PreferenceSection(title: "Start Date:", orientation: .horizontal, alignment: .centerY, spacing: 20, views: [
                CalendarPicker() { date in
                    
                },
                ClockPicker() { date in
                    
                },
            ]),
        ])

        let list3 = PreferenceList(style: .center, views: [
            PreferenceSection(title: "Maximum Level:", views: [
                Box(views: [
                    Level(value: 0.3) { value in
                        
                    },
                    Slider() { value in
                        print("value changed to \(value)")
                    },
                ])
            ]),
            Separator(),
            PreferenceSection(title: "Body Text:", views: [
                FontPicker() { font in
                    
                },
                ColorWell(color: .blue, style: .default) { color in
                    
                },
            ]),
        ])

        let list = PreferenceList(style: .fullWidth, views: [
            Tabs(selectedIndex: 0, items: [
                .init(title: "General", views: [
                    list1,
                ]),
                .init(title: "Calendar", views: [
                    list2,
                ]),
                .init(title: "Other", views: [
                    list3,
                ])
            ]) { index in
                
            },
        ])
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            list.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            list.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            list.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            list.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
        
        preferredContentSize = CGSize(width: 500, height: view.fittingSize.height)
    }
    
}

