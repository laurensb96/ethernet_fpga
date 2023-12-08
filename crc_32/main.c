#include <stdio.h>
#include <stdint.h>
#include <math.h>

uint32_t crc32_table[256];
uint32_t crc32_poly = 0x04C11DB7;

void build_crc32_table(void);
uint32_t compute_crc32(uint16_t *data, uint16_t length);
void print_crc32_table(void);
uint16_t reflect_byte(uint16_t x);
uint32_t reflect_crc32(uint32_t x);

int main(void) {
    printf("Hello World!\n");
    build_crc32_table();
    print_crc32_table();
    //uint16_t data[2] = {0x05, 0x02};
    //printf("%#08x\n", compute_crc32(data, 2));
    return 0;
}

void build_crc32_table(void) {
    uint32_t crc;
    for(uint16_t i=0;i<=0xFF;i++)
    {
        crc = i;
        crc = (crc<<24);
        for (uint8_t j=0;j<8;j++)
        {
            if(crc & (1<<31))
            {
            	crc = (crc<<1);
            	crc = crc ^ crc32_poly;
            }
            else
            {
            	crc = (crc<<1);
            }
        }
        crc32_table[i] = crc;
    }
}

uint32_t compute_crc32(uint16_t *data, uint16_t length) {
    uint32_t crc = 0xFFFFFFFF; // initial CRC
    for(uint16_t i=0;i<length;i++)
    {
        crc = (crc << 8) ^ crc32_table[((crc & 0xFF000000) ^ (reflect_byte(data[i]) << 24)) >> 24];
    }
    return reflect_crc32(crc ^ 0xFFFFFFFF); // output XOR
}

void print_crc32_table(void) {
    for(uint16_t i=0;i<=0xFF;i++)
    {
        printf("CRC32_LUT(%u) <= x\"%08X\";\n", i, crc32_table[i]);
    }
}

uint16_t reflect_byte(uint16_t x)
{
    uint16_t y = 0;
    for (int i = 0; i < 4; i++)
    {
        y |= (x & 1 << i) << 7-2*i;
        y |= (x & 1 << (i+4)) >> 1+2*i;
    }
    return y;
}

uint32_t reflect_crc32(uint32_t x)
{
    uint32_t y = 0;
    for (int i = 0; i < 16; i++)
    {
        y |= (x & 1 << i) << 31-2*i;
        y |= (x & 1 << (i+16)) >> 1+2*i;
    }
    return y;
}

