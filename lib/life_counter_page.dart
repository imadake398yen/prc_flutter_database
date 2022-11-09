import 'package:flutter/material.dart';
import 'objectbox.g.dart';
import 'life_event.dart';
import 'add_life_event_page.dart';

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key});

  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  Store? store;
  Box<LifeEvent>? lifeEventBox;
  List<LifeEvent> lifeEvents = [];

  Future<void> initialize() async {
    store = await openStore();
    lifeEventBox = store?.box<LifeEvent>();
    fetchLifeEvents();
  }

  void fetchLifeEvents() {
    lifeEvents = lifeEventBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('人生カウンター'),
      ),
      body: ListView.builder(
        itemCount: lifeEvents.length,
        itemBuilder: ((context, index) {
          final lifeEvent = lifeEvents[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    lifeEvent.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  '${lifeEvent.count}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    lifeEvent.count++;
                    lifeEventBox?.put(lifeEvent);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.add_circle),
                ),
                IconButton(
                  onPressed: () {
                    if (lifeEvent.count > 0) lifeEvent.count--;
                    lifeEventBox?.put(lifeEvent);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.remove_circle),
                ),
                IconButton(
                  onPressed: () {
                    lifeEventBox?.remove(lifeEvent.id);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newLifeEvent = await Navigator.of(context).push<LifeEvent>(
            MaterialPageRoute(builder: (context) {
              return const AddLifeEventPage();
            }),
          );
          if (newLifeEvent != null) {
            lifeEventBox?.put(newLifeEvent);
            lifeEvents = lifeEventBox?.getAll() ?? [];
            setState(() {});
          }
        },
      ),
    );
  }
}
