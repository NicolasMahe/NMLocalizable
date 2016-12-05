# NMLocalize

[![CI Status](http://img.shields.io/travis/Nicolas Mahé/NMLocalize.svg?style=flat)](https://travis-ci.org/Nicolas Mahé/NMLocalize)
[![Version](https://img.shields.io/cocoapods/v/NMLocalize.svg?style=flat)](http://cocoapods.org/pods/NMLocalize)
[![License](https://img.shields.io/cocoapods/l/NMLocalize.svg?style=flat)](http://cocoapods.org/pods/NMLocalize)
[![Platform](https://img.shields.io/cocoapods/p/NMLocalize.svg?style=flat)](http://cocoapods.org/pods/NMLocalize)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NMLocalize is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NMLocalize"
```

## Extract Localizable String from swift files

To extract localizable string (eg: `L("your_localizable_string")`) from all your swift files, you can use the `ExtractLocalizableString.exec` bin from this repo.

### Utilisation

```
$ ExtractLocalizableString.exec arg1 arg2 (arg3)
```

#### Arg1
Argi1 is the path to the project where the swift file are. Be carefull to put an `/` at the end of the path.

#### Arg2
Argi2 is the path to the localizable file.

#### Arg3 - Optional
Argi3 is optional and force the value of new Localizable string

### Example

```
$ ExtractLocalizableString.exec /path/to/your/project/ /path/to/your/project/fr.lproj/Localizable.strings TO_TRANSLATE
```


## Author

Nicolas Mahé, nicolas@mahe.me

## License

NMLocalize is available under the MIT license. See the LICENSE file for more info.
