/**
 * Created by SXJH on 17/4/14.
 */
import React,{Component,PropTypes}from 'react';
import {requireNativeComponent} from 'react-native';

var  RCTScrollView = requireNativeComponent('TestScrollView',TextScrollView);

export default  class  TestScrollView extends Component{
    render(){
        return<RCTScrollView{...this.props}/>;
    }
}

TestScrollView.propTypes = {
    autoScrollTimeInterval:PropTypes.number,
    imageURLStringsGroup:PropTypes.array,
    autoScroll:PropTypes.bool,

    onClickBanner:PropTypes.func

};

modules.exports = TestScrollView;
