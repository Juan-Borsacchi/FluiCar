//
//  SplashView.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 08/10/26.
//
import SwiftUI
import AVKit
import CoreMedia
import OSLog

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var player: AVPlayer?
    @State private var timeObserver: Any?
    let videoDuration: Double = 2.5
    let skipTime: Double = 3.0
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if let player = player {
                    FullScreenVideoPlayer(player: player)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea()
                        .disabled(true)
                        .onAppear {
                            player.isMuted = true
                            player.play()
                            player.rate = 1.4
                            
                            let exitTime = CMTime(seconds: skipTime + videoDuration, preferredTimescale: 600)
                            let timeValue = NSValue(time: exitTime)
                            timeObserver = player.addBoundaryTimeObserver(forTimes: [timeValue], queue: .main) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    self.isActive = true
                                }
                            }
                        }
                        .onDisappear {
                            if let observer = timeObserver {
                                player.removeTimeObserver(observer)
                                timeObserver = nil
                            }
                        }
                    
                }else {
                    Text("FluiCar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .onAppear{
            setupVideo()
        }
    }
    private func setupVideo() {
        guard let url = Bundle.main.url(forResource: "AnimationSplash", withExtension: "mov") else {
            Logger.interface.error("Erro: Não encontrei o ficheiro de vídeo da Splash Screen.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation { self.isActive = true }
            }
            return
        }
        let newPlayer = AVPlayer(url: url)
        
        let initialPoint = CMTime(seconds: skipTime, preferredTimescale: 600)
        newPlayer.seek(to: initialPoint)
        self.player = newPlayer
    }
}
    
struct FullScreenVideoPlayer: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = player
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) {
    }
}

class PlayerView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set {
            playerLayer.player = newValue
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
}
