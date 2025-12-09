//
//  DeviceCountryImpl.swift
//  DeviceCountry
//
//  Created by Евгений Сецко on 9.12.25.
//  Copyright © 2025 Facebook. All rights reserved.
//

import CoreTelephony

@objc(DeviceCountryImpl)
public class DeviceCountryImpl: NSObject {

    private let TYPE_ANY = "any"
    private let TYPE_CONFIGURATION = "config"
    private let TYPE_TELEPHONY = "telephony"

    @MainActor @objc
    public func getCountryCode(
        _ type: String
    ) -> [String: String]? {
        var countryCode: String? = nil
        var resolveType = type

        if type == TYPE_TELEPHONY || type == TYPE_ANY {
            countryCode = getCountryCodeFromTelephonyNetworkInfo()
            resolveType = TYPE_TELEPHONY
        }

        if type == TYPE_CONFIGURATION ||
            (countryCode == nil && type != TYPE_TELEPHONY) {

            countryCode = getCountryCodeFromLocale()
            resolveType = TYPE_CONFIGURATION
        }

        do {
            return try getDictionaryResult(countryCode: countryCode, type: resolveType)
        } catch {
            print("event_failure", "No country code found exception")
        }
      return nil
    }

    // MARK: - Helpers

    private func getDictionaryResult(countryCode: String?, type: String) throws -> [String: String] {
        guard let code = countryCode else {
            throw NSError(domain: "DeviceCountry", code: -1, userInfo: nil)
        }
        return ["code": code, "type": type]
    }

    private func getCountryCodeFromTelephonyNetworkInfo() -> String? {
        do {
            let telephony = CTTelephonyNetworkInfo()

            var carrier: CTCarrier?

            if #available(iOS 12.1, *) {
                if let carriers = telephony.serviceSubscriberCellularProviders {
                    carrier = firstCarrier(carriers: carriers)
                }
            } else if #available(iOS 12.0, *) {
                if let carriers = telephony.value(forKey: "serviceSubscriberCellularProvider") as? [String: CTCarrier] {
                    carrier = firstCarrier(carriers: carriers)
                }
            }

            if carrier == nil {
                carrier = telephony.subscriberCellularProvider
            }

            return carrier?.isoCountryCode?.uppercased()
        } catch {
            return nil
        }
    }

    private func firstCarrier(carriers: [String: CTCarrier]) -> CTCarrier? {
        return carriers.values.first
    }

    private func getCountryCodeFromLocale() -> String? {
        return Locale.current.regionCode
    }
}
