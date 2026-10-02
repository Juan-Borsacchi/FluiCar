//
//  SearchablePicker.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 01/10/26.
//
import SwiftUI

struct SearchablePicker: View {
    let title: String
    @Binding var selection: String
    let items: [(code: String, name: String)]
    
    var fallbackName: String? = nil
    
    var selectedName: String {
        if let found = items.first(where: { $0.code == selection }) {
            return found.name
        } else if let fallback = fallbackName, !fallback.isEmpty {
            return fallback
        } else {
            return "Selecionar"
        }
    }
    
    var body: some View {
        NavigationLink {
            SearchablePickerList(title: title, selection: $selection, items: items, fallbackName: fallbackName)
        } label: {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Text(selectedName)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
