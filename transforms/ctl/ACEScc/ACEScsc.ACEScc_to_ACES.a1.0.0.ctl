//
// ACES Color Space Conversion - ACEScc to ACES
//
// converts ACEScc (AP1 w/ ACESlog encoding) to 
//          ACES2065-1 (AP0 w/ linear encoding)
//

// *-*-*-*-*-*-*-*-*
// ACEScc is intended to be transient and internal to software or hardware 
// systems, and is specifically not intended for interchange or archiving.
// ACEScc should NOT be written into a container file in actual implementations!
// *-*-*-*-*-*-*-*-*



import "ACESlib.Transform_Common.a1.0.0";



float ACEScc_to_lin( input varying float in)
{
  float out;
  
  // denormal transition (log2( pow(2.,-15.)*0.5)+9.72)/17.52
  if (in < -0.3013698630) 
    out = ( pow( 2., in*17.52-9.72) - pow( 2.,-16.))*2.0;
  else 
    out = pow( 2., in*17.52-9.72);
  
  return out;
}



void main
(   
    input varying float rIn,
    input varying float gIn,
    input varying float bIn,
    input varying float aIn,
    output varying float rOut,
    output varying float gOut,
    output varying float bOut,
    output varying float aOut
)
{
    float ACEScc_lin[3];
    ACEScc_lin[0] = ACEScc_to_lin( rIn);
    ACEScc_lin[1] = ACEScc_to_lin( gIn);
    ACEScc_lin[2] = ACEScc_to_lin( bIn);

    float ACES[3] = mult_f3_f44( ACEScc_lin, AP1_2_AP0_MAT);

    // this clamp prevents ACEScc values > 1.4679962397 from producing NaNs
    ACES = clamp_f3( ACES, HALF_NEG_INF, HALF_MAX);
  
    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}