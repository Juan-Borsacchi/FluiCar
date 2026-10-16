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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var isPadOrLandscape: Bool {
        UIDevice.current.userInterfaceIdiom == .pad || verticalSizeClass == .compact
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .reverseMask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: automaticTaskFrame.width + 8, height: automaticTaskFrame.height + 8)
                        .position(x: automaticTaskFrame.midX, y: automaticTaskFrame.midY)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) { dismissAction() }
                }
            
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
            
            .padding(.trailing, isPadOrLandscape ? 95 : 80)
            
            .padding(.top, isPadOrLandscape ?  70 : 95)
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .ignoresSafeArea()
    }
}
