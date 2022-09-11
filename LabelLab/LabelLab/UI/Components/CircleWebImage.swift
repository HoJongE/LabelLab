//
//  CircleWebImage.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct CircleWebImage<Placeholder: View>: View {
    private let url: URL?
    private let width: CGFloat
    private let placeHolder: () -> Placeholder

    init(url: URL?, width: CGFloat = 15, placeholder: @escaping () -> Placeholder = {
        EmptyView()
    }) {
        self.url = url
        self.width = width
        self.placeHolder = placeholder
    }

    init(urlString: String?, width: CGFloat = 15, placeholder: @escaping () -> Placeholder = {
        EmptyView()
    }) {
        if let url = urlString {
            self.url = URL(string: url)
        } else {
            self.url = nil
        }
        self.width = width
        self.placeHolder = placeholder
    }

    var body: some View {
        WebImage(url: url)
            .resizable()
            .placeholder(content: placeHolder)
            .indicator(.activity)
            .scaledToFit()
            .transition(.fade)
            .frame(width: width, height: width, alignment: .center)
            .clipShape(Circle())
    }
}

struct CircleWebImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleWebImage(urlString: UserInfo.hojonge.profileImage ?? "", width: 200)
                .previewDisplayName("Success")
            CircleWebImage(url: nil, width: 200) {
                Circle()
                    .fill(Color.blue)
                    .overlay {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
            }
            .previewDisplayName("Placeholder")
        }
    }
}
