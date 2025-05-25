# 🔌 USB Device Scanner with Wakeup Support & JSON Export

A Bash script that scans all connected USB devices and presents a detailed, tree-style view of device information — including USB hub hierarchy, wakeup capabilities, and optional structured JSON export.

This tool is perfect for:
- Debugging wake-from-USB issues
- Auditing connected hardware
- Understanding how your system organizes and handles USB devices

---

## 📋 Features

- 🧩 **Full detection** of all connected USB devices and hubs  
- 🌲 **Tree-style hierarchy** using visual connectors: `├─`, `└─`, `│`  
- 🔍 **Detailed device info**, including:
  - Vendor ID & Product ID
  - Manufacturer & Product name
  - Serial Number
  - USB version & speed
  - Device class, subclass, and protocol  
- ⚡ **Wakeup support status**:
  - ✅ Enabled
  - ❌ Disabled
  - ⚠️ Not supported  
- 🧾 **Optional JSON export** (`usb_devices.json`) for scripting or archiving  
- 🎨 **Color-coded terminal output** for readability  
- 📂 **MIT licensed** and fully open source

---

## 🚀 Usage

### 1. Run the script
```bash
chmod +x usb_device_scan.sh
./usb_device_scan.sh
```

### 2. Review the device output
```
├─ Device: /sys/bus/usb/devices/2-1
│  Vendor ID        : 2dc8
│  Product ID       : 3109
│  Manufacturer     : 8BitDo
│  Product Name     : IDLE
│  Serial Number    : E417D81715AD
│  USB Version      : 1.10
│  Speed            : 12 Mbps
│  Device Class     : 00
│  Device SubClass  : 00
│  Device Protocol  : 00
│  Wakeup Support   : ❌ Disabled
```

### 3. Export results to JSON (optional)
At the end of the scan, you’ll be prompted:
```
Would you like to export results to JSON? [y/N]:
```

If you choose `y`, a file named `usb_devices.json` will be created in the current directory.

---

## 🧪 JSON Output Example

```json
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

---

## 📦 Requirements

- `bash`
- `jq` (for JSON formatting)

To install `jq`, use:
```bash
# Debian/Ubuntu
sudo apt install jq

# Arch Linux
sudo pacman -S jq
```

---

## 📄 License

This project is licensed under the **MIT License** — free to use, modify, and distribute.

---

🛠️ Pull requests, feedback, and improvements are always welcome!
