using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Bridgera.Smokerlyzer.RNBridgeraSmokerlyzer
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNBridgeraSmokerlyzerModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNBridgeraSmokerlyzerModule"/>.
        /// </summary>
        internal RNBridgeraSmokerlyzerModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNBridgeraSmokerlyzer";
            }
        }
    }
}
