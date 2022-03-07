//
//  Popover.swift
//  Place-To-Place
//
//  Created by СОВА on 05.03.2022.
//

import SwiftUI

extension View {
    func tolbarPopover<Content: View>(show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content ) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack{
                    if show.wrappedValue {
                        content()
                            .padding()
                            .background(Color.white
                                            .clipShape(PathPopover())
                            )
                            .shadow(radius: 2)
                            .offset(x: -10)
                            .offset(y: 10)
                    }
                },
                alignment: .topTrailing
            )
    }
}

struct Popover_Previews: PreviewProvider {
    static var previews: some View {
        let chatLog = ChatLogViewModel(chatUser: ChatUsers(name: "Sergey", uid: "1234567", phoneNumber: "7903888888234", profileImage: "", token: ""), chatCurentUser: ChatUsers(name: "", uid: "1234567", phoneNumber: "7903888888234", profileImage: "", token: ""))
//                NavigationView {
                    ChatLogView(vm: chatLog)
//                }
//        MainMessagesView()
        
    }
}
struct PathPopover: Shape {
    func path(in rect: CGRect) -> Path {
        return Path {path in
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: rect.width, y: 0)
            let pt3 = CGPoint(x: rect.width, y: rect.width / 3)
            let pt4 = CGPoint(x: 0, y: rect.width / 3)
            
            
            path.move(to: pt4)
            
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 15)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 15)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 15)
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 15)
            
            path.move(to: pt1)
            path.addLine(to: CGPoint(x: 120, y: 0))
            path.addLine(to: CGPoint(x: 125, y: 0))
            path.addLine(to: CGPoint(x: 132, y: -15))
            path.addLine(to: CGPoint(x: 140, y: 0))
        }
    }
}
