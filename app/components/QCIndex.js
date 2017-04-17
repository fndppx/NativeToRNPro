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
    ListView
} from 'react-native';

// var PasswordView = NativeModules.TestPasswordViewManager;
//
//
// var BlackboardEditorVC = NativeModules.QCBlackboardEditorManager;
//时间监听器
// const EventEmitter = Platform.select({
//     ios:NativeAppEventEmitter,
// });

// var  subscription = NativeAppEventEmitter.addListener(
//     'Save', (reminder) => {
//         console.log("dismiss");
//
//     }
// );
// EventEmitter.addListener('Dismiss',(ev)=> {
//     console.log("dismiss");
// });
// EventEmitter.addListener('Save',(ev)=> {
//     console.log("save");
//
// });

export default class NativeToJSPro1 extends Component {

    // constructor(props){
    //     super(props);
    //     this.state={
    //         bannerNum:0
    //     }
    // }
    // render() {
    //     const onPressButtonOne =() =>{
    //         PasswordView.showPassWordWithTitle("ss");
    //     };
    //     const onPressButtonTwo =() =>{
    //         BlackboardEditorVC.pushBlackboardVC();
    //     };
    //     return (
    //         <View style={{ marginTop:50,flexDirection: 'row', justifyContent: 'center'}}>
    //             <Button color='red'  title="密码框"  onPress={onPressButtonOne}/>
    //             <Button title="小黑板" onPress={onPressButtonTwo}/>
    //         </View>
    //
    //     );
    // }
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

{/*<ScrollView style = {{marginTop:64}}>*/}
{/*<View>*/}
{/*<TestScrollView style={styles.container}*/}
{/*autoScrollTimeInterval = {2}*/}
{/*imageURLStringsGroup = {bannerImgs}*/}
{/*pageControlAliment = {TestScrollViewConsts.SDCycleScrollViewPageContolAliment.right}*/}
{/*onClickBanner={(e) => {*/}
{/*console.log('test' + e.nativeEvent.value);*/}
{/*this.setState({bannerNum:e.nativeEvent.value});*/}
{/*}}*/}
{/*/>*/}
{/*<Text style={{fontSize: 15, margin: 10, textAlign:'center'}}>*/}
{/*点击banner -> {this.state.bannerNum}*/}
{/*</Text>*/}
{/*</View>*/}
{/*</ScrollView>*/}
//  实际组件的具体大小位置由js控制
// const styles = StyleSheet.create({
//     container:{
//         padding:30,
//         borderColor:'#e7e7e7',
//         marginTop:10,
//         height:200,
//         width:100,
//     },
// });


AppRegistry.registerComponent('NativeToJSPro', () => NativeToJSPro1);
