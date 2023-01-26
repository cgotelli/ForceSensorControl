# Force Sensor Recorder

This repository contains MATLAB scripts for using a force sensor connected to a National Instruments (TM) USB-6001 DAQ USB Device. One file gets the voltage signal and records it into a Logfile, while the second computes the sediment transport rate time series. Both files offer different visualization options that are explained inside each script. 

> :warning: It requires MATLAB's Data Acquisition Toolbox to work.

## Recording the signal into a Logfile

### How to use the script `forceSensor.m`

The script must be executed in three steps. The first step sets the parameters, the second launches the recording process, and the last one closes the file and clears the workspace. Below there is a detailed explanation of the process: 

1. First we need to set the parameters for the acquisition process:
  - **twindow:** [integer] The size of the window (in seconds) over the data will be averaged,
  - **drate:** [integer] The frequency of the sensor,
  - **SavePath:** [string] The path where to save the logfiles,
  - **plotting:** [boolean] Decide if we want to see in real time the evolution of the signal.

2. Then we need to compute the first section of the code. For that look for the code shown below and press the button "Run Section", or pose the cursor on the section and press `Ctrl + Enter`.

```MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      EXECUTE THIS SECTION FIRST                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

As the recording has no fixed duration, it is necessary to manually "kill" the process once we want to stop it. For doing it, we just need to press the red button "Stop" or go in the Command Window and press `Ctrl + C`.

3. Finally, we have to execute the second section of the code by doing the same as in the first step. In this case we need to find the following code in the script:
```MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           EXECUTE THIS SECTION SECOND (AFTER PRESSING CTRL + C)         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

## Building the bed load timeseries from the recorded signal

This code processes at the same time all the Logfiles that are stored in one folder. Then, it computes the sediment transport rate at the specified frequency[^1] and builds time series of both transport rate and accumulated transport for the single experiment represented by these files. It is executed in one step, however, it requires to set the parameters before running it. Their explanation can be found below:

- **filesPath:** [string] Where the Logfiles are stored,
- **plotSedRate:** [boolean] Plot sediment rate timeseries for each file,
- **plotCumSed:** [boolean] Plot accumulated sediment timeseries for each file,
- **plotBoth:** [boolean] Plot the smoothed series in addition to the original,
- **originalTimeWindow:** [integer] What is the frequency at which the data was written in the logfile,
- **newTimeWindow:** [integer] The frequency at which the smoothness will be performed.


[^1]: This value should small enough to capture the smallest possible variation, but sufficiently big to smooth out variations caused by the movement of the sensor caused by external forces (like the water falling inside the basket).
