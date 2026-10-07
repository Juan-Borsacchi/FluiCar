//
//  CustomSheetHeader.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 28/09/26.
//
import SwiftUI

struct CustomSheetHeader: ToolbarContent {
    let onDismiss: () -> Void
    let onSave: () -> Void
    var isSaveDisabled: Bool = false
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading){
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                   
            }

        }
        ToolbarItem(placement: .topBarTrailing){
            Button(action: onSave) {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(isSaveDisabled ? Color.gray.opacity(0.5) : Color(uiColor: .darkGray)))
            }
            .disabled(isSaveDisabled)
        }
        .sharedBackgroundVisibility(.hidden)
    }
}
