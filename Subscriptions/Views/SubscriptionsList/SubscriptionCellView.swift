//
//  SubscriptionCellView.swift
//  Subscriptions
//
//  Created by Paul Cristian on 21.12.2022.
//

import SwiftUI

struct SubscriptionCellView: View {
    
    let subscription: PVSubscription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(subscription.name)
                .bold()
            Text(subscription.amountDue.formatted(.currency(code: "RON")))
                .font(.headline)
                .bold()
            HStack(spacing: 4) {
                Text("payment due on")
                Text(subscription.nextDueData.formatted(date: .numeric, time: .omitted))
                    .bold()
            }
        }
    }
}

struct SubscriptionCellView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionCellView(subscription: PVSubscription())
    }
}
