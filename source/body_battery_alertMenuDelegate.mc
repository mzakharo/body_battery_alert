import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

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
        }
    }

}
