float toff_unit = 2.0;
float ton_unit = 1.0;

switch( integer lights_on )
{
    llSetPrimitiveParams( [ PRIM_FULLBRIGHT, ALL_SIDES, lights_on  ] );
}

default
{
    state_entry()
    {
        llSetTimerEvent(toff_unit);
        switch( FALSE );
    }

    timer() { state lightOn; }
}

state lightOn
{
    state_entry()
    {
        llSetTimerEvent(ton_unit);
        switch( TRUE );
    }

    timer() { state default; }
}
