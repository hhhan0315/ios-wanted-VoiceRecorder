//
//  FirebaseStorageManager.swift
//  VoiceRecorder
//
//  Created by rae on 2022/06/27.
//

import Foundation
import FirebaseStorage
import UIKit
import AVFAudio

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let storage = Storage.storage().reference().child("voiceRecords")
    private let deviceId:String?
    
    private init() {
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString
    }
    
    func fetch(completion: @escaping (Result<Audio, Error>) -> Void) {
        
        if let deviceId = deviceId {
            storage.child(deviceId).listAll { result in
                switch result{
                case .success(let result):
                    result.items.forEach { item in
                        let timeTitle = item.name.replacingOccurrences(of: ".m4a", with: "")
                        let title = "voiceRecords_" + timeTitle
                        //TODO: - item을 로컬로 다운로드 하고, 캐싱 처리하기
//                        item.write(toFile: URL(string: title)) { url, error in
//                            Audio(title: title, url: url)
//
//                            AVAudioFile(forReading: url)
//                        }
                        
                        item.downloadURL { url, err in
                            if let url = url{
                                let audio = Audio(title: title, url: url)
                                completion(.success(audio))
                            }
                        }
                    }
                case .failure(let err):
                    print("Error in fetch FirebaseManager \(err.localizedDescription)")
                }
            }
        }
    }
    
    func uploadData(url:URL,fileName:String){
        if let deviceId = deviceId {
            storage.child("\(deviceId)/\(fileName)").putFile(from: url)
        }
    }
}
