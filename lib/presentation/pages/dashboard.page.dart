import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac/data/models/user.models.dart';
import 'package:prac/logic/now_playing/cubit/now_playing_cubit.dart';
import 'package:prac/logic/top_rated/cubit/top_rated_cubit.dart';
import 'package:prac/presentation/pages/search.page.dart';
import 'package:prac/presentation/pages/we_movies.page.dart';
import 'package:prac/presentation/widgets/shared/app_bar.widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  UserAddressModel? userAddress;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    WeMoviesPage(),
    Center(
      child: Text(
        'Explore',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Upcoming',
        style: optionStyle,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    userAddress ??=
        ModalRoute.of(context)!.settings.arguments as UserAddressModel;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xffc6aeb2), Color(0xfff8f7f7)],
        stops: [0.35, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingCubit>(
            create: (BuildContext context) => NowPlayingCubit(),
          ),
          BlocProvider<TopRatedCubit>(
            create: (BuildContext context) => TopRatedCubit(),
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: WeAppBar(
            context,
            title: 'Search Movies by name....',
            titleHeight: 104,
            bottomHeight: 24,
            userAddress: userAddress,
            onTap: () {
              showSearch(
                context: context,
                delegate: MoviesListSearchDelegate(theme: Theme.of(context)),
              );
            },
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/we_work_logo.png",
                  height: 24,
                  width: 24,
                ),
                label: 'We Movies',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Explore',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Upcoming',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
