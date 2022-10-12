package c

// Common apps on all K3D machines.
common: apps: {
	"cert-manager": {}
}

// Dev environment app.
common: dev: {
	"dev": {
		namespace: "default"
	}
}

// Env: control is the control plane, used by the operator.
env: control: #K3D & {
	apps: default: {
		common.apps
		"external-secrets": {}
		"argo-cd": {}
		"argo-events": {}
		"argo-workflows": {}
		"bootstrap": {}
	}
}

// Env: circus is the global control plane, used by all machines.
env: circus: #K3D & {
	apps: default: {
		common.apps
		"kyverno": {}
		"kuma-global": {
			namespace: "kuma"
		}
	}
}

// Env: smiley is the second machine used for multi-cluster.
env: smiley: #K3D & {
	apps: default: {
		common.apps
		"kyverno": {}
	}
}

// Env: VClusters
env: {
	// VClusters on control machine
	_vc_machine: #VCluster & {machine: env.control}

	// Running dev environments
	_vc_apps: apps: default: common.dev

	// The VClusters
	vc1: _vc_machine & _vc_apps
	vc2: _vc_machine & _vc_apps
	vc3: _vc_machine & _vc_apps
	vc4: _vc_machine & _vc_apps
}
