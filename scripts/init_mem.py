import argparse
import os
import random

def gen():
    """Generates a random 64-bit unsigned integer."""
    return random.getrandbits(64)

def main(output_directory):
    """
    Simulates a memory pre-state generation and an addition operation,
    saving results to specified output files within the given directory.
    """
    # Ensure the output directory exists
    os.makedirs(output_directory, exist_ok=True)

    # Define file paths within the output directory
    pre_state_upper_file = os.path.join(output_directory, "memory_pre_state_upper.txt")
    pre_state_lower_file = os.path.join(output_directory, "memory_pre_state_lower.txt")
    post_state_upper_file = os.path.join(output_directory, "memory_post_state_upper.txt")
    post_state_lower_file = os.path.join(output_directory, "memory_post_state_lower.txt")

    read_start_addr = 0
    read_end_addr = 255
    write_start_addr = 384
    
    # Generate and write pre-state memory
    with open(pre_state_upper_file, "w") as u, open(pre_state_lower_file, "w") as l:
        # Generate 256 random 64-bit values and split them into upper/lower 32-bit binary strings
        for i in range(256):
            value = gen()
            # Extract upper 32 bits
            upper = (value >> 32) & 0xFFFFFFFF
            # Extract lower 32 bits
            lower = value & 0xFFFFFFFF
            u.write(f"{upper:032b}\n")
            l.write(f"{lower:032b}\n")

        # Append another 256 lines of zeros to both files
        for i in range(256):
            u.write(f"{0:032b}\n")
            l.write(f"{0:032b}\n")

    # Open output files for writing the post-state
    with open(post_state_upper_file, "w") as u_out, \
         open(post_state_lower_file, "w") as l_out:
        
        # Open pre-state files for reading
        with open(pre_state_upper_file, "r") as u_in, \
             open(pre_state_lower_file, "r") as l_in:
            
            # Read all lines from pre-state files into lists
            upper_lines = u_in.readlines()
            lower_lines = l_in.readlines()

        # Initialize read and write addresses
        read_addr = read_start_addr
        write_addr = write_start_addr

        # Perform 128 addition operations
        for i in range(128):
            # Read src1_upper and src1_lower from the current read_addr
            src1_upper = int(upper_lines[read_addr].strip(), 2)
            src1_lower = int(lower_lines[read_addr].strip(), 2)
            read_addr += 1

            # Read src2_upper and src2_lower from the next read_addr
            src2_upper = int(upper_lines[read_addr].strip(), 2)
            src2_lower = int(lower_lines[read_addr].strip(), 2)
            read_addr += 1

            # Combine src2 (as upper 32-bits) and src1 (as lower 32-bits)
            src1 = (src1_upper + src1_lower) & 0xFFFFFFFF
            src2 = (src2_upper + src2_lower) & 0xFFFFFFFF

            # Combine src2 (as upper 32-bits) and src1 (as lower 32-bits) into a new 64-bit result
            result = (src2 << 32) | src1
    
            res_upper = src2
            res_lower = src1

            upper_lines[write_addr] = f"{res_upper:032b}\n"
            lower_lines[write_addr] = f"{res_lower:032b}\n"
            
            write_addr += 1

        # Write the modified 'upper_lines' and 'lower_lines' to the post-state files
        u_out.writelines(upper_lines)
        l_out.writelines(lower_lines)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate pre- and post-state memory contents for Digital Design onboarding verification.")
    parser.add_argument("output_directory", type=str,
                        help="The directory where output files (memory_pre_state_*.txt and memory_post_state_*.txt) will be saved.")
    
    args = parser.parse_args()
    
    main(args.output_directory)