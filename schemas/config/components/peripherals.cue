package components

#Peripheral: {
	type: "RobotSensor"
	hostname: string
}

#Peripherals: {
	[=~"^*"]: #Peripheral
}
