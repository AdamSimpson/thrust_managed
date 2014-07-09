#include "thrust/device_ptr.h"
#include "thrust/sort.h"

__global__ void calculate_hash(uint *hash_values, uint *particle_ids, int length)
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;

    if(i >= length)
        return;

    hash_values[i] =  1;
    particle_ids[i] = i;
}

void hash_particles_gpu(uint *d_hash_values, uint *d_particle_ids, int length)
{
    int block_size = 256;
    int num_blocks = ceil(length/(float)block_size);

    calculate_hash<<<num_blocks, block_size>>>(d_hash_values, d_particle_ids, length);  

    cudaDeviceSynchronize();

    thrust::device_ptr<uint> keys(d_hash_values);
    thrust::device_ptr<uint> values(d_particle_ids);
    thrust::sort_by_key(keys, keys+length, values);
}

int main(int argc, char *argv[])
{
    int length = 15;
    int bytes;

    #ifdef BROKE
    int *m_int;
    cudaMallocManaged((void**)&m_int, sizeof(int));
    #endif

    // Allocate uint hash value array
    bytes = length*sizeof(unsigned int);
    unsigned int * hash_values;
    cudaMalloc((void**)&hash_values, bytes);    

    // Allocate uint particle ID array
    bytes = length*sizeof(unsigned int);
    unsigned int *particle_ids;
    cudaMalloc((void**)&particle_ids, bytes);

    hash_particles_gpu(hash_values, particle_ids, length);
}
