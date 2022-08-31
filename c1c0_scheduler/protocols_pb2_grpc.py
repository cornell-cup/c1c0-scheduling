# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc

try:
    from . import protocols_pb2 as protocols__pb2
except ImportError:
    from c1c0_scheduler import protocols_pb2 as protocols__pb2


class SchedulerStub(object):
    """Scheduler service, used to schedule processes/tasks
    """

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.SysCommand = channel.unary_unary(
                '/scheduler.Scheduler/SysCommand',
                request_serializer=protocols__pb2.SysRequest.SerializeToString,
                response_deserializer=protocols__pb2.SysResponse.FromString,
                )
        self.SysCommandStream = channel.unary_stream(
                '/scheduler.Scheduler/SysCommandStream',
                request_serializer=protocols__pb2.SysRequest.SerializeToString,
                response_deserializer=protocols__pb2.SysResponse.FromString,
                )


class SchedulerServicer(object):
    """Scheduler service, used to schedule processes/tasks
    """

    def SysCommand(self, request, context):
        """Starts a specific module specified by StartModuleRequest. Gets back
        a StartModuleResponse
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def SysCommandStream(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_SchedulerServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'SysCommand': grpc.unary_unary_rpc_method_handler(
                    servicer.SysCommand,
                    request_deserializer=protocols__pb2.SysRequest.FromString,
                    response_serializer=protocols__pb2.SysResponse.SerializeToString,
            ),
            'SysCommandStream': grpc.unary_stream_rpc_method_handler(
                    servicer.SysCommandStream,
                    request_deserializer=protocols__pb2.SysRequest.FromString,
                    response_serializer=protocols__pb2.SysResponse.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'scheduler.Scheduler', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))


 # This class is part of an EXPERIMENTAL API.
class Scheduler(object):
    """Scheduler service, used to schedule processes/tasks
    """

    @staticmethod
    def SysCommand(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/scheduler.Scheduler/SysCommand',
            protocols__pb2.SysRequest.SerializeToString,
            protocols__pb2.SysResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def SysCommandStream(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_stream(request, target, '/scheduler.Scheduler/SysCommandStream',
            protocols__pb2.SysRequest.SerializeToString,
            protocols__pb2.SysResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)