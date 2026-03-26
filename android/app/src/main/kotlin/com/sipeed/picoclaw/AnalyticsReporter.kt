package com.sipeed.picoclaw

import android.content.Context
import android.os.Build
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure

object AnalyticsReporter {
    private const val DEVICE_REPORT_EVENT = "device_feedback_report"
    private var umengInitialized = false

    private val provider: String
        get() = BuildConfig.PICOCLAW_ANALYTICS_PROVIDER.lowercase()

    private val umengAppKey: String
        get() = BuildConfig.PICOCLAW_UMENG_APP_KEY

    private val umengChannel: String
        get() = BuildConfig.PICOCLAW_UMENG_CHANNEL.ifBlank { "official" }

    private fun isUmengProviderEnabled(): Boolean {
        return provider == "umeng" && umengAppKey.isNotBlank()
    }

    fun preInit(context: Context) {
        if (!isUmengProviderEnabled()) {
            return
        }
        UMConfigure.preInit(context.applicationContext, umengAppKey, umengChannel)
    }

    fun submitConsent(context: Context, granted: Boolean) {
        if (!isUmengProviderEnabled()) {
            return
        }
        val appContext = context.applicationContext
        UMConfigure.submitPolicyGrantResult(appContext, granted)
        if (granted && !umengInitialized) {
            UMConfigure.init(
                appContext,
                umengAppKey,
                umengChannel,
                UMConfigure.DEVICE_TYPE_PHONE,
                null,
            )
            MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO)
            umengInitialized = true
        }
    }

    fun uploadDeviceReport(context: Context, payload: Map<String, Any?>): Map<String, Any> {
        if (!isUmengProviderEnabled()) {
            return mapOf(
                "success" to false,
                "message" to "Umeng provider is not enabled for this build.",
            )
        }
        if (!umengInitialized) {
            return mapOf(
                "success" to false,
                "message" to "Umeng SDK is not initialized. Consent may be required.",
            )
        }

        val eventPayload = linkedMapOf<String, Any>(
            "installId" to ((payload["installId"] as? String).orEmpty()),
            "platform" to ((payload["platform"] as? String).orEmpty()),
            "deviceModel" to ((payload["deviceModel"] as? String).orEmpty()),
            "systemVersion" to ((payload["systemVersion"] as? String).orEmpty()),
            "clientType" to ((payload["clientType"] as? String).orEmpty()),
            "updatedAt" to ((payload["updatedAt"] as? String).orEmpty()),
            "manufacturer" to Build.MANUFACTURER.orEmpty(),
            "sdkInt" to Build.VERSION.SDK_INT,
            "channel" to ((payload["channel"] as? String).orEmpty()),
        )

        return try {
            MobclickAgent.onEventObject(
                context.applicationContext,
                DEVICE_REPORT_EVENT,
                eventPayload,
            )
            mapOf(
                "success" to true,
                "message" to "Upload succeeded.",
            )
        } catch (e: Exception) {
            mapOf(
                "success" to false,
                "message" to "Upload failed: ${e.message ?: e.javaClass.simpleName}",
            )
        }
    }
}
