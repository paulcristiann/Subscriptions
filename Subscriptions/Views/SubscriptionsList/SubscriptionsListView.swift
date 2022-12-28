//
//  ContentView.swift
//  Subscriptions
//
//  Created by Paul Cristian on 20.12.2022.
//

import SwiftUI
import CoreData

struct SubscriptionsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var vm = SubscriptionsListVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch vm.screenState {
                case .loading:
                    ProgressView()
                case .loaded:
                    subscriptionsList
                case .empty:
                    emptyView
                case .error:
                    Text("An error occured")
                }
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        Text("Add Subscriptions View")
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .onAppear {
                vm.setContext(context: viewContext)
                vm.fetchSubscriptions()
            }
        }
    }
    
    var subscriptionsList: some View {
        List {
            ForEach(vm.subscriptions) { subscription in
                SubscriptionCellView(subscription: subscription)
            }
            .onDelete(perform: vm.removeSubscription(indexSet:))
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 10) {
            Text("Add a subscription")
                .font(.title)
                .bold()
            Text("Tap the '+' button to create your first subscription")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
