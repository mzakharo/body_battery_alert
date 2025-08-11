import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.SensorHistory;
import Toybox.Lang;

using Constants;

class body_battery_alertView extends WatchUi.View {

    
    private var _bodyBattery as Number?;
    private var _lastCheckTime as Number?;
    private var _notificationsEnabled as Boolean;
    private var _batteryThreshold as Number?;

    function initialize() {
        View.initialize();
        _bodyBattery = null;
        _lastCheckTime = null;
        _notificationsEnabled = true;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // We'll use custom drawing instead of layout resources
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {      
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Load stored values
        _bodyBattery = Application.Storage.getValue("lastNotificationBattery");
        _lastCheckTime = Application.Storage.getValue("lastCheckTime");
        var enabled = Application.Storage.getValue("notificationsEnabled");
        _notificationsEnabled = (enabled != null) ? enabled : true;
        var threshold = Application.Storage.getValue("batteryThreshold");
        _batteryThreshold = (threshold != null) ? threshold : Constants.DEFAULT_BATTERY_THRESHOLD;

        
        // Clear the screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        
        // Title
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 0.15, Graphics.FONT_SMALL, "Body Battery Alert", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Body Battery Level
        if (_bodyBattery != null) {
            var batteryColor = Graphics.COLOR_GREEN;
            if (_bodyBattery <= _batteryThreshold) {
                batteryColor = Graphics.COLOR_RED;
            } else if (_bodyBattery < (_batteryThreshold + 20)) {
                batteryColor = Graphics.COLOR_YELLOW;
            }
            
            dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, centerY - 60, Graphics.FONT_NUMBER_MILD, _bodyBattery.toNumber().toString() + "%", Graphics.TEXT_JUSTIFY_CENTER);
            
            // Battery status text
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            var statusText = "Body Battery";
            if (_bodyBattery <= _batteryThreshold) {
                statusText = "LOW BATTERY!";
            }
            dc.drawText(centerX, centerY + 20, Graphics.FONT_SMALL, statusText, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, centerY, Graphics.FONT_MEDIUM, "No Data", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Last check time
        if (_lastCheckTime != null) {
            var now = Time.now();
            var lastCheck = new Time.Moment(_lastCheckTime);
            var diff = now.subtract(lastCheck).value();
            var minutes = diff / 60;
            
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            var timeText = "Updated: " + minutes + " min ago";
            if (minutes < 1) {
                timeText = "Updated: Just now";
            } else if (minutes > 60) {
                var hours = minutes / 60;
                timeText = "Updated: " + hours + " hr ago";
            }
            dc.drawText(centerX, height * 0.75, Graphics.FONT_XTINY, timeText, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Notification status and threshold
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var notifText = _notificationsEnabled ? "Alerts: ON" : "Alerts: OFF";
        dc.drawText(centerX, height * 0.82, Graphics.FONT_XTINY, notifText, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Threshold setting
        var thresholdText = "Threshold: " + _batteryThreshold + "%";
        dc.drawText(centerX, height * 0.88, Graphics.FONT_XTINY, thresholdText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
    
}
