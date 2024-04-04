

# Imports
from subprocess import call
import os, sys
from optparse import OptionParser

#calculation for address width given our current data:
#10 bites of addr
#assume address is:
def main(argv):
    
    parser = OptionParser()
    parser.add_option("-i", "--input", dest="inputfile",
                      help="Input file for checksum verification", default = None)
    parser.add_option("-o", "--output", dest="outputfile",
                      help="Output file with valid checksum", default = None)
    parser.add_option("-r", action="store_true", dest="remout",
                      help="Delete output file")
       
    # Get command line arguments                  
    (options, args) = parser.parse_args()
     # Check arguments
    if not options.inputfile:
            parser.print_help()
            sys.exit(1)
    
    infile = options.inputfile
    
    if options.remout:
        del_output = True
    else:
        del_output = False
    if not options.outputfile:
        outfile = os.path.splitext(infile)[0] + "_vld" + os.path.splitext(infile)[1]
    else:
        outfile = options.outputfile

    # Variable initialization
    linecount = 0
    passcount = 0
    missmatch = []

    # Open files
    f_in = open(infile,'r')
    f_out = open(outfile,'w')
    
    #parameters for the ocm:
    #address bytes:
    record_length = 8
    address_increnment = 4
    cur_address = 0
    data_len_req = 16 #for 64 bit data
    # Find checksum for every non-empty line in input file
    for line in f_in:
        linecount += 1
        chksum = 0
        line_data = line.rstrip()
        # Calculate checksum

        #first make my string to append to newfile：
        new_line = "0"+str(record_length)
        #determining the current address: 10 bit address
        address = str(hex(cur_address))
        address = address[2:]
        if(cur_address < 16): # only one:
            new_line += "000"+address
        elif(cur_address <256):
            new_line += "00"+address
        elif(cur_address < 4096):
            new_line +=  "0" + address
        new_line += "00";
        #adding data to new_line:
        #need to make sure that it is the same length
        #converting binary data to hex:
        data = str(hex(int(line_data,2)))
        data = data[2:]
        if(len(data) < 16):
            #add zeros at the beginning
            z = 16 - len(data)
            for i in range(z):
                data = "0" + data
        print(data)
        new_line += data
        cur_address = cur_address + address_increnment

        ##adding the checksum to it
        #checksum calculation: 
        
        #print(new_line)
        hex_sum = [int(new_line[x:x+2],16) for x in range(0, len(new_line),2)]
        hex_sum = sum(hex_sum) ^ 0xff
        chksum = (hex_sum+1 ) & 0xff 
        chksum = str(hex(chksum))
        chksum = chksum[2:]
        if(len(chksum) == 1):
            chksum = "0"+chksum 
        new_line += chksum
        new_line += "\n"
        new_line = ":" + new_line
        print(new_line)
        #replace this line just purely for hex version output"
        #f_out.write(new_line)
        temp = "0x"+data + ",\n"
        f_out.write(temp)

    #append other parameters to it:
    #eof 
    #f_out.write(":00000001FF")
    # Close files
    f_in.close()
    f_out.close()

# Call main with command line arguments
if __name__ == "__main__":
    main(sys.argv[1:])
