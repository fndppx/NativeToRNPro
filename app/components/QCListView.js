/**
 * Created by SXJH on 17/4/17.
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
    ListView
} from 'react-native';

export default class ListViewBasics extends Component{
    constructor(props){
        super(props);
        const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            dataSource: ds.cloneWithRows([
                'John', 'Joel', 'James', 'Jimmy', 'Jackson', 'Jillian', 'Julie', 'Devin'
            ])
        };
    }
    render(){
        return (
            <View style={{flex: 1, paddingTop: 22}}>
                <ListView
                    dataSource={this.state.dataSource}
                    renderRow={(rowData) => <Text>{rowData}</Text>}
                />
            </View>
        );
    }
    componentWillUnmount(){
        subscription.remove();
    }

}
AppRegistry.registerComponent('NativeToJSPro', () => ListViewBasics);
