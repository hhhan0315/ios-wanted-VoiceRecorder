//
//  Engine.swift
//  VoiceRecorder
//
//  Created by 이경민 on 2022/06/30.
//

import Foundation
import AVFAudio

protocol Playable{
    func setup()
}

protocol Recordable{
    func setup()
    func toggleRecording()
}

class Engine{
    var fileURL:URL
    var player = AVAudioPlayerNode()
    var recordFile:AVAudioFile?
    var engine = AVAudioEngine()
    var isRecording = false
    private var isNewRecordingAvailable = false
    var voiceIOFormat:AVAudioFormat
    
    //Audio Second Change Properties
    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0
    private var audioLengthSamples: AVAudioFramePosition = 0
    
    private var audioSampleRate:Double = 0
    private var audioLengthSeconds: Double = 0
    private var currentFrame:AVAudioFramePosition {
        guard let lastRenderTime = player.lastRenderTime,
              let playerTime = player.playerTime(forNodeTime: lastRenderTime) else{
            return 0
        }
        
        return playerTime.sampleTime
    }
    
    enum engineError:Error{
        case initError
    }
    
    init(fileURL:URL) throws {
        self.fileURL = fileURL
        do{
            self.recordFile = try AVAudioFile(forReading: fileURL)
        } catch {
            throw engineError.initError
        }
        
        guard let voiceIOFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                                sampleRate: 8000,
                                                channels: 1,
                                                interleaved: true)
        else{
            throw engineError.initError
        }
        print("Engine Init")
        self.voiceIOFormat = voiceIOFormat
    }
    
    func engineStart(){
        do{
            try engine.start()
        } catch {
            print("Could not start engine : \(error)")
        }
    }
    
    func checkEngineRunning(){
        if !engine.isRunning{
            engineStart()
        }
    }
    
    private static func getBuffer(fileURL:URL)->AVAudioPCMBuffer?{
        let file:AVAudioFile!
        do{
            try file = AVAudioFile(forReading: fileURL)
            print(file.length)
        } catch {
            print("Could not load file \(error)")
            return nil
        }
        
        file.framePosition = 0
        
        let bufferCapacity = AVAudioFrameCount(file.length) + AVAudioFrameCount(file.processingFormat.sampleRate * 0.1)
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: bufferCapacity) else{return nil}
        
        do{
            try file.read(into: buffer)
        } catch {
            print("Could not load file into buffer \(error)")
            return nil
        }
        
        file.framePosition = 0
        return buffer
    }
    
    func togglePlaying(completion:@escaping()->Void){
        if player.isPlaying{
            print("player stop")
            player.pause()
        } else {
            print("player play")
            do {
                recordFile = try AVAudioFile(forReading: fileURL)
                if let recordFile = recordFile {
                    audioLengthSamples = recordFile.length
                    audioSampleRate = recordFile.processingFormat.sampleRate
                    audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
                }
            } catch {
                print("Error reading the audio file \(error.localizedDescription)")
            }
            guard let recordedBuffer = Engine.getBuffer(fileURL: fileURL) else{return}
            
            player.scheduleBuffer(recordedBuffer,at: nil) {
                completion()
            }
            
            player.play()
        }
    }
    
    func skip(forwards:Bool){
        let timeToSeek:Double
        
        if forwards{
            timeToSeek = 5
        }else{
            timeToSeek = -5
        }
        
        seek(to: timeToSeek)
    }
    
    func seek(to time:Double){
        guard let recordFile = recordFile else {
            return
        }

        let offset = AVAudioFramePosition(time * audioSampleRate)
        
        seekFrame = currentPosition + offset
        seekFrame = max(seekFrame, 0)
        seekFrame = min(seekFrame, audioLengthSamples)
        
        currentPosition = seekFrame
        
        let wasPlaying = player.isPlaying
        player.stop()
        
        if currentPosition < audioLengthSamples{
            updateDisplay()
            
            let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
            player.scheduleSegment(recordFile, startingFrame: seekFrame, frameCount: frameCount, at: nil)
            
            if wasPlaying{
                player.play()
            }
        }
    }
    
    func updateDisplay(){
        currentPosition = currentFrame + seekFrame
        currentPosition = max(currentFrame, 0)
        currentPosition = min(currentPosition, audioLengthSamples)
        
        if currentPosition >= audioLengthSamples{
            player.stop()
            
            seekFrame = 0
            currentPosition = 0
        }
        
        let time = Double(currentPosition) / audioSampleRate
        print("All second \(audioLengthSeconds)")
        print("Remain time \(audioLengthSeconds - time)")
    }
    
    var isPlaying:Bool{
        return player.isPlaying
    }
}
