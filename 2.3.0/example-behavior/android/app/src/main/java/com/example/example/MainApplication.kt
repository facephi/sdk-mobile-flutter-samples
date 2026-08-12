package com.example.example

import android.app.Application
import com.facephi.widget_behavior.WidgetBehaviorApplication

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        WidgetBehaviorApplication().initializeBehavior(this)
    }
}