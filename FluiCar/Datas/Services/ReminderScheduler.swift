//
//  ReminderScheduler.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//

import Foundation
import UserNotifications
import os

protocol ReminderSchedulerProtocol {
    func schedule(id: String, title: String, body: String, date: Date, repeatRule: ReminderRepeat) async
    func cancel(ids: [String])
}

struct NotificationReminderScheduler: ReminderSchedulerProtocol {
    private let center = UNUserNotificationCenter.current()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "FluiCar",
        category: "Reminders"
    )

    func schedule(id: String, title: String, body: String, date: Date, repeatRule: ReminderRepeat) async {
        let fireDate = repeatRule.nextFireDate(from: date)

        // Data passada sem repetição nunca dispararia: só limpa o pedido antigo.
        if repeatRule == .never && date <= Date() {
            center.removePendingNotificationRequests(withIdentifiers: [id])
            return
        }

        guard await isAuthorized() else { return }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: repeatRule.triggerComponents(for: fireDate),
            repeats: repeatRule.repeats
        )
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        do {
            try await center.add(request)
        } catch {
            logger.error("Falha ao agendar \(id, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    func cancel(ids: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    private func isAuthorized() async -> Bool {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        default:
            return false
        }
    }
}
