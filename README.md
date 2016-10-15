# Skycons-Swift

This is a port of the animated HTML5 canvas weather icons - [**Skycons**](http://darkskyapp.github.io/skycons/) from [**forecast.io**](http://forecast.io). Credit goes to [**zachwaugh**](https://github.com/zachwaugh/cocoa-skycons) [**miwand**](https://github.com/miwand/Skycons-Swift) as this project is originally translated from [**zachwaugh**] 's work and modified legacy Swift 2.x from [**miwand**].

I did this so that those wanting to incorporate these works into the latest version of Swift could do it quickly.

## Usage

Create a `SKYIconView`, with a frame in mind. Set the type of weather and color, then use as you would use a UIView. It will be animated by default and the animation can be turned off by setting the new that you have created to pause 

```Swift
let iconView = SkyconView(frame: frame)
iconView.setType = .ClearDay
iconView.setColor = UIColor.cyanColor()
self.view.addSubview(iconView)
iconView.pause To pause the animation when needed
```

## Gif

<p align="center">
  <img src="https://github.com/marklise/Skycons-Swift/blob/master/skycons-Gif.gif" alt="Skycons"/>
</p>


## License

This is released into the public domain, same as the originals.
