/* Quartus Prime Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("C:/ECE496_FPGA/FPGA-Accelerated-SERDES-Simulation-System/FPGA/output_files/") File("SerDes_Sys.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
