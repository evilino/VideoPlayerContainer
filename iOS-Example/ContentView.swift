//
//  ContentView.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/13.
//

import SwiftUI
import AVKit
import VideoPlayerContainer
import UIKit

let wwdcVideo = "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10036/4/BB960BFD-F982-4800-8060-5674B049AC5A/cmaf/hvc/2160p_16800/hvc_2160p_16800.m3u8"

struct ContentView: View {
    
    @StateObject var context = Context()
    
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        
        PlayerWidget()
            .ignoresSafeArea(edges: .vertical)
            .frame(maxWidth: .infinity, maxHeight: orientation.isLandscape ? .infinity : 300)
            .bindContext(context, launch: [
                LoadingService.self,
            ])
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                
                self.orientation = UIDevice.current.orientation
                
                if UIDevice.current.orientation.isLandscape {
                    context[StatusService.self].toFullScreen()
                } else {
                    context[StatusService.self].toHalfScreen()
                }
            })
            .onAppear {
                
                let controlService = context[ControlService.self]
                
                //MARK: HalfScreen Configuration
                
                /// halfScreen top
                controlService.configure(.halfScreen(.top)) {[
                    IdentifableView(id: "back") { BackButtonWidget() },
                    IdentifableView(id: "title") { TitleWidget() },
                    IdentifableView(id: "space") { Spacer() },
                    IdentifableView(id: "playback") {  Button("Hello World") {
                        context[FeatureService.self].present(.right(.squeeze)) {AnyView(
                            Form {
                                Text("World")
                                Text("World")
                                Text("World")
                            }.frame(width: 100)
                        )}
                    } },
                    IdentifableView(id: "more") {  MoreButtonWidget() }
                ]}
                
                /// halfScreen bottom
                controlService.configure(.halfScreen(.bottom)) {[
                    IdentifableView(id: "playback") {  PlaybackButtonWidget() },
                    IdentifableView(id: "progress") {  ProgressWidget()   },
                    IdentifableView(id: "timeline") {  TimelineWidget()   }
                ]}
                
                /// halfScreen center
                controlService.configure(.halfScreen(.center)) {[
                    IdentifableView(id: "playback") {  Button("Hello World") {
                        context[FeatureService.self].present(.left(.cover)) {AnyView(
                            Form {
                                Text("Hello")
                                Text("Hello")
                                Text("Hello")
                            }.frame(width: 100)
                        )}
                    } },
                ]}
                
                //MARK: FullScreen Configuration
                
                /// fullScreen top
                controlService.configure(.fullScreen(.top)) {[
                    IdentifableView(id: "back") { BackButtonWidget() },
                    IdentifableView(id: "title") { TitleWidget() },
                    IdentifableView(id: "space") { Spacer() },
                    IdentifableView(id: "A") { Image(systemName: "scribble") },
                    IdentifableView(id: "B") { Image(systemName: "eraser") },
                    IdentifableView(id: "C") { Image(systemName: "paperplane") },
                    IdentifableView(id: "D") { Image(systemName: "bookmark") },
                    IdentifableView(id: "E") { Image(systemName: "arrowshape.turn.up.right") },
                    IdentifableView(id: "more") {  MoreButtonWidget() }
                ]}
                
                /// fullScreen bottom
                controlService.configure(.fullScreen(.bottom)) {[
                    IdentifableView(id: "playback") {  PlaybackButtonWidget() },
                    IdentifableView(id: "progress") {  ProgressWidget()   },
                    IdentifableView(id: "timeline") {  TimelineWidget()   }
                ]}
                
                /// fullScreen center
                controlService.configure(.fullScreen(.left)) {[
                    IdentifableView(id: "playback") {  Image(systemName: "lock.open") },
                ]}
                
                //MARK: Other
                
                // configure title
                context[TitleService.self].setTitle("WWDC Video")
                
                // load video item
                let item = AVPlayerItem(url: URL(string:wwdcVideo)!)
                context[RenderService.self].player.replaceCurrentItem(with: item)
                
                // configure toast view
                context[ToastService.self].configure { toast in
                    Text(toast.title)
                }
                
                // configure more widget
                context[MoreButtonService.self].bindClickHandler { [weak context] in
                    context?[ToastService.self].toast(ToastService.Toast(title: "Hahahahaha"))
                }
                
                // configure control style
                context[ControlService.self].configure(controlStyle: .manual)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
