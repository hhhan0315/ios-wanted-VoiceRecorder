//
//  Extensions.swift
//  VoiceRecorder
//
//  Created by 이경민 on 2022/06/28.
//

import Foundation

//UI

//UTILS

//UIVIEW
#if canImport(swiftUI) && DEBUG
import SwiftUI

enum DeviceType {
    case iPhoneSE2
    case iPhone8
    case iPhone12Pro
    case iPhone12ProMax

    func name() -> String {
        switch self {
        case .iPhoneSE2:
            return "iPhone SE"
        case .iPhone8:
            return "iPhone 8"
        case .iPhone12Pro:
            return "iPhone 12 Pro"
        case .iPhone12ProMax:
            return "iPhone 12 Pro Max"
        }
    }
}

extension UIView {
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView

        let view: UIView

        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }

    func showPreview() -> some View {
        Preview(view: self).previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
    
    struct UIViewPreview<View: UIView>: UIViewRepresentable {
        let view: View

        init(_ builder: @escaping () -> View) {
            view = builder()
        }

        // MARK: - UIViewRepresentable

        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ view: UIView, context: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
    }
}



extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func showPreview(_ deviceType: DeviceType = .iPhone12Pro) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif
