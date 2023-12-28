/*
 * Filter Coefficients (C Source) generated by the Filter Design and Analysis Tool
 * Generated by MATLAB(R) 9.14 and Signal Processing Toolbox 9.2.
 * Generated on: 08-Apr-2023 00:27:23
 */

/*
 * Discrete-Time IIR Filter (real)
 * -------------------------------
 * Filter Structure    : Direct-Form II, Second-Order Sections
 * Number of Sections  : 16
 * Stable              : Yes
 * Linear Phase        : No
 */

/* General type conversion for MATLAB generated C-code  */
#include "tmwtypes.h"
/* 
 * Expected path to tmwtypes.h 
 * C:\Program Files\MATLAB\R2023a\extern\include\tmwtypes.h 
 */
#define MWSPT_NSEC 33
const int NL[MWSPT_NSEC] = { 1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,2,1 };
const real64_T NUM[MWSPT_NSEC][3] = {
  {
     0.3389776648187,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.3104157559545,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.2866364468081,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.2667330860552,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.2500128955107,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.2359409019499,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
      0.224100397256,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.2141646591604,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.2058764776367,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
      0.199033183732,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.1934756230004,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.1890800069036,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
      0.185751905217,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.1834218681245,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.1820423246782,                 0,                 0 
  },
  {
                   1,                 2,                 1 
  },
  {
     0.4261285231005,                 0,                 0 
  },
  {
                   1,                 1,                 0 
  },
  {
                   1,                 0,                 0 
  }
};
const int DL[MWSPT_NSEC] = { 1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,2,1 };
const real64_T DEN[MWSPT_NSEC][3] = {
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.5516030349634,   0.9075136942381 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.5051255314315,   0.7467885552495 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.4664305362864,   0.6129763235188 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,   -0.434042696801,   0.5009750410218 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.4068346863427,   0.4068862683855 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3839359671593,   0.3276995749589 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3646684489642,   0.2610700379882 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3485004713747,   0.2051591080165 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3350134881386,   0.1585193986854 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3238777052279,   0.1200104401557 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3148341378054,  0.08873662980712 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3076813503766,  0.06400137799095 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.3022656809047,  0.04527330177255 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.2984741168427,  0.03216158934075 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,  -0.2962292481364,   0.0243985468491 
  },
  {
                   1,                 0,                 0 
  },
  {
                   1,   -0.147742953799,                 0 
  },
  {
                   1,                 0,                 0 
  }
};