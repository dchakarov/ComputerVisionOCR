# ComputerVisionOCR
A service to send images to Azure Computer Vision OCR service and get the parsed text

## Requirements
- Xcode 9.0
- iOS 11.0
- Swift 4.0

## Contribute
PRs accepted.


## Install
### Carthage

You can use [Carthage](https://github.com/Carthage/Carthage) to install `ComputerVisionOCR` by adding it to your `Cartfile`:

```bash
github "dchakarov/ComputerVisionOCR"
```

### Manually

Clone or download this repository, and copy over the `ComputerVisionOCR.swift` file to your project.

## Usage
### Initialization
`ComputerVisionOCR` is a singleton and you need to configure it before you use it. To do that, please set your API Key for Azure Computer Vision and the URL to the server you are set to connect to (e.g. `https://westeurope.api.cognitive.microsoft.com/vision/v1.0`) , like so:

```swift
ComputerVisionOCR.shared.configure(
	apiKey: "YOUR_API_KEY",
	baseUrl: "YOUR_BASE_URL")
```
Don't forget to include the framework first:

```swift
import Lumina

```
### OCR
Once configured, using the framework is straight forward:

```swift
ComputerVisionOCR.shared.requestOCRString(imageData) { parseResult in
	guard let parseResult = parseResult else { fatalError("No text found!") }
	debugPrint(parseResult) // Each line is a String in the resulting array
}
```

## License
Unlicense.
