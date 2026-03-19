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
    object      k;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

dimensions      [0 2 -2 0 0 0 0];

internalField     uniform 1e-10;

boundaryField
{
    cylinder
    {
        type            kqRWallFunction;
        value           uniform 1e-10;
    }
    inlet
    {
        type            codedFixedValue;
        value           uniform 1e-10;
        
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
                 if (t <= 79)
                 {
                     field[faceI] = (t/79)*(t/79)*8.464e-5;
                 }
                 else
                 {
                     field[faceI] = 8.464e-5;
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
    bottom
    {
        type            kqRWallFunction;
        value           uniform 1e-10;
    }
    surface
    {
        type            zeroGradient;
    }
}


// ************************************************************************* //
