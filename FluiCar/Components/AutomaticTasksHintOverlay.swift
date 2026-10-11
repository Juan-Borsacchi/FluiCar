//
//  AutomaticTasksHintOverlay.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 09/10/26.
//

//
//  AutomaticTasksHintOverlay.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 09/10/26.
//

import SwiftUI

extension View {
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(
            ZStack {
                Rectangle()
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}

struct AutomaticTasksHintOverlay: View {
    var automaticTaskFrame: CGRect
    var dismissAction: () -> Void
    
    // Deteta se a tela está num formato compacto vertical (iPhone deitado)
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // Retorna true se for iPad OU se o iPhone estiver na horizontal (Landscape/Duo)
    private var isPadOrLandscape: Bool {
        UIDevice.current.userInterfaceIdiom == .pad || verticalSizeClass == .compact
    }
    
    var body: some View {
        ZStack {
            // 1. FUNDO ESCURO E RECORTE APENAS DAS TAREFAS
            Color.black.opacity(0.85)
                .reverseMask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: automaticTaskFrame.width + 8, height: automaticTaskFrame.height + 8)
                        .position(x: automaticTaskFrame.midX, y: automaticTaskFrame.midY)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) { dismissAction() }
                }
            
            // 2. TEXTO DAS TAREFAS AUTOMÁTICAS (Em baixo)
            VStack(spacing: 12) {
                Image(systemName: "arrow.up")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("Estas tarefas são criadas\nde forma automática.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
            .position(x: automaticTaskFrame.midX, y: automaticTaskFrame.maxY + 60)
            
            // 3. TEXTO DO BOTÃO PLUS (No topo direito)
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "arrow.up.right")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.trailing, isPadOrLandscape ? 12 : 34)
                
                Text("Toque aqui para criar\noutras tarefas.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(isPadOrLandscape ? .trailing : .center)
            }
            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
            
            // Mantém a margem lateral que alinha com o botão
            .padding(.trailing, isPadOrLandscape ? 24 : 80)
            
            // AUMENTAR AQUI: mude o valor do iPad/Landscape para 180 ou 200.
            // O 95 do iPhone em pé continua seguro e intocável!
            .padding(.top, isPadOrLandscape ?  100 : 95)
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .ignoresSafeArea()
    }
}
