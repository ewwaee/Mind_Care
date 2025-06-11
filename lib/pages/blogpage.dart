import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher_string.dart';




class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<dynamic> articles = [];
  List<dynamic> filteredArticles = [];
  List<bool> expanded = [];
  bool isLoading = true;
  String? error;
  String? userRole;
  String? userName;
  bool showArticleForm = false;
  String? selectedTopic;
  String searchQuery = '';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late TextEditingController _tagsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<String> psychologyTopics = [
    'Depression',
    'Anxiety',
    'Family relationships',
    'Personal growth',
    'Stress',
    'Self-esteem',
    'Partnership',
    'Parenting',
    'Work stress',
    'Crisis',
    'Psychosomatics',
    'Addiction',
    'Trauma',
    'Neuroses',
    'Communication',
    'Emotional intelligence',
    'Financial psychology',
    'Age crises',
    'Grief and loss',
    'Sexual psychology'
  ];

  @override
  void initState() {
    super.initState();
    articles = [];
    _fetchAllTopicArticles();
    _fetchVerywellMindArticles();
    _fetchPsychCentralArticles();
    _fetchMediumArticles();
  }

  String _parseHtmlString(String htmlString) {
    final document = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(document, '').replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&');
  }

  // 1. Функция: Получаем статьи из NewsAPI по каждому тегу
  Future<void> _fetchAllTopicArticles() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    const newsApiKey = '457b732de8814162af06b9401b2a1deb';
    List<dynamic> allNewsApiArticles = [];

    // Можно ускорить: делать Future.wait, но для простоты — по очереди
    for (final topic in psychologyTopics) {
      final url =
          'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(topic)}&language=en&pageSize=6&apiKey=$newsApiKey';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final loadedArticles = (data['articles'] as List).map((item) {
            return {
              'id': item['url'],
              'title': item['title'] ?? '',
              'content': item['description'] ?? '',
              'author': item['author'] ?? 'Unknown author',
              'topics': [topic],
              'date': item['publishedAt'] ?? '',
              'type': 'professional',
              'image': item['urlToImage'],
            };
          }).toList();
          allNewsApiArticles.addAll(loadedArticles);
        }
      } catch (e) {
        // Не прерываем общий цикл, просто идём дальше
      }
    }

    setState(() {
      articles.addAll(allNewsApiArticles);
      filteredArticles = articles;
      expanded = List.filled(articles.length, false);
      isLoading = false;
    });
  }

  // 2. Verywell Mind RSS
  Future<void> _fetchVerywellMindArticles() async {
    try {
      final url = 'https://api.rss2json.com/v1/api.json?rss_url=https://www.verywellmind.com/rss';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadedArticles = (data['items'] as List).map((item) {
          final title = (item['title'] ?? '').toLowerCase();
          final content = (item['description'] ?? '').toLowerCase();

          final matchedTopics = psychologyTopics.where((topic) {
            final topicLower = topic.toLowerCase();
            return title.contains(topicLower) || content.contains(topicLower);
          }).toList();
          if (matchedTopics.isEmpty) matchedTopics.add('Psychology');

          return {
            'id': item['link'],
            'title': item['title'] ?? '',
            'content': item['description'] ?? '',
            'author': item['author'] ?? 'Unknown author',
            'topics': matchedTopics,
            'date': item['pubDate'] ?? '',
            'type': 'blog',
            'image': item['thumbnail'],
          };
        }).toList();

        setState(() {
          articles.addAll(loadedArticles);
          filteredArticles = articles;
          expanded = List.filled(articles.length, false);
          isLoading = false;
        });
      }
    } catch (_) {}
  }

  // 3. Psych Central
  Future<void> _fetchPsychCentralArticles() async {
    try {
      final url = 'https://api.rss2json.com/v1/api.json?rss_url=https://psychcentral.com/blog/feed/';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadedArticles = (data['items'] as List).map((item) {
          final title = (item['title'] ?? '').toLowerCase();
          final content = (item['description'] ?? '').toLowerCase();

          final matchedTopics = psychologyTopics.where((topic) {
            final topicLower = topic.toLowerCase();
            return title.contains(topicLower) || content.contains(topicLower);
          }).toList();
          if (matchedTopics.isEmpty) matchedTopics.add('Psychology');

          return {
            'id': item['link'],
            'title': item['title'] ?? '',
            'content': item['description'] ?? '',
            'author': item['author'] ?? 'Unknown author',
            'topics': matchedTopics,
            'date': item['pubDate'] ?? '',
            'type': 'blog',
            'image': item['thumbnail'],
          };
        }).toList();

        setState(() {
          articles.addAll(loadedArticles);
          filteredArticles = articles;
          expanded = List.filled(articles.length, false);
          isLoading = false;
        });
      }
    } catch (_) {}
  }

  // 4. Medium
  Future<void> _fetchMediumArticles() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/tag/psychology'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadedArticles = (data['items'] as List).map((item) {
          final title = (item['title'] ?? '').toLowerCase();
          final content = (item['description'] ?? '').toLowerCase();

          final matchedTopics = psychologyTopics.where((topic) {
            final topicLower = topic.toLowerCase();
            return title.contains(topicLower) || content.contains(topicLower);
          }).toList();
          if (matchedTopics.isEmpty) matchedTopics.add('Psychology');

          return {
            'id': item['link'],
            'title': item['title'] ?? '',
            'content': item['description'] ?? '',
            'author': item['author'] ?? 'Unknown author',
            'topics': matchedTopics,
            'date': item['pubDate'] ?? '',
            'type': 'blog',
            'image': item['thumbnail'],
          };
        }).toList();

        setState(() {
          articles.addAll(loadedArticles);
          filteredArticles = articles;
          expanded = List.filled(articles.length, false);
          isLoading = false;
        });
      }
    } catch (e) {}
  }

  void _filterArticles() {
    setState(() {
      filteredArticles = articles.where((article) {
        final matchesTopic = selectedTopic == null ||
            (article['topics'] as List).contains(selectedTopic);
        final matchesSearch = searchQuery.isEmpty ||
            article['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            article['content'].toLowerCase().contains(searchQuery.toLowerCase());
        return matchesTopic && matchesSearch;
      }).toList();
      expanded = List.filled(filteredArticles.length, false);
    });
  }

  // Остальные методы (submitArticle, build, buildArticleCard, buildSearchAndFilter, buildArticleForm) — оставь как у тебя выше.

  Future<void> _submitArticle() async {
    // твой код — не менялся
  }

  Widget _buildArticleCard(int index) {
    final article = filteredArticles[index];
    final isExpanded = expanded[index];
    final isProfessional = article['type'] == 'professional';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => expanded[index] = !isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article['image'] != null &&
                  article['image'].toString().startsWith('http'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article['image'],
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (article['topics'] != null && (article['topics'] as List).isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (article['topics'] as List).map((topic) => Chip(
                    label: Text(topic),
                    backgroundColor:
                    isProfessional ? Colors.blue[50] : Colors.green[50],
                    labelStyle: TextStyle(
                      color: isProfessional
                          ? Colors.blue[800]
                          : Colors.green[800],
                      fontSize: 12,
                    ),
                  )).toList(),
                ),
              const SizedBox(height: 12),
              Text(
                _parseHtmlString(article['title']),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isProfessional ? Icons.medical_services : Icons.people,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  // Используй Expanded, чтобы текст переносился!
                  Expanded(
                    child: Text(
                      article['author'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    article['date'].toString().split('T')[0],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: Text(
                  _parseHtmlString(article['content']).length > 150
                      ? '${_parseHtmlString(article['content']).substring(0, 150)}...'
                      : _parseHtmlString(article['content']),
                  style: const TextStyle(fontSize: 15),
                ),
                secondChild: Text(
                  _parseHtmlString(article['content']),
                  style: const TextStyle(fontSize: 15),
                ),
                crossFadeState:
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final url = article['id'];
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    isExpanded ? 'Collapse' : 'Read more',
                    style: TextStyle(
                      color: isProfessional ? Colors.blue[800] : Colors.green[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search articles...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
              _filterArticles();
            },
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedTopic,
            decoration: InputDecoration(
              labelText: 'Filter by topic',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All topics'),
              ),
              ...psychologyTopics.map((topic) => DropdownMenuItem(
                value: topic,
                child: Text(topic),
              )).toList(),
            ],
            onChanged: (value) {
              setState(() {
                selectedTopic = value;
              });
              _filterArticles();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticleForm() {
    // Оставь как у тебя было, не менял
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final canAddArticle = userRole == 'Psychologist' || userRole == 'Volunteer';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychology Blog'),
        actions: [
          if (canAddArticle)
            IconButton(
              icon: Icon(showArticleForm ? Icons.close : Icons.add),
              onPressed: () {
                setState(() {
                  showArticleForm = !showArticleForm;
                  if (!showArticleForm) {
                    _titleController.clear();
                    _contentController.clear();
                    _tagsController.clear();
                  }
                });
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : showArticleForm
          ? _buildArticleForm()
          : Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: filteredArticles.isEmpty
                ? const Center(
              child: Text(
                'No articles found',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) =>
                  _buildArticleCard(index),
            ),
          ),
        ],
      ),
      floatingActionButton: !showArticleForm && canAddArticle
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            showArticleForm = true;
          });
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
