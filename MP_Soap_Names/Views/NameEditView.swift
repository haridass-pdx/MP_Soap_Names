//
//  NameEditView.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
//

import SwiftUI

struct NameEditView: View {
    @Bindable var name: Name
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Last Name", text: $name.lastname)
                TextField("First Name", text: $name.firstname)
                OptionalDatePicker(label: "Start Date", date: $name.startDate)
                OptionalDatePicker(label: "End Date", date: $name.endDate)
                TextField("Num Visits", value: $name.count, format: .number)
                TextField("DB", text: $name.dbid)
            }
        }
        .frame(width: 300)
    }
}

struct OptionalDatePicker: View {
    var label: String
    @Binding var date: Date?
    
    var body: some View {
        HStack {
            Toggle(label, isOn: Binding(
                get: { date != nil },
                set: { enabled in date = enabled ? Date() : nil }
            ))
            if let d = date {
                DatePicker("", selection: Binding(
                    get: { d },
                    set: { date = $0 }
                ), displayedComponents: .date)
                .labelsHidden()
            }
        }
    }
}

#Preview {
    // NameEditView()
}
