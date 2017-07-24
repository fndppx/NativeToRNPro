/**
 * Created by SXJH on 17/4/17.
 */
import React from 'react';
import {
    View,
    Navigator,
    TouchableOpacity,
    Text,
    StyleSheet,
    Platform,
    ListView,
    Image,
    navigation,
} from 'react-native';

import FirstPageComponent from './FirstPageComponent';
// import ListView1 from '../components/QCListView';

export default class SecondPageComponent extends React.Component {

    constructor(props) {
        super(props);

        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            dataSource: ds.cloneWithRows(['第一行', '第二行']),
        };

    }

    _onPressButton() {
        const { navigator } = this.props;
        if(navigator) {
            //很熟悉吧，入栈出栈~ 把当前的页面pop掉，这里就返回到了上一个页面:FirstPageComponent了
            navigator.pop();
        }
    }

    _navigate(name, type = 'Normal') {
        this.props.navigator.push({
            component: SecondPage,
            passProps: {
                name: name
            },
            type: type
        })
    }


    topView(){
        return(
            <View style={styles.topViewStyle}>
                {/*<TouchableOpacity onPress={()=>{this.pushToDetail()}}>*/}
                <Text style={styles.textStyle}>test</Text>
                {/*</TouchableOpacity>*/}
            </View>

        )
    }


    render() {
        return (
            <View>
                {/*var  topView={this.topView.bind(this)}*/}
                {this.topView.bind(this)()}
                <ListView
                    dataSource={this.state.dataSource}
                    renderRow={this.renderRow.bind(this)}
                />

            </View>
        )
    }
    pushDetail(){
        this.props.navigator.push({
            component: SecondPageComponent,
            passProps: {
                name: 'hh'
            },
            type: 'Normal'
        })

    }

    /*参数传递需要加上{}*/
    /* onPress={() =>
     //  navigate('Profile', { name: 'Jane' }*/
    renderRow(rowData){
        return(
            <TouchableOpacity onPress={this.pushDetail.bind(this)}>
                <View style={styles.cellStyle}>
                    <Image
                        style={styles.cellImageStyle}
                        source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}}
                    />
                    <Text style={{fontSize:16}}>{rowData}</Text>
                    <View style={{height:10}}>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}


const  styles = StyleSheet.create({
    topViewStyle:{
        paddingLeft:10,
        paddingRight:10,
        marginTop: Platform.OS == 'ios' ? 25 : 0,
        height: Platform.OS == 'ios' ? 45 : 45,
        backgroundColor:'red',

        // 设置主轴的方向
        flexDirection:'row',
        // 垂直居中 ---> 设置侧轴的对齐方式
        alignItems:'center',

        // 设置主轴的对齐方式
        justifyContent:'space-around'
    },
    container: {
        // flex: 0,
        alignItems:'center',
        backgroundColor: '#06c1ae'
    },
    textStyle:{
        paddingTop:20,
        fontSize:20,
    },
    cellStyle:{
        flex:1,
    },
    cellImageStyle:{
        height:200,

    }
})