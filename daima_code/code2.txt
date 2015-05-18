{file_name, "__otu_sk_pro__h"}.
{header_start, std}.
{content, [{macro, [{"OTU", "0"}, {"ODU", "1"}]},
			{enum, {"perf_code",["TCM1_BBE", "TCM1_FEBBE"]}},
			{struct, {"OhRes", ["UINT32 num", "UINT8 data[128]"]}},
			{func_point, {"UINT32", "get_svc_off", ["UsrInfo *usr_info",
			"UINT32 code"]}},
			{func_prototype, {"UINT8", "otu_sk_get_alm",["UsrInfo
			*usr_info", "UINT32 code"]}},
			{func_prototype, {"Perf64Bit", "otu_sk_get_perf",["UsrInfo
			*usr_info", "UINT32 code"]}}
			]
}.
{header_end,std}.