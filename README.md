# Body Battery Alert

A Garmin Connect IQ application that monitors your body battery level and sends alerts when it drops below a configurable threshold.

## Overview

Body Battery Alert is a background-enabled watch app that continuously monitors your Garmin device's body battery level and provides notifications when your energy levels are running low. This helps you make informed decisions about rest, activity, and energy management throughout your day.

## Features

- **Continuous Monitoring**: Runs in the background and checks body battery levels every 5 minutes
- **Customizable Threshold**: Set your preferred alert threshold (default: 20%)
- **Smart Notifications**: Only alerts when battery drops below threshold (prevents spam)
- **Visual Display**: Shows current body battery level with color-coded status
- **Settings Menu**: Toggle notifications on/off and adjust alert threshold
- **Last Update Tracking**: Displays when the battery level was last checked

## Installation

1. Compile the app for your target device (Instructions below)
2. Attach your target device via USB to your computer (MTP mode).
2. Transfer the built binary `body_battery_alert.prg` file to `GARMIN/Apps/` folder
3. Disconnect the device from USB
4. Launch the app from your device's app menu

## Usage

### Initial Setup
1. Open the Body Battery Alert app on your device
2. The app will start monitoring your body battery in the background
3. Default alert threshold is set to 20%

### Configuring Settings
1. From the main app screen, press the menu button
2. Select "Toggle Notifications" to enable/disable alerts
3. Select "Set Alert Threshold" to customize when you receive notifications

### Understanding the Display
- **Green**: Body battery is healthy (above threshold + 20%)
- **Yellow**: Body battery is getting low (within 20% of threshold)
- **Red**: Body battery is below your set threshold
- **"LOW BATTERY!" message**: Appears when below threshold

## How It Works

The app uses Garmin's SensorHistory API to access your device's body battery data. It runs as a background service that:

1. Checks your body battery level every 5 minutes
2. Compares the current level to your configured threshold
3. Sends a notification if the battery drops below the threshold
4. Stores the last known values for display in the app

## Technical Details

### Permissions Required
- **Background**: Allows the app to run continuously in the background
- **SensorHistory**: Provides access to body battery data

### Background Processing
The app registers for temporal events every 300 seconds (5 minutes) to check body battery levels without draining your device's battery.

## Development

This is a Garmin Connect IQ application written in Monkey C.

### Building
1. Install the Connect IQ SDK (SDK 8.2.2) Tested
2. Use Visual Studio Code with the Garmin Monkey C extension
3. Build using "Monkey C: Build for Device" command

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

