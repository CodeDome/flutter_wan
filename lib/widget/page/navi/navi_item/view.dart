import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/widget/utils/ui_adapter.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(NaviItemState state, Dispatch dispatch, ViewService viewService) {
  return _itemWidget(state, viewService);
}

Widget _itemWidget(NaviItemState state, ViewService viewService){
  return Card(
    margin: EdgeInsets.all(setWidth(20)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(setWidth(30)) ),
    child: Container(
      padding: EdgeInsets.only( bottom: setWidth(30)),
      child: InkWell(
        child: Column(
          children: <Widget>[
            //头部
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(setWidth(30)), topRight: Radius.circular(setWidth(30))  ),
                color: Colors.black12
              ),
              padding: EdgeInsets.only(top:setWidth(15), bottom: setWidth(15)),
              child: Center(
                child: Text(state.itemDetail.name, style: TextStyle(fontSize: setSp(34)) ),
              ),
            ),

            //内容
            Container(
              margin: EdgeInsets.only(top: setWidth(20)),
              child: GridView.builder(
                shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                itemBuilder: viewService.buildAdapter().itemBuilder,
                itemCount: viewService.buildAdapter().itemCount,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: setWidth(300),
                  childAspectRatio: 3,
                ),
              ),
            ),

          ],
        ),
      ),
    )
  );
}