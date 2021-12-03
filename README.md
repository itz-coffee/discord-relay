# discord-relay
A discord chat relay for Garry's Mod

![image](https://user-images.githubusercontent.com/36643731/144539412-3a7693ac-2b18-4759-af60-4e29b1bf40a0.png)

![image](https://user-images.githubusercontent.com/36643731/144539488-02d29799-e3f8-41dd-935e-c76d74392b2e.png)

# Requirements
- Garry's Mod
- [Node.js](https://nodejs.org)
- [GWSockets](https://github.com/FredyH/GWSockets)
- [Discord bot](https://discord.com/developers/applications)

# Getting Started
- Clone the repository
```
git clone https://github.com/wildflowericecoffee/discord-relay.git
```
- Move addon folder

Move the `addons` folder to your Garry's Mod addons folder.
- Install dependencies

On the `web` folder, run
```
cd web
yarn
```
- Configuration

Rename the `.json.example` files to `.json` and fill out the config variables
| Config Variable 	| Description                                           	|
|-----------------	|-------------------------------------------------------	|
| WSS_SECRET      	| A randomly generated secret used for authentication.  	|
| WSS_PORT        	| The port to run the websocket server on.              	|
| BOT_TOKEN       	| A Discord bot token.                                  	|
| CHANNEL_ID      	| The channel ID of where the messages will be relayed. 	|
| WEBHOOK         	| A Discord webhook of to post messages.                	|
- Start the websocket server
```
yarn build && yarn start
```
