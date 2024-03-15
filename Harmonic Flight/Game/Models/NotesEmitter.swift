import UIKit
import SwiftUI


class MusicNotesEmitterView: UIView {
    private var emitter: CAEmitterLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureEmitter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmitter() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
        emitterLayer.emitterShape = .point
        emitterLayer.emitterSize = CGSize(width: 1, height: 1)
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular))?.cgImage
        emitterCell.birthRate = 20
        emitterCell.lifetime = 0.3
        emitterCell.velocity = -500
        emitterCell.velocityRange = 50
        emitterCell.emissionLongitude = -CGFloat.pi / 2
        emitterCell.emissionRange = CGFloat.pi / 8
        emitterCell.scale = 0.6
        emitterCell.scaleRange = 0.3
        emitterLayer.emitterCells = [emitterCell]
        self.layer.addSublayer(emitterLayer)
        self.emitter = emitterLayer
    }
    
    func updateEmitterDirection(angle: CGFloat) {
        emitter?.emitterCells?.forEach { cell in
            cell.emissionLongitude = angle
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter?.emitterPosition = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
    }
}

struct MusicNotesEmitter: UIViewRepresentable {
    @Binding var playerPosition: CGPoint
    @Binding var previousPlayerPosition: CGPoint
    
    func makeUIView(context: Context) -> MusicNotesEmitterView {
        let view = MusicNotesEmitterView()
        return view
    }
    
    func updateUIView(_ uiView: MusicNotesEmitterView, context: Context) {
        let deltaX = playerPosition.x - previousPlayerPosition.x
        let deltaY = playerPosition.y - previousPlayerPosition.y
        let angle = atan2(deltaY, deltaX) + .pi // Propulsion in opposite direction
        uiView.configureEmitter()
        uiView.updateEmitterDirection(angle: angle)
    }
}

