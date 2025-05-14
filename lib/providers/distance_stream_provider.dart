import 'package:dishedout/providers/notifications_provider.dart';
import 'package:dishedout/services/maps_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/post_service.dart';

part 'distance_stream_provider.g.dart';

@riverpod
Stream<double> distanceStream(Ref ref) {
  final post = ref.watch(claimedPostProvider);

  return post.when(
    data: (post) {
      if (post == null) return const Stream.empty();
      final LatLng location = LatLng(post.latitude, post.longitude);
      return MapService().getDistanceStream(location);
    },
    error: (e, _) => Stream.error(e),
    loading: () => const Stream.empty(),
  );
}
