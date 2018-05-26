\(_params : {mountPath : (Text), name : (Text)}) ->
{ mountPath = _params.mountPath
, mountPropagation = ([] : Optional (Text))
, name = _params.name
, readOnly = ([] : Optional (Bool))
, subPath = ([] : Optional (Text))
} : ../types/io.k8s.api.core.v1.VolumeMount.dhall
