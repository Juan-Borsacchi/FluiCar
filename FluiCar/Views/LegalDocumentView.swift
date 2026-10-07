//
//  LegalDocumentView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 06/10/26.
//


import SwiftUI

struct LegalDocumentView: View {
    @State var viewModel: LegalDocumentViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ScrollView {
            Text(viewModel.markdownText)
                .lineSpacing(6)
                .tint(.blue)
                .padding(sizeClass == .regular ? 40 : 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.documentType.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Termos de Uso") {
    NavigationStack {
        LegalDocumentView(
            viewModel: LegalDocumentViewModel(documentType: .termsOfUse)
        )
    }
}

#Preview("Política de Privacidade") {
    NavigationStack {
        LegalDocumentView(
            viewModel: LegalDocumentViewModel(documentType: .privacyPolicy)
        )
    }
}
