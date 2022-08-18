package config

import "autofork.com/config/components"

#config: {
	vision: components.#Vision
	peripherals: components.#Peripherals
	max_speed: float
	task: "ReserveToForward" | "InboundToReserve"
}
