import UIKit

extension CGPoint {
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }
}

struct BezierCurveData {
    var start: CGPoint
    var end: CGPoint
    var c1: CGPoint
    var c2: CGPoint
    
    init(start: CGPoint, end: CGPoint, c1: CGPoint, c2: CGPoint) {
        self.start = start
        self.end = end
        self.c1 = c1
        self.c2 = c2
    }
    
    init() {
        self.start = .init(x: 0, y: 0)
        self.end = .init(x: 1, y: 1)
        self.c1 = .init(x: 0.5, y: 1)
        self.c2 = .init(x: 1, y: 0.5)
    }
}

class BezierCurveView: UIView {
    var curve: BezierCurveData = .init()
    var p1 = UIView()
    var p2 = UIView()
    var c1 = UIView()
    var c2 = UIView()
    
    let curveSize: CGFloat = 5
    let controlLineSize: CGFloat = 2
    let pointSize: CGFloat = 20
    let pointColor: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    let controlColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    let curveColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let controlLineColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    
    init(curve: BezierCurveData) {
        super.init(frame: .zero)
        self.curve = curve
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clear
        p1 = UIView(frame: .init(x: 0, y: 0, width: pointSize, height: pointSize))
        p1.backgroundColor = pointColor
        p1.layer.cornerRadius = pointSize / 2.0
        p1.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:))))
        addSubview(p1)
        p2 = UIView(frame: .init(x: 0, y: 0, width: pointSize, height: pointSize))
        p2.backgroundColor = pointColor
        p2.layer.cornerRadius = pointSize / 2.0
        p2.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:))))
        addSubview(p2)
        c1 = UIView(frame: .init(x: 0, y: 0, width: pointSize, height: pointSize))
        c1.backgroundColor = controlColor
        c1.layer.cornerRadius = pointSize / 2.0
        c1.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:))))
        addSubview(c1)
        c2 = UIView(frame: .init(x: 0, y: 0, width: pointSize, height: pointSize))
        c2.backgroundColor = controlColor
        c2.layer.cornerRadius = pointSize / 2.0
        c2.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:))))
        addSubview(c2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        p1.center = CGPoint(x: curve.start.x * frame.size.width, y: curve.start.y * frame.size.height)
        p2.center = CGPoint(x: curve.end.x * frame.size.width, y: curve.end.y * frame.size.height)
        c1.center = CGPoint(x: curve.c1.x * frame.size.width, y: curve.c1.y * frame.size.height)
        c2.center = CGPoint(x: curve.c2.x * frame.size.width, y: curve.c2.y * frame.size.height)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // curve
        context.saveGState()
        context.beginPath()
        context.move(to: p1.center)
        context.addCurve(to: p2.center, control1: c1.center, control2: c2.center)
        context.setStrokeColor(curveColor.cgColor)
        context.setLineWidth(curveSize)
        context.strokePath()
        context.restoreGState()
        
        // p1 - c1 line
        context.saveGState()
        context.beginPath()
        context.move(to: p1.center)
        context.addLine(to: c1.center)
        context.closePath()
        context.setStrokeColor(controlLineColor.cgColor)
        context.setFillColor(controlLineColor.cgColor)
        context.setLineWidth(controlLineSize)
        context.setLineDash(phase: 0, lengths: [5])
        context.strokePath()
        context.fillPath()
        context.restoreGState()

        // p2 - c2 line
        context.saveGState()
        context.beginPath()
        context.move(to: p2.center)
        context.addLine(to: c2.center)
        context.closePath()
        context.setStrokeColor(controlLineColor.cgColor)
        context.setFillColor(controlLineColor.cgColor)
        context.setLineWidth(controlLineSize)
        context.setLineDash(phase: 0, lengths: [5])
        context.strokePath()
        context.fillPath()
        context.restoreGState()
    }
    
    @IBAction func didPan(pan: UIPanGestureRecognizer) {
        guard pan.state == .changed else { return }
        let translation = pan.translation(in: pan.view)
        let normalised = CGPoint(x: translation.x / frame.size.width, y: translation.y / frame.size.height)
        if pan.view == p1 {
            curve.start += normalised
        } else if pan.view == p2 {
            curve.end += normalised
        } else if pan.view == c1 {
            curve.c1 += normalised
        } else if pan.view == c2 {
            curve.c2 += normalised
        }
        pan.setTranslation(.zero, in: pan.view)
        setNeedsLayout()
    }
}

class BezierCurveEditor: UIView {
    var curves: [BezierCurveView] = []
    
}

