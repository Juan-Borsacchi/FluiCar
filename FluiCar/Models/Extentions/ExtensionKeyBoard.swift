//
//  ExtensionKeyBoard.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 15/10/26.
//
import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// um componente invisível do UIKit que interceta toques na tela toda
struct GlobalTapToDismiss: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // espera a view aparecer na tela para pegar a "Window" (Janela) principal do app
        DispatchQueue.main.async {
            if let window = view.window {
                let tapRecognizer = UITapGestureRecognizer(
                    target: context.coordinator,
                    action: #selector(Coordinator.handleTap)
                )
                // isso avisa o iOS para NÃO bloquear os Pickers, Botões e TextFields
                tapRecognizer.cancelsTouchesInView = false
                tapRecognizer.delegate = context.coordinator
                window.addGestureRecognizer(tapRecognizer)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @objc func handleTap() {
            // envia o comando para esconder o teclado
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        // impede a briga de toques
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            // Se o usuário clicou num campo de texto (TextField), NÃO abaixa o teclado,
            // deixa ele continuar digitando no novo campo.
            let isTextField = touch.view is UITextField || touch.view is UITextView
            return !isTextField
        }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.background(GlobalTapToDismiss())
    }
}
