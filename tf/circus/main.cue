package circus

provider: kubernetes: [{
	config_context: "k3d-circus"
	config_path:    "~/.kube/config"
}]

locals: [{
	envs: {}
},
]