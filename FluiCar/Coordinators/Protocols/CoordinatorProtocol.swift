//
//  CoordinatorProtocols.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 21/09/26.
//
import SwiftUI

protocol CoordinatorProtocol {
    associatedtype Destination: View
    
    var path: NavigationPath { get set }
    var sheet: AppRoute? { get set }
    
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
    func presentSheet(_ route: AppRoute)
    func dismissSheet()
    
    func build(_ route: AppRoute) -> Destination
}
