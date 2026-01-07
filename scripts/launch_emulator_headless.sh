#!/bin/bash

# Start the emulator in headless mode
echo "Starting Emulator (Headless)..."
# We assume the emulator binary is in the standard Android SDK location or accessible via PATH
# If not, we might need to find it. But usually 'emulator' command works if SDK is set up.
# However, the previous script used a wrapper.
# Let's try to find the emulator executable first.
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}
EMULATOR_BIN="$ANDROID_SDK_ROOT/emulator/emulator"

if [ ! -f "$EMULATOR_BIN" ]; then
    echo "Error: Emulator binary not found at $EMULATOR_BIN"
    exit 1
fi

# List AVDs
echo "Available AVDs:"
$EMULATOR_BIN -list-avds

# Pick the first AVD or a specific one (e.g., Pixel_API_30)
# We'll try to grep for a likely candidate or just take the first one.
# Filter out INFO lines which might appear in stdout/stderr
AVD_NAME=$($EMULATOR_BIN -list-avds | grep -v "INFO" | head -n 1)

if [ -z "$AVD_NAME" ]; then
    echo "Error: No AVDs found."
    exit 1
fi

echo "Launching AVD: $AVD_NAME"
$EMULATOR_BIN -avd "$AVD_NAME" -no-window -no-audio &
EMULATOR_PID=$!

echo "Emulator PID: $EMULATOR_PID"

# Wait for device
echo "Waiting for device..."
adb wait-for-device

echo "Device connected!"

# Connect to logcat
echo "Starting Logcat (Press Ctrl+C to stop)..."
adb logcat -v color TestJunk:V *:S
