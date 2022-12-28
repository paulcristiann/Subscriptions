//
//  AddSubscription.swift
//  Subscriptions
//
//  Created by Paul Cristian on 21.12.2022.
//

import SwiftUI

struct AddSubscription: View {
    
    enum FocusedField {
        case name
        case amount
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State private var subscriptionName = ""
    @State private var amountDue = ""
    @State private var currency = Locale.autoupdatingCurrent.currency
    @State private var nextDueDate = Date()
    @State private var recurrenceInterval = PVRecurrenceInterval.monthly
    @State private var shouldRemind = false
    @State private var daysBefore = 1
    
    @FocusState private var focusedField: FocusedField?
    
    var supportedCurrencies: [Locale.Currency] = []
    
    var dayString: String {
        return daysBefore == 1 ? "day" : "days"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    titleLabel
                    amountLabel
                    dueDateLabel
                    intervalLabel
                }
                .onSubmit {
                    manageFocus()
                }
                
                Section {
                    reminderToggle
                    if shouldRemind {
                        daysBeforeStepper
                    }
                }
            }
            .navigationTitle("Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelActionButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    addActionButton
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    submitKeyboardButton
                }
            }
            .onAppear {
                setupScreen()
            }
        }
    }
    
    var titleLabel: some View {
        HStack {
            Image(systemName: "bookmark.square")
                .font(.title)
            Text("Name")
            TextField("Subscription name", text: $subscriptionName)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .name)
                .multilineTextAlignment(.trailing)
        }
    }
    
    var amountLabel: some View {
        HStack {
            Image(systemName: "tag.square")
                .font(.title)
                .foregroundColor(.green)
            Text("Amount due")
            TextField("0.00", text: $amountDue)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .amount)
            Picker("", selection: $currency) {
                ForEach(supportedCurrencies, id: \.self) { currency in
                    Text(currency.identifier)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
    
    var dueDateLabel: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.title)
                .foregroundColor(.red)
            DatePicker("Due on", selection: $nextDueDate, displayedComponents: .date)
        }
    }
    
    var intervalLabel: some View {
        HStack {
            Image(systemName: "timer.square")
                .font(.title)
                .foregroundColor(.blue)
            Text("Interval")
            Spacer()
            Picker("", selection: $recurrenceInterval) {
                ForEach(PVRecurrenceInterval.allCases, id: \.self) { interval in
                    switch interval {
                    case .daily:
                        Text("Daily")
                    case .weekly:
                        Text("Weekly")
                    case .monthly:
                        Text("Monthly")
                    case .yearly:
                        Text("Yearly")
                    }
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
    
    var reminderToggle: some View {
        HStack {
            Image(systemName: "bolt.square")
                .font(.title)
                .foregroundColor(.purple)
            Toggle(isOn: $shouldRemind.animation()) {
                Text("Enable reminder")
            }
        }
    }
    
    var daysBeforeStepper: some View {
        HStack {
            Image(systemName: "bell.square")
                .font(.title)
                .foregroundColor(.green)
            Text("\(daysBefore) " + dayString + " before")
            Spacer()
            Stepper("Days before", value: $daysBefore)
                .labelsHidden()
        }
    }
    
    var cancelActionButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
    
    var addActionButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Add")
                .bold()
        }
    }
    
    var submitKeyboardButton: some View {
        Button {
            manageFocus()
        } label: {
            Text("Done")
                .bold()
        }
    }
    
    func manageFocus() {
        switch focusedField {
        case .name:
            focusedField = .amount
        case .amount:
            focusedField = nil
        default:
            focusedField = nil
        }
    }
    
    mutating func setupScreen() {
        let userLocale = Locale.autoupdatingCurrent
        let localCurrency = userLocale.currency ?? Locale.Currency("USD")
        self.supportedCurrencies = Array(Set([
            Locale.Currency("EUR"),
            Locale.Currency("USD"),
            localCurrency
        ]))
    }
}

struct AddSubscription_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscription()
    }
}
