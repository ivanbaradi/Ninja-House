# Client to Client Communications

## Definition

### Client to Client Communications 
![Client-Client Diagram](/Screenshots/client-client-diagram2.png)<br>
- One-way passage between the client, server, and another client
- Represented as a RemoteEvent

### Client to Client Communications 2
![Client-Client Diagram](/Screenshots/client-client-diagram.png)<br>
- Two-way passage between the client, server, and another client
- Represented as a RemoteFunction
- Client expects data returned from another client in some cases

## Examples

### Client to Client Communications 

![Client-Client Pic](/Screenshots/client-client-ex3.png)<br>
Suppose that the player clicks the button to open the Account Stats menu and it needs to perform a sound effect.<br><br>

![Client-Client Pic](/Screenshots/client-client-ex2.png)<br>
The **Account Stats UI  Handler** LocalScript opens or closes the Account Stats menu when the player presses its button. From line 20, it fires the server passing the RemoteEvent named <code>Play Sound Effect</code> and sound effect properties.<br><br>


![Client-Client Pic](/Screenshots/client-client-ex.png)<br>
In this case, it is triggering a RemoteEvent called <code>Client-Client Communications</code> since it is working through an event, not a function.<br><br>


![Client-Client Pic](/Screenshots/client-client-ex6.png)<br>
The **Client-Client-Handler** Script retrieves the RemoteEvent's name and sound effect properties.
<br><br>

![Client-Client Pic](/Screenshots/client-client-ex4.png)<br>
In line 22, it retrieves that RemoteEvent from ReplicatedStorage and fires another client sending the targeted <code>player</code> and sound effect properties. <br><br>

![Client-Client Pic](/Screenshots/client-client-ex5.png)<br>
The **Play Sound Effect** LocalScript is responsible for playing sound effects at the player's screen. It also includes the <code>SoundEffects</code> Sound instance, which also serves as collection of sound effects. In the client event, it retrieves the sound effect's name and volume. <br><br>

![Client-Client Pic](/Screenshots/client-client-ex7.png)<br>
This script looks for a sound effect called **Button Clicked**. It sets <code>SoundEffects.SoundId</code> with Button Clicked's assetID and its volume to 1. Finally, the sound effect is played.<br><br> 

![Client-Client Diagram](/Screenshots/client-client-diagram3.png)<br>
This diagram represents the example explained above.
