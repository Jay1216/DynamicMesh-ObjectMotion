/*--------------------------------*- C++ -*----------------------------------*\
| =========                 |                                                 |
| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |
|  \\    /   O peration     | Version:  2.4.0                                 |
|   \\  /    A nd           | Web:      www.OpenFOAM.org                      |
|    \\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       volScalarField;
    location    "0";
    object      omega;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

dimensions      [0 0 -1 0 0 0 0];

internalField   uniform 10.; 

boundaryField
{
    cylinder
    {
        type            omegaWallFunction;
        value           uniform 10.;
        blending        exponential;
    }
    inlet
    {
        type            codedFixedValue;
        value           uniform 10;
        
        name    inlet;

        codeInclude
        #{
            #include "fvCFD.H"
        #};

        codeOptions
        #{
            -I$(LIB_SRC)/finiteVolume/lnInclude \
            -I$(LIB_SRC)/meshTools/lnInclude
        #};
        codeLibs
        #{
            -lfiniteVolume \
            -lmeshTools
        #};
        code
        #{
            const fvPatch& boundaryPatch = patch();
            const vectorField& Cf = boundaryPatch.Cf();
            scalarField& field = *this;
            scalar t = this->db().time().value(); 
            forAll(Cf, faceI)
            {
                if (Cf[faceI].z() >= 0.035)
                {
                    if (t <= 16)
                    {   
                        field[faceI] = 10
                                       *pow((t/16)*(t/16)*1.3456e-4, 0.5)
                                       /(0.09*0.1*0.5);
                    }
                    else
                    {
                        field[faceI] = 10*pow(1.3456e-4, 0.5)/(0.09*0.1*0.5);
                    }
                 }
                 else
                 {
                     field[faceI] = 10;
                 }
            }
        #};
    }
    outlet
    {
        type            zeroGradient;
    }

    lateralfront
    {
        type            zeroGradient;
    }
    lateralback
    {
        type            zeroGradient;
    }
    surface
    {
        type            zeroGradient;
    }
    bottom
    {
        type            omegaWallFunction;
        value           uniform 10.;
        blending        exponential;
    }
}


// ************************************************************************* //
