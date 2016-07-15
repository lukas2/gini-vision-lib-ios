![Gini Vision Library for iOS](https://www.gini.net/assets/GiniVision_Logo.png)

[![CI Status](https://travis-ci.com/gini/gini-vision-lib-ios.svg?token=TvDgN64LcAHcyTDy8g4j&branch=master)](https://travis-ci.com/gini/gini-vision-lib-ios)

The Gini Vision Library provides components for capturing, reviewing and analyzing photos of invoices and remittance slips.

By integrating this library into your application you can allow your users to easily take a picture of a document, review it and - by implementing the necessary callbacks - upload the document for analysis to the Gini backend.

Communication with the Gini backend is not part of this library. You can either use the [Gini API SDK](https://github.com/gini/gini-sdk-ios) or implement communication with the Gini API yourself.

The Gini Vision Library can be integrated in two ways, either by using the *Screen API* or the *Component API*. In the Screen API we provide pre-defined screens that can be customized in a limited way. The screen and configuration design is based on our long-lasting experience with integration in customer apps. In the Component API, we provide independent views so you can design your own application as you wish. We strongly recommend keeping in mind our UI/UX guidelines, however.

## Documentation

Furhter documentation can be found in our 

* [Integration Guide](http://developer.gini.net/gini-vision-lib-ios/docs/) and
* [API Documentation](http://developer.gini.net/gini-vision-lib-ios/api/)

## Architecture

The Gini Vision Library consists of four main screens

* Onboading: Provides useful hints to the users how to take a perfect photo of a document,
* Camera: The actual camera screen to capture the image of the document,
* Review: Offers the opportunity to the user to check the sharpness of the image and eventually to rotate it into reading direction,
* Analysis: Provides a UI for the analysis process of the document by showing the user a loading indicator and the image of the document.

As mentioned before the Gini Vision Library provides two integration options. A Screen API that is easy to implement and a more complex, but also more flexible Component API. Both APIs can access the complete functionality of the library.

### Screen API

The Screen API provides a custom `UINavigationController` object, which can be presented modally. It handles the complete process from showing the onboarding until providing a UI for the analysis. To start with the Screen API simply call `GINIVision.viewcontroller(withDelegate:)` and present it. Also make sure to pass an object conforming to the `GINIVisionDelegate` protocol. Optionally you can also pass in a configuration object to customize the UI of the Gini Vision Library.

Exemplary implementation Screen API:

```swift
let giniConfiguration = GINIConfiguration()
giniConfiguration.navigationBarItemTintColor = UIColor.whiteColor()
giniConfiguration.backgroundColor = UIColor.whiteColor()
presentViewController(GINIVision.viewController(withDelegate: self, withConfiguration: giniConfiguration), animated: true, completion: nil)
```

### Component API

The Component API provides a custom `UIViewController` for each of the four screens (onboarding, camera, review and analysis). This allows a maximum of flexibility, as the screens can be presented modally, used in a container view or pushed to a navigation view controller. Make sure to add your own navigational elements around the provided views.

Exemplary implementation Component API camera:

```swift
let cameraController = GINICameraViewController(success:
    { imageData in
        // Do something with the captured image
    }, failure: { error in
        print(error)
    })

@IBOutlet var containerView: UIView!
self.addChildViewController(cameraController)
cameraController.view.frame = self.containerView.bounds
self.containerView.addSubview(cameraController.view)
cameraController.didMoveToParentViewController(self)
```

To also use the `GINIConfiguration` with the Component API just use the `setConfiguration()` method of the `GINIVision` class.

```swift
let giniConfiguration = GINIConfiguration()
giniConfiguration.backgroundColor = UIColor.whiteColor()
GINIVision.setConfiguration(giniConfiguration)
```

## Example

To run the example project, clone the repo and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+
- Xcode 7.3+

## Installation

Gini Vision Library can either be installed by using CocoaPods or by manually dragging the required files to your project.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Gini Vision Library.

To integrate Gini Vision Library into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod "GiniVision"
```

Then run the following command:

```bash
$ pod install
```

## Author

Peter Pult, p.pult@gini.net

## License

Gini Vision Library is available under a commercial license. See the LICENSE file for more info.