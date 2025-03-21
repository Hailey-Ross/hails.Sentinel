// Script Created by Hailey Enfield
// Site: https://u.hails.cc/Links
// Github: https://github.com/Hailey-Ross/hails.Sentinel
// PLEASE LEAVE ALL CREDITS/COMMENTS INTACT
// Avoid those that have wronged you in SL

integer debug = FALSE;         // THESE WILL SPAM YOU IF ENABLED
integer verbose_debug = FALSE; // THESE WILL SPAM YOU IF ENABLED

string scriptRGB = "hails.rgb";  // Name of the RGB script | https://github.com/Hailey-Ross/hails.rgb
string scriptBlink = "hails.blink"; // Name of the blinking script | https://github.com/Hailey-Ross/hails.Sentinel/blob/main/hails.blink.lsl

string firstID = "00000000-0000-0000-0000-000000000000"; // UUID of first avatar to monitor for
string secondID = "00000000-0000-0000-0000-000000000000"; // UUID of second avatar to monitor for

// LEAVE THE REST ALONE
// SERIOUSLY.
key blank = TEXTURE_BLANK;
key transp = TEXTURE_TRANSPARENT;
key alert = "2ad9598f-e66d-7835-753a-e734e0e24efa";
key request_id_name;
key request_id_online;
key id;
integer noSpammy;
integer scriptState;
string hailsAlert = "66abf077-3bb0-fc76-f209-8ad7317121ac";
string whotocheck;
string objdesc;
string hailsObjName;
string objOwner;

default
{
    on_rez(integer start_param) {
        llSleep(0.75); hailsObjName = "hails.Sentinel"; llSetObjectName(hailsObjName); llResetScript(); 
    }

    changed(integer change) {
        if (change & (CHANGED_OWNER | CHANGED_INVENTORY | CHANGED_REGION)) {
            llStopSound(); hailsObjName = "hails.Sentinel"; llSetObjectName(hailsObjName);
            if (debug) {  
                llOwnerSay(hailsObjName + " Now Rebooting. . ."); 
            }
            llSleep(0.75); llResetScript(); 
        }
    }

    state_entry() {    
        llStopSound();
        noSpammy = 0; 
        id = llGetOwner(); 
        objdesc = llGetObjectDesc();
        if (objdesc == "one") { whotocheck = firstID; } else if (objdesc == "two") { whotocheck = secondID; } else { whotocheck = objdesc; }
        objOwner = llKey2Name(id); hailsObjName = "hails.Sentinel"; llSetScriptState(scriptRGB, FALSE); 
        llSetScriptState(scriptBlink, TRUE); 
        llSetColor(<0.0, 0.0, 0.0>, ALL_SIDES); llSetTexture(blank, ALL_SIDES); llSetAlpha(0.1, ALL_SIDES);
        request_id_name = llRequestAgentData(whotocheck, DATA_NAME);
        if (debug) { 
            llOwnerSay(hailsObjName + " Initializing Silent Sentinel. . ."); 
        } 
        llSetTimerEvent(20); llSetObjectName(hailsObjName);
    }
    
    touch_start(integer num) { 
        llStopSound(); llSetObjectName(hailsObjName); llOwnerSay("Currently Monitoring: " + whotocheck); 
        llOwnerSay("Detach/Re-attach if Sentinel is not responding."); 
    } 

    timer() { 
        request_id_online = llRequestAgentData(whotocheck, DATA_ONLINE); hailsObjName = "hails.Sentinel";
    } 

    dataserver(key queryid, string data) {
        if (queryid == request_id_name) {
            if (debug) {  
                llOwnerSay("Initialization has completed successfully."); 
            }
            llOwnerSay("Sentinel is now Online\n Monitoring: " + data); hailsObjName= "hails.Sentinel";
        } else if (queryid == request_id_online) {
            if ((integer)data == 1) {
                if (verbose_debug) { 
                    llOwnerSay(hailsObjName + "Silent Sentinel has received an online status for UUID requested."); 
                }
                if (scriptState != 0) {
                    llSetScriptState(scriptBlink, TRUE); hailsObjName = "hails.Sentinel"; llSetScriptState(scriptRGB, FALSE);
                    if (verbose_debug) {  
                            llOwnerSay( "Set " + scriptRGB + " to 0 from " + (string)scriptState); 
                        }
                    scriptState = 0;
                }
                llSetTexture(blank, ALL_SIDES); hailsObjName = "hails.Sentinel"; llSetColor(<0.9, 0.0, 0.0>, ALL_SIDES); llSetAlpha(0.5, ALL_SIDES);

                if (llGetAgentSize(whotocheck)) { 
                    llSetColor(<1.0, 1.0, 0.2>, ALL_SIDES); llSetTexture(alert, ALL_SIDES); hailsObjName = "hails.Sentinel"; llSetAlpha(1.0, ALL_SIDES);
                    
                    if (noSpammy <= 1) {
                        noSpammy = 5; 
                        string regionName = llGetRegionName();
                        llLoopSound(hailsAlert, 0.9); hailsObjName = "hails.Sentinel"; llOwnerSay("Attention " + objOwner + ", Sensors have found " + llKey2Name(whotocheck) + " entering Sim " + regionName);
                    } else {
                        --noSpammy;
                        if (verbose_debug) {  
                            llOwnerSay(hailsObjName + " decrementing counter " + (string)noSpammy); 
                        }
                    }
                }
            } else {
                if (debug) {
                    if (noSpammy <= 1) { 
                        noSpammy = 10; 
                        //llOwnerSay(hailsObjName + " no status has been received back from Dataserver.");
                    } else { 
                        --noSpammy; 
                        if (verbose_debug) {  
                            llOwnerSay(hailsObjName + " decrementing counter " + (string)noSpammy); 
                        }
                    }
                }
                llStopSound(); llSetObjectName(hailsObjName);
                llSetTexture(blank, ALL_SIDES);
                if (scriptState != 1) {
                    llSetScriptState(scriptBlink, FALSE); 
                    llSetScriptState(scriptRGB, TRUE);
                    if (verbose_debug) {  
                            llOwnerSay( "Set " + scriptRGB + " to 1 from " + (string)scriptState); 
                        }
                    scriptState = 1;
                }
            }
        }
    }
}
