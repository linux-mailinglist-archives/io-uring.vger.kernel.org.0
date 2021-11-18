Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF454561DB
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 18:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhKRR6O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 12:58:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhKRR6G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 12:58:06 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIF0FlP004218;
        Thu, 18 Nov 2021 09:54:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EOfF0e6ow91+9tDryJ9VW+D9JHVxTKjCD8oYqeRQm2g=;
 b=XZ4G2SdrPk64/r8NAUwxTh/R0S8RWZZHdcEdtzd8q2tRP1u3WxxG6nZTXR2sgQRZs4of
 MgSSqDsDY2ZuYsrgLHy/ECjImlwVpdl5l9avwOxmDVz0dPl2VtSq6cSfziMnqMl8qxnU
 iF4ABLYCJ4DL2lwMp8wA27i6PhiscV+z0+Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cds3f1bw3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 09:54:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 09:54:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMGRDd73KBDOBEHCuT19Zq7v3CwGT/IeOmQDinQN3PCovVPlEv3YToOJuV/7S8eV6Ir8F9xd4NSNtF/p+z6nUD7QG0OFIrEZCQ+/QcT1Q8Leup1WKbi+f5rbKlUXZlQzyaXMP6vviyy+8bIOO/fchriQMXAethaa17FB5d7ljxijMAPnO9uQicpC7MgRIWXt4gZxA2UaRfWM/iGOAHtaFQUJ8IJ4MJbjokfFZRzbX+Qn4dEYuEvsL5rksnX5r3w4ZakJ9LRGS22ghesJI/RxlIxt0S/cV+KNCOJS3lSfnl74zC8MlvjeifpOAoPRNnD7GrQe3Kz/LZ2ivHoKLvTetw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOfF0e6ow91+9tDryJ9VW+D9JHVxTKjCD8oYqeRQm2g=;
 b=UpGLFMTgTFw+6WqpQrvmZDD1lLQKBdtLXwvU2XLnRSF62BiY/2Sx70/oDt+LQRW5CUIiooFWxClvbuWrGU/QYwC0E0m1XUIafI27Y+GIZmCPF8MYrbmf3n9z8SC3bJQIanFlNwNcCWoTd/lsJimw/E/W2PgUTL+NXUvEVGK63FzGuMUbIKcj8cAL3xRljbx86vliYrHi9odaxCW0NrZIDpJOZFYNG/REyp2BNryOYHj7Z0EUxwustAfEAou7cVvPgmHwPAc0k8t2N55ZIRrxwdaMwv1qrTD/2/xDSlVY828qJjlXpXXRmP+rBycCwWMjQB4YmBCSlqN/iJQ2P5ouOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2479.namprd15.prod.outlook.com (2603:10b6:805:17::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 17:54:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 17:54:22 +0000
Message-ID: <92be1024-971f-0ae3-11b7-2988f3b37100@fb.com>
Date:   Thu, 18 Nov 2021 09:54:19 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 5/8] selftests/bpf: Add test for io_uring BPF
 iterators
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, <criu@openvz.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-6-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211116054237.100814-6-memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:300:93::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MWHPR17CA0058.namprd17.prod.outlook.com (2603:10b6:300:93::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 17:54:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc8b84d8-2ad2-4839-241d-08d9aabc73be
X-MS-TrafficTypeDiagnostic: SN6PR15MB2479:
X-Microsoft-Antispam-PRVS: <SN6PR15MB247963D005335387262253E3D39B9@SN6PR15MB2479.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:158;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCgt/h0LMQ0z6EzLhskU7gVK2gdRDxbbC4GZxvMts/+pSEnu1MFZDPDzSJO2nsD0Og8nkH7oh6jv+/WPR/qiJD/bSeCAX7FY11cEB75f5rf3lZTx90+E6w2t+qM5a6xWENpMhmXhXz03NE05p8Z8IJwLqokaZ2wNkL7SffGBFTrIs1WeQIQD/tJzGB5gVdfkJVcTrGBmD+jwzEvU1Rxjajm/qhDK0Y6eW2aceJ/13WI0XHXp2EFiiWnsKGG6oSdvkyGLaI0V9M1JrLMsTS9m/iS/Uhq+w29DPUAtDc+tLBjYl1mxQpWjArU6EPjLdECv86ua+F1elasUCidmrATjaCplrEg5FyxKuXuDvAeWZflCsWyZma3zf5GHHlRxNzOZ3fmUGacZvbyX+2CGTjY2KAZOqCj9TEXOaFOsoSBquTWufI39yYqDUJdZprVrxVrirwgoFqB549qKrOdGYSwoLMNWipcDkb0LCPfHoevDg7JN3Ic6Xw3bjkQZ8hDhQwi4BYGN/MP65SICEL2slU7MFCdb1E2HIBGEfdCH81jPzb32x6DL/+hrwEncB4WorniW12cBLOMg5B7jc/PDL6GxbUWoWlldGAxECsoQSIeNbRUVjtGt/DTRStM4+1xik0En35H3j9GFTOeUtsQN9r/46O7iH9zvK+lwZa8Wc6VsvIf1evy135NuB11tLn9m4ac86yEy5Ou3Ke8G+8ONUyhEvYhf9y64QXLv0fgN1NRcilQGp0md8GwoVBgfOtPAc8G/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2906002)(508600001)(53546011)(7416002)(38100700002)(186003)(8676002)(8936002)(4326008)(54906003)(86362001)(52116002)(36756003)(6486002)(31696002)(2616005)(316002)(5660300002)(66946007)(31686004)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzZRN1k2anBGVEVMVDJEcFI0UmZTUkFjZXhnTjBpdmh3RCs1bUo3bStJZkdU?=
 =?utf-8?B?azlUQmRJZk8zenhqWnkxTXI2ZXhkVW9WSkxIenpxSnpLN3Q1bWdnQWFZc0NP?=
 =?utf-8?B?VGs5R1kwODBRcUF4Nk1jRXdsNHlSTUF2YXpqUFFUZGFPdjBhU3JwUkVwS0Ft?=
 =?utf-8?B?WXlYNE9hazB3MFdPVFFZbGxmelliZGhhcUVnZlBwMHJ1ZmZHU3p5M3F3bVFw?=
 =?utf-8?B?SjlVblBIYTJnK3hqZUxSUDZJUTJUOG9wUUt6TUhGcGJ5SUJmSWU3RmdPZ3RG?=
 =?utf-8?B?aVZDMG13NWpvNEovc3RaNTJhSzcwVEEyM28ydEFkcHgvZldPUEJCdk5iQ2o2?=
 =?utf-8?B?Q2g0THd0amM3c1NoUmt1dG5sU3UycUgvazRydUZ2MzVEUDhpWVRBSWVJMlY5?=
 =?utf-8?B?L080WmFoVUEyUm9JRFRBOVVrZSszTmVTY01URGdjb3c5S1RXMnlYVkJrcjJM?=
 =?utf-8?B?bkhDaURjei8xbjhhVTJYRlI1OUhsa2gxSnFYcHppVVRYVVZxYmtyUmMwSFR2?=
 =?utf-8?B?cGg2aTBaV29oT3Z1TjVaOGxOeHROS3hlRHRKSWZoWG1DY3FpTUoyL1VWWDly?=
 =?utf-8?B?Ri82U3d5aVE4ZDRUK1RNUENxVXRrSGJpV0FSS0NOdUoyK1hkWjl4bWhBU3hm?=
 =?utf-8?B?UXRsa0N6cjZFTlpRNEFBeVJFRFhRVHlMMDV4Mm44enVkN3VMK3ZXYnJUN2xH?=
 =?utf-8?B?YnN5RlRVbkdXckRMejhQN0owZnlvQkxGQlRQK2xNUEJ1ODcyTHdpa0tEK1Vp?=
 =?utf-8?B?MFIxbkhZTTgzcGNwTnFSL2FjV0EvbzBHdUNtUU0yWk1PbEYrc3JGNWc5WDVh?=
 =?utf-8?B?TlpTWEJFZFpXTVpqTTZHMlM5Y0xiWXp6RnJkL0hkY3ErdS9GLzlOa1VqV25u?=
 =?utf-8?B?eHdISmpsOFpEYSsxOXRVRCtUSGhmS1N4NjhCMHNKTk5oR2kyOWVoQmNqbXEr?=
 =?utf-8?B?bTRzS0dIb2pUKytvRlVNWlZYbGRtWEJaV09kQklTNDhpWEJrNnpDdXl1T3JH?=
 =?utf-8?B?cDRQQmtYRnAySlJSSDlsMENPbzdjR2VyWFlKRUZxQi9uS1lnaUlKU0Q4ZWk0?=
 =?utf-8?B?dEJmQ3hMa20wSWljR0N5aWQ5bDRXSG9yeEcxWWtMaHJPOW9nNDUwTWhHVlBv?=
 =?utf-8?B?bXZCSW1GYXF5RDIvR0tZa1QxZFV4MmIzbk11M0RNbXRHVU5hL2lyM1NDOGNh?=
 =?utf-8?B?M2xteG1jZ1ZHeFlLL1J4SVRQM2F0UG1vWm94UFZucW02RitlcU80aDc4STFa?=
 =?utf-8?B?SzZOVHJaZ3ZZOThzeGhCdlFWL0NlaFkzaVRQWkl4eHpuUThJUWU1bk1CREVE?=
 =?utf-8?B?SmFhZGhTR1ZLTGhRWTJwV0ZPOTdjSDlrTjlXRk1kMDlISUZVd29uVTJxdzBt?=
 =?utf-8?B?VFFGbGNUbG1BckNCcHlYVlE4UEdzMHRvbjAvK3RiYVQ3OWZ6YmU4cTBQd2M0?=
 =?utf-8?B?bTgvZUkxRVFBMHZzU2RyUllZYno0aVB4U0wyWU51ckxUTFNUR2pnNkpiVis1?=
 =?utf-8?B?a0I2TEZMNjZJMWp1VWZxZmFmWWp0VmxEd2F3ZUdXTEx0aTVIbVNoa0RwR3pk?=
 =?utf-8?B?d1Y3azNhandjMGlmNldCMCtLMzVwcENwd3k1VEFPQWtHdC90WElxM3pGVnZC?=
 =?utf-8?B?ZkVnd2RITzJXMERHUzEvdlN4akswem1IbjZWbXNlVVhmUm96WGVjTUY1NlQ4?=
 =?utf-8?B?Wlpob0RMQVQrL0Y2QmpNUWFLbFViZHc4TW9TYmU2bE9GSmgzNU93RzRjcmM3?=
 =?utf-8?B?YlViSnNGMHZhd1E3SVVVVVFYYW9aSXp1SmthSnMxeGpndTljc2x0WTdHdkVh?=
 =?utf-8?B?bjFTOG5vUzVNRFVkUTVoVk10Z1JPTE9RcFZEMHoybkZkY29ONUYxTjdRb1dl?=
 =?utf-8?B?SUdod0M2WGFFZmpHWmVWcExlR0JHVzN0NnU4cjBEUlZ0cDdDaUFVdEtzLzVI?=
 =?utf-8?B?cWMvSUc3RTFSSWxaZ2F2b0wxMjh6QkdTdFZPMFN2WU81OVNUSzQvUm1TbTJp?=
 =?utf-8?B?UzBuUWJyTm5ySGpVbWpGYkFtY1lsdDVyTXcxRUFKLzRIYThieGZoRFVGYWQ3?=
 =?utf-8?B?anNrUlNmQ1JqNVIwdzBva051alZQczdrMzFOVVc3akRBR3VSWWE0T2JubmpY?=
 =?utf-8?B?T0VUVHJMeHltU09kbjNoUy9hMEJtd0w2RkVnTkFEaFhnTkxieC8yUFFJajAy?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8b84d8-2ad2-4839-241d-08d9aabc73be
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 17:54:22.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1htZfnKBxRLcp/bI+RRxg8hapXQ4SwGQsyML27CH2PNXIpsI2XwinSduEBddRpc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2479
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: LxC0Z1PNTcCOBKf5eFqHRuMx6PpM1RZt
X-Proofpoint-GUID: LxC0Z1PNTcCOBKf5eFqHRuMx6PpM1RZt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=994 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> This exercises the io_uring_buf and io_uring_file iterators, and tests
> sparse file sets as well.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 226 ++++++++++++++++++
>   .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++++
>   2 files changed, 276 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 3e10abce3e5a..baf11fe2f88d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -1,6 +1,9 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Copyright (c) 2020 Facebook */
> +#include <sys/mman.h>
>   #include <test_progs.h>
> +#include <linux/io_uring.h>
> +
>   #include "bpf_iter_ipv6_route.skel.h"
>   #include "bpf_iter_netlink.skel.h"
>   #include "bpf_iter_bpf_map.skel.h"
> @@ -26,6 +29,7 @@
>   #include "bpf_iter_bpf_sk_storage_map.skel.h"
>   #include "bpf_iter_test_kern5.skel.h"
>   #include "bpf_iter_test_kern6.skel.h"
> +#include "bpf_iter_io_uring.skel.h"
>   
>   static int duration;
>   
> @@ -1239,6 +1243,224 @@ static void test_task_vma(void)
>   	bpf_iter_task_vma__destroy(skel);
>   }
>   
> +static int sys_io_uring_setup(u32 entries, struct io_uring_params *p)
> +{
> +	return syscall(__NR_io_uring_setup, entries, p);
> +}
> +
> +static int io_uring_register_bufs(int io_uring_fd, struct iovec *iovs, unsigned int nr)
> +{
> +	return syscall(__NR_io_uring_register, io_uring_fd,
> +		       IORING_REGISTER_BUFFERS, iovs, nr);
> +}
> +
> +static int io_uring_register_files(int io_uring_fd, int *fds, unsigned int nr)
> +{
> +	return syscall(__NR_io_uring_register, io_uring_fd,
> +		       IORING_REGISTER_FILES, fds, nr);
> +}
> +
> +static unsigned long long page_addr_to_pfn(unsigned long addr)
> +{
> +	int page_size = sysconf(_SC_PAGE_SIZE), fd, ret;
> +	unsigned long long pfn;
> +
> +	if (page_size < 0)
> +		return 0;
> +	fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (fd < 0)
> +		return 0;
> +
> +	ret = pread(fd, &pfn, sizeof(pfn), (addr / page_size) * 8);
> +	close(fd);
> +	if (ret < 0)
> +		return 0;
> +	/* Bits 0-54 have PFN for non-swapped page */
> +	return pfn & 0x7fffffffffffff;
> +}
> +
> +void test_io_uring_buf(void)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	char rbuf[4096], buf[4096] = "B\n";
> +	union bpf_iter_link_info linfo;
> +	struct bpf_iter_io_uring *skel;
> +	int ret, fd, i, len = 128;
> +	struct io_uring_params p;
> +	struct iovec iovs[8];
> +	int iter_fd;
> +	char *str;
> +
> +	opts.link_info = &linfo;
> +	opts.link_info_len = sizeof(linfo);
> +
> +	skel = bpf_iter_io_uring__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "bpf_iter_io_uring__open_and_load"))
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(iovs); i++) {
> +		iovs[i].iov_len	 = len;
> +		iovs[i].iov_base = mmap(NULL, len, PROT_READ | PROT_WRITE,
> +					MAP_ANONYMOUS | MAP_SHARED, -1, 0);
> +		if (iovs[i].iov_base == MAP_FAILED)
> +			goto end;
> +		len *= 2;
> +	}
> +
> +	memset(&p, 0, sizeof(p));
> +	fd = sys_io_uring_setup(1, &p);
> +	if (!ASSERT_GE(fd, 0, "io_uring_setup"))
> +		goto end;
> +
> +	linfo.io_uring.io_uring_fd = fd;
> +	skel->links.dump_io_uring_buf = bpf_program__attach_iter(skel->progs.dump_io_uring_buf,
> +								 &opts);
> +	if (!ASSERT_OK_PTR(skel->links.dump_io_uring_buf, "bpf_program__attach_iter"))
> +		goto end_close_fd;
> +
> +	ret = io_uring_register_bufs(fd, iovs, ARRAY_SIZE(iovs));
> +	if (!ASSERT_OK(ret, "io_uring_register_bufs"))
> +		goto end_close_fd;
> +
> +	/* "B\n" */
> +	len = 2;
> +	str = buf + len;
> +	for (int j = 0; j < ARRAY_SIZE(iovs); j++) {
> +		ret = snprintf(str, sizeof(buf) - len, "%d:0x%lx:%zu\n", j,
> +			       (unsigned long)iovs[j].iov_base,
> +			       iovs[j].iov_len);
> +		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> +			goto end_close_fd;
> +		len += ret;
> +		str += ret;
> +
> +		ret = snprintf(str, sizeof(buf) - len, "`-PFN for bvec[0]=%llu\n",
> +			       page_addr_to_pfn((unsigned long)iovs[j].iov_base));
> +		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> +			goto end_close_fd;
> +		len += ret;
> +		str += ret;
> +	}
> +
> +	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(iovs));
> +	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> +		goto end_close_fd;
> +
> +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_buf));
> +	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
> +		goto end_close_fd;
> +
> +	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
> +	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
> +		goto end_close_iter;
> +
> +	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
> +
> +	puts("=== Expected Output ===");
> +	printf("%s", buf);
> +	puts("==== Actual Output ====");
> +	printf("%s", rbuf);
> +	puts("=======================");

Maybe you can do an actual comparison and use ASSERT_* macros to check 
result?

> +
> +end_close_iter:
> +	close(iter_fd);
> +end_close_fd:
> +	close(fd);
> +end:
> +	while (i--)
> +		munmap(iovs[i].iov_base, iovs[i].iov_len);
> +	bpf_iter_io_uring__destroy(skel);
> +}
> +
> +void test_io_uring_file(void)
> +{
> +	int reg_files[] = { [0 ... 7] = -1 };
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	char buf[4096] = "B\n", rbuf[4096] = {}, *str;
> +	union bpf_iter_link_info linfo = {};
> +	struct bpf_iter_io_uring *skel;
> +	int iter_fd, fd, len = 0, ret;
> +	struct io_uring_params p;
> +
> +	opts.link_info = &linfo;
> +	opts.link_info_len = sizeof(linfo);
> +
> +	skel = bpf_iter_io_uring__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "bpf_iter_io_uring__open_and_load"))
> +		return;
> +
> +	/* "B\n" */
> +	len = 2;
> +	str = buf + len;
> +	ret = snprintf(str, sizeof(buf) - len, "B\n");
> +	for (int i = 0; i < ARRAY_SIZE(reg_files); i++) {
> +		char templ[] = "/tmp/io_uringXXXXXX";
> +		const char *name, *def = "<none>";
> +
> +		/* create sparse set */
> +		if (i & 1) {
> +			name = def;
> +		} else {
> +			reg_files[i] = mkstemp(templ);
> +			if (!ASSERT_GE(reg_files[i], 0, templ))
> +				goto end_close_reg_files;
> +			name = templ;
> +			ASSERT_OK(unlink(name), "unlink");
> +		}
> +		ret = snprintf(str, sizeof(buf) - len, "%d:%s%s\n", i, name, name != def ? " (deleted)" : "");
> +		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> +			goto end_close_reg_files;
> +		len += ret;
> +		str += ret;
> +	}
> +
> +	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(reg_files));
> +	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> +		goto end_close_reg_files;
> +
> +	memset(&p, 0, sizeof(p));
> +	fd = sys_io_uring_setup(1, &p);
> +	if (!ASSERT_GE(fd, 0, "io_uring_setup"))
> +		goto end_close_reg_files;
> +
> +	linfo.io_uring.io_uring_fd = fd;
> +	skel->links.dump_io_uring_file = bpf_program__attach_iter(skel->progs.dump_io_uring_file,
> +								  &opts);
> +	if (!ASSERT_OK_PTR(skel->links.dump_io_uring_file, "bpf_program__attach_iter"))
> +		goto end_close_fd;
> +
> +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_file));
> +	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
> +		goto end;
> +
> +	ret = io_uring_register_files(fd, reg_files, ARRAY_SIZE(reg_files));
> +	if (!ASSERT_OK(ret, "io_uring_register_files"))
> +		goto end_iter_fd;
> +
> +	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
> +	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer(iterator_fd, buf)"))
> +		goto end_iter_fd;
> +
> +	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
> +
> +	puts("=== Expected Output ===");
> +	printf("%s", buf);
> +	puts("==== Actual Output ====");
> +	printf("%s", rbuf);
> +	puts("=======================");

The same as above.

> +end_iter_fd:
> +	close(iter_fd);
> +end_close_fd:
> +	close(fd);
> +end_close_reg_files:
> +	for (int i = 0; i < ARRAY_SIZE(reg_files); i++) {
> +		if (reg_files[i] != -1)
> +			close(reg_files[i]);
> +	}
> +end:
> +	bpf_iter_io_uring__destroy(skel);
> +}
[...]
