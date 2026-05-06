//
//  FilePickerView.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
//


import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    @State private var isShowingPicker = false
    @State private var selectedFileURL: URL?

    var body: some View {
        Button("Select File") {
            isShowingPicker = true
        }
        .fileImporter(
            isPresented: $isShowingPicker,
            allowedContentTypes: [.pdf, .png, .plainText, .commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                self.selectedFileURL = urls.first
            case .failure(let error):
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
    }
    
    func getFileURL() -> URL? {
        return selectedFileURL
    }
}
