/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    ScrollView,
    Button,
    requireNativeComponent,
    NativeAppEventEmitter,
    NativeModules,
    Platform,
} from 'react-native';

//listView
// import  ListViewBasics from  './app/components/QCListView';
//navigation
// import  navigation from  './app/components/QCNavigation';

import Navigation from './app/components/QCNavigationCustom';

console.disableYellowBox = true;
console.warn('YellowBox is disabled.');
export default class NativeToJSPro extends Component {
    render() {
        return (
            <Navigation/>
        );
    }
}
AppRegistry.registerComponent('NativeToJSPro', () => NativeToJSPro);


// AppRegistry.registerComponent('NativeToJSPro', () => ListViewBasics);
