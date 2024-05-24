 Container(
                          height: 100,
                          width: 200,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 300,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                            ),
                            items: imageUrls.map((imageUrl) {
                              return GestureDetector(
                                onTap: () {
                                  // Implement full screen image view
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              FullScreenImageViewer(
                                                  imageUrls: imageUrls))));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }).toList(),
                          ),
                        ),