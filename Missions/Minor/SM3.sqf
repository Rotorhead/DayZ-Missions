private ["_coords","_iArray","_nearby","_index","_num","_itemType","_itemChance","_weights","_wait","_dummymarker","_nul"];
_wait = [600,300] call fnc_hTime;
sleep _wait;
[nil,nil,rTitleText,"Hillbillies have moved into the area!", "PLAIN",6] call RE;
[nil,nil,rGlobalRadio,"Hillbillies have moved into the area!"] call RE;
[nil,nil,rHINT,"Hillbillies have moved into the area!"] call RE;

_coords =  [getMarkerPos "center",0,12000,10,0,20,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["Rednecks", _coords];
_dummymarker setMarkerColor "ColorRed";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [75,75];

baserunover = createVehicle ["land_housev_1i4",[(_coords select 0) +2, (_coords select 1)+5,-0.3],[], 0, "CAN_COLLIDE"];
baserunover2 = createVehicle ["land_kbud",[(_coords select 0) - 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
baserunover3 = createVehicle ["land_kbud",[(_coords select 0) - 7, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

[[(_coords select 0) - 20, (_coords select 1) - 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;
[[(_coords select 0) + 20, (_coords select 1) + 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;

if (isDedicated) then {

  _num = round(random 5) + 1;
	_itemType =		[["FN_FAL", "weapon"], ["bizon_silenced", "weapon"], ["M14_EP1", "weapon"], ["BAF_AS50_scoped", "weapon"], ["MakarovSD", "weapon"], ["Mk_48_DZ", "weapon"], ["M249_DZ", "weapon"], ["DMR", "weapon"], ["", "military"], ["", "medical"], ["MedBox0", "object"], ["NVGoggles", "weapon"], ["AmmoBoxSmall_556", "object"], ["AmmoBoxSmall_762", "object"], ["Skin_CamoWinter_DZN", "magazine"], ["Skin_CamoWinterW_DZN", "magazine"], ["Skin_Sniper1_DZ", "magazine"], ["Skin_Sniper1W_DZN", "magazine"]];
	_itemChance =	[0.02,					 0.05,							 0.05, 					0.01, 				0.03, 						0.02, 					0.03, 				0.05, 				0.1, 				0.1, 			0.2, 						0.07, 					0.01, 							0.01, 							0.08, 								0.05, 								0.08, 								0.05];
	
	waituntil {!isnil "fnc_buildWeightedArray"};
	
	_weights = [];
	_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
	//diag_log ("DW_DEBUG: _weights: " + str(_weights));	
	for "_x" from 1 to _num do {
		//create loot
		_index = _weights call BIS_fnc_selectRandom;
		sleep 1;
		if (count _itemType > _index) then {
			//diag_log ("DW_DEBUG: " + str(count (_itemType)) + " select " + str(_index));
			_iArray = _itemType select _index;
			_iArray set [2,_coords];
			_iArray set [3,5];
			_iArray call spawn_loot;
			_nearby = _coords nearObjects ["WeaponHolder",20];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};
	};
};

waitUntil{{isPlayer _x && _x distance baserunover < 300  } count playableunits > 0}; 
if ({isPlayer _x && _x distance baserunover < 200  } count playableunits > 0) then {
	_nul = [objNull, _x, rSAY, "hillbilly"] call RE; // This is a RPC sound call for the voices
};

waitUntil{{isPlayer _x && _x distance baserunover < 20  } count playableunits > 0}; 

[nil,nil,rTitleText,"You survived the rape attempt! Loot their corpses!", "PLAIN",6] call RE;
[nil,nil,rGlobalRadio,"You survived the rape attempt! Loot their corpses!"] call RE;
[nil,nil,rHINT,"You survived the rape attempt! Loot their corpses!"] call RE;

deleteMarker _dummymarker;

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";