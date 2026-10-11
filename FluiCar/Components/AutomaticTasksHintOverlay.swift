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
            // Fica sempre exatamente 60 pontos abaixo do último cartão
            .position(x: automaticTaskFrame.midX, y: automaticTaskFrame.maxY + 60)
            
            // 3. TEXTO DO BOTÃO PLUS (No topo direito)
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "arrow.up.right")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.trailing, 34)
                
                Text("Toque aqui para criar\noutras tarefas.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
            .padding(.trailing, 80)
            .padding(.top, 95)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .ignoresSafeArea()
    }
}
#Preview("Tutorial Overlay") {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        Text("Conteúdo do App ao fundo")
            .font(.title)
            .foregroundColor(.white)
        
        AutomaticTasksHintOverlay(
            automaticTaskFrame: CGRect(x: 200, y: 300, width: 360, height: 400)
        ) {
            print("Tutorial finalizado!")
        }
    }
}
