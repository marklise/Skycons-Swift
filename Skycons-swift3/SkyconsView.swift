//
//  SKYIconView.swift
//  Skycons-iOS
//
//  Created by Mark Lise on 2016-10-13.
//  Copyright © 2016 Mark Lise. All rights reserved.
//

import Foundation
import UIKit

enum Skycons {
	case ClearDay,ClearNight,Rain,Sleet,Wind,Fog,Cloudy,PartlyCloudyDay,PartlyCloudyNight,Snow
}

let STROKE: CGFloat = 0.08
let TWO_PI = M_PI * 2.0
let TWO_OVER_SQRT_2 = 2.0 / sqrt(2)

struct SKYWindOffset {
	var start: CGFloat?
	var end: CGFloat?
}

let WIND_PATHS = [
	[
		-0.7500, -0.1800, -0.7219, -0.1527, -0.6971, -0.1225,
		-0.6739, -0.0910, -0.6516, -0.0588, -0.6298, -0.0262,
		-0.6083,  0.0065, -0.5868,  0.0396, -0.5643,  0.0731,
		-0.5372,  0.1041, -0.5033,  0.1259, -0.4662,  0.1406,
		-0.4275,  0.1493, -0.3881,  0.1530, -0.3487,  0.1526,
		-0.3095,  0.1488, -0.2708,  0.1421, -0.2319,  0.1342,
		-0.1943,  0.1217, -0.1600,  0.1025, -0.1290,  0.0785,
		-0.1012,  0.0509, -0.0764,  0.0206, -0.0547, -0.0120,
		-0.0378, -0.0472, -0.0324, -0.0857, -0.0389, -0.1241,
		-0.0546, -0.1599, -0.0814, -0.1876, -0.1193, -0.1964,
		-0.1582, -0.1935, -0.1931, -0.1769, -0.2157, -0.1453,
		-0.2290, -0.1085, -0.2327, -0.0697, -0.2240, -0.0317,
		-0.2064,  0.0033, -0.1853,  0.0362, -0.1613,  0.0672,
		-0.1350,  0.0961, -0.1051,  0.1213, -0.0706,  0.1397,
		-0.0332,  0.1512,  0.0053,  0.1580,  0.0442,  0.1624,
		0.0833,  0.1636,  0.1224,  0.1615,  0.1613,  0.1565,
		0.1999,  0.1500,  0.2378,  0.1402,  0.2749,  0.1279,
		0.3118,  0.1147,  0.3487,  0.1015,  0.3858,  0.0892,
		0.4236,  0.0787,  0.4621,  0.0715,  0.5012,  0.0702,
		0.5398,  0.0766,  0.5768,  0.0890,  0.6123,  0.1055,
		0.6466,  0.1244,  0.6805,  0.1440,  0.7147,  0.1630,
		0.7500,  0.1800
	],
	[
		-0.7500,  0.0000, -0.7033,  0.0195, -0.6569,  0.0399,
		-0.6104,  0.0600, -0.5634,  0.0789, -0.5155,  0.0954,
		-0.4667,  0.1089, -0.4174,  0.1206, -0.3676,  0.1299,
		-0.3174,  0.1365, -0.2669,  0.1398, -0.2162,  0.1391,
		-0.1658,  0.1347, -0.1157,  0.1271, -0.0661,  0.1169,
		-0.0170,  0.1046,  0.0316,  0.0903,  0.0791,  0.0728,
		0.1259,  0.0534,  0.1723,  0.0331,  0.2188,  0.0129,
		0.2656, -0.0064,  0.3122, -0.0263,  0.3586, -0.0466,
		0.4052, -0.0665,  0.4525, -0.0847,  0.5007, -0.1002,
		0.5497, -0.1130,  0.5991, -0.1240,  0.6491, -0.1325,
		0.6994, -0.1380,  0.7500, -0.1400
	]
]

let Wind_OFFSETS = [SKYWindOffset(start: 0.36, end: 0.11), SKYWindOffset(start: 0.56, end: 0.16)]

class SkyconsView: UIView {
	
	private var _type = Skycons.ClearDay
	private var _color = UIColor.black
	private var _timer: Timer!
	
	var w: CGFloat {
		return bounds.width
	}
	
	var h: CGFloat {
		return bounds.height
	}
	
	var s: CGFloat {
		return min(w, h)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.play()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	var setType: Skycons {
		get { return _type }
		set { _type = newValue }
	}
	
	var setColor: UIColor {
		get { return _color }
		set { _color = newValue }
	}
	
	func refresh() {
		self.setNeedsDisplay()
	}
	
	override func draw(_ rect: CGRect) {
		//     super.drawRect(rect)
		
		let ctx: CGContext = UIGraphicsGetCurrentContext()!
		self.drawRect(rect: rect, inContext: ctx)
	}
	
	func isAnimating() -> Bool {
		return self._timer != nil
	}
	
	func play() {
		
		
		
		if _timer != nil {
			self.pause()
		}
		self._timer = Timer.scheduledTimer(timeInterval: 1/30,
		                                   target: self,
		                                   selector: #selector(self.update(timer:)),
		                                   userInfo: nil,
		                                   repeats: true)
	}
	
	func pause() {
		
		if self._timer != nil {
			self._timer?.invalidate()
		}
		
		self._timer = nil
	}
	
	func update(timer:Timer) {
		self.refresh()
	}
	
	// Mark: Drawing
	
	private func drawRect(rect: CGRect, inContext context: CGContext) {
		
		let time: Double = NSDate().timeIntervalSince1970 * 1000
		let color: CGColor = self._color.cgColor
		
		switch self._type {
		case .ClearDay:
			drawClearDayInContext(ctx: context, time: time, color: color)
		case .ClearNight:
			drawClearNightInContext(ctx: context, time: time, color: color)
		case .Cloudy:
			drawCloudyInContext(ctx: context, time: time, color: color)
		case .Fog:
			drawFogInContext(ctx: context, time: time, color: color)
		case .PartlyCloudyDay:
			drawPartlyCloudyDayInContext(ctx: context, time: time, color: color)
		case .PartlyCloudyNight:
			drawPartlyCloudyNightInCotnext(ctx: context, time: time, color: color)
		case .Rain:
			drawRainInContext(ctx: context, time: time, color: color)
		case .Sleet:
			drawSleetInContext(ctx: context, time: time, color: color)
		case .Wind:
			drawWindInContext(ctx: context, time: time, color: color)
		case .Snow:
			drawSnowInContext(ctx: context, time: time, color: color)
		}
	}
	
	// Mark: Icons
	
	private func drawClearDayInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		sun(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.5, cw: s, s: s * STROKE, color: color)
	}
	
	private func drawClearNightInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		moon(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.5, cw: s, s: s * STROKE, color: color)
	}
	
	private func drawPartlyCloudyDayInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		sun(ctx: ctx, t: time, cx: w * 0.625, cy: h * 0.375, cw: s * 0.75, s: s * STROKE, color: color)
		cloud(ctx: ctx, t: time, cx: w * 0.375, cy: h * 0.625, cw: s * 0.75, s: s * STROKE, color: color)
		ctx.endTransparencyLayer()
	}
	
	private func drawPartlyCloudyNightInCotnext(ctx: CGContext, time: Double, color: CGColor) {
		
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		moon(ctx: ctx, t: time, cx: w * 0.625, cy: h * 0.375, cw: s * 0.75, s: s * STROKE, color: color)
		cloud(ctx: ctx, t: time, cx: w * 0.375, cy: h * 0.625, cw: s * 0.75, s: s * STROKE, color: color)
		ctx.endTransparencyLayer()
	}
	
	private func drawCloudyInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		cloud(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.5, cw: s, s: s * STROKE, color: color)
		ctx.endTransparencyLayer()
	}
	
	private func drawRainInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		rain(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.37, cw: s * 0.9, s: s * STROKE, color: color)
		cloud(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.37, cw: s * 0.9, s: s * STROKE, color: color)
		ctx.endTransparencyLayer()
	}
	
	private func drawSleetInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		sleet(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.37, cw: s * 0.9, s: s * STROKE, color: color)
		cloud(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.37, cw: s * 0.9, s: s * STROKE, color: color)
		ctx.endTransparencyLayer()
	}
	
	private func drawSnowInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		snow(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.37, cw: s * 0.9, s: s * STROKE, color: color)
		cloud(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.37, cw: s * 0.9, s: s * STROKE, color: color)
		ctx.endTransparencyLayer()
	}
	
	private func drawWindInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		swoosh(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.5, cw: s, s: s * STROKE, index: 0, total: 2, color: color)
		swoosh(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.5, cw: s, s: s * STROKE, index: 1, total: 2, color: color)
	}
	
	private func drawFogInContext(ctx: CGContext, time: Double, color: CGColor) {
		
		let k = s * STROKE
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		fogBank(ctx: ctx, t: time, cx: w * 0.5, cy: h * 0.32, cw: s * 0.75, s: k, color: color)
		ctx.endTransparencyLayer()
		
		let newTime = time/5000
		let ds = Double(s)
		
		let a = CGFloat(cos((newTime) * TWO_PI) * ds * 0.02)
		let b = CGFloat(cos((newTime + 0.25) * TWO_PI) * ds * 0.02)
		let c = CGFloat(cos((newTime + 0.50) * TWO_PI) * ds * 0.02)
		let d = CGFloat(cos((newTime + 0.75) * TWO_PI) * ds * 0.02)
		let n = h * 0.936
		let e = floor(n - k * 0.5) + 0.5
		let f = floor((n - k * 2.5)) + 0.5
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: k, color: color, fillColor: nil)
		line(ctx: ctx, ax: a + w * 0.2 + k * 0.5, ay: e, bx: b + w * 0.8 - k * 0.5, by: e)
		line(ctx: ctx, ax: c + w * 0.2 + k * 0.5, ay: f, bx: d + w * 0.8 - k * 0.5, by: f)
	}
	
	// Mark: Basic shapes
	
	private func puff(ctx: CGContext, t: Double, cx: CGFloat, cy:CGFloat, rx:CGFloat, ry:CGFloat,rmin:CGFloat, rmax: CGFloat) {
		let c = CGFloat(cos(t * TWO_PI))
		let s = CGFloat(sin(t * TWO_PI))
		let rmaximum = rmax - rmin
		
		circle(ctx: ctx, x: cx - s * rx, y: cy + c * ry + rmaximum * 0.5, r: rmin + (1 - c * 0.5) * rmaximum)
	}
	
	private func puffs(ctx: CGContext, t: Double, cx: CGFloat, cy:CGFloat, rx:CGFloat, ry:CGFloat,rmin:CGFloat, rmax: CGFloat) {
		
		for i in (0..<5).reversed() {
			puff(ctx: ctx, t: t + Double(i) / 5, cx: cx, cy: cy, rx: rx, ry: ry, rmin: rmin, rmax: rmax)
		}
	}
	
	private func cloud(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		
		let time = t/30000
		let a = cw * 0.21
		let b = cw * 0.12
		let c = cw * 0.24
		let d = cw * 0.28
		
		ctx.setFillColor(color)
		puffs(ctx: ctx, t: time, cx: cx, cy: cy, rx: a, ry: b, rmin: c, rmax: d)
		ctx.setBlendMode(.destinationOut)
		puffs(ctx: ctx, t: time, cx: cx, cy: cy, rx: a, ry: b, rmin: c - s, rmax: d - s)
		ctx.setBlendMode(.normal)
	}
	
	private func sun(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		let time = t/120000
		let a = cw * 0.25 - s * 0.5
		let b = cw * 0.32 + s * 0.5
		let c = cw * 0.50 - s * 0.5
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: s, color: color, fillColor: nil)
		ctx.beginPath()
		ctx.addArc(center: CGPoint(x: cx, y: cy),
		           radius: CGFloat(a),
		           startAngle: CGFloat(0),
		           endAngle: CGFloat(TWO_PI),
		           clockwise: true)
		ctx.strokePath()
		
		for i in (0...8).reversed() {
			let p = (time + Double(i) / 8) * (TWO_PI)
			let cosine = CGFloat(cos(p))
			let sine = CGFloat(sin(p))
			line(ctx: ctx, ax: cx + cosine * b, ay: cy + sine * b, bx: cx + cosine * c, by: cy + sine * c)
		}
	}
	
	private func moon(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		let time = t/15000
		let a = cw * 0.29 - s * 0.5
		let b: CGFloat = cw * 0.05
		let c = CGFloat(cos(time * TWO_PI))
		let p = CGFloat(c * CGFloat(TWO_PI / -16))
		let newcx = cx + c * b
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: s, color: color, fillColor: nil)
		ctx.beginPath()
		ctx.addArc(center: CGPoint(x: newcx, y: cy),
		           radius: CGFloat(a),
		           startAngle: CGFloat(p + CGFloat(TWO_PI/8)),
		           endAngle: CGFloat(p + CGFloat(TWO_PI * 7/8)),
		           clockwise: false)
		ctx.addArc(center: CGPoint(x: newcx + cos(p) * a * CGFloat(TWO_OVER_SQRT_2), y: cy + sin(p) * a * CGFloat(TWO_OVER_SQRT_2)),
		           radius: CGFloat(a),
		           startAngle: CGFloat(p + CGFloat(TWO_PI) * 5 / 8),
		           endAngle: CGFloat(p + CGFloat(TWO_PI) * 3 / 8),
		           clockwise: true)
		ctx.closePath()
		ctx.strokePath()
	}
	
	private func rain(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		let time = t / 1350
		let a: Double = Double(cw) * 0.16
		let b = TWO_PI * 11 / 12
		let c = TWO_PI * 7 / 12
		
		ctx.setFillColor(color)
		for i in (0...4).reversed(){
			let p = fmod(time + Double(i)/4, 1)
			let x = floor(Double(cx) + ((Double(i) - 1.5) / 1.5) * (i == 1 || i == 2 ? -1 : 1) * a) + 0.5
			let y = cy + CGFloat(p) * cw
			ctx.beginPath()
			ctx.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y - s * 1.5)))
			ctx.addArc(center: CGPoint(x: CGFloat(x), y: y),
			           radius: CGFloat(s * 0.75),
			           startAngle: CGFloat(b),
			           endAngle: CGFloat(c),
			           clockwise: false)
			ctx.fillPath()
		}
	}
	
	private func sleet(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		
		let time = t / 750
		let a = cw * 0.1875
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: s * 0.05, color: color, fillColor: nil)
		
		for i in (0..<4) {
			
			let p = fmod(time + Double(i) / 4, 1)
			let x = floor(cx + (CGFloat((Double(i) - 1.5) / 1.5) * (i == 1 || i == 2 ? -1 : 1)) * a) + 0.5
			let y = cy + CGFloat(p) * cw
			line(ctx: ctx, ax: x, ay: y - s * 1.5, bx: x, by: y + s * 1.5)
		}
	}
	
	private func snow(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		let time = t/3000
		
		let a = cw * 0.16
		let b = Double(s * 0.75)
		let u = time * TWO_PI * 0.7
		let ux = CGFloat(cos(u) * b)
		let uy = CGFloat(sin(u) * b)
		let v = u + TWO_PI / 3
		let vx = CGFloat(cos(v) * b)
		let vy = CGFloat(sin(v) * b)
		let w = u + TWO_PI * 2 / 3
		let wx = CGFloat(cos(w) * b)
		let wy = CGFloat(sin(w) * b)
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: s * 0.5, color: color,fillColor: nil)
		
		for i in (0..<4).reversed() {
			let p = fmod(time + Double(i)/4, 1)
			let x = cx + CGFloat(sin(p + Double(i) / 4 * TWO_PI)) * a
			let y = cy + CGFloat(p) * cw
			
			line(ctx: ctx, ax: x - ux, ay: y - uy, bx: x + ux, by: y + uy)
			line(ctx: ctx, ax: x - vx, ay: y - vy, bx: x + vx, by: y + vy)
			line(ctx: ctx, ax: x - wx, ay: y - wy, bx: x + wx, by: y + wy)
		}
	}
	
	private func fogBank(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		let time = t/30000
		
		let a = cw * 0.21
		let b = cw * 0.06
		let c = cw * 0.21
		let d = cw * 0.28
		
		ctx.setFillColor(color)
		puffs(ctx: ctx, t: time, cx: cx, cy: cy, rx: a, ry: b, rmin: c, rmax: d)
		ctx.setBlendMode(.destinationOut)
		puffs(ctx: ctx, t: time, cx: cx, cy: cy, rx: a, ry: b, rmin: c - s, rmax: d - s)
		ctx.setBlendMode(.normal)
	}
	
	private func leaf(ctx: CGContext, t: Double, x: CGFloat, y: CGFloat, cw:CGFloat, s: CGFloat, color: CGColor) {
		
		let a = cw / 8
		let b = a / 3
		let c = 2 * b
		let d = CGFloat(fmod(t, 1) * TWO_PI)
		let e = CGFloat(cos(d))
		let f = CGFloat(sin(d))
		
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: s, color: color, fillColor: color)
		ctx.beginPath()
		ctx.addArc(center: CGPoint(x: x, y: y),
		           radius: CGFloat(a),
		           startAngle: CGFloat(d),
		           endAngle: CGFloat(d + CGFloat(M_PI)),
		           clockwise: true)
		ctx.addArc(center: CGPoint(x: x - b * e, y: y - b * f),
		           radius: CGFloat(c),
		           startAngle: CGFloat(d + CGFloat(M_PI)),
		           endAngle: CGFloat(d),
		           clockwise: true)
		ctx.addArc(center: CGPoint(x: x + c * e, y: y + c * f),
		           radius: CGFloat(b),
		           startAngle: CGFloat(d + CGFloat(M_PI)),
		           endAngle: CGFloat(d),
		           clockwise: false)
		
		ctx.setBlendMode(.destinationOut)
		ctx.beginTransparencyLayer(auxiliaryInfo: nil)
		ctx.endTransparencyLayer()
		
		ctx.setBlendMode(.normal)
		ctx.strokePath()
	}
	
	private func swoosh(ctx: CGContext, t: Double, cx: CGFloat, cy: CGFloat, cw:CGFloat, s: CGFloat, index: Int, total: Double, color: CGColor) {
		
		let time = t / 2500
		let windOffset = Wind_OFFSETS[index]
		let pathLength = index == 0 ? 128 : 64
		let path = WIND_PATHS[index]
		var a = fmod(time + Double(index) - Double(windOffset.start!), total)
		var c = fmod(time + Double(index) - Double(windOffset.end!), total)
		var e = fmod(time + Double(index), total)
		
		setUpStroke(ctx: ctx, lineCapType: .round, joinCapType: .round, lineWidth: s, color: color, fillColor: nil)
		
		if a < 1 {
			ctx.beginPath()
			
			a *= Double(pathLength) / 2 - 1
			var b = floor(a)
			a -= b
			b *= 2
			b += 2
			
			let ax = (path[Int(b) - 2] * (1 - a) + path[Int(b)] * a)
			let ay = (path[Int(b) - 1] * (1 - a) + path[Int(b) + 1] * a)
			let x = cx + CGFloat(ax) * cw
			let y = cy + CGFloat(ay) * cw
			ctx.move(to: CGPoint(x: x , y: y))
			
			if c < 1 {
				c *= Double(pathLength) / 2 - 1
				var d = floor(c)
				c -= d
				d *= 2
				d += 2
				
				for i in Int(b)...Int(d) where i != Int(d) && i % 2 == 0 {
					ctx.addLine(to: CGPoint(x: cx + CGFloat(path[i]) * cw, y: cy + CGFloat(path[i + 1]) * cw))
				}
				
				let condX = (path[Int(d) - 2] * (1 - c) + path[Int(d)] * c)
				let condY = (path[Int(d) - 1] * (1 - c) + path[Int(d) + 1] * c)
				let bx =  cx + CGFloat(condX) * cw
				let by = cy + CGFloat(condY) * cw
				
				ctx.addLine(to: CGPoint(x: bx, y: by))
			} else {
				
				for i in Int(b)...pathLength where i != pathLength && i % 2 == 0 {
					ctx.addLine(to: CGPoint(x: cx + CGFloat(path[i]) * cw, y: cy + CGFloat(path[i + 1]) * cw))
				}
			}
			
			ctx.strokePath()
		} else if c < 1 {
			ctx.beginPath()
			
			c *= Double(pathLength) / 2 - 1
			var d  = floor(c)
			c -= d
			d *= 2
			d += 2
			ctx.move(to: CGPoint(x: cx + CGFloat(path[0]) * cw, y: cy + CGFloat(path[1]) * cw))
			
			for i in (2...Int(d)) where i != Int(d) && i % 2 == 0 {
				ctx.addLine(to: CGPoint(x: cx + CGFloat(path[i]) * cw, y: cy + CGFloat(path[i + 1]) * cw))
			}
			
			let dx = (path[Int(d) - 2] * (1 - c) + path[Int(d)] * c)
			let dy = (path[Int(d) - 1] * (1 - c) + path[Int(d) + 1] * c)
			ctx.addLine(to: CGPoint(x: cx + CGFloat(dx) * cw, y: cy + CGFloat(dy) * cw))
			ctx.strokePath()
		}
		if e < 1 {
			e *= Double(pathLength) / 2 - 1
			var f = floor(e)
			e -= f
			f *= 2
			f += 2
			
			let fx = (path[Int(f) - 2] * (1 - e) + path[Int(f)] * e)
			let fy = (path[Int(f) - 1] * (1 - e) + path[Int(f) + 1] * e)
			
			leaf(ctx: ctx, t: time, x: cx + CGFloat(fx) * cw, y: cy + CGFloat(fy) * cw, cw: cw, s: s, color: color)
		}
	}
	
	// Mark: Setting up Stroke
	
	func setUpStroke(ctx: CGContext, lineCapType: CGLineCap, joinCapType: CGLineJoin, lineWidth: CGFloat,color: CGColor, fillColor: CGColor?) {
		ctx.setStrokeColor(color)
		ctx.setLineWidth(lineWidth)
		ctx.setLineCap(.round)
		ctx.setLineJoin(.round)
		
		if fillColor != nil {
			ctx.setFillColor(fillColor!)
		}
	}
	
	// Mark: Drawing Primitives
	
	private func circle(ctx: CGContext, x: CGFloat, y: CGFloat, r: CGFloat) {
		ctx.beginPath()
		ctx.addArc(center: CGPoint(x: CGFloat(x), y: CGFloat(y)),
		           radius: CGFloat(r),
		           startAngle: CGFloat(0),
		           endAngle: CGFloat(CGFloat(M_PI) * 2),
		           clockwise: true)
		ctx.fillPath()
	}
	
	private func line(ctx:CGContext, ax: CGFloat, ay: CGFloat, bx: CGFloat, by: CGFloat) {
		ctx.beginPath()
		ctx.move(to: CGPoint(x: ax, y: ay))
		ctx.addLine(to: CGPoint(x: bx, y: by))
		ctx.strokePath()
	}
}





