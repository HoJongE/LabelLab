//
//  CustomImageButton.swift
//  LabelLab
//
//  Created by Chanhee Jeong on 2022/09/18.
//

import Foundation
import SwiftUI

struct CustomImageButton: View {

    private let imageName: String
    private let width: CGFloat
    private let height: CGFloat
    private let action: () -> Void

    init(imageName: String,
         width: CGFloat,
         height: CGFloat,
         action: @escaping () -> Void) {
        self.imageName = imageName
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
        .buttonStyle(.borderless)
    }
}
