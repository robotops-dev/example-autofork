package components

#WorkflowFilters: {}

#WorkflowProto: {
	type: string
	...
}

#ObstacleDetectionWorkflow: #WorkflowProto & {
	type: "ObstacleDetection"
	model: "tensorflowV1"
	filters: #WorkflowFilters
	velocity_factor: float | *0.5
}

#CalibrationWorkflow: #WorkflowProto & {
	type: "Calibration"
	style: *"leastSquares" | "intrinsic"
	fov: float | *0.6
}

#Workflow: #ObstacleDetectionWorkflow | #CalibrationWorkflow

#Vision: {
    sensor:  "ifm" | "realsense"
    workflows: [...#Workflow]
}
