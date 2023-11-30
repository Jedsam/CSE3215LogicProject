#include <stdio.h>

// Define the maximum length
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
        fprintf(stderr, "Usage: %s <input_file.txt> <output_file.txt>\n", argv[0]);
        return 1;
    }

    assemble_program(argv[1], argv[2]);
    printf("Assembly completed successfully.\n");

    return 0;
}

// Convert register number to binary
unsigned int reg_to_bin(const char* reg) {
	
    return atoi(reg + 1); // Assuming register is in the format Rn and return n
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
    unsigned int opcode, rd, rs1, rs2, imm, addr;
    unsigned int binary_value = 0;

    sscanf(instruction, "%s", instr);

    if (strcmp(instr, "ADD") == 0 || strcmp(instr, "AND") == 0 || strcmp(instr, "NAND") == 0 || strcmp(instr, "NOR") == 0) {
		// Format for ADD, AND, NAND, NOR
        if (strcmp(instr, "ADD") == 0) opcode = 0x1;
        else if (strcmp(instr, "AND") == 0) opcode = 0x3;
        else if (strcmp(instr, "NAND") == 0) opcode = 0x5;
        else opcode = 0x6;
                
        sscanf(instruction, "%s %s %s %s", instr, reg1, reg2, reg3);
        rd = reg_to_bin(reg1);
        rs1 = reg_to_bin(reg2);
        rs2 = reg_to_bin(reg3);
        binary_value = (opcode << 14) | (rd << 10) | (rs1 << 6) | rs2;
        
    } else if (strcmp(instr, "ADDI") == 0 || strcmp(instr, "ANDI") == 0) {
        // Format for ADDI, ANDI
        if(strcmp(instr, "ADDI") == 0) opcode = 0x2;
        else opcode = 0x4;
      
        sscanf(instruction, "%s %s %s %s", instr, reg1, reg2, reg3);
        rd = reg_to_bin(reg1);
        rs1 = reg_to_bin(reg2);
        imm = imm_to_bin(reg3, 6);
        binary_value = (opcode << 14) | (rd << 10) | (rs1 << 6) | imm;
        
    } else if (strcmp(instr, "LD") == 0 || strcmp(instr, "ST") == 0 || strcmp(instr, "JUMP") == 0 || strcmp(instr, "JE") == 0 ||
               strcmp(instr, "JA") == 0 || strcmp(instr, "JB") == 0 || strcmp(instr, "JAE") == 0 || strcmp(instr, "JBE") == 0) {
        // Format for LD, ST, JUMP, JE, JA, JB, JAE, JBE
        if (strcmp(instr, "JUMP") == 0) opcode = 0x7;
        else if(strcmp(instr, "LD") == 0) opcode = 0x8;
        else if(strcmp(instr, "ST") == 0) opcode = 0x9;
        else if(strcmp(instr, "JE") == 0) opcode = 0xB;
        else if(strcmp(instr, "JA") == 0) opcode = 0xC;
        else if(strcmp(instr, "JB") == 0) opcode = 0xD;
        else if(strcmp(instr, "JAE") == 0) opcode = 0xE;
        else opcode = 0xF;
              
        sscanf(instruction, "%s %s %s", instr, reg1, reg2);
        rd = (opcode == 0x9 || opcode == 0x8) ? reg_to_bin(reg1) : 0; // only ST and LD have destination or source register
        if (opcode == 0x9 || opcode == 0x8) addr = addr_to_bin(reg2, 10);
        else addr = addr_to_bin(reg1, 10);
        binary_value = (opcode << 14) | (rd << 10) | addr;
        
    } else if (strcmp(instr, "CMP") == 0) {
        // Format for CMP
        opcode = 0xA;
        sscanf(instruction, "%s %s %s", instr, reg1, reg2);
        rd = reg_to_bin(reg1);
        rs1 = reg_to_bin(reg2);
        binary_value = (opcode << 14) | (rd << 10) | rs1;
    } else {
        // Unsupported instruction
        fprintf(stderr, "Error: Unsupported instruction '%s'\n", instr);
        exit(1);
    }

    // Format the binary_value into a hexadecimal string with leading zeros
    sprintf(binary_instr, "%05X", binary_value);
}

// Read assembly instructions from a file, assemble them, and write to a file in hex form
void assemble_program(const char* input_file, const char* output_file) {
    FILE *fp_read, *fp_write;
    char line[MAX_LINE_LENGTH] = {0}; // Initialize to zero
    char binary_instr[5] = {0}; // Initialize to zero

    fp_read = fopen(input_file, "r");
    if (fp_read == NULL) {
        perror("Error opening input file");
        exit(1);
    }

    fp_write = fopen(output_file, "w");
    if (fp_write == NULL) {
        perror("Error opening output file");
        fclose(fp_read);
        exit(1);
    }

    while (fgets(line, MAX_LINE_LENGTH, fp_read)) {
        if (line[0] == '\n') continue; // Skip empty lines
        assemble_instruction(line, binary_instr);
        if (binary_instr[0] != '\0') { // Only write if binary_instr is not empty
            fprintf(fp_write, "%s\n", binary_instr);
        }
    }

    fclose(fp_read);
    fclose(fp_write);
}
