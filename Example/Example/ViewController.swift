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

        title = "Scribe Settings"

        // MARK: General

        let general = PreferenceList(style: .center, views: [
            PreferenceSection(title: "At launch:", views: [
                Checkbox(title: "Open Scribe automatically at login", isOn: true) { _ in
                },
                Checkbox(title: "Show Scribe in the menu bar", isOn: false) { _ in
                },
            ]),
            Separator(),
            PreferenceSection(title: "When opening Scribe show:", views: [
                Radio(items: [
                    .init(title: "The note I edited last", footer: "Reopens the note you were editing when you last quit Scribe."),
                    .init(title: "A new blank note"),
                    .init(title: "A specific note:", footer: "Always opens the same note, regardless of recent activity.", views: [
                        PopUp(items: ["Daily Journal", "Inbox", "Reading List"].map { .init(title: $0) }, selectedIndex: 0) { index, title in
                        }
                    ]),
                ], selectedIndex: 0) { index, previousIndex in
                },
            ]),
            Separator(),
            PreferenceSection(title: "Software updates:", views: [
                Checkbox(title: "Automatically check for updates", footer: "Scribe checks for new versions in the background and notifies you when an update is ready to install.", isOn: true) { _ in
                },
            ]),
            verticalSpacer(),
        ])

        // MARK: Editor

        let signature = TextView(text: "Written with Scribe.") { text in
        }
        NSLayoutConstraint.activate([
            signature.widthAnchor.constraint(equalToConstant: 320),
            signature.heightAnchor.constraint(equalToConstant: 70),
        ])

        let lineSpacingValue = Label(string: "2 pt")
        let lineSpacing = Slider(value: 2, minValue: 0, maxValue: 8, numberOfTickMarks: 9) { value in
            lineSpacingValue.stringValue = "\(Int(value)) pt"
        }
        lineSpacing.widthAnchor.constraint(equalToConstant: 200).isActive = true

        let editor = PreferenceList(style: .center, views: [
            PreferenceGroup(footer: "These settings apply to the editing area of every note.", items: [
                .init(title: "Font:", views: [
                    FontPicker(font: .systemFont(ofSize: 13)) { font in
                    }
                ]),
                .init(title: "Font size:", views: [
                    PopUp(items: ["11", "12", "13", "14", "16"].map { .init(title: $0) }, selectedIndex: 2, trailingText: "pt") { index, title in
                    }
                ]),
                .init(title: "Theme:", views: [
                    PopUp(items: ["System", "Solarized Light", "Dracula"].map { .init(title: $0) }, selectedIndex: 0) { index, title in
                    }
                ]),
            ]),
            Separator(),
            PreferenceSection(title: "Line spacing:", orientation: .horizontal, alignment: .centerY, spacing: 10, views: [
                lineSpacing,
                lineSpacingValue,
            ]),
            Separator(),
            PreferenceSection(title: "While typing:", views: [
                Checkbox(title: "Check spelling", isOn: true) { _ in
                },
                Checkbox(title: "Correct spelling automatically", isOn: true) { _ in
                },
                Checkbox(title: "Use smart quotes and dashes", isOn: false) { _ in
                },
            ]),
            Separator(),
            PreferenceSection(title: "Signature:", footer: "Appended to the end of documents you export or share.", views: [
                signature,
            ]),
            verticalSpacer(),
        ])

        // MARK: Appearance

        let appearance = PreferenceList(style: .center, views: [
            PreferenceGroup(items: [
                .init(title: "Theme:", views: [
                    PopUp(items: ["Light", "Dark", "Match System"].map { .init(title: $0) }, selectedIndex: 2) { index, title in
                    }
                ]),
                .init(title: "Accent color:", views: [
                    ColorWell(color: .systemIndigo, style: .default) { color in
                    }
                ]),
            ]),
            Separator(),
            PreferenceSection(title: "App icon:", footer: "Pick the icon Scribe uses in the Dock and Launchpad.", views: [
                Image(systemSymbolName: "book.closed.fill", size: CGSize(width: 28, height: 28)) {
                },
            ]),
            verticalSpacer(),
        ])

        // MARK: Reminders

        let reminders = PreferenceList(style: .center, views: [
            PreferenceSection(title: "Daily writing reminder:", footer: "Scribe nudges you to write at this time every day.", views: [
                Switch(isOn: true) { isOn in
                },
            ]),
            PreferenceGroup(items: [
                .init(title: "Remind me at:", views: [
                    TimePicker(date: .now, showSeconds: false) { date in
                    }
                ]),
                .init(title: "Starting:", views: [
                    DatePicker(date: .now) { date in
                    }
                ]),
            ]),
            Separator(),
            PreferenceSection(title: "Schedule a review:", footer: "Choose a day and time to be reminded to review your older notes.", orientation: .horizontal, alignment: .centerY, spacing: 20, views: [
                CalendarPicker() { date in
                },
                ClockPicker(showSeconds: false) { date in
                },
            ]),
            verticalSpacer(),
        ])

        // MARK: Account

        let avatar = Image(systemSymbolName: "person.crop.circle.fill", size: CGSize(width: 44, height: 44)) {
        }

        let storage = Level(value: 0.62) { value in
        }
        storage.widthAnchor.constraint(equalToConstant: 220).isActive = true

        let devices = Box(title: "Synced devices:", views: [
            "MacBook Pro — this device",
            "iPhone 15 Pro",
            "iPad Air",
            "Mac Studio",
            "iPhone SE",
        ].map { Label(string: $0) })
        devices.widthAnchor.constraint(equalToConstant: 240).isActive = true

        let account = PreferenceList(style: .center, views: [
            PreferenceSection(orientation: .horizontal, alignment: .centerY, spacing: 12, views: [
                avatar,
                Label(string: "Jane Appleseed — jane@example.com"),
            ]),
            PreferenceGroup(items: [
                .init(title: "Display name:", views: [
                    TextField(value: "Jane Appleseed", width: 200) { text in
                    }
                ]),
                .init(title: "Email:", views: [
                    TextField(value: "jane@example.com", width: 200) { text in
                    }
                ]),
            ]),
            Separator(),
            PreferenceSection(title: "iCloud storage:", footer: "6.2 GB of 10 GB used.", views: [
                storage,
            ]),
            Separator(),
            PreferenceBlock(footer: "These devices are currently signed in to your account.", views: [
                devices,
            ]),
            PreferenceButtonSection(buttons: [
                Button(title: "Sign Out…") {
                },
            ], onHelp: {
            }),
            verticalSpacer(),
        ])

        // MARK: Tabs

        let list = PreferenceList(style: .fullWidth, views: [
            Tabs(selectedIndex: 0, items: [
                .init(title: "General", views: [ general ]),
                .init(title: "Editor", views: [ editor ]),
                .init(title: "Appearance", views: [ appearance ]),
                .init(title: "Reminders", views: [ reminders ]),
                .init(title: "Account", views: [ account ]),
            ]) { index in
            },
        ])

        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            list.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            list.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            list.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            list.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        preferredContentSize = CGSize(width: 500, height: view.fittingSize.height)
    }

    // An empty view with the lowest vertical hugging priority. As the last item in a vertical
    // PreferenceList it soaks up surplus height when the window grows, keeping the content
    // top-aligned instead of stretching the controls.
    private func verticalSpacer() -> NSView {
        let view = NSView()
        view.setContentHuggingPriority(.init(rawValue: 1), for: .vertical)
        return view
    }

}
