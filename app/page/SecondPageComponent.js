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
} from 'react-native';

import FirstPageComponent from './FirstPageComponent';
// import ListView1 from '../components/QCListView';

export default class SecondPageComponent extends React.Component {

    constructor(props) {
        super(props);

        // dataSource : new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            dataSource : new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
                // dataSource: ds.cloneWithRows([
                //     'John', 'Joel', 'James', 'Jimmy', 'Jackson', 'Jillian', 'Julie', 'Devin'
                // ])
        }

    }


    _onPressButton() {
        const { navigator } = this.props;
        if(navigator) {
            //很熟悉吧，入栈出栈~ 把当前的页面pop掉，这里就返回到了上一个页面:FirstPageComponent了
            navigator.pop();
        }
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
                {/*<ListView */}
                    {/*dataSource={this.state.dataSource}*/}
                    {/*renderRow={this.renderRow.bind(this)}*/}
                {/*/>*/}
            </View>
        )
    }

    renderRow(rowData){
        return(
            <TouchableOpacity onPress={()=>alert(0)}>
                {/*<View style={styles.listViewStyle}>*/}
                    {/*/!*左边*!/*/}
                    {/*<Image source={{uri:this.dealWithImgUrl(rowData.imageUrl)}} style={styles.imageViewStyle}/>*/}
                    {/*/!*右边*!/*/}
                    {/*<View style={styles.rightViewStyle}>*/}
                        {/*<View style={styles.rightTopViewStyle}>*/}
                            {/*<Text>{rowData.title}</Text>*/}
                            {/*<Text>{rowData.topRightInfo}</Text>*/}
                        {/*</View>*/}
                        {/*<Text style={{color:'gray'}}>{rowData.subTitle}</Text>*/}
                        {/*<View  style={styles.rightBottomViewStyle}>*/}
                            {/*<Text style={{color:'red'}}>{rowData.subMessage}</Text>*/}
                            {/*<Text>{rowData.bottomRightInfo}</Text>*/}
                        {/*</View>*/}
                    {/*</View>*/}
                {/*</View>*/}
                <Text>aaa</Text>
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
        backgroundColor:'gray',

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
    }
})