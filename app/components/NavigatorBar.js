/**
 * Created by SXJH on 2017/7/27.
 */
import React,{Component,PropTypes} from 'react';
import {
    View,
    TouchableOpacity,
    StyleSheet,
    Platform
} from 'react-native';
import {getPhoneSize} from './Utils';
import QcText from './cusText';

const {width,statusBarH} = getPhoneSize();

class NavigationBar extends Component {
    constructor(props) {
        super(props);

        this.layoutRecord = {
            left:false,
            right:false,
            leftWidth:0,
            rightWidth:0
        }

    }

    render(){
        return (<View style={[styles.barContainer,{backgroundColor:this.props.barBackgroundColor}]}>
            <View style={styles.barNav}>
                <View ref="left" style={styles.leftItems} onLayout={this.leftViewLayout.bind(this)}>
                    {
                        this.props.enableBack && <NavigationItem onPress={this.pop.bind(this)}>
                            <QcText>返回</QcText>
                        </NavigationItem>
                    }
                    {this.props.leftItems()}
                </View>
                <View style={styles.barTitle}>
                    {
                        this.props.title.length ? <QcText style={[styles.titleText,{color:this.props.titleColor}]}>{this.props.title}</QcText> :
                            this.props.customTitleView()
                    }
                </View>
                <View ref="right" style={styles.rightItems} onLayout={this.rightViewLayout.bind(this)}>
                    {this.props.rightItems()}
                </View>
            </View>
        </View>);
    }

    pop(){
        if (this.props.backCallbackActive) {
            return this.props.backCallback();
        }
        this.props.navigator && this.props.navigator.pop();
    }

    leftViewLayout(ev){
        this.layoutRecord.left = true;
        this.layoutRecord.leftWidth = ev.nativeEvent.layout.width;
        if (this.layoutRecord.right) {
            this.setWidth();
        }
    }
    rightViewLayout(ev){
        this.layoutRecord.right = true;
        this.layoutRecord.rightWidth = ev.nativeEvent.layout.width;
        if (this.layoutRecord.left) {
            this.setWidth();
        }
    }

    setWidth(){
        let width = Math.max(this.layoutRecord.rightWidth,this.layoutRecord.leftWidth);
        this.refs['left'].setNativeProps({
            style:{
                width:width
            }
        });
        this.refs['right'].setNativeProps({
            style:{
                width:width
            }
        });
    }

}


NavigationBar.propTypes = {
    enableBack:PropTypes.bool,
    leftItems:PropTypes.func,
    rightItems:PropTypes.func,
    customTitleView:PropTypes.func,
    title:PropTypes.string,
    titleColor:PropTypes.string,
    barBackgroundColor:PropTypes.string,
    backCallbackActive:PropTypes.bool,
    backCallback:PropTypes.func
}
NavigationBar.defaultProps = {
    enableBack:true,
    title:'',
    titleColor:'white',
    barBackgroundColor:'gray',
    backCallbackActive:false,
    backCallback:()=>{},
    customTitleView:()=>{},
    leftItems:()=>{},
    rightItems:()=>{}
}

class NavigationItem extends Component {
    render(){
        return (<TouchableOpacity onPress={this._onPress.bind(this)} style={styles.itemContainer}>
            {this.props.children}
        </TouchableOpacity>);
    }
    _onPress(){
        window.requestAnimationFrame(()=>{
            this.props.onPress();
        });
    }
}
NavigationItem.defaultProps = {
    onPress:()=>{}
}
NavigationItem.propTypes = {
    onPress:PropTypes.func
}



const styles = StyleSheet.create({
    barContainer:{
        paddingTop:Platform.select({
            ios:20,
            android:statusBarH
        })
    },
    itemContainer:{
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'center',
        paddingLeft:16,
        paddingRight:16,
        height:44
    },
    barNav:{
        height:44,
        flexDirection:'row'
    },
    barTitle:{
        flex:1,
        alignItems:'center',
        justifyContent:'center'
    },
    leftItems:{
        flexDirection:'row',
        justifyContent:'flex-start'
    },
    rightItems:{
        flexDirection:'row',
        justifyContent:'flex-end'
    },
    titleText:{
        fontSize:18
    }
});


NavigationBar.Item = NavigationItem;

export default NavigationBar;