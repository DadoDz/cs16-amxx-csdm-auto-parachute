#include <amxmodx>
#include <reapi>

#define PLUGIN "[CSDM] Auto Parachute"
#define VERSION "1.0"
#define AUTHOR "DadoDz"

new parachute_ent[33];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	RegisterHookChain(RG_CBasePlayer_PreThink, "OnPlayerPreThink", false);
}

public client_putinserver(id) remove_parachute(id);
public client_disconnected(id) remove_parachute(id);

public OnPlayerPreThink(id)
{
	if (!is_user_alive(id))
		return;

	if (get_entvar(id, var_button) & IN_USE)
	{
		if (!(get_entvar(id, var_flags) & FL_ONGROUND))
		{
			new Float:velocity[3];
			get_entvar(id, var_velocity, velocity);

			if (velocity[2] < 0.0)
			{
				if (!is_entity(parachute_ent[id]))
				{
					parachute_ent[id] = rg_create_entity("info_target");

					if (is_entity(parachute_ent[id]))
					{
						set_entvar(parachute_ent[id], var_movetype, MOVETYPE_FOLLOW);
						set_entvar(parachute_ent[id], var_aiment, id);
					}
				}

				if (is_entity(parachute_ent[id]))
				{
					velocity[2] = (velocity[2] + 40.0 < -100.0) ? velocity[2] + 40.0 : -100.0;
					set_entvar(id, var_velocity, velocity);

					set_entvar(parachute_ent[id], var_sequence, 1);
					set_entvar(parachute_ent[id], var_frame, get_entvar(parachute_ent[id], var_frame) + 1.0);
				}
			}
		}
		else
			remove_parachute(id);
	}
	else if (get_entvar(id, var_oldbuttons) & IN_USE)
		remove_parachute(id);
}

public remove_parachute(id)
{
	if (is_entity(parachute_ent[id]))
	{
		rg_remove_entity(parachute_ent[id]);
		parachute_ent[id] = 0;
	}
}