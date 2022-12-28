//
//  SubscriptionsApp.swift
//  Subscriptions
//
//  Created by Paul Cristian on 20.12.2022.
//

import SwiftUI

@main
struct SubscriptionsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SubscriptionsListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
