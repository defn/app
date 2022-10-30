package c

// All inputs have a name and label, which are usually the same.  Set both in
// the same place.  See #Transform.inputs.
#Input: {
	name:  string
	label: string
	...
}

#Transform: {
	// A transformer takes an (in)put and (out)put.  The input is extended with
	// additional fields, the output is the template.
	transformer: {
		in: #Input
		out: _in: in
		out: {...}
		...
	}

	inputs: [N=string]: #Input & {
		// The label is usually a custom value like "resource-\(label)",
		// defaults to the name.  Additional fields can be defined in terms of
		// name.
		name:  N
		label: string | *name
		...
	}

	outputs: {
		// Outputs are meant to be assigned to top level fields, like
		// "resource:" or "kustomizes"

		for _in in inputs {
			"\(_in.label)": (transformer & {
				in: _in
			}).out
		}
	}
}
