
## RouterMan [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/wanggang316/URLRouter/master/LICENSE) [![Cocoapods](https://img.shields.io/cocoapods/v/URLRouter.svg)](https://cocoapods.org/?q=zbjcALENDAR)  


> RouterMan is a protocol-oriented url router,  base on regular expressions. RouterMan is simple and extensible.


## Requirements

 * iOS 10 or later
 * Swift 4

##Features 

- [x] Regular expressions support
- [x] Storyboard controller support，you can open a storyboard based controller easily
- [x] Mutable source urls to a target behavior
- [x] Mutable transitions support



## Installation with CocoaPods
`pod 'RouterMan'`

## Installation with Carthage
`github "wanggang316/RouterMan"`


## Useage

It's simple to use RouterMan, implement `RoutableType` based protocol for your controller or other types, then registe it to RouteMan, done.

`RoutableType` is routable base protocol, it derivative three protocols

* `RoutableControllerType`
* `RoutableStoryboardControllerType`
* `RoutableActionType`



#### Config RoutableType

* RoutableControllerType

```Swift
class CityViewController: UIViewController: RoutableControllerType {
    
	static var patterns: [String] {
        return ["abc://page/cities/\\d+\\?name=\\w+"]
    }
    
    required convenience init(_ url: URLConvertible) {
        self.init()
        let params = url.urlValue?.queryParameters
        let title = params?["name"]
        self.title = title
    }
}
```

* RoutableStoryboardControllerType

``` swift
// MARK: - RoutableStoryboardControllerType

extension StoryViewController: RoutableStoryboardControllerType {
    
    static var patterns: [String] {
        return ["abc://page/stories/\\d+\\?name=\\S+",
                "http://www.xxx.com/stories/\\d+\\?name=\\w+"]
    }
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var identifier: String {
        return "StoryViewController"
    }
    
    func initViewController(_ url: URLConvertible) {
        print("story parameters: \(String(describing: url.urlStringValue))")
        self.storyId = url.urlValue?.pathComponents.last
        self.storyName = url.urlValue?.queryParameters["name"]
    }
}
```

* RoutableActionType

```Swift
class AlertActionRouter: RoutableActionType {
    static func handle(_ url: URLConvertible) -> Bool {
        let title = url.urlValue?.queryParameters["title"]
        let message = url.urlValue?.queryParameters["message"]

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))

        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)

        return true
    }
    
    static var patterns: [String] {
        return ["abc://alert\\?title=\\w+&message=\\w+"]
    }
}
```



#### Registe

```Swift
Router.default.registe(CityViewController.self)
Router.default.registe(StoryViewController.self)
Router.default.registe(AlertActionRouter.self)
```

#### Handle

``` swift
try? Router.default.handle(url)
```

## License

RouterMan is released under the MIT license.






