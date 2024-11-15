# Godot.bot
A simple websocket integration between Godot and Streamer.bot


## Instructions
The godot project itself is pretty plug and play. All you need is to setup the streamer.bot side now.

### Server initialization
![Streamerbot1](https://github.com/user-attachments/assets/f6190448-424b-4498-987b-617b5f92f9e4)

You can change the address and port if you want. But make sure to change ***websocket_url*** value in ***Connection.gd*** as well.

### Setting up events

![Streamerbot2](https://github.com/user-attachments/assets/cd9a2354-e068-49da-beb5-562067c62aa7)

Things in actions and triggers are your choice but the execute C# code in the sub-actions is what i'm using to send messages from streamer.bot to godot.
So this is extremly important.
Here are some example code,

This one sends the name of the user and their message to godot.
```
using System;
using Newtonsoft.Json.Linq;

public class CPHInline
{
    public bool Execute()
    {
        CPH.TryGetArg("user", out string user);
        CPH.TryGetArg("message", out string message);


        JObject data = new JObject(
            new JProperty("event", "Chat_Message"),
            new JProperty("user", user),
            new JProperty("message",message)
        );

        CPH.WebsocketBroadcastJson(data.ToString());
        return true;
    }
}
```
Meanwhile this one just sends the username of the newly followed user.
```
using System;
using Newtonsoft.Json.Linq;

public class CPHInline
{
    public bool Execute()
    {
        CPH.TryGetArg("user", out string user);


        JObject data = new JObject(
            new JProperty("event", "New_Follow"),
            new JProperty("user", user)
        );

        CPH.WebsocketBroadcastJson(data.ToString());
        return true;
    }
}
```
![Streamerbot3](https://github.com/user-attachments/assets/aaa59b7c-1296-4919-92df-94dd36ca5b4f)


In the Connection.gd script we simply check the value of the "event" variable.
If you want to add new events change the c# script in sub-action and just check the newly used event name in this script like this.


>This should be enough to get you started. I'm working on a simple tutorial explaining this. When it's done I'll post the link in this. 
If you have any issues raise them in github and i'll try to help you if i can.
>Cheers!
