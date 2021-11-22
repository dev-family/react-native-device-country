package com.reactnativedevicecountry;

import android.content.Context;
import android.telephony.TelephonyManager;
import androidx.annotation.NonNull;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import org.json.JSONObject;

@ReactModule(name = DeviceCountryModule.NAME)
public class DeviceCountryModule extends ReactContextBaseJavaModule {
  public static final String NAME = "DeviceCountryModule";

  private static ReactApplicationContext reactContext;

  public static final String TYPE_ANY = "any";
  public static final String TYPE_CONFIGURATION = "config";
  public static final String TYPE_TELEPHONY = "telephony";

  public DeviceCountryModule(ReactApplicationContext context) {
    super(reactContext);
    reactContext = context;
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void getCountryCode(String type, Promise promise) {
    String countryCode = null;
    String resolveType = type;
    if (type.equals(TYPE_TELEPHONY) || type.equals(TYPE_ANY)) {
      countryCode = getCountryCodeFromTelephonyManager();
      resolveType = TYPE_TELEPHONY;
    }

    if (
      type.equals(TYPE_CONFIGURATION) ||
      (countryCode == null && type.equals(TYPE_TELEPHONY) == false)
    ) {
      countryCode = getCountryCodeFromConfiguration();
      resolveType = TYPE_CONFIGURATION;
    }

    try {
      promise.resolve(getResultJSON(countryCode, resolveType).toString());
    } catch (Exception e) {
      promise.reject("No country code found exception");
    }
  }

  protected JSONObject getResultJSON(String countryCode, String type)
    throws Exception {
    if (countryCode == null) {
      throw new Exception();
    }
    try {
      JSONObject json = new JSONObject();
      json.put("code", countryCode);
      json.put("type", type);
      return json;
    } catch (Exception e) {
      throw e;
    }
  }

  protected String getCountryCodeFromTelephonyManager() {
    try {
      TelephonyManager tm = (TelephonyManager) reactContext.getSystemService(
        Context.TELEPHONY_SERVICE
      );
      String countryCode = tm.getNetworkCountryIso();
      if (countryCode.isEmpty()) {
        return null;
      }
      return countryCode;
    } catch (Exception e) {
      return null;
    }
  }

  protected String getCountryCodeFromConfiguration() {
    try {
      String countryCode = reactContext
        .getResources()
        .getConfiguration()
        .locale.getCountry();
      return countryCode;
    } catch (Exception e) {
      return null;
    }
  }
}
