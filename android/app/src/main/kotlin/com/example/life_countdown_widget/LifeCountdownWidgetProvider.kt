package com.example.life_countdown_widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.util.*

class LifeCountdownWidgetProvider : AppWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
    
    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)
        
        // Calculate life countdown
        val birthDate = Calendar.getInstance().apply {
            set(2003, Calendar.NOVEMBER, 13)
        }
        val now = Calendar.getInstance()
        val lifeExpectancy = 80
        
        val expectedDeath = Calendar.getInstance().apply {
            timeInMillis = birthDate.timeInMillis
            add(Calendar.YEAR, lifeExpectancy)
        }
        
        val remaining = expectedDeath.timeInMillis - now.timeInMillis
        
        if (remaining > 0) {
            val years = remaining / (365.25 * 24 * 60 * 60 * 1000).toLong()
            val months = (remaining % (365.25 * 24 * 60 * 60 * 1000).toLong()) / (30.44 * 24 * 60 * 60 * 1000).toLong()
            val days = (remaining % (30.44 * 24 * 60 * 60 * 1000).toLong()) / (24 * 60 * 60 * 1000)
            val hours = (remaining % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000)
            
            views.setTextViewText(R.id.years_text, "$years\nYears")
            views.setTextViewText(R.id.months_text, "$months\nMonths")
            views.setTextViewText(R.id.days_text, "$days\nDays")
            views.setTextViewText(R.id.hours_text, "$hours\nHours")
        }
        
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}