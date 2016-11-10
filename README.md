
## ZBJCalendar [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/wanggang316/URLRouter/master/LICENSE) [![Cocoapods](https://img.shields.io/cocoapods/v/URLRouter.svg)](https://cocoapods.org/?q=zbjcALENDAR)  


> URLRouter is a url manager based regular expressions, it is inspired by [URLNavigator](https://github.com/devxoul/URLNavigator). But i don't like the `URLMatcher` in `URLNavigator`. I like regular expressions which is smaller but stronger.

> Thanks [devxoul](https://github.com/devxoul) for the excellent projects he opend.


## Requirements

 * iOS 8 or later

## Installation with CocoaPods
`pod 'URLRouter'`

## Installation with Carthage
`github "wanggang316/URLRouter"`


## Useage

### Registe

* Registe a class which is implements the `URLRoutable` protocol

```
URLRouter.default.map("abc://page/city/\\d+\\?name=\\w+", routable: CityViewController.self)
URLRouter.default.map("abc://page/user/\\d+", routable: UserViewController.self)
```

* Registe a handler closure

```
URLRouter.default.map("tel:[^\\s]+", handler: { (url) in
    UIApplication.shared.open(url.urlValue!)
    return true
})

URLRouter.default.map("abc://alert\\?title=\\w+&message=\\w+", handler: { (url) in

    let params = url.urlValue?.queryParameters
    let title = params?["title"]
    let message = params?["message"]
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    appdelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    
    return true
})
```

### Handle url

* handler via push or present action

```
URLRouter.default.push(url, from: self.navigationController!)
```

* handle via the closure

```
URLRouter.default.open(url)
```

## License

URLRouter is released under the MIT license.






