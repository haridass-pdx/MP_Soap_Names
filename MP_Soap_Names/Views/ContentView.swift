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
    @State var menuSelection = "MP"
    @State  var nameTypeSelection = "Last"
    @State private var sortOrder = [KeyPathComparator(\Name.lastname)]

    var filteredNames: [Name] {
        names.filter { name in
            (searchText.isEmpty || {
                switch nameTypeSelection {
                case "Last":
                    return name.lastname.localizedCaseInsensitiveContains(searchText)
                case "First":
                    return name.firstname.localizedCaseInsensitiveContains(searchText)
                default:
                    return name.lastname.localizedCaseInsensitiveContains(searchText) || name.firstname.localizedCaseInsensitiveContains(searchText)
                }
            }())
            &&
            (menuSelection == "ALL" || name.dbSource == menuSelection)
        }
        .sorted(using: sortOrder)
    }
    
    var body: some View {
        
        //  NavigationSplitView {
        VStack{
            Text("Names \(filteredNames.count)")
            MenuView(menuSelection: $menuSelection,
                     possible:  ["MP", "SOAP", "ALL"],
                     queryString: "Data Source")
            HStack{
                Text("Name: ")
                TextField("Name:", text: $searchText)
                MenuView(menuSelection: $nameTypeSelection,
                         possible:  ["Last", "First", "Both"],
                         queryString: "Search Criteria")


            }
            .frame(width: 400)
            .onChange(of: menuSelection) { oldValue, newValue in
                
            }
            
            
            Table(filteredNames, selection: $selectedItem, sortOrder: $sortOrder) {
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
                Button(action: deleteSelectedItem) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedItem == nil)
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .task {
            if names.isEmpty {
                importBundledCSV(modelContext: modelContext)
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

private func deleteSelectedItem() {
    guard let selectedItem,
          let name = names.first(where: { $0.id == selectedItem }) else { return }
    withAnimation {
        modelContext.delete(name)
        self.selectedItem = nil
    }
}
}

#Preview {
    ContentView()
        .modelContainer(for: Name.self, inMemory: true)
}
