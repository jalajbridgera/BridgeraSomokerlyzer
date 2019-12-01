
# react-native-bridgera-smokerlyzer

## Getting started

`$ npm install react-native-bridgera-smokerlyzer --save`

### Mostly automatic installation

`$ react-native link react-native-bridgera-smokerlyzer`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-bridgera-smokerlyzer` and add `RNBridgeraSmokerlyzer.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBridgeraSmokerlyzer.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNBridgeraSmokerlyzerPackage;` to the imports at the top of the file
  - Add `new RNBridgeraSmokerlyzerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-bridgera-smokerlyzer'
  	project(':react-native-bridgera-smokerlyzer').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-bridgera-smokerlyzer/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-bridgera-smokerlyzer')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNBridgeraSmokerlyzer.sln` in `node_modules/react-native-bridgera-smokerlyzer/windows/RNBridgeraSmokerlyzer.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Bridgera.Smokerlyzer.RNBridgeraSmokerlyzer;` to the usings at the top of the file
  - Add `new RNBridgeraSmokerlyzerPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNBridgeraSmokerlyzer from 'react-native-bridgera-smokerlyzer';

// TODO: What to do with the module?
RNBridgeraSmokerlyzer;
```
  