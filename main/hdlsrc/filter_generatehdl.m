function filter_generatehdl(filtobj)
%  FILTER_GENERATEHDL   Function to generate HDL for filter object.
%  Generated by MATLAB(R) 9.14 and Filter Design HDL Coder 3.1.13.
%  Generated on: 2023-04-08 00:28:12
%  -------------------------------------------------------------
%  HDL Code Generation Options:
%  TargetLanguage: VHDL
%  OptimizeForHDL: on
%  TestBenchStimulus: step ramp chirp 
%  GenerateHDLTestbench: on
% 
%  Filter Settings:
%  Discrete-Time IIR Filter (real)
%  -------------------------------
%  Filter Structure    : Direct-Form II, Second-Order Sections
%  Number of Sections  : 16
%  Stable              : Yes
%  Linear Phase        : No

%  -------------------------------------------------------------

% Generating HDL code
generatehdl(filtobj, 'TargetLanguage', 'VHDL',... 
               'OptimizeForHDL', 'on',... 
               'TestBenchStimulus',  {'step', 'ramp', 'chirp'},... 
               'GenerateHDLTestbench', 'on');

% [EOF]
