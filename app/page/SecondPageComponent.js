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
import homeData from  '../LocalData/home.json'

export default class SecondPageComponent extends React.Component {
    //有分號
    static defaultProps = {
        // dataArray:homeData.rooms,
        dataArray:[],
    };
    constructor(props) {
        super(props);
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            dataSource: ds.cloneWithRows(this.props.dataArray),
        };
    }

    _onPressButton() {
        const { navigator } = this.props;
        if(navigator) {
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
                {/*<Text style={styles.textStyle}>test</Text>*/}
                {/*</TouchableOpacity>*/}

                <Image source={ {uri:'qingclasslogo_icon'} } style={{height:22,width:40,bottom:-10}}/>

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

    fetchNetData(){
        //this 不能写里边
        let that = this
        fetch('https://streaming-jupiter.qingclass.com/api/streaming/v1/room/all', {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json;charset=utf-8',
                'x-version-key':'a27a1bf3-b97d-4deb-bfef-7975fc00926d',
                'x-session-id':'9856be32-e634-4fd2-a6da-eff533243cb0'
            }
        }).then(function(res){
            if (res.ok){
                res.json().then(function(data){
                    // alert(data.rooms[0].title)
                    that.setState( {
                        dataSource:that.state.dataSource.cloneWithRows(data.rooms)
                            })
                })
            }else{
                alert('error')
            }
        }).done()

    }

    componentDidMount() {
        this.fetchNetData();
    //通过改变state动态加载view
    //     this.setState( {
    //         dataSource:this.state.dataSource.cloneWithRows(homeData.rooms)
    //     })
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
                        source={{uri: rowData.cover}}
                    />
                    <Text style={{fontSize:16}}>{rowData.title}</Text>
                    <View style={{height:10}}>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }

}


const  styles = StyleSheet.create({
    topViewStyle:{
        marginTop: 0,
        height:64,
        backgroundColor:'white',

        // // 设置主轴的方向
        // flexDirection:'row',
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
        // paddingTop:20,
        fontSize:20,
    },
    cellStyle:{
        flex:1,
    },
    cellImageStyle:{
        height:200,

    }
})