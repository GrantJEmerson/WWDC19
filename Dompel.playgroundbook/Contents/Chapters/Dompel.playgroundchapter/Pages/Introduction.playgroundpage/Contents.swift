/*:
 ![Logo](DompelIconSM.png)
 ##### An interactive and immersive binaural audio experience that utilizes AR for the visual spacilization of virtual speakers placed within a user's immediate environment.
 - - -
 
 
 ## What is Binaural Audio? 🤔
 
 When discerning the meaning of unfamiliar words it’s always valuable to deconstruct them into their fundamental segments. The word “binaural” can be separated into two parts: “bi”, meaning 2, and “naural”, which refers to the outer part of a human ear. We can derive insight through a similar word, “binocular.” As you probably already know, binoculars clarify and magnify the visible realm. **Binaural audio** has a similar purpose; it clarifies the positioning of different sources on a soundscape. Binaural audio is a perfectly immersive, 3D audio recording that utilizes two microphones installed within the ears of a mannequin head. Through the reflection and attenuation of sound waves that occur surrounding a mannequin’s **auricula** (or outer ears), the recorded audio forms an identical match of the original signal that occurred in the actual live setting. In layman’s terms, this means that when you listen to a binaural audio recording through a pair of stereo headphones, it actually feels like you are in the physical space that the original recording took place. Although binaural audio is experienced through stereo headphones, it is quite different than stereo or even fancy surround sound systems. Both stereo and binaural audio are recorded through a dual microphone set up. However, stereo microphones only have a small amount of separating space , whereas binaural microphones mimic the spacing between two human ears. Surround sound is different from binaural audio because the latter is for a more compact, personal, and authentic soundscape.
 
 ![Mannequin Head Microphone](HeadMicrophone.png)
 
 The changes in sound frequencies, the decrease in volume, and the difference in time delay that occur due to the distance and anatomical density between the two ears of one’s head can all be represented by two distinct **HRTFs** or Head Related Transfer Functions. A head related transfer function, when applied to any signal, simulates a **head shadow** which includes the **ITDs** (Interaural Time Differences) and **ILDs** (Interaural Level Differences). Apple’s own media framework, **AVFoundation**, contains an HRTF. Many recent applications such as first person games and musical applications have incorporated this resource to create immersive experiences. For example, the playground you will be experiencing momentarily, **Dompel**, utilizes the high quality HRTF audio rendering algorithm.

 ![AVFoundation Code Sample](AVFoundationHRTFExample.png)
 
 
 ## Deconstructing an HRTF √👨‍💻
 
 To recap, a **Head Related Transfer Function** describes how sound is transformed by the various features of the listener’s head including obscure details such as the shape of their nostrils. This transformation can be represented by a continuous function of frequency adjustments where the domain of possible input frequencies depends upon the physical aspects of the listener. Just as an EQ on a sound system ducks the high or low ends of the music by filtering out unwanted frequencies, an HRTF filters out frequencies lost through the dampening effects of an environment. The outputs of each ear’s HRTF are called **monaural cues**. The differences in these cues is what allows for the innate mapping of sounds.
 
 ![HRTF Diagram](HRTF.png)
 
 The process of accurately recreating binaural audio through HRTFs on a computer has been a difficult task. As we’ve discussed so far, there are countless measurements of the listeners body that must be taken into consideration in order for binaural audio to be remotely believable. Fortunately, new discoveries in **digital signal processing** have opened up opportunities for non-mathematicians to work with binaural audio.
 
 First, we must understand how sound is encoded on a computer. Scientifically, sound is just the fluctuation of air pressure that occurs when the diaphragm of the sound source vibrates back and forth. A microphone is responsible for sampling and recording the surrounding pressure changes at an interval known as the **sample rate**. Although it varies between devices, the most common sample rate is 44,100 hertz (or times per second). These samples will ultimately create a discrete waveform that resembles the curved waves of the ocean.
 
 ![Digital Audio](DigitalAudio.png)
 
 When an HRTF is applied to this recorded waveform, a process known as convolution occurs. **Convolution** is simply the combination of two functions. In this case, the first is the original sound. The second would be what is known as the **Head Related Impulse Response**. An HRIR is the waveform recorded just outside the eardrums of a listener when a single click is played through a sound source. Basically, in convolution, each straight line sample of our recording is replaced by the HRIR waveform. The post-processing result will sound like it originated in the environment that the HRIR was recorded.

 
 ## Source Attributions
 - En.wikipedia.org. (2019). Head-related transfer function. [online] Available at: https://en.wikipedia.org/wiki/Head-related_transfer_function [Accessed 18 Mar. 2019].
 - En.wikipedia.org. (2019). Binaural recording. [online] Available at: https://en.wikipedia.org/wiki/Binaural_recording [Accessed 18 Mar. 2019].
 - Hooke Audio. (2019). What Is Binaural Audio - Hooke Audio. [online] Available at: https://hookeaudio.com/what-is-binaural-audio/
 - Immortal Mics. (2019). What is 3d Binaural Audio? - Immortal Mics. [online] Available at: https://www.immortalmics.com/what-is-3d-binaural-audio/.
 - By Aquegg - Own work, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=29599378
 - By The original uploader was Soumyasch at English Wikipedia. - Transferred from en.wikipedia to Commons., CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=3848567
 - By EJ Posselius - Flickr: *_X301277, CC BY-SA 2.0, https://commons.wikimedia.org/w/index.php?curid=25030807
 
 - - -

 ## [Next page](@next)
*/
