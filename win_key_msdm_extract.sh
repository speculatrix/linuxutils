#!/bin/bash
# extracts embedded windows activation key from the system's firmware
# yes, it's trivial but so I don't have to remember

echo "Need root to read /sys/firmware/acpi/tables/MSDM"
sudo strings /sys/firmware/acpi/tables/MSDM
