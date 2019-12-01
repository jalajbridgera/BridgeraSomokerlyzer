
import { NativeModules } from 'react-native';

//import SmokerLyzer from './src/SmokerLyzer';

// var Orientation = require('react-native').NativeModules.Orientation;
// var DeviceEventEmitter = require('react-native').DeviceEventEmitter;

const { RNBridgeraSmokerlyzer } = NativeModules;


var listeners = {};

var DeviceEventEmitter = require('react-native').DeviceEventEmitter;
var smokerlyzerDidChangeEvent = 'smokerlyzerDidChange';
//const BridgeraSmokerlyzer = require('react-native').NativeModules.RNBridgeraSmokerlyzer;
//export default BridgeraSmokerlyzer;

var id = 0;
var META = '__listener_id';

function getKey(listener) {
  if (!listener.hasOwnProperty(META)) {
    if (!Object.isExtensible(listener)) {
      return 'F';
    }

    Object.defineProperty(listener, META, {
      value: 'L' + ++id,
    });
  }

  return listener[META];
};

module.exports =  { 
    
  registerCallBack(cb){

    return RNBridgeraSmokerlyzer.registerCallBack(cb);
},


  startTest(msg,cb){

        return RNBridgeraSmokerlyzer.startTest(cb);
    },
    onSmokeDestroy(cb){

      return RNBridgeraSmokerlyzer.onSmokeDestroy(cb);
    },
    
    addSmokerlyzerListener(cb) {
    var key = getKey(cb);
    listeners[key] = DeviceEventEmitter.addListener(smokerlyzerDidChangeEvent,
      (body) => {
        cb(body.smokerlyzer);
      });
  },

  removeSmokerlyzerListener(cb) {
    var key = getKey(cb);

    if (!listeners[key]) {
      return;
    }

    listeners[key].remove();
    listeners[key] = null;
  },
}
// export { 
//     SmokerLyzer
// };