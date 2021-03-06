import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/widget/page/tree/tree_detail/tree_detail_tab/page.dart';

import 'state.dart';

Widget buildView(TreeDetailState state, Dispatch dispatch, ViewService viewService) {
  return _topTab(state);
}

//设置顶部tab widget
Widget _topTab(TreeDetailState state){
  return DefaultTabController(
    length: state.topList.length,
    initialIndex: 0,
    child: Scaffold(
      appBar: AppBar(
        title: Text(state.treeInfoData.name),
        bottom: TabBar(
          tabs: state.topList,
          isScrollable: true, //按钮过多,滚动
        ),
      ),
      body: TabBarView(
        children: state.topList.asMap().keys.map((int index){
          return TreeDetailTabPage().buildPage({"id": state.treeInfoData.children[index].id.toString() });
        }).toList()
      ),
    )
  );
}