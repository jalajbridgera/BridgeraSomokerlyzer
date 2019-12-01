import {
    NativeModules,
    DeviceEventEmitter,
    NativeAppEventEmitter,
    Platform,Component
  } from 'react-native';

  import async from 'async';


  export default class SmokerLyzer extends Component {
    constructor(props) {
      super(props);
      // this.state = {
      //   sessionInfo: null,
      // };
      // this.otrnEventHandler = getOtrnErrorEventHandler(this.props.eventHandlers);
    }


    callMyName(){

     return NativeModules.callMyName();

    }
  }