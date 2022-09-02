//
//  Color.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/19.
//

import SwiftUI

// MARK: - Color Assests
extension Color {
    // TODO: Hex 값 초기화 대신 Assests 에 추가해야함
    static let statusBackground: Color = Color("1E1E1E")
    static let statusTitle: Color = Color("EBEBF5").opacity(0.6)
    static let cellBackground: Color = Color("3D3C3D")
    static let detailBackground: Color = Color("282828")
    static let cellHoverBackground: Color = Color("017AFF").opacity(0.3)
    static let defaultButtonBackground: Color = Color("6E6D70")
    static let white80: Color = Color("FFFFFF").opacity(0.8)
    static let darkGray: Color = Color("3D3C3D")
    static let primaryBlue: Color = Color("017AFF")
}

// MARK: - Hex Color initializer
extension Color {
    init(_ hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
