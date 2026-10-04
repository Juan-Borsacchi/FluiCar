//
//  SearchablePickerList.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 01/10/26.
//
import SwiftUI

struct SearchablePickerList: View {
    let title: String
    @Binding var selection: String
    let items: [(code: String, name: String)]
    
    var fallbackName: String? = nil
    
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    var filteredItems: [(code: String, name: String)] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        List(filteredItems, id: \.code) { item in
            Button {
                selection = item.code
                dismiss()
            } label: {
                HStack {
                    Text(item.name)
                        .foregroundStyle(Color.primary)
                    Spacer()
                    
                    
                    let isSelected = !selection.isEmpty ? (selection == item.code) : (item.name == fallbackName)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Buscar \(title.lowercased())...")
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
