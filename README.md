# my-azerothcore-settings
Settings and docs for azerothcore with playerbots

## Server settings

### Mods:
- [mod-playerbots](https://www.azerothcore.org/catalogue#/details/138432861)
- [mod-ah-bot](https://www.azerothcore.org/catalogue#/details/646926161)

### Updates:

To update, `git pull` then `cd build` and `. ./build.sh` 

auth- and worldserver scripts under `~/azerothcore/build/src/server/apps`

Conf files at `~/azerothcore-wotlk/env/dist/etc` and module specific ones inside `modules` folder in that directory.

### Scripts:

- `start-azeroth.sh`: Starts auth- and worldserver on tmux sessions;
- `stop-azeroth.sh`: Graciously stops each server;
- `stop-world.sh` and `stop-auth.sh`: Graciously stops respective servers;
- `attach-world.sh` and `attach-auth.sh`: Attaches to the respective tmux sessions;
