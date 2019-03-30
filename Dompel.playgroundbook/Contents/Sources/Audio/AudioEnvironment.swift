//
//  Conductor.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import AVFoundation

@available(iOS 12.0, *)
public class AudioEnvironment {
    
    // MARK: Properties
    
    public static let shared = AudioEnvironment()
    
    private let engine = AVAudioEngine()
    private let environment = AVAudioEnvironmentNode()
    
    private var audioFiles = [String: AVAudioFile]()
    private var playerNodes = [String: AVAudioPlayerNode]()
    
    private var startTime: AVAudioTime?
    
    private var reset = false
    private var playing = true
    
    // MARK: Init
    
    public init() {
        setUpAudioEngine()
        setUpObservers()
    }
    
    // MARK: Selector Functions
    
    @objc private func clearPlayers() {
        for player in self.playerNodes.values {
            player.reset()
        }
        self.playerNodes.removeAll()
        self.audioFiles.removeAll()
        startTime = nil
        engine.disconnectNodeInput(environment)
    }
    
    // MARK: Private Functions
    
    private func setUpAudioEngine() {
        environment.listenerPosition = AVAudio3DPoint(x: 0, y: 0, z: 0)
        environment.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: 0, pitch: 0, roll: 0)
        
        environment.reverbParameters.enable = true
        environment.reverbBlend = 1
        environment.reverbParameters.level = -34
        environment.reverbParameters.loadFactoryReverbPreset(.mediumChamber)
        
        engine.attach(environment)
        engine.connect(environment, to: engine.mainMixerNode, format: nil)
        engine.prepare()

        do {
            try engine.start()
            print("Playing!")
        } catch {
            print("Couldn't start engine due to error:", error.localizedDescription)
        }
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearPlayers),
                                               name: .experienceChanged, object: nil)
    }
    
    // MARK: Public Functions
    
    public func setListenerPosition(_ x: Float, _ y: Float, _ z: Float) {
        environment.listenerPosition = AVAudio3DPoint(x: x, y: y, z: z)
    }
    
    public func setListenerOrientation(_ yaw: Float, _ pitch: Float, _ roll: Float) {
        environment.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch, roll: roll)
    }
    
    public func getVolumeFrom(_ trackID: String) -> Float {
        let player = playerNodes[trackID]
        return player?.volume ?? 0
    }
    
    public func setVolumeFor(_ trackID: String, to volume: Float) {
        let player = playerNodes[trackID]
        player?.volume = volume
    }
    
    public func getVerticalPercentageFrom(_ trackID: String) -> Float {
        guard let player = playerNodes[trackID] else { return 0 }
        return Vector.transfromYToVerticalPercentage(player.position.y)
    }
    
    public func setYFromVerticalPercentage(_ verticalPercentage: Float, for trackID: String) {
        let player = playerNodes[trackID]
        player?.position.y = Vector.tranfromVerticalPercentageToY(verticalPercentage)
    }
    
    public func addTrack(_ file: AVAudioFile, at position: Vector) -> String {
        if !playing && !playerNodes.isEmpty { setPlaybackStateTo(true); sleep(1) }
        
        let playerNode = AVAudioPlayerNode()
        let audioPosition = AVAudio3DPoint(x: position.x, y: position.y, z: position.z)
        playerNode.position = audioPosition
        playerNode.renderingAlgorithm = .HRTFHQ
        playerNode.reverbBlend = 0.9
        
        let trackID = UUID().uuidString
        audioFiles[trackID] = file
        playerNodes[trackID] = playerNode
        
        engine.attach(playerNode)
        engine.connect(playerNode, to: environment, format: file.processingFormat)
        
        var startingFrame = AVAudioFramePosition(0)
        
        var playTime: AVAudioTime?
        
        if let startTime = startTime {
            let last = AVAudioTime.seconds(forHostTime: environment.lastRenderTime!.hostTime)
            let start = AVAudioTime.seconds(forHostTime: startTime.hostTime) + 0.03
            playTime = AVAudioTime(hostTime: AVAudioTime.hostTime(forSeconds: start))
            let playedDuration = last - start
            startingFrame = AVAudioFramePosition(playedDuration * file.processingFormat.sampleRate)
        } else {
            startTime = environment.lastRenderTime
        }
        
        let frameCount = AVAudioFrameCount(file.length - startingFrame)
        
        guard frameCount >= 0 else { return trackID }
        
        playerNode.scheduleSegment(file, startingFrame: startingFrame, frameCount: frameCount, at: nil,
                                   completionCallbackType: .dataConsumed) { [weak self] t in
            guard let self = self,
                self.playing,
                !self.reset else { return }
            self.reset = true
            self.rescheduleTracks()
        }
        
        playerNode.prepare(withFrameCount: frameCount)
        
        playerNode.play(at: playTime)
        
        return trackID
    }
    
    public func rescheduleTracks(at frame: AVAudioFramePosition = AVAudioFramePosition(0)) {
        var time: AVAudioTime?
        var delayedTime: AVAudioTime?
        
        if let hostTime = environment.lastRenderTime?.hostTime {
            let seconds = AVAudioTime.seconds(forHostTime: hostTime) + 0.5
            let delayedSeconds = seconds
            time = AVAudioTime(hostTime: AVAudioTime.hostTime(forSeconds: seconds))
            delayedTime = AVAudioTime(hostTime: AVAudioTime.hostTime(forSeconds: delayedSeconds))
        }
        
        startTime = delayedTime
        
        for (trackID, playerNode) in playerNodes {
            let file = audioFiles[trackID]!
            let frameCount = AVAudioFrameCount(file.length - frame)
            playerNode.scheduleSegment(file, startingFrame: frame, frameCount: frameCount, at: nil,
                                       completionCallbackType: .dataConsumed) { [weak self] t in
                                        guard let self = self,
                                            self.playing,
                                            !self.reset else { return }
                                        self.reset = true
                                        self.rescheduleTracks()
            }
            
            playerNode.prepare(withFrameCount: AVAudioFrameCount(file.length))
        }
        
        playerNodes.values.forEach { $0.play(at: time) }
        reset = false
    }
    
    public func removeTrack(_ track: Track) {
        playerNodes[track.id]?.stop()
        playerNodes.removeValue(forKey: track.id)
        audioFiles.removeValue(forKey: track.id)
        if playerNodes.isEmpty {
            startTime = nil
        }
    }
    
    public func setPlaybackStateTo(_ playing: Bool) {
        guard !playerNodes.isEmpty else { return }
        
        if playing {
            for player in playerNodes.values {
                player.stop()
            }
            rescheduleTracks()
        } else {
            playerNodes.values.forEach { $0.pause() }
        }
        
        self.playing = playing
    }
    
    public func getPlayBackState() -> Bool {
        return playing
    }
    
    public func setReverbVolumeTo(_ percentage: Float) {
        environment.reverbParameters.level = (percentage * 40) - 40
    }
    
    public func setReverbTypeTo(_ typeRawValue: Int) {
        let type = AVAudioUnitReverbPreset(rawValue: typeRawValue)!
        environment.reverbParameters.loadFactoryReverbPreset(type)
    }
}
