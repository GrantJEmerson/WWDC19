/*:
 # DOMPEL
 
 ## What is Dompel? 🤷‍♂️
 
 **Dompel** is an interactive 3D (or binaural) audio experience that allows for the positioning of various instruments or tracks in the real world environment. **Augmented reality** is utilized to mesh the visual and audible reference points of sound in 3D space.
 
 ## How to Use Dompel 🔊
 
 * First, in order to open Dompel, tap the “Run My Code” button in the lower righthand corner of the screen.
 * Next, grant Dompel access to your camera so that it may place objects in augmented reality.
 * Dompel starts with a tinted overlay containing two key instructions. The primary instruction is to connect and put on headphones. Although Dompel can be experienced with the iPad’s built in speakers, the 3D effect is extremely limited without headphones. After connecting headphones, the next instruction is to scan a large section of your surroundings. The ideal amount of space is at least 3x3 ft. or 1x1 M. The iPad needs to add feature points on the floor so that it can orient itself properly. Wave the iPad slowly, face down over the floor until you start to see small yellow dots appear. The tinted overlay will disappear after scanning has completed. The overlay may reappear later in Dompel’s duration if the iPad loses track of its orientation.
 * Once the main interface of Dompel is visible, direct your attention to the “MAPPER” section.
     * This is where you will add various tracks/speakers.
     * Each of the 12 circles represents a speaker that can be placed in augmented reality and the audio environment.
     * A 3D head in the center of the “MAPPER” section rotates as you move the iPad around. The head is always oriented towards the speaker circle you are currently facing in AR.
     * Tap on the circle the 3D head is currently facing.
     * A pop up will appear containing a list of tracks that you can select and add.
     * After choosing a track, you will be presented with a list of colors. Choose a color for the “node” that will be added. A node consists of an AR speaker and the actual audio source (represented with circles in the “MAPPER” section).
     * Upon tapping “done,” you should see a speaker pop up directly in front of you.
 * Once the speaker is added, direct your attention to the section to the right of the “MAPPER”, titled with the track you just selected.
     * This contains two controls for the node you just added.
     * This first is a slider that controls the vertical position of the node.
     * The second is a volume slider to control the volume of the node in the mix.
 * After adjusting your new node’s settings, have fun and explore the rest of Dompel!
     * The last section in the editor slide out is “REVERB.” You can adjust the gain of the reverb on the mix and change the size of the space the reverb is modeling.
     * If at any point the sphere containing all your speakers in ARKit disappears or slides away, hit the “RESET” button in the upper righthand corner. This will allow you to rescan the environment.
     * Lastly, try other experiences by clicking on the “EXPERIENCES” button in the upper lefthand corner. Dompel has five experiences including: Big Band Jazz, Indie Soul, Country, Grungey Blues Rock, and Acoustic Jazz. Warning, selecting a new experience will clear the “MAPPER” section.
 * I hope you have as much fun exploring Dompel as I had making it!
 
 
 ## Source Attributions
 
 * Recordings (Thanks Cambridge MT!)
     * Mixing Secrets For The Small Studio (Cambridge Music Technology), www.cambridge-mt.com/ms-mtk.htm#Abletones_CorineCorine.
     * Mixing Secrets For The Small Studio (Cambridge Music Technology), www.cambridge-mt.com/ms-mtk.htm#thelvnguage_KingsAndQueens.
     * Mixing Secrets For The Small Studio (Cambridge Music Technology), www.cambridge-mt.com/ms-mtk.htm#AngelaThomasWade_MilkCowBlues.
     * Mixing Secrets For The Small Studio (Cambridge Music Technology), www.cambridge-mt.com/ms-mtk.htm#NeonHornet_TakeItOff.
     * Mixing Secrets For The Small Studio (Cambridge Music Technology), www.cambridge-mt.com/ms-mtk.htm#JesperBuhlTrio_WhatIsThisThingCalledLove.
 * Design, Mad Mouse. “Male Head.” 3D Models and Textures | TurboSquid.com, 18 Mar. 2007, www.turbosquid.com/3d-models/male-head-obj/346686.
 
 👂🎧✌️
 */

//#-hidden-code
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.wantsFullScreenLiveView = true

if #available(iOS 12.0, *) {
    let viewController = MainViewController()
    PlaygroundPage.current.liveView = viewController
}
//#-end-hidden-code
