//
//  OnRotateExtension.swift
//  WFL
//
//  Created by Berksu Kısmet on 22.12.2021.
//

import SwiftUI

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
