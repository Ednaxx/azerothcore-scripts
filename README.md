# azerothcore-scripts
Settings, docs and scripts for azerothcore with playerbots

## Server settings

### Mods:
- [mod-playerbots](https://www.azerothcore.org/catalogue#/details/646926161)
- [mod-ah-bot](https://www.azerothcore.org/catalogue#/details/138432861)

### Overral setup:

- Set .env;

- First build: execute `build.sh`;

- Conf files usually go under `~/azerothcore/env/dist/etc` copy those over there (there should be some `.conf.dist` files there already. If not, it should be elsewhere). Don't forget to set to set `DataDir` to `"<full_path_to_source_code_dir>/build/data"`, because I'm lazy and didn't find a way to make the env var work;

- Download [Client Data](https://github.com/wowgaming/client-data/releases/) and unpack it on your DataDir;

- Auth- and worldserver entry scripts under `~/azerothcore/build/src/server/apps`;

- Conf files at `~/azerothcore-wotlk/env/dist/etc` and module specific ones inside `modules` folder in that directory.

### Updates:

To update, `git pull` on the server dir and run `build.sh` here. 

### Scripts:

- `build.sh`: Builds the server;
- `start-azeroth.sh`: Starts auth- and worldserver on tmux sessions;
- `stop-azeroth.sh`: Graciously stops each server;
- `stop-world.sh` and `stop-auth.sh`: Graciously stops respective servers;
- `attach-world.sh` and `attach-auth.sh`: Attaches to the respective tmux sessions;
- `start-world.sh` and `start-auth.sh`: Starts respective server;
- `backup-databases.sh`: Create db backups based on set environment variables;
- `restore-databases.sh`: Restores db backups based on set environment variables;
- `list-backups.sh`: Lists existing backups on `BACKUP_DIR` with datetime and size.
