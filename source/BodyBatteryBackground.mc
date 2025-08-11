import Toybox.Background;
import Toybox.System;
import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Time;

(:background)
class BodyBatteryBackground extends System.ServiceDelegate {
    
    const BATTERY_THRESHOLD = 20; // Alert when battery drops Threshold
    
    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        // Get the current body battery level
        var bodyBattery = getBodyBatteryLevel();
        
        if (bodyBattery != null) {            
            // Check if we should send a notification
            checkAndSendNotification(bodyBattery);
        }        
        Background.exit(null);
    }
    
    function getBodyBatteryLevel() as Number? {
        // Get body battery history
        var history = SensorHistory.getBodyBatteryHistory({
            :period => 1,
            :order => SensorHistory.ORDER_NEWEST_FIRST
        });
        
        if (history != null) {
            var sample = history.next();
            if (sample != null && sample.data != null) {
                return sample.data;
            }
        }
        
        return null;
    }
    
    function checkAndSendNotification(bodyBattery as Number) as Void {
        var storage = Application.Storage;
        var lastNotificationBattery = storage.getValue("lastNotificationBattery");
        var notificationsEnabled = storage.getValue("notificationsEnabled");
        
        // Default to enabled if not set
        if (notificationsEnabled == null) {
            notificationsEnabled = true;
            storage.setValue("notificationsEnabled", true);
        }
        
        var currentTime = Time.now().value();
        
        // Check if battery is below threshold
        if (bodyBattery < BATTERY_THRESHOLD) {
            var shouldNotify = false;            
            if (lastNotificationBattery != null && lastNotificationBattery >= BATTERY_THRESHOLD) {
                // Battery just dropped below threshold
                shouldNotify = true;
            }                     
            if (shouldNotify && notificationsEnabled) {
                sendLowBatteryNotification(bodyBattery);
            }
        }
        // Always update the last known battery level
        storage.setValue("lastNotificationBattery", bodyBattery);
        storage.setValue("lastCheckTime", currentTime);
    }
    
    function sendLowBatteryNotification(bodyBattery as Number) as Void {
        // Create notification message
        var message = "Body Battery Low: " + bodyBattery.toNumber().toString() + "%";
        System.println(message);
        Background.requestApplicationWake(message);
    }
}
