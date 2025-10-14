import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class SearchBox extends StatefulWidget {
  final Function onSearch;
  final String placeholder;

  SearchBox({this.onSearch, this.placeholder});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(_searchQuery.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      // Padding(
      // child:
      Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor.withOpacity(0.5),
          color: barColor,
          borderRadius: BorderRadius.circular(100),
        ),
        // child: Padding(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: widget.onSearch,
                  controller: _searchQuery,
                  style:  TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      EvilIcons.search,
                      color: Colors.white70,
                    ),
                    suffixIcon: InkWell(
                      onTap: (){
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.of(context).pop();
                      },
                      child:Icon(
                      EvilIcons.close,
                      color: primary,
                    ),),
                    hintText: widget.placeholder == null
                        ? 'Recherche...'
                        : widget.placeholder,
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
      //   ),
      // ),
    );
  }
}
