//
//  LottieView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 19/10/24.
//

import SwiftUI
import Lottie

struct LottieViewSize: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop
    
    let animationView = LottieAnimationView()
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView() // Создаём контейнерный UIView
        animationView.animation = LottieAnimation.named(name)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        animationView.play()
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
