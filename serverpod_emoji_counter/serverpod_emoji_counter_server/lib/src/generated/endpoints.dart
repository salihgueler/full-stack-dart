/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/example_endpoint.dart' as _i2;
import '../endpoints/reaction_endpoint.dart' as _i3;
import 'package:serverpod_emoji_counter_server/src/generated/reaction.dart'
    as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'example': _i2.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'reaction': _i3.ReactionEndpoint()
        ..initialize(
          server,
          'reaction',
          null,
        ),
    };
    connectors['example'] = _i1.EndpointConnector(
      name: 'example',
      endpoint: endpoints['example']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['example'] as _i2.ExampleEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    connectors['reaction'] = _i1.EndpointConnector(
      name: 'reaction',
      endpoint: endpoints['reaction']!,
      methodConnectors: {
        'sendReaction': _i1.MethodConnector(
          name: 'sendReaction',
          params: {
            'reaction': _i1.ParameterDescription(
              name: 'reaction',
              type: _i1.getType<_i4.Reaction>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['reaction'] as _i3.ReactionEndpoint).sendReaction(
            session,
            params['reaction'],
          ),
        ),
        'getReactionCounts': _i1.MethodConnector(
          name: 'getReactionCounts',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['reaction'] as _i3.ReactionEndpoint)
                  .getReactionCounts(session),
        ),
        'resetReactionCounts': _i1.MethodConnector(
          name: 'resetReactionCounts',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['reaction'] as _i3.ReactionEndpoint)
                  .resetReactionCounts(session),
        ),
        'streamReactions': _i1.MethodStreamConnector(
          name: 'streamReactions',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['reaction'] as _i3.ReactionEndpoint)
                  .streamReactions(session),
        ),
      },
    );
  }
}
