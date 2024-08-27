# Racher GPS - FiveM Lua Script

## Description

Racher GPS script that provides functionality for navigation and location tracking. It allows police and medical staff to manage and view GPS blips on the map, including car blips.

## Features

- **GPS Management**: Enable and disable GPS with commands.
- **Blip Handling**: Add, update, and remove blips for players and vehicles.
- **Department-Specific Blips**: Customizable blip colors and text for police and EMS.
- **Dynamic Updates**: Real-time updates of player and vehicle locations.

## Installation

1. **Download or clone** this repository.
2. **Place** the `racher-gps` folder in your `resources` directory.
3. **Add** `start racher-gps` to your `server.cfg` file.
4. **Add** the GPS item to your QBcore inventory system.

## Configuration

The configuration is done via `config.lua` and includes:

- **Locales**: Customizable text for GPS-related messages.
- **Blip Settinracher**: Different scales for various blip types.
- **Departments**: Configure police and EMS departments.

### Example Configuration

```lua
Config = {}

Config.Locales = {
    gps_item_check = "GPS item:",
    input_header = "GPS Number and Department Selection",
    submit_text = "Submit",
    gps_number_prompt = "Enter GPS Number",
    department_prompt = "Select Department",
    select_department = "Select Your Department",
    not_police_or_doctor = "You are not a Police Officer or Doctor",
    no_gps = "No GPS found!",
    gpsOpen = "GPS Opened",
    gpsClose = "GPS Closed",
    gpsError = "GPS Couldn't Open",
    jobDutyMessage = "You were taken off duty because you were injured"
}

Config.BlipSettinracher = {
    normal_blip_scale = 0.85,
    flashing_blip_scale = 0.6,
    dead_blip_scale = 1.0,
    police_blip_scale = 0.3
}

Config.PoliceDepartments = {
    { value = "pd", text = "LSPD" },
    { value = "sd", text = "BCSO" }
}

Config.EMSDepartment = {
    { value = "ems", text = "EMS" }
}
```

## Usage

1. **Add GPS Item**: Ensure that the GPS item is added to your QBcore inventory system.
2. **Open GPS**: Use the in-game GPS item to open the GPS interface. If you have the item and are in a valid job (police or EMS), you can enter the required information.
3. **Close GPS**: Use the GPS item to close the GPS if it is currently active.

## Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests for any improvements or bug fixes.






