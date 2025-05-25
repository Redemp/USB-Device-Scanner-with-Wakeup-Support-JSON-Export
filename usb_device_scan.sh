#!/bin/bash

# Color constants
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Start JSON array
json_output="["

echo "Scanning USB devices for detailed information including wakeup support..."
echo

scan_usb_tree() {
    local parent="$1"
    local indent="$2"

    local entries=()
    for dev in /sys/bus/usb/devices/${parent}*; do
        [[ "$dev" =~ : ]] && continue
        [[ -f "$dev/idVendor" && -f "$dev/idProduct" ]] && entries+=("$dev")
    done

    local total=${#entries[@]}
    local count=0

    for dev in "${entries[@]}"; do
        ((count++))
        local branch="├─"
        local new_indent="${indent}│  "
        [[ $count -eq $total ]] && branch="└─" && new_indent="${indent}   "

        vendor=$(cat "$dev/idVendor")
        product=$(cat "$dev/idProduct")
        manufacturer=$(cat "$dev/manufacturer" 2>/dev/null || echo "unknown")
        product_str=$(cat "$dev/product" 2>/dev/null || echo "unknown")
        serial=$(cat "$dev/serial" 2>/dev/null || echo "unknown")
        usbver=$(cat "$dev/version" 2>/dev/null || echo "unknown")
        speed=$(cat "$dev/speed" 2>/dev/null || echo "unknown")
        class=$(cat "$dev/bDeviceClass" 2>/dev/null || echo "unknown")
        subclass=$(cat "$dev/bDeviceSubClass" 2>/dev/null || echo "unknown")
        protocol=$(cat "$dev/bDeviceProtocol" 2>/dev/null || echo "unknown")

        # Wakeup support
        wakeup_icon="⚠️"
        wakeup_color="$YELLOW"
        wakeup_text="Not supported"
        wakeup_raw="unsupported"
        if [[ -f "$dev/power/wakeup" ]]; then
            status=$(cat "$dev/power/wakeup")
            wakeup_raw="$status"
            if [[ "$status" == "enabled" ]]; then
                wakeup_icon="✅"
                wakeup_color="$GREEN"
                wakeup_text="Enabled"
            else
                wakeup_icon="❌"
                wakeup_color="$RED"
                wakeup_text="Disabled"
            fi
        fi

        # Output to terminal
        echo -e "${indent}${branch} Device: ${dev}"
        printf "${indent}   %-18s : %s\n" "Vendor ID"        "$vendor"
        printf "${indent}   %-18s : %s\n" "Product ID"       "$product"
        printf "${indent}   %-18s : %s\n" "Manufacturer"     "$manufacturer"
        printf "${indent}   %-18s : %s\n" "Product Name"     "$product_str"
        printf "${indent}   %-18s : %s\n" "Serial Number"    "$serial"
        printf "${indent}   %-18s : %s\n" "USB Version"      "$usbver"
        printf "${indent}   %-18s : %s Mbps\n" "Speed"         "$speed"
        printf "${indent}   %-18s : %s\n" "Device Class"     "$class"
        printf "${indent}   %-18s : %s\n" "Device SubClass"  "$subclass"
        printf "${indent}   %-18s : %s\n" "Device Protocol"  "$protocol"
        echo -e "${indent}   Wakeup Support    : ${wakeup_color}${wakeup_icon} $wakeup_text${NC}"
        echo

        # Append JSON block
        json_output+=$(
            jq -n \
                --arg dev "$dev" \
                --arg vendor "$vendor" \
                --arg product "$product" \
                --arg manufacturer "$manufacturer" \
                --arg product_str "$product_str" \
                --arg serial "$serial" \
                --arg usbver "$usbver" \
                --arg speed "$speed" \
                --arg class "$class" \
                --arg subclass "$subclass" \
                --arg protocol "$protocol" \
                --arg wakeup "$wakeup_raw" \
                '{
                    path: $dev,
                    vendor_id: $vendor,
                    product_id: $product,
                    manufacturer: $manufacturer,
                    product_name: $product_str,
                    serial: $serial,
                    usb_version: $usbver,
                    speed_mbps: $speed,
                    device_class: $class,
                    device_subclass: $subclass,
                    device_protocol: $protocol,
                    wakeup_support: $wakeup
                }'
        )
        [[ $count -ne $total || "$parent" != "" ]] && json_output+=","

        [[ "$class" == "09" ]] && scan_usb_tree "$(basename "$dev")-" "$new_indent"
    done
}

# Start the scan
scan_usb_tree "" ""

# Ask about JSON export
read -rp "Would you like to export results to JSON? [y/N]: " export_choice
export_choice=${export_choice,,}

if [[ "$export_choice" == "y" || "$export_choice" == "yes" ]]; then
    echo "${json_output}]" | jq '.' > ./usb_devices.json
    echo -e "\n✅ JSON export complete: ./usb_devices.json"
else
    echo -e "\nExport skipped."
fi
