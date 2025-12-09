package com.reactnativedevicecountry

import android.content.Context
import android.content.res.Resources
import android.os.Build
import android.telephony.TelephonyManager
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap
import java.util.Locale

class DeviceCountryModule(reactContext: ReactApplicationContext) : NativeDeviceCountrySpec(reactContext) {

    companion object {
        const val NAME = "NativeDeviceCountry"

        const val TYPE_ANY = "any"
        const val TYPE_CONFIGURATION = "config"
        const val TYPE_TELEPHONY = "telephony"
    }

    override fun getName() = NAME

    override fun getCountryCode(type: String, promise: Promise) {
        var countryCode: String? = null
        var resolveType = type

        if (type == TYPE_TELEPHONY || type == TYPE_ANY) {
            countryCode = getCountryCodeFromTelephonyManager()
            resolveType = TYPE_TELEPHONY
        }

        if (type == TYPE_CONFIGURATION || (countryCode == null && type != TYPE_TELEPHONY)) {
            countryCode = getCountryCodeFromConfiguration()
            resolveType = TYPE_CONFIGURATION
        }

        try {
            val result = createResultMap(countryCode, resolveType)
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("event_failure", "No country code found exception")
        }
    }

    private fun createResultMap(countryCode: String?, type: String): WritableMap {
        if (countryCode == null) {
            throw Exception("Country code is null")
        }

        return Arguments.createMap().apply {
            putString("code", countryCode)
            putString("type", type)
        }
    }

    private fun getCountryCodeFromTelephonyManager(): String? {
        return try {
            val tm = reactApplicationContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val code = tm.networkCountryIso
            if (code.isNullOrEmpty()) null else code
        } catch (e: Exception) {
            null
        }
    }

    private fun getCountryCodeFromConfiguration(): String? {
        return try {
            val locale: Locale =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    Resources.getSystem().configuration.locales.get(0)
                } else {
                    Resources.getSystem().configuration.locale
                }
            locale.country
        } catch (e: Exception) {
            null
        }
    }
}
