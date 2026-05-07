//
//  MenuView.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/6/26.
//

import SwiftUI

struct MenuView: View {
    @Binding var menuSelection: String
    var  possible: [String] = []
    var queryString: String = ""

    var body: some View {
  
        Picker(queryString, selection: $menuSelection) {
            ForEach(possible, id: \.self) { item in
                Text(item)
            }
        }
        .pickerStyle(.menu)
}
}

#Preview {
  //  MenuView()
}
