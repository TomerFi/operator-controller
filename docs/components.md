OLM v1 is composed of various component projects: 

* [operator-controller](https://github.com/operator-framework/operator-controller): operator-controller is the central component of OLM v1, that consumes all of the components below to extend Kubernetes to allows users to install, and manage the lifecycle of other extensions

* [deppy](https://github.com/operator-framework/deppy): Deppy is a Kubernetes API that runs on- or off-cluster for resolving constraints over catalogs of RukPak bundles. Deppy is part of the next iteration of OLM and was first introduced here. The initial goal of the project is to remove the dependency manager from the Operator Lifecycle Manager (OLM) and make it its own generic component.

* [catalogD](https://github.com/operator-framework/catalogd): Catalogd is a Kubernetes extension that unpacks [file-based catalog (FBC)](https://olm.operatorframework.io/docs/reference/file-based-catalogs/#docs) content that is packaged and shipped in container images, for consumption by clients on-clusters (unpacking from other sources, like git repos, OCI artifacts etc, are in the roadmap for catalogD). As component of the Operator Lifecycle Manager (OLM) v1 microservices architecture, catalogD hosts metadata for Kubernetes extensions packaged by the authors of the extensions, as a result helping customers discover installable content.
