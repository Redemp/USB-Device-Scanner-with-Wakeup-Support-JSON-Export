🔌 USB Device Scanner with Wakeup Support & JSON Export

* A Bash script that scans all connected USB devices and presents a detailed tree-style view of device information, including USB hub hierarchy, wakeup capabilities, and structured JSON export.
* This tool is perfect for debugging wake-from-USB issues, hardware inventory, or just exploring how your system handles USB devices.

***

📋 Features

*    🧩 Full detection of all USB devices and hubs

*    🌲 Tree-like hierarchy using visual connectors (├─, └─, │)

*    🔍 Detailed information including:

  *    Vendor ID, Product ID

  *    Manufacturer and product name

  *    Serial number

  *    USB version, speed

  *    Device class, subclass, protocol

*    Wakeup support: ✅ Enabled, ❌ Disabled, ⚠️ Not supported

*    🧾 Optional JSON export (usb_devices.json) for further processing or record keeping

*    🎨 Colored terminal output for easy readability

*    📂 MIT licensed and fully open source

***

🚀 Usage
**1. Run the script:**
```
chmod +x usb_device_scan.sh
./usb_device_scan.sh
```

**2. Review device output in the terminal:**
```
├─ Device: /sys/bus/usb/devices/2-1
│  Vendor ID          : 2dc8
│  Product ID         : 3109
│  Manufacturer       : 8BitDo
│  Product Name       : IDLE
│  Serial Number      : E417D81715AD
│  USB Version        :  1.10
│  Speed              : 12 Mbps
│  Device Class       : 00
│  Device SubClass    : 00
│  Device Protocol    : 00
│  Wakeup Support     : ❌ Disabled
```
**3. Choose whether to export to JSON:**
```
Would you like to export results to JSON? [y/N]:
```
If `yes`, it will create a file in the same directory:
```
usb_devices.json
```
***
🧪 JSON Output Example
```
[
  {
    "path": "/sys/bus/usb/devices/2-1",
    "vendor_id": "2dc8",
    "product_id": "3109",
    "manufacturer": "8BitDo",
    "product_name": "IDLE",
    "serial": "E417D81715AD",
    "usb_version": "1.10",
    "speed_mbps": "12",
    "device_class": "00",
    "device_subclass": "00",
    "device_protocol": "00",
    "wakeup_support": "disabled"
  }
]
```
***
📦 Requirements

*    bash
*    jq (for JSON formatting)

📄 License

This project is licensed under the MIT License — do whatever you want with it.
