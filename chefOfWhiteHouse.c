/*
This C program now includes all the instruction types you've listed. It reads each line from the input file and determines the type of instruction. Then, it encodes the instruction into a machine-readable format and writes the output to the .hex file. Instructions like LD, ST, JUMP, JE, JA, JB, JAE, and JBE have been simplified to demonstrate the concept, but the actual encoding will depend on the specifics of your ISA.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Define the maximum length for an instruction and line
#define MAX_INSTR_LENGTH 10
#define MAX_LINE_LENGTH 100

// Function prototypes
unsigned int reg_to_bin(const char* reg);
unsigned int imm_to_bin(const char* imm, int bits);
unsigned int addr_to_bin(const char* addr, int bits);
void assemble_instruction(const char* instruction, char* binary_instr);
void assemble_program(const char* input_file, const char* output_file);

// Main function
int main(int argc, char* argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input_file.asm> <output_file.hex>\n", argv[0]);
        return EXIT_FAILURE;
    }

    assemble_program(argv[1], argv[2]);
    printf("Assembly completed successfully.\n");

    return EXIT_SUCCESS;
}

// Convert register name to binary code
unsigned int reg_to_bin(const char* reg) {
    return atoi(reg + 1); // Assuming register is in the format Rn
}

// Convert immediate value to binary
unsigned int imm_to_bin(const char* imm, int bits) {
    int immediate = atoi(imm);
    return (unsigned int)((1 << bits) + immediate) % (1 << bits);
}

// Convert address to binary
unsigned int addr_to_bin(const char* addr, int bits) {
    int address = atoi(addr);
    return (unsigned int)((1 << bits) + address) % (1 << bits);
}
// Assemble a single instruction
void assemble_instruction(const char* instruction, char* binary_instr) {
    char instr[MAX_INSTR_LENGTH], reg1[MAX_INSTR_LENGTH], reg2[MAX_INSTR_LENGTH], reg3[MAX_INSTR_LENGTH];
    unsigned int opcode, rd, rs, rt, imm, addr;
    unsigned int binary_value = 0;

    sscanf(instruction, "%s", instr);

    if (strcmp(instr, "ADD") == 0 || strcmp(instr, "AND") == 0 || strcmp(instr, "NAND") == 0 || strcmp(instr, "NOR") == 0) {
        // Format for ADD, AND, NAND, NOR
        opcode = (strcmp(instr, "ADD") == 0) ? 0x1 :
                 (strcmp(instr, "AND") == 0) ? 0x3 :
                 (strcmp(instr, "NAND") == 0) ? 0x5 : 0x6;
        sscanf(instruction, "%s %s %s %s", instr, reg1, reg2, reg3);
        rd = reg_to_bin(reg1);
        rs = reg_to_bin(reg2);
        rt = reg_to_bin(reg3);
        binary_value = (opcode << 14) | (rd << 10) | (rs << 6) | rt;
    } else if (strcmp(instr, "ADDI") == 0 || strcmp(instr, "ANDI") == 0) {
        // Format for ADDI, ANDI
        opcode = (strcmp(instr, "ADDI") == 0) ? 0x2 : 0x4;
        sscanf(instruction, "%s %s %s %s", instr, reg1, reg2, reg3);
        rd = reg_to_bin(reg1);
        rs = reg_to_bin(reg2);
        imm = imm_to_bin(reg3, 6);
        binary_value = (opcode << 14) | (rd << 10) | (rs << 6) | imm;
    } else if (strcmp(instr, "LD") == 0 || strcmp(instr, "ST") == 0 || strcmp(instr, "JUMP") == 0 || strcmp(instr, "JE") == 0 ||
               strcmp(instr, "JA") == 0 || strcmp(instr, "JB") == 0 || strcmp(instr, "JAE") == 0 || strcmp(instr, "JBE") == 0) {
        // Format for LD, ST, JUMP, JE, JA, JB, JAE, JBE
        opcode = (strcmp(instr, "LD") == 0) ? 0x8 :
                 (strcmp(instr, "ST") == 0) ? 0x9 :
                 (strcmp(instr, "JUMP") == 0) ? 0x7 :
                 (strcmp(instr, "JE") == 0) ? 0xB :
                 (strcmp(instr, "JA") == 0) ? 0xC :
                 (strcmp(instr, "JB") == 0) ? 0xD :
                 (strcmp(instr, "JAE") == 0) ? 0xE : 0xF;
        sscanf(instruction, "%s %s %s", instr, reg1, reg2);
        rd = (opcode == 0x9 || opcode == 0x7) ? 0 : reg_to_bin(reg1); // ST and JUMP have no destination register
        addr = addr_to_bin(reg2, 10);
        binary_value = (opcode << 14) | (rd << 10) | addr;
    } else if (strcmp(instr, "CMP") == 0) {
        // Format for CMP
        opcode = 0xA;
        sscanf(instruction, "%s %s %s", instr, reg1, reg2);
        rd = reg_to_bin(reg1);
        rs = reg_to_bin(reg2);
        binary_value = (opcode << 14) | (rd << 10) | (rs << 6);
    } else {
        // Unsupported instruction
        fprintf(stderr, "Error: Unsupported instruction '%s'\n", instr);
        exit(EXIT_FAILURE);
    }

    // Format the binary_value into a hexadecimal string with leading zeros
    sprintf(binary_instr, "%05X", binary_value);
}

// Read assembly instructions from a file, assemble them, and write to a .hex file
void assemble_program(const char* input_file, const char* output_file) {
    FILE *fp_read, *fp_write;
    char line[MAX_LINE_LENGTH] = {0}; // Initialize to zero
    char binary_instr[5] = {0}; // Initialize to zero

    fp_read = fopen(input_file, "r");
    if (fp_read == NULL) {
        perror("Error opening input file");
        exit(EXIT_FAILURE);
    }

    fp_write = fopen(output_file, "w");
    if (fp_write == NULL) {
        perror("Error opening output file");
        fclose(fp_read);
        exit(EXIT_FAILURE);
    }

    while (fgets(line, MAX_LINE_LENGTH, fp_read)) {
        if (line[0] == '\n' || line[0] == '#') continue; // Skip empty lines and comments
        assemble_instruction(line, binary_instr);
        if (binary_instr[0] != '\0') { // Only write if binary_instr is not empty
            fprintf(fp_write, "%s\n", binary_instr);
        }
    }

    fclose(fp_read);
    fclose(fp_write);
}
