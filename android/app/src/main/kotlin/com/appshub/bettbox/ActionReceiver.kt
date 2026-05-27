package com.appshub.bettbox

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.appshub.bettbox.extensions.wrapAction

class ActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            context.wrapAction("START") -> GlobalState.handleStart()
            context.wrapAction("STOP") -> GlobalState.handleStop()
            context.wrapAction("CHANGE") -> GlobalState.handleToggle()
        }
    }
}
