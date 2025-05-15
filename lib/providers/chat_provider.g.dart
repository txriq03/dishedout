// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageStreamHash() => r'9956ecf100fdcdc7797365db33ad6f6f129985f6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [messageStream].
@ProviderFor(messageStream)
const messageStreamProvider = MessageStreamFamily();

/// See also [messageStream].
class MessageStreamFamily extends Family<AsyncValue<List<MessageModel>>> {
  /// See also [messageStream].
  const MessageStreamFamily();

  /// See also [messageStream].
  MessageStreamProvider call(String otherUserId) {
    return MessageStreamProvider(otherUserId);
  }

  @override
  MessageStreamProvider getProviderOverride(
    covariant MessageStreamProvider provider,
  ) {
    return call(provider.otherUserId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messageStreamProvider';
}

/// See also [messageStream].
class MessageStreamProvider
    extends AutoDisposeStreamProvider<List<MessageModel>> {
  /// See also [messageStream].
  MessageStreamProvider(String otherUserId)
    : this._internal(
        (ref) => messageStream(ref as MessageStreamRef, otherUserId),
        from: messageStreamProvider,
        name: r'messageStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$messageStreamHash,
        dependencies: MessageStreamFamily._dependencies,
        allTransitiveDependencies:
            MessageStreamFamily._allTransitiveDependencies,
        otherUserId: otherUserId,
      );

  MessageStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.otherUserId,
  }) : super.internal();

  final String otherUserId;

  @override
  Override overrideWith(
    Stream<List<MessageModel>> Function(MessageStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessageStreamProvider._internal(
        (ref) => create(ref as MessageStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        otherUserId: otherUserId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageModel>> createElement() {
    return _MessageStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageStreamProvider && other.otherUserId == otherUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessageStreamRef on AutoDisposeStreamProviderRef<List<MessageModel>> {
  /// The parameter `otherUserId` of this provider.
  String get otherUserId;
}

class _MessageStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageModel>>
    with MessageStreamRef {
  _MessageStreamProviderElement(super.provider);

  @override
  String get otherUserId => (origin as MessageStreamProvider).otherUserId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
