import numpy as np

# ----------------------------
# Parameters 
# ----------------------------
num_clusters = 10_000
bodies_per_cluster = 256   # fits shared memory

# The inter-cluster force is 10^12 times smaller than the intra-cluster force.
cluster_spacing = 1e6      # inter-cluster distance
intra_radius = 1.0         # cluster internal spread

N = num_clusters * bodies_per_cluster

# ----------------------------
# Allocate arrays
# ----------------------------
# mass = np.ones(N, dtype=np.float32)
mass = np.random.uniform(low=0.1, high=1.0, size=N)
coords = np.zeros((N, 3), dtype=np.float32)
cluster_id = np.zeros(N, dtype=np.int32)

# ----------------------------
# Generate data
# ----------------------------
idx = 0
for c in range(num_clusters):
    center = np.array([c * cluster_spacing, 0.0, 0.0])
    offsets = np.random.uniform(
        low=-intra_radius,
        high=intra_radius,
        size=(bodies_per_cluster, 3)
    )
    coords[idx:idx+bodies_per_cluster] = center + offsets
    cluster_id[idx:idx+bodies_per_cluster] = c
    idx += bodies_per_cluster

# ----------------------------
# Save files
# ----------------------------
np.savetxt("mass.txt", mass, fmt="%.6f")
np.savetxt("coord.txt", coords, fmt="%.6f %.6f %.6f")
np.savetxt("cluster_id.txt", cluster_id, fmt="%d")

print(f"Generated {N} bodies in {num_clusters} clusters")
