//
//  Extensions.swift
//  VoiceRecorder
//
//  Created by 이경민 on 2022/06/28.
//

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    // TODO: - format 기본값 선언, locale 분리, DateFormatter Extension
    func toString(_ format: String) -> String {
        Self.dateFormatter.dateFormat = format
        Self.dateFormatter.locale = Locale(identifier: "ko_KR")
        return Self.dateFormatter.string(from: self)
    }
}
