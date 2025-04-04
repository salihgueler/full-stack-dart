/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_emoji_counter_client/src/protocol/reaction.dart'
    as _i3;
import 'protocol.dart' as _i4;

/// {@category Endpoint}
class EndpointExample extends _i1.EndpointRef {
  EndpointExample(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'example';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointReaction extends _i1.EndpointRef {
  EndpointReaction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reaction';

  _i2.Stream<_i3.Reaction> streamReactions() => caller
          .callStreamingServerEndpoint<_i2.Stream<_i3.Reaction>, _i3.Reaction>(
        'reaction',
        'streamReactions',
        {},
        {},
      );

  _i2.Future<void> sendReaction(_i3.Reaction reaction) =>
      caller.callServerEndpoint<void>(
        'reaction',
        'sendReaction',
        {'reaction': reaction},
      );

  _i2.Future<Map<String, int>> getReactionCounts() =>
      caller.callServerEndpoint<Map<String, int>>(
        'reaction',
        'getReactionCounts',
        {},
      );

  _i2.Future<void> resetReactionCounts() => caller.callServerEndpoint<void>(
        'reaction',
        'resetReactionCounts',
        {},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i4.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    example = EndpointExample(this);
    reaction = EndpointReaction(this);
  }

  late final EndpointExample example;

  late final EndpointReaction reaction;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'example': example,
        'reaction': reaction,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
