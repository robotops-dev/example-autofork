# example-autofork

This is a simple example of how to use RobotOps.

## Setup

Obtain the RobotOps CLI and install it.

Optionally enable tab completion for the RobotOps CLI by adding the following to your `.bashrc` or `.zshrc`:

```bash
eval "$(robotops completion bash)"
```

## Local Validation

To validate the configuration file locally, run the following command:
```bash
robotops verify -l schemas/config customers/mxl-shipping/autoFork1.json
```

The output should be:
```bash
Status: VALID
```

Now try validating an invalid configuration file:
```bash
robotops verify -l schemas/config customers/mxl-shipping/autoFork2.json
```

you should see:
```bash
Status: INVALID
Details:
#config.vision.workflows.0: 2 errors in empty disjunction:
#config.vision.workflows.0.model: conflicting values "tensorflowV1" and "tensorFlowV1":
    7:18
    ./schemas/config/components/vision.cue:12:9
    ./schemas/config/components/vision.cue:23:12
    ./schemas/config/components/vision.cue:27:17
    ./schemas/config/components/vision.cue:27:20
    ./schemas/config/config.cue:6:10
#config.vision.workflows.0.type: conflicting values "Calibration" and "ObstacleDetection":
    6:17
    ./schemas/config/components/vision.cue:18:8
    ./schemas/config/components/vision.cue:23:41
    ./schemas/config/components/vision.cue:27:17
    ./schemas/config/components/vision.cue:27:20
    ./schemas/config/config.cue:6:10
```

notice that both errors complain about `config.vision.workflows.0.type` and refer to the `vision.cue` file.

In `vision.cue` the vision block is described as:

```cue
#Workflow: #ObstacleDetectionWorkflow | #CalibrationWorkflow

#Vision: {
    sensor:  "ifm" | "realsense"
    workflows: [...#Workflow]
}
```

This means "vision" should have a list of workflows, and each workflow should be either a `ObstacleDetectionWorkflow` or a `CalibrationWorkflow`.

The error above is explaining that the first workflow in the list is invalid because doesn't match the expected format of either `ObstacleDetectionWorkflow` or `CalibrationWorkflow`.

The definition for the ObstacleDetectionWorkflow is:

```cue
#ObstacleDetectionWorkflow: #WorkflowProto & {
	type: "ObstacleDetection"
	model: "tensorflowV1"
	filters: #WorkflowFilters
	velocity_factor: float | *0.5
}
```

Notice that `model` should be `tensorflowV1`, not `tensorFlowV1`. Fix that and re-run the validation command:

```bash
Status: VALID
```

## Remote Validation

Browse to `https://app.robotops.dev` (or your own self-hosted instance) and login with your Google account. Create a new organization.

Click `API Keys` and create a new key. Copy the key and save it in a safe place. You will not be able to see it again.

In your shell, export the key as `ROBOTOPS_API_KEY`:

```bash
export ROBOTOPS_API_KEY=<orgname>:<api-key>
```

## Upload the schema

```bash
robotops schema upload -p schemas/config -v v0.1.0

```
Now you can validate the configuration file remotely:

```bash
robotops verify -v v0.1.0 customers/mxl-shipping/autoFork1.json
# Sending HTTP POST request https://validator.robotops.dev/organization/autofork/schema/validate ...
# Response status: 200 OK
# Status: VALID
```