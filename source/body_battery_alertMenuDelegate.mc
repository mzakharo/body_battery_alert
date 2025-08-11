import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

using Constants;

class body_battery_alertMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :toggle_notifications) {
            var enabled = Application.Storage.getValue("notificationsEnabled");
            if (enabled == null) {
                enabled = true;
            }
            enabled = !enabled;
            Application.Storage.setValue("notificationsEnabled", enabled);
            
            var message = enabled ? "Notifications Enabled" : "Notifications Disabled";
            WatchUi.showToast(message, null);
        } else if (item == :set_threshold) {
            // Create threshold selection menu
            var thresholdMenu = new WatchUi.Menu2({:title => "Alert Threshold"});
            
            // Add threshold options
            var thresholds = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90];
            var currentThreshold = Application.Storage.getValue("batteryThreshold");
            if (currentThreshold == null) {
                currentThreshold = Constants.DEFAULT_BATTERY_THRESHOLD;
            }
            
            for (var i = 0; i < thresholds.size(); i++) {
                var threshold = thresholds[i];
                var label = threshold + "%";
                if (threshold == currentThreshold) {
                    label = threshold + "% *";
                }
                thresholdMenu.addItem(new WatchUi.MenuItem(label, null, threshold, null));
            }
            
            var delegate = new ThresholdMenuDelegate();
            WatchUi.pushView(thresholdMenu, delegate, WatchUi.SLIDE_UP);
        }
    }

}

class ThresholdMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    function initialize() {
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(item as WatchUi.MenuItem) as Void {
        var threshold = item.getId() as Number;
        
        // Save the selected threshold value
        Application.Storage.setValue("batteryThreshold", threshold);
        
        var message = "Threshold set to " + threshold + "%";
        WatchUi.showToast(message, null);
        
        // Pop back to previous view
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
    
    function onBack() as Void {
        // User pressed back, just pop back
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
