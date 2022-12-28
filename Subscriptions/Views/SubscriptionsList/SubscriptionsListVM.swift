//
//  SubscriptionsListVM.swift
//  Subscriptions
//
//  Created by Paul Cristian on 20.12.2022.
//

import Foundation
import CoreData

final class SubscriptionsListVM: ObservableObject {
    
    enum ScreenStates {
        case empty
        case loading
        case loaded
        case error
    }
    
    @Published var subscriptions: [PVSubscription] = []
    @Published var screenState: ScreenStates = .loading
    
    var context: NSManagedObjectContext? = nil
    var coreDataManager: CoreDataManager? = nil
    
    func setContext(context: NSManagedObjectContext) {
        self.context = context
        guard let context = self.context else { return }
        self.coreDataManager = CoreDataManager(with: context)
    }
    
    func fetchSubscriptions() {
        self.screenState = .loading
        do {
            guard let coreDataManager = coreDataManager else {
                self.screenState = .error
                return
            }
            self.subscriptions = try coreDataManager.getAllSubscriptions()
            self.screenState = self.subscriptions.count == 0 ? .empty : .loaded
        } catch {
            self.screenState = .error
        }
    }
    
    func removeSubscription(indexSet: IndexSet) {
        guard let coreDataManager = coreDataManager else {
            return
        }
        
        do {
            try indexSet.forEach { index in
                try coreDataManager.removeSubscription(subscription: subscriptions[index])
            }
            self.subscriptions.remove(atOffsets: indexSet)
            if self.subscriptions.isEmpty {
                self.screenState = .empty
            }
        } catch {
            print("Error removing item")
        }
    }
    
}
