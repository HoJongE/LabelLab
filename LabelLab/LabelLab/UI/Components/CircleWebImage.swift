//
//  CircleWebImage.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct CircleWebImage: View {
    private let url: URL?
    private let width: CGFloat

    init(url: URL?, width: CGFloat = 15) {
        self.url = url
        self.width = width
    }

    init(urlString: String?, width: CGFloat = 15) {
        if let url = urlString {
            self.url = URL(string: url)
        } else {
            self.url = nil
        }
        self.width = width
    }

    var body: some View {
        WebImage(url: url)
            .resizable()
            .placeholder(Image(systemName: "person.fill"))
            .indicator(.activity)
            .scaledToFit()
            .transition(.fade)
            .frame(width: width, height: width, alignment: .center)
            .background(Color.darkGray)
            .clipShape(Circle())
    }
}

#if DEBUG
struct CircleWebImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleWebImage(urlString: UserInfo.hojonge.profileImage ?? "", width: 200)
                .previewDisplayName("Success")
            CircleWebImage(url: nil, width: 200)
            .previewDisplayName("Placeholder")
        }
    }
}
#endif
