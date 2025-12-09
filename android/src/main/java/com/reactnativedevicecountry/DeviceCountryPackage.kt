package com.reactnativedevicecountry;

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider

class DeviceCountryPackage : BaseReactPackage() {

  override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? =
    (if (name == DeviceCountryModule.NAME) {
      DeviceCountryModule(reactContext)
    } else {
      null
    }) as NativeModule?

  override fun getReactModuleInfoProvider() = ReactModuleInfoProvider {
    mapOf(
      DeviceCountryModule.NAME to ReactModuleInfo(
        name = DeviceCountryModule.NAME,
        className = DeviceCountryModule.NAME,
        canOverrideExistingModule = false,
        needsEagerInit = false,
        isCxxModule = false,
        isTurboModule = true,
        hasConstants = false
      )
    )
  }
}
