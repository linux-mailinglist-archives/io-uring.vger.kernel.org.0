Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1695456177
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhKRRao (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 12:30:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40644 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhKRRao (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 12:30:44 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIDNtkE027720;
        Thu, 18 Nov 2021 09:27:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H9ghsYgH2nKzxJe9v3i6H2QeUCUal+DIswGyVGiz20k=;
 b=Bnx6VYqCK2SUaxJGWMKuYc53nY7apm4FuKQvJKdqBF912BkZ9f9oRkKDEcpskWtG88tr
 HVLYdnmmib8EQyWgtT3Ow8Cu4D/W0TtuBCazUPjw2cMSuqCc5745e0LVlOl5HlzMyF4i
 uh8L46/LF1VmwoJvgiUq8dTXqz+RYQtJy1k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cdqp4hwh2-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 09:27:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 09:27:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7HuPCQYrI8lHjpqrwHTnpJzKdoj3/5DEfNzOnRG0a0fKYReH6xlPdxvGVQczbDCuJ6lm3bKZul8bzMgukV8gjgOMK7b2XdAeXgVVRqlLwjiYUWUIEYn9MRR1xWYd7QQJJcJE/hS8l2q0yRViG2MrsS42blv/S1Uwu98qGFZdARrmIUL+725nq3Vzlxmgc0rt0TMOQGO/fhvlmmDwWVaJwT46nrFKyFahsVPZm699XnMV7l6ThoK5dWHc77xo1TVgBXw9SDBGDEV+u1Ct6FdK1jjmzkcu5V1buGgM3fePlCV5WpGUvqKKf5+qE5Np2RceaeR1rHJVDSo0z2x5W2/Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9ghsYgH2nKzxJe9v3i6H2QeUCUal+DIswGyVGiz20k=;
 b=YZjIJevnQZnNmUolAiHZYfLZ4z5mASloBHP8WftcJ1waohlOf0E1xT6EVkLUY0aeoS3hOx9XwFIe3+7ka0M9Vr/wUNsFRhDcY7NTNcrlvexGIHYiW7GFaiW76PE5oEqwhjRJf3T9ceKK5DS/Gl9CPwjV3Jvfx56qusbJeuiIfkyh/hRqnWfNI8kVYfiZOiaxIc1cEbQ3ui5bGVoMxRU2+osnQqbj/z2qvkTJoHNNPZ0kJnG3Y+TOlvxFB90f/j0nYNEjJ2YbMNaFBQn54hEA5f2LDaugz/3K/XlvDNCnI+ypY9z9SLPCIK/PEY4TMfpa/xDKyj0u1ACCEd2hJgI1yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2415.namprd15.prod.outlook.com (2603:10b6:805:1c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 17:27:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 17:27:18 +0000
Message-ID: <7efcf912-46be-1ed4-7e12-88c2baeaab12@fb.com>
Date:   Thu, 18 Nov 2021 09:27:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 2/8] bpf: Add bpf_page_to_pfn helper
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, <criu@openvz.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-3-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211116054237.100814-3-memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:104:6::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by CO2PR04CA0092.namprd04.prod.outlook.com (2603:10b6:104:6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 17:27:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b018d24-59b0-4ee3-b3cb-08d9aab8ac02
X-MS-TrafficTypeDiagnostic: SN6PR15MB2415:
X-Microsoft-Antispam-PRVS: <SN6PR15MB241594415D9BE7CEE8D9AB29D39B9@SN6PR15MB2415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rO78GFSeMmZHD49ht/XxCRVuC56JEhlhhttTw3Zrik59k/iSH3BJftbPYfRRo9JwMTdb0S/8oXloobsgL4XnTFCzyB6ilYCgTE8rH7tgRVUtskuwW9OZYB1bXiJyO4JUsA9rIKXEOf1vnIaTP8bonwnAmeESEFGKlxgHiB/kHnizHYaHKlLGXjE/s19UAtCGtafqkHp/kAGNZQwPivpYxkdqv+AMF/DuxVjxkztkNtNc59DaLymJwDAWv9Rui5E+9ypS9FLaOdMAu9Bb5p/o0b37kLUT5fELe5NUPEEZakHn1FSOkzy+Io9uWBtxzzfgxXiEo6HCzWty6NKZgnmtpc0L5jPP7njy+8vk9JJJZRpRJacbswtyV7FQ8YrHEsWxMT5DkS3u7PZBlTX/hDZv/Pm+2bI69CmMloNKw0zeAaDLl/tXuhBrrQnvVTI+9JjZkLj7MwBV2wZM5trTXigl4qlmqSDhAp6zi5LLSZAs6msKfohADxPAwuE+39ZG6aTdrTKo1INVm8dI7H4vz6V4fz+9Et/tZ0b7r7IBLusGclQKfAxxCac/M1+2GSApDhPzJ3jxxfhBF1X/nIggLP05jM/Ty1SNJNxruXqm1VP2oW9Q0aI/tz5xCYQ+ZA9k95Cb6j0NT6uqkJiMjqChqPQ5z88H7vBpnmB92SkXUX1nusD19nu6lrgL7AM6m03CgFHdI/0grQyHo5XaOrPfLimohwbFtWM0s6kOTyhXHaCcTpFRvsjrM38WMxj3cYsYb4OG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(86362001)(31696002)(2616005)(38100700002)(54906003)(8936002)(6486002)(36756003)(66476007)(52116002)(66946007)(508600001)(31686004)(8676002)(7416002)(316002)(5660300002)(53546011)(2906002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U05ZN2dDL2xYc3ZqYnpPTFF4ejQ0Znc0UmdIaTJscGdGZUlNWVFsQWxTL2o4?=
 =?utf-8?B?eVY5WW9TQmJlK3dscDdNYk1idW8wdXhLRWNmRUV0eDdrdFlXVWVuSlNUNC81?=
 =?utf-8?B?eFUxcU9oY1J6bVZrZGNVVGZtT2I5L2dEQnVuZGJRZ0Q3T3Rra0Q1V09WWGpZ?=
 =?utf-8?B?Tk1maTVxbmtteUZoRWw3YWFqa1B2cCsySFpXbk10Y09wK1h3cmxMUjhRWEpN?=
 =?utf-8?B?K0NPVWVhL1dEemlIN1Y5ZkdrSHJzZEkvTkZCTHhGakthMWt2Q0I1RCs2YVVx?=
 =?utf-8?B?ZncyNGpFcHFJQ0pxMEZvQXo2Z3FXUDdmRnZtZGZtOTg4NXp2WCtRK0xiSE14?=
 =?utf-8?B?ZFhaV2xxSCtpSU1KLytraTdrMTVUUGxIYmpFRldGRFcvdmRTcitvMDlSTk4z?=
 =?utf-8?B?R1Z1NTBscngrMFdxdHppYTFoOElMa0szT3dUZlRmejB4ZmFHWkxhMGkrQmcx?=
 =?utf-8?B?VFNNOTVMaThuL3NZZ3FzTVdMeXpRN1lRSkFpWUwxeElwZFUzOFVzR0x2ZXlW?=
 =?utf-8?B?OXB5RFJzTWhBc0xPbXoybXlkRnVnQzFkUEtUOWJDdDhuS0ZBMzRqLzVuTFVT?=
 =?utf-8?B?U0IwaHNneEpiMWNQZ2dlNFlhQWxDSVc4V29UYjA1ejNTNXVMRGpjMzAxeEZs?=
 =?utf-8?B?S2hSMmZyVlZRcE9RcHR5eGlnMzVmd2FXZE80c2tJSGxoU0VGMjQ4QXpuNGF1?=
 =?utf-8?B?VnVDMEFZQy9sRjNJOGsxVEJjWi82VndJSVo2SEhzeDhBM1RCYTVBaUl6ZkZz?=
 =?utf-8?B?TytIM0lqN2Z2VkRqeWt0U3hIamJFVFlHNU5SbGg3VzNoWnlRcHNnNlE1bVlz?=
 =?utf-8?B?VTBCL1V1VmtrVSt4V0NGbVhlak5oZHh2V3UyY1pjeWJIYmJQVHFIYnZLNTBW?=
 =?utf-8?B?U3ArR21maTJQRFc5ZlhHUlE3ZXNKQkRXZDV0S2g5TzNrbG9FZGZNYlk0a2JV?=
 =?utf-8?B?dEkvN1JqTVVhTEM2WXN4SzV5RlZMYjlpM0Qwc2dRSXBCeXhrMUQxa0RLamZ3?=
 =?utf-8?B?TGw3OVNyS2svVTFCR2JTUkJtVW9IRjhZL0FrVWtoQ053N2Nud1FQRjVNUGZY?=
 =?utf-8?B?M2Vmd1FrZjFVaHBCSDFKSTNSM0F3aGV2VFhhYUIzc3U1bkMxZ0J1TUNabnZ5?=
 =?utf-8?B?OTBDUTUwSkxVNHlnNmJRTkF3aDBMNWFRSmZUaVIwNG1GaktkcmJNU3dNeG13?=
 =?utf-8?B?eXVnZzFDdDdDWHNVcTZxQkljTmdVOTNOa0g5WXUvSEJyQVJLb1F5NXhUNDRI?=
 =?utf-8?B?N2JvY082RGMvSDF3bWV6eVlzckM4VG1SUHRmNjV4bCtoc1ZRL2YxblpZRXdq?=
 =?utf-8?B?Y3VBcVh1VUxZQ0dGckNJVHZILy9OYU5zSTRNZ1NUbnZKTHA2Z0kzUXN4YjFB?=
 =?utf-8?B?ZWlHM2pmcUwzOGN5alhvNW1HcE1kNDhqSHJWOFZkeE5zc2VHeG1PTnBGM292?=
 =?utf-8?B?U1hOREs0Y1N4MVZpNGwrbmhxbEErcUkxOUpqWlpJbVVnRW5sc3BWWmYrN2Qz?=
 =?utf-8?B?SmE2WWZocTV2cWhhcnMvUTlIOWkrZmgyTEx2cCtDbkphNmx0RW5PU3lMb0V0?=
 =?utf-8?B?QVY4ZlpQUHpkL080N2Jka0RwSnQwSE50WHArdktQZnN3ZTlBZHl5Zk52U1k0?=
 =?utf-8?B?ajY4T2dJejIrMXl6QVEvOUF0d3lIdndZWkkxRzl3aFc1bEU2amMzS2RHMTdQ?=
 =?utf-8?B?Zk4rR29MeGdXeFRHcHZhMjN5WC9pckNhbDZHODFqK0l2aUkyZXpaNHhNbkY0?=
 =?utf-8?B?Z1RwKzl6SGl4WkZIZHZqajhhbEpiQUdRTzRvTlVOZk5BMFRXYkZVMGhxaERk?=
 =?utf-8?B?UU9rV09PaTJxODhRVWZuelMxd0QwenpUWnpKNytNRFlpelNCZlorY3dOOTRz?=
 =?utf-8?B?ejA1V3VGTWxPajFZejgwdjR0eCtCaU5mN0VIRTBPZVUrM3RMTlFoTkhVM3R3?=
 =?utf-8?B?ZU9RdGExS3lHUFd1R20vV2ppZ2hYTCtQSTBRWC9NRHg5R2JsRVZkUDBtUytu?=
 =?utf-8?B?VnBxV2ZncW10aGhvWm1TNFpXOE9USC9mdHFRZ2wxTUNHQmVYVk5qSnpDL244?=
 =?utf-8?B?bmVFRlpSTXBBOWV0MVcxYnFLL3ptdFJMcWpQVE1uMlV3RDBXaDVzZVF2TW9G?=
 =?utf-8?B?bUVtUWdDRnAxbHRhamlQM25FS0QvM3U1UmxOWHVXelpwR0Z5dXBtSmpHaksv?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b018d24-59b0-4ee3-b3cb-08d9aab8ac02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 17:27:18.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWa07NeMfEGfUjJn2zV6BWFmxKkKWOHzLpzaXtxBllgi2oVBndKzmFp/mp0p30rq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2415
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 8I7PQJBLuV3meZLxZ9Vn9CTdYhwFGlsT
X-Proofpoint-ORIG-GUID: 8I7PQJBLuV3meZLxZ9Vn9CTdYhwFGlsT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> In CRIU, we need to be able to determine whether the page pinned by
> io_uring is still present in the same range in the process VMA.
> /proc/<pid>/pagemap gives us the PFN, hence using this helper we can
> establish this mapping easily from the iterator side.
> 
> It is a simple wrapper over the in-kernel page_to_pfn helper, and
> ensures the passed in pointer is a struct page PTR_TO_BTF_ID. This is
> obtained from the bvec of io_uring_ubuf for the CRIU usecase.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   fs/io_uring.c                  | 17 +++++++++++++++++
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       |  9 +++++++++
>   kernel/trace/bpf_trace.c       |  2 ++
>   scripts/bpf_doc.py             |  2 ++
>   tools/include/uapi/linux/bpf.h |  9 +++++++++
>   6 files changed, 40 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 46a110989155..9e9df6767e29 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -11295,6 +11295,23 @@ static struct bpf_iter_reg io_uring_buf_reg_info = {
>   	.seq_info	   = &bpf_io_uring_buf_seq_info,
>   };
>   
> +BPF_CALL_1(bpf_page_to_pfn, struct page *, page)
> +{
> +	/* PTR_TO_BTF_ID can be NULL */
> +	if (!page)
> +		return U64_MAX;
> +	return page_to_pfn(page);
> +}
> +
> +BTF_ID_LIST_SINGLE(btf_page_to_pfn_ids, struct, page)
> +
> +const struct bpf_func_proto bpf_page_to_pfn_proto = {
> +	.func		= bpf_page_to_pfn,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> +	.arg1_btf_id	= &btf_page_to_pfn_ids[0],

Does this helper need to be gpl_only?

> +};
> +
>   static int __init io_uring_iter_init(void)
>   {
>   	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
[...]
