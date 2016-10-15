//
//  ViewController.swift
//  Skycons-swift3
//
//  Created by Mark Lise on 10/14/16.
//
//

import UIKit

class ViewController: UIViewController {

	var xPadding: CGFloat = 30
	var yPadding: CGFloat = 30

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let weatherTypes: [Skycons] =
			[
				.ClearDay,
				.ClearNight,
				.Cloudy,
				.Fog,
				.PartlyCloudyDay,
				.PartlyCloudyNight,
				.Rain,
				.Sleet,
				.Snow,
				.Wind
		]
		
		for i in weatherTypes {
			let iconView = SkyconsView(frame: CGRect(x: xPadding, y: yPadding, width: 128, height: 128))
			
			if yPadding >= UIScreen.main.bounds.height - 200 {
				xPadding += 150
				yPadding = 30
			} else {
				yPadding += 140
			}
			
			iconView.setType = i
			iconView.setColor = UIColor.black
			iconView.backgroundColor = UIColor.white
			
			self.view.addSubview(iconView)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

