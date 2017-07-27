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
    ScrollView,
    RefreshControl,
} from 'react-native';
import FirstPage from '../page/SecondPageComponent'

import LiveDetailPage from './LiveDetailPage';
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
            isRefreshing: false,
            loaded: 0,
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
                {/*<TouchableOpacity onPress={()=>{this._pushToDetail()}}>*/}
                {/*<Text style={styles.textStyle}>test</Text>*/}
                {/*</TouchableOpacity>*/}

                <Image source={ {uri:'qingclasslogo_icon'} } style={{height:22,width:40,bottom:-10}}/>

            </View>
        )
    }
    _pushToDetail(){
        this.props.navigator.push(
            {
                component: LiveDetailPage, // 要跳转的版块
                title:'详情页',
                passProps:{
                    tabBar: {
                        hide: () => this.props.tabBar.hide(),
                        show: () => this.props.tabBar.show()
                    }
                }
            }
        )
    }
    _onRefresh() {
        this.setState({isRefreshing: true});
        setTimeout(()=>{
            this.setState( {
                dataSource:this.state.dataSource.cloneWithRows(homeData.rooms),
            })
            this.setState({isRefreshing: false})
        },2000)
    }

    _renderLevelItem(){
        // 组件数组
        var itemArr = [];
        for(var i=0; i<3; i++){
            itemArr.push(
                <View style={{width:100,backgroundColor:'red'}}>
                    <Text style={{textAlign:'center',backgroundColor:'gray',}}>111</Text>

                </View>
            );
        }
        // 返回组件数组
        return itemArr;
    }
    render() {
        return (
            <View style={styles.container}>
                {this.topView()}
                {/*<View style={styles.tabStyles}>*/}
                {/*{this._renderLevelItem()}*/}
                {/*</View>*/}
                <ScrollView
                    refreshControl={
                        <RefreshControl
                            refreshing={this.state.isRefreshing}
                            onRefresh={this._onRefresh.bind(this)}
                            tintColor="#ff0000"
                            title="Loading..."
                            colors={['#ff0000', '#00ff00', '#0000ff']}
                        />}>
                    <ListView
                        dataSource={this.state.dataSource}
                        renderRow={this.renderRow.bind(this)}
                        enableEmptySections={true}
                    />
                </ScrollView>
            </View>

        )
    }
    pushDetail(){
        this.props.navigator.push({
            component: SecondPageComponent,
            passProps: {
                name: 'hh',
                // tabBar: {
                //     hide: () => this.props.tabBar.hide(),
                //     show: () => this.props.tabBar.show()
                // }
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
        // this.fetchNetData();
        this.setState( {
            dataSource:this.state.dataSource.cloneWithRows(homeData.rooms)
        })
    }

    /*参数传递需要加上{}*/
    /* onPress={() =>
     //  navigate('Profile', { name: 'Jane' }*/
    renderRow(rowData){
        return(
        <TouchableOpacity onPress={()=>{{this._pushToDetail()}}}>
            <View style={styles.cellStyle}>
                <Image
                    style={styles.cellImageStyle}
                    resizeMode={'cover'}
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

        // 垂直居中
        alignItems:'center',

        // 水平
        justifyContent:'center'
    },
    container: {
        flex:1,
    },
    textStyle:{
        // paddingTop:20,
        fontSize:20,
    },
    cellStyle:{
        flex:1,
        // backgroundColor:'gray',

    },
    tabStyles:{
        backgroundColor:'gray',
        height:44,
        flexDirection:'row',
        justifyContent:'space-around',
    },
    middleStyle:{
        backgroundColor: 'gray',
        marginBottom:7,
        justifyContent:'space-between'
    },
    cellImageStyle:{
        height:200,

    }
})