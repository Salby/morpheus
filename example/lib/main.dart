import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/morpheus.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morpheus example',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.tealAccent,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.light,
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 20.0,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
        ),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    FeedScreen(),
    ListScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MorpheusTabView(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Profile'),
          ),
        ],
        onTap: (index) {
          if (index != _currentIndex) setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 128.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(18.0),
              title: Text(
                'List',
                style: Theme.of(context).appBarTheme.textTheme.title,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Divider(height: 1.0),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final parentKey = GlobalKey();
                  return ListTile(
                    key: parentKey,
                    leading: CircleAvatar(child: Text('$index')),
                    title: Text('Item $index'),
                    onTap: () => _showPost(context, parentKey, 'Item $index'),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      height: 0.0,
                    ),
                itemCount: 100,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _showPost(BuildContext context, GlobalKey parentKey, String title) {
    Navigator.of(context).push(MorpheusPageRoute(
      builder: (context) => Scaffold(
            appBar: AppBar(title: Text(title)),
          ),
      parentKey: parentKey,
    ));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fabKey = GlobalKey();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 128.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(18.0),
              title: Text(
                'Profile',
                style: Theme.of(context).appBarTheme.textTheme.title,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Divider(height: 1.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 112.0 + 32.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (context, index) => SizedBox(width: 16.0),
                  itemBuilder: (context, index) {
                    final double unit =
                        (MediaQuery.of(context).size.width - 16.0 * 4) / 3;
                    final _key = GlobalKey();
                    return Container(
                      key: _key,
                      width: unit,
                      height: unit,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () => _showPost(context, _key, 'Saved'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 0.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 112.0 + 32.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (context, index) => SizedBox(width: 16.0),
                  itemBuilder: (context, index) {
                    final double unit =
                        (MediaQuery.of(context).size.width - 16.0 * 4) / 3;
                    return Container(
                      width: unit,
                      height: unit,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 0.0),
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        key: fabKey,
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MorpheusPageRoute(
              builder: (context) => PostScreen(title: 'New post'),
              parentKey: fabKey,
              transitionColor: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(28.0),
            )),
      ),
    );
  }

  void _showPost(BuildContext context, GlobalKey parentKey, String title) {
    Navigator.of(context).push(MorpheusPageRoute(
      builder: (context) => PostScreen(
            title: title,
          ),
      parentKey: parentKey,
      transitionColor: Colors.grey[300],
      borderRadius: BorderRadius.circular(8.0),
    ));
  }
}

class FeedScreen extends StatelessWidget {
  final List<String> _titles = [
    'This is a title',
    'Hey, another title!',
    'Did you know this about that?',
    'Wow, what a title!',
    'This is a title',
    'Hey, another title!',
    'Did you know this about that?',
    'Wow, what a title!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 128.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(18.0),
              title: Text(
                'Feed',
                style: Theme.of(context).appBarTheme.textTheme.title,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Divider(height: 1.0),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final parentKey = GlobalKey();
                  return PostHeader(
                    key: parentKey,
                    title: _titles[index],
                    onTap: () => _showPost(context, parentKey, _titles[index]),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      height: 0.0,
                    ),
                itemCount: _titles.length,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _showPost(BuildContext context, GlobalKey parentKey, String title) {
    Navigator.of(context).push(MorpheusPageRoute(
      builder: (context) => PostScreen(
            title: title,
          ),
      parentKey: parentKey,
      transitionToChild: false,
    ));
  }
}

class PostHeader extends StatelessWidget {
  PostHeader({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 156.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostScreen extends StatefulWidget {
  PostScreen({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> height;
  bool display = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    height = Tween<double>(
      begin: 0.0,
      end: 80.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ))
      ..addListener(() {
        setState(() {});
      });
    play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.reverse();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: height.value,
              padding: const EdgeInsets.only(left: 8.0),
            ),
            PostHeader(
              title: widget.title,
            ),
            Container(
              height: 256.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.more_vert),
                  tooltip: 'Actions',
                  onPressed: () => null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void play() {
    if (mounted) setState(() => display = true);
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
