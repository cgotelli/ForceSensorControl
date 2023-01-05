# Force Sensor Recorder

This MATLAB script gets the voltage input from a force sensor connected to a National Instruments (TM) USB-6001 DAQ USB Device and records it in a Logfile. It also gives the option of showing the evolution in time. It requires MATLAB's Data Acquisition Toolbox to work.

## How to use the script

The code must be executed in three steps. The first sets the parameters, the second launches the recording process, and the last one closes the file and clears the workspace. Below there is a detailed explanation of the process: 

1. First we need to set the parameters for the acquisition process:
  - **twindow**: The size of the window (in seconds) over the data will be averaged,
  - **drate**: The frequency of the sensor,
  - **SavePath**: The path where to save the logfiles,
  - **plotting**: Decide if we want to see in real time the evolution of the signal.

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

