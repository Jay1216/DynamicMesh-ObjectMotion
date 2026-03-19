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
    object      epsilon;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

dimensions      [0 2 -3 0 0 0 0];

internalField    uniform 1e-3; 

boundaryField
{
    cylinder
    {
	type epsilonWallFunction;
	value uniform 10;
    }
    inlet
    {
        type         fixedValue;
        value        uniform 1;           
        type            codedFixedValue;

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
                 if (t <= 16)
                 {
                     field[faceI] = pow((t/16)*(t/16)*1.3456e-4, 1.5)/(0.1*0.5);
                 }
                 else
                 {
                     field[faceI] = pow(1.3456e-4, 1.5)/(0.1*0.5);
                 }
            }
          #};
          value           uniform 10;
    }
    outlet
    {
//        type            cyclic;
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
    bottom
    {
	type            zeroGradient;
    }
    surface
    {
        type            zeroGradient;
    }
}


// ************************************************************************* //
