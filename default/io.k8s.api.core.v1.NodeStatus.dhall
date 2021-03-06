{ addresses = ([] : Optional (List ../types/io.k8s.api.core.v1.NodeAddress.dhall))
, allocatable = ([] : Optional ((List {mapKey : Text, mapValue : Text})))
, capacity = ([] : Optional ((List {mapKey : Text, mapValue : Text})))
, conditions = ([] : Optional (List ../types/io.k8s.api.core.v1.NodeCondition.dhall))
, config = ([] : Optional (../types/io.k8s.api.core.v1.NodeConfigStatus.dhall))
, daemonEndpoints = ([] : Optional (../types/io.k8s.api.core.v1.NodeDaemonEndpoints.dhall))
, images = ([] : Optional (List ../types/io.k8s.api.core.v1.ContainerImage.dhall))
, nodeInfo = ([] : Optional (../types/io.k8s.api.core.v1.NodeSystemInfo.dhall))
, phase = ([] : Optional (Text))
, volumesAttached = ([] : Optional (List ../types/io.k8s.api.core.v1.AttachedVolume.dhall))
, volumesInUse = ([] : Optional (List Text))
} : ../types/io.k8s.api.core.v1.NodeStatus.dhall
