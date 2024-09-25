//
//  Router.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/25/24.
//

import SwiftUI

class Router: ObservableObject {
    enum Route {
        case onboarding
        case login
        case registration
        case home
    }

    @Published var currentRoute: Route = .onboarding

    func navigate(to route: Route) {
        currentRoute = route
    }

    func resetToOnboarding() {
        currentRoute = .onboarding
    }
}

