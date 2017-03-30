# MyoSurgeon
MyoConnect app for playing Surgeon Simulator 2013

This project was designed as part of a course on gesture based user interfaces. The sole script in this repository is
for use with Thalmic's MyoConnect application and Surgeon Simulator 2013. As part of the project, a writeup was to be included detailing the development process, as well as any insight gained regarding the development for
alternative gesture based software. Included in this readme is the writeup, as it contains details for using this script, take note that it also 
contains extraneous information regarding another implementation of this same script using the MyoSharp C# wrapper for the Myo.


 
## Objective 
The project is an application that listens for Myo input then sends the appropriate keypresses and mouse movement to the Surgeon Simulator 2013 game window. It needs to be as unobtrusive as possible, and should only send input to Surgeon Simulator if it is the window in focus.  
 
## Controlling the Game 
Due to the way key bindings are handled in game, it's very limiting in how arm movement and gestures can be used. The game was deliberately designed to make controlling the in game arm difficult. Each finger is controlled by an individual key. The key bindings are as follows: 
 
### Keyboard 
 - 'A' - Pinky Finger 
 - 'W' - Ring Finger 
 - 'E' - Middle Finger 
 - 'R' - Index Finger 
 - 'SPACEBAR' - Thumb 
 
### Mouse 
 - Movement - Moves the arm 
 - Left Click - Lowers the arm 
 - Right Click - Toggles rotating the arm and angling the hand 
 
The player is left with a few basic actions that are achieved through combining these controls. The most important action would be grabbing and holding items. This is accomplished by holding the left mouse button (to lower the arm down to the item), and holding A+W+E+R+SPACEBAR. While holding the object (by keeping a, w, e, r, space pressed) the player moves the arm about, and using items is typically just a case of swinging them or hitting the patient with them.  
 
Converting gestures to key events is easy enough, making a fist could send key hold events for all fingers, and relaxing the hand could release the grip. Handling movement of the arm itself was more difficult, and resulted in the abandonment of the original Winforms application in favor of a MyoConnect Lua script. 
  
## The Winforms Application 
Getting the application to behave as a tray application took a small bit of research, but getting a winform to run as a tray application was simple. Setting up a run context and adding it to the tray was done using a few lines of code. From there the MyoSharp and Myo DLL files were added and referenced. Example code provided in the MyoSharp documentation was used to get the Myo registered in the application. 
The next task was to get a method for sending key press and hold signals for some basic game control. I found the normal usage of System.Windows.Forms.Sendkeys to provide basic key presses, but it lacked a workable key hold method. It could send a set of key down and key up signals, but this caused the hand to open, dropping anything that was held. 
My solution was to use an external library called InputSimulator, which also had a great implementation of mimicking mouse movements, which I ended up using as well. It allowed me to send a batch of single key down events to the operating system, allowing me to grab items, and then send a batch of key up events when I wanted to release the object. At this point I had a workable system of grabbing objects by closing my fist, from there I decided to work on moving the arm using arm movements, essentially converting accelerometer data to mouse movement. 
I found it to be the most difficult part of this project, mostly due to my limited knowledge of how accelerometers work. My first observation was the constant signal being sent to the three accelerometer planes on the Myo, based on orientation. The constant force of gravity on the Myo was sending causing my mouse to move as I angled and rotated my arm. After a fair amount of research on creating a low pass filter, I decided to focus on one plane of motion. Once I had an understanding of it, I could replicate the code and make the necessary changes for the other planes. With some experimentation I found that while wearing the Myo and pointing straight up, the X-Axis would read –1 (presumably G-force), and pointing straight down to cause a reading of ~1. Pitch, after converting to a 0-9 scale, reads as around 7 while pointing straight up, and roughly 2.5 while pointing straight down. I decided to move the center point of the pitch scale to 5 (by subtracting 5 from pitch), meaning 2.5 was the top of my scale and –2.5 the bottom. I then took the pitch being read in, divided it by my arbitrary scale (2.5) and added it to the current accelerometer input. I then had roughly 0g input when the arm is stationary regardless of the pitch of the arm. Now that I had (albeit relatively inaccurate) working accelerometer data on one axis, I needed to convert that to mouse movement. To start, I was just passing in the leftover accelerometer input to the InputSimulator mouse class. Unfortunately, inertia makes using the accelerometer for mouse movement a bit difficult. After moving the arm in one direction the accelerometer would read back the deceleration (as acceleration in the opposite direction). I needed to account for the deceleration when the arm stopped moving, or the mouse just returns to roughly where it started.  
 
After trying various methods for converting acceleration to velocity, and passing that velocity to InputSimulator to move the mouse and getting no real difference in behavior, I scrapped the idea of using the C# wrapper.  
 
## The MyoConnect Plug-in 
I rebuilt the application using a MyoConnect script, and after getting a basic understanding of Lua syntax found it to be very straight forward. MyoConnect simply registers the script and provides a rather thorough API for building applications for use with the Myo. The most notable feature I found was the ability to control the mouse with the Myo by simply passing a boolean to a predefined method. 
 
The API also has predefined callback methods for when the operating system sees a change in window focus, one that is called every ten milliseconds, and one for when a pose is made. The difficulty in converting the various available gestures into the intentionally obtuse controls is still an issue though, which probably also serves as a great analogy for wrapping legacy software. In terms of the functionality I am interested in that is offered by the Myo itself; there are 5 usable gestures and one axis of motion (roll) available (pitch and yaw control the mouse), leaving plenty of room for the 3 basic controls (grab/release, raise/lower arm, rotate arm). However, only one gesture can be sent at any given time. Meaning I had to resort to gestures that toggle actions in the game, because I can't hold a 'fist' gesture and use another one to raise and lower the arm while holding an object. 
In its final implementation, moving your arm moves the in game arm, and the following Myo poses control the game as follows: 
 
 - Grab - Toggles the grabbing in game 
 - Wave in -  Toggles raising or lowering the arm 
 - Wave out – Toggles rotating the arm and hand 

Even considering the poor controls provided from the start, the game is still very difficult to play using the Myo. The poor controls prevent using more intuitive motions and gestures to play the game. For instance, the original plan was to use orientation reported from the Myo to control the rotation of the arm. However, rolling the arm involves holding the right mouse button and moving the mouse, and moving the mouse is done by moving the arm. Sending a right click 'down' event would be easy enough given a certain threshold of roll being detected, but once the mouse down event is sent, all horizontal and vertical movement of the arm is prohibited. Then, assuming that works, mapping the left and right motion of the mouse during right click events, while filtering out intentional arm movement would make for a very cumbersome scheme for rotating the arm. 
 
One minor issue that was noticed regarding the Myo mouse feature, moving the hand using the Myo can still be somewhat challenging, even with Thalmic's solution to converting accelerometer data into mouse movement. Movement does not feel 1-to-1, even with the mouse sensitivity set to the maximum. This issue is more indicative of working with accelerometers though, and not an issue with software. 
 
## Conclusions 
There were a few key things to take away from this project. The first being just how difficult it can be to try and interface a new peripheral or device to software that was not designed with it in mind. It's very common lately to see new devices hit the market, and subsequently get added as a feature for a piece of software (most notably in gaming). Unfortunately in most cases the implementation feels clumsy and unfinished, but for software that was built with new technology at its core, the entire experience is completely different. It's hard to fully appreciate the difficulty with trying to coerce software into using a foreign piece of hardware is (from the software perspective) until you've had to do it yourself. 
As far as the Myo itself goes, the false poses and the noticeable lag time between poses in general makes converting fluid arm and hand movements into responsive software commands, very challenging. Hopefully this is improved through future updates and releases of the Myo, but until the hardware is more reliable, making software for it will be rather limited. 
 
 
 
 
