import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/category.dart';
import 'package:mealknight/models/search_data.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/requests/search.request.dart';
import 'package:mealknight/services/navigation.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/view_models/search_filter.vm.dart';
import 'package:mealknight/widgets/bottomsheets/search_filter.bottomsheet.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/utils.dart';

class SearchViewModel extends MyBaseViewModel {
  //
  SearchRequest _searchRequest = SearchRequest();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  TextEditingController searchTEC = TextEditingController();
  SearchData? searchData;
  String keyword = "";
  String type = "";
  Category? category;
  Search? search;
  int selectTagId = 2;
  bool showGrid = false;

  //
  int queryPage = 1;
  List<dynamic> searchResults = [];
  bool filterByProducts = true;
  SearchFilterViewModel? searchFilterVM;
  List<String> searchHistory = [];

  SearchViewModel(BuildContext context, this.search) {
    this.viewContext = context;
    this.vendorType = this.search?.vendorType;
    //
    if (search != null && search!.showType != null) {
      setSlectedTag(search!.showType!);
    }
  }

  //
  startSearch({bool initialLoaoding = true}) async {
    //
    if (initialLoaoding) {
      setBusy(true);
      queryPage = 1;
      refreshController.refreshCompleted();
    } else {
      queryPage = queryPage + 1;
    }

    //
    try {
      final searchResult = await _searchRequest.searchRequest(
        keyword: keyword,
        search: search!,
        page: queryPage,
      );
      clearErrors();

      for (dynamic searchItem in searchResult) {
        /*if (searchItem is Vendor) {
          Utils.vendorDistanceFromDefaultAddress(searchItem).then((value) {
            searchItem.distance = value;
            notifyListeners();
          });
        }*/
      }
          if (initialLoaoding) {
        searchResults = searchResult;
      } else {
        searchResults.addAll(searchResult);
      }
      print("My search data$searchResults");
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      rethrow;
    }

    if (!initialLoaoding) {
      refreshController.loadComplete();
    }
    //done loading data
    setBusy(false);
  }
  void onFavoriteChange(int index, bool isFavorite, dynamic vendors) {
    vendors[index].isFavorite = isFavorite;
    if (vendors[index].id == vendor?.id) {
      vendor?.isFavorite = isFavorite;
    }
    notifyListeners();
  }
  //
  void showFilterOptions() async {
    searchFilterVM ??= SearchFilterViewModel(viewContext, search!);

    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SearchFilterBottomSheet(
          search: search!,
          vm: searchFilterVM!,
          onSubmitted: (mSearch) {
            search = mSearch;
            queryPage = 1;
            startSearch();
          },
        );
      },
    );
  }

  //
  productSelected(Product product) async {
    final page = NavigationService().productDetailsPageWidget(product);
    viewContext.nextPage(page);
  }

  //
  vendorSelected(Vendor vendor) async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }

  setSlectedTag(int tagId) {
    //start the reassign the tagId from search to the view type of tag
    if (tagId == 4) {
      tagId = 1;
    } else if (tagId == 5) {
      tagId = 3;
    }
    //END

    selectTagId = tagId;
    refreshController = new RefreshController();
    //
    search?.genApiType(selectTagId);
    startSearch();
  }

  toggleShowGird(bool mShowGrid) {
    showGrid = mShowGrid;
    refreshController = new RefreshController();
    notifyListeners();
  }
}
