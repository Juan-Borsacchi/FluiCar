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
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.documentType.title.uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Última atualização: \(viewModel.documentType.lastUpdated)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)
                
                Text(viewModel.markdownText)
                    .font(.body)
                    .lineSpacing(6)
                    .foregroundColor(.primary)
                    .tint(.blue)
            }
            .padding(sizeClass == .regular ? 40 : 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.background)
        .navigationTitle(viewModel.documentType.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
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
