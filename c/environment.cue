package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		"global-vc0": {
			instance_types: []
			parent: env.global
		}

		"control-vc0": {
			instance_types: []
			parent: env.control
		}
		"control-vc1": {
			parent: env.control
		}
		"control-vc2": {
			parent: env.control
		}
		"control-vc3": {
			parent: env.control
		}
		"control-vc4": {
			parent: env.control
		}

		[N=string]: {
			bootstrap: {
				"cert-manager": 1
			}
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformK3D

	inputs: {
		// control is the control plane, used by the operator.
		control: {
			bootstrap: {
				"argo-cd":                   0
				"cert-manager":              1
				"pod-identity-webhook":      10
				"kyverno":                   10
				"external-secrets-operator": 10
				"argo-events":               10
				"karpenter":                 20
				"k3d-control-secrets-store": 20
				//"k3d-control-kuma-zone":     30
				"tfo": 30
				//"mastodon": 30
				//"knative":                   40
				//"rocky":                     40
				//"rosie":                     40
				//"bonchon":                   41
				//"kong":                      50
				//"hello":                     60
			}
		}

		// smiley is the second machine used for multi-cluster.
		smiley: {
			bootstrap: {
				"cert-manager":              1
				"pod-identity-webhook":      10
				"kyverno":                   10
				"external-secrets-operator": 10
				"k3d-smiley-secrets-store":  20
				"k3d-smiley-kuma-zone":      30
				"tfo":                       30
				"demo1":                     40
				"demo2":                     40
			}
		}

		// global is the global control plane, used by all machines.
		global: {
			bootstrap: {
				"cert-manager":              1
				"pod-identity-webhook":      10
				"kyverno":                   10
				"external-secrets-operator": 10
				"k3d-global-secrets-store":  20
				"k3d-global-kuma-global":    30
				"tfo":                       30
				"mesh":                      40
			}
		}
	}
}).outputs

bootstrap: (#Transform & {
	transformer: #TransformEnvToBootstrapMachine

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)": {
				name:      _env_name
				type:      _env.type
				bootstrap: _env.bootstrap
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		"control-vc0": {
			vc_machine: "control"
		}

		"global-vc0": {
			vc_machine: "global"
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		"control-vc1": {}
		"control-vc2": {}
		"control-vc3": {}
		"control-vc4": {}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformEnvToAnyResource

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)": {
				name:  _env_name
				type:  _env.type
				label: "\(type)-\(name)"
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformEnvToSecretStore

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)": {
				name:  _env_name
				type:  _env.type
				label: "\(type)-\(name)-secrets-store"
			}
		}
	}
}).outputs
