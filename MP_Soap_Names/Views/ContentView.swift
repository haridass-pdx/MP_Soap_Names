//
//  ContentView.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    // @Query private var items: [Item]
    @Query private var names: [Name]
    @State private var isShowingPicker: Bool = false
    @State private var selectedFileURL: URL?
    @State private var selectedItem: Name.ID?
    @State private var searchText = ""
    
    var filteredNames: [Name] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.lastname.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        
        //  NavigationSplitView {
        VStack{
            Text("Names \(names.count)")
            HStack{
                Text("Last Name: ")
                TextField("Last Name:", text: $searchText)
            }
            .frame(width: 250)
            
            
            Table(filteredNames, selection: $selectedItem) {
                TableColumn("Last", value: \.lastname)
                TableColumn("First", value: \.firstname)
                
                TableColumn("ID", value: \.dbid)
                TableColumn("DB", value: \.dbSource)
                
                TableColumn("Start") { name in
                    Text(name.startDate?.formatted(date: .numeric, time: .omitted) ?? "")
                }
                TableColumn("End") { name in
                    Text(name.endDate?.formatted(date: .numeric, time: .omitted) ?? "")
                }
                TableColumn("Count") { name in
                    Text("\(name.count)")
                }
                TableColumn("DOB") { name in
                    Text(name.dob?.formatted(date: .numeric, time: .omitted) ?? "")
                }
            }
            
            
        }
        .onChange(of: selectedItem) { id in
            if let id = id {
                print(names.first(where: { $0.id == id })!)
            }
        }
        
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                
            }
        }
    
 
    Button("Import", systemImage: "arrow.up.folder"){
        isShowingPicker = true
    }
    Spacer()
        .fileImporter(
            isPresented: $isShowingPicker,
            allowedContentTypes: [.pdf, .png, .plainText, .commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first
                {
                    importCSV(url: url, modelContext: modelContext)
                }
            case .failure(let error):
                self.selectedFileURL = nil
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
}

private func importData() {
    isShowingPicker = true
    
}


private func addItem() {
    withAnimation {
        let newItem = Name(dbid: "ID", lastname: "LN", firstname: "FN", gender: "female", dob:  nil, startDate: nil, endDate: nil, count: 0, dbSource: "DB")
        modelContext.insert(newItem)
    }
}

private func deleteItems(offsets: IndexSet) {
    withAnimation {
        for index in offsets {
            modelContext.delete(names[index])
        }
    }
}
}

#Preview {
    ContentView()
        .modelContainer(for: Name.self, inMemory: true)
}
