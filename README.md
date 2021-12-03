# discord-relay
A discord chat relay for Garry's Mod

# Getting Started
- Clone the repository
```
git clone https://github.com/wildflowericecoffee/discord-relay.git
```
- Move addon folder

Move the `DiscordRelay` addon to your Garry's Mod server's addons folder.
- Install dependencies

On the `web` folder, run
```
cd <project_name>
yarn install
```
- Create a Discord bot

Make an application at https://discord.com/developers/applications, invite it to your server and copy the bot token.
- Configuration

Rename the `.json.example` files to `.json` and fill out the config variables
| Config Variable 	| Description                                           	|
|-----------------	|-------------------------------------------------------	|
| WSS_SECRET      	| A randomly generated secret used for authentication.  	|
| PORT            	| The port to run the websocket server on.              	|
| BOT_TOKEN       	| A Discord bot token.                                  	|
| CHANNEL_ID      	| The channel ID of where the messages will be relayed. 	|
| WEBHOOK         	| A Discord webhook of to post messages.                	|
- Start the websocket server
```
yarn build && yarn start
```
