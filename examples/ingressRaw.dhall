-- Prelude imports
   let map    = https://raw.githubusercontent.com/dhall-lang/Prelude/v2.0.0/List/map

-- dhall-kubernetes types and defaults
in let TLS     = ../types/io.k8s.api.extensions.v1beta1.IngressTLS.dhall
in let Rule    = ../types/io.k8s.api.extensions.v1beta1.IngressRule.dhall
in let RuleVal = ../types/io.k8s.api.extensions.v1beta1.HTTPIngressRuleValue.dhall
in let Spec    = ../types/io.k8s.api.extensions.v1beta1.IngressSpec.dhall
in let Ingress = ../types/io.k8s.api.extensions.v1beta1.Ingress.dhall
in let defaultIngress = ../default/io.k8s.api.extensions.v1beta1.Ingress.dhall
in let defaultMeta    = ../default/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall
in let defaultSpec    = ../default/io.k8s.api.extensions.v1beta1.IngressSpec.dhall
in let IntOrString    = ../types/io.k8s.apimachinery.pkg.util.intstr.IntOrString.dhall

-- Our Service type
in let Service = ./Config.dhall
in let Config = { services : List Service }

-- A function to generate an ingress given a configuration
in let mkIngress : Config -> Ingress =

  \(config : Config) ->

  -- Given a service, make a TLS definition with their host and certificate
     let makeTLS = \(service : Service) ->
    { hosts = Some [ service.host ]
    , secretName = Some "${service.name}-certificate"
    }

  -- Given a service, make an Ingress Rule
  in let makeRule = \(service : Service) ->
    { host = Some service.host
    , http = Some
        { paths = [ { backend =
                        { serviceName = service.name
                        , servicePort = IntOrString.Int 80
                        }
                    , path = None Text
                    }
                  ]
        }
    }

  -- Nginx ingress requires a default service as a catchall
  in let defaultService =
    { name = "default"
    , host = "default.example.com"
    , version = " 1.0"
    }

  -- List of services
  in let services = config.services # [ defaultService ]

  -- Some metadata annotations
  -- NOTE: `dhall-to-yaml` will generate a record with arbitrary keys from a list
  -- of records where mapKey is the key and mapValue is the value of that key
  in let genericRecord = List { mapKey : Text, mapValue : Text }
  in let kv = \(k : Text) -> \(v : Text) -> { mapKey = k, mapValue = v }

  in let annotations = Some
    [ kv "kubernetes.io/ingress.class"      "nginx"
    , kv "kubernetes.io/ingress.allow-http" "false"
    ]

  -- Generate spec from services
  in let spec = defaultSpec //
    { tls   = Some (map Service TLS  makeTLS  services)
    , rules = Some (map Service Rule makeRule services)
    }

  in defaultIngress
    { metadata = defaultMeta
      { name = "nginx" } //
      { annotations = annotations }
    } //
    { spec = Some spec }


-- Here we import our example service, and generate the ingress with it
in mkIngress { services = [ ./myConfig.dhall ] }
