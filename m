Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2846E45618B
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhKRRgo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 12:36:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34306 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232035AbhKRRgn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 12:36:43 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIF0ktV004689;
        Thu, 18 Nov 2021 09:33:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WNDTT51wCwFpWm5hfNOfVvXkFhKDKGfEf61GqZJcwfU=;
 b=i3E+fDj+u/OwIO9t9YEEwGn2BeGqZvOhxop3dHjIkFtfIwX4lk8fHiDPlvQIqqa6N7i4
 IFELNPlhyYdotyqe/4hUL6rJBM90HBrHD204FBTWID5YHd1ePJbInz1Dmkeu5FVnS4Rf
 A2uKrmo6W4I9XupWBxehFIIM31lBPFT+EFg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cds3f16qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 09:33:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 09:33:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvLxpvyx0IWe/IQh5uO6iRvbe6yQkNBNGK88r+EPmNKdgcAjovlfFH6jzGy21xWwX726hL8zdfJZdgwvwoNwSKH1y6tY++GAOOj2dSLbHizyG8UHTTda4Wi/nDZ9BspqkRUCL7hxwnj/500QrbpJlJ71PgQFeXWkbaVIDKBx12IuT/ltn0HPaSCYGAMFwWJQH6347sdby7E8rRH1sdkVLXVWWAS/gcitLwLAQyzbVpBwf3u4wSqUBIXe//1Z92KEZRcvLyjnj4NsL7Z6sMw5qc9YrrvNEeLTYzILlgRTK3AmCtXY2Y+rK8gx8FjycwuiKP5xtND/o6eRwsFHPBugXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNDTT51wCwFpWm5hfNOfVvXkFhKDKGfEf61GqZJcwfU=;
 b=mcdGxZFAyojbH6Mq0c6hpQl3HH/B0MOoqte+ZguhcEL1tbRg7cRmdIsYAHBCgBbtG3rXVbgU/hiR7AazlW8Cq+KFd3hLDZyPqXJfHeGyf4dX6sfpy4PtfQOanY4yYfQWiye4vHQw+WMrYbi1g8GX5U5Pdxq3rFZ35N2zK7kbjPXD+aCGJvyT6EUtyXJOCsfBMcBnTuF0ZbKSVmsr/AjtwUL59T06FpltEiA2gzdYIe7kLM+6ki9PjfT2W9A8HsPOrAYuCiETg71GC8CgnHQp2bxaFYO2Kqd3AJW9jUn4B/cBOTjYDUPZ0TJ3Rj3LIycXUOfsiSHhRitjyh8PsiC+Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB4093.namprd15.prod.outlook.com (2603:10b6:805:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 17:33:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 17:33:09 +0000
Message-ID: <8e1b6378-0017-a09c-d254-0f141073a945@fb.com>
Date:   Thu, 18 Nov 2021 09:33:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 3/8] io_uring: Implement eBPF iterator for
 registered files
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
 <20211116054237.100814-4-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211116054237.100814-4-memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MW4PR03CA0079.namprd03.prod.outlook.com (2603:10b6:303:b6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 17:33:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce0266ee-a584-4fb6-0482-08d9aab97cf4
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4093:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB40937F422CCA0844996EF93CD39B9@SN6PR1501MB4093.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZkVA55eQScV/eRvPn2gd1feGpfV942NiSzgi+XxoXN7Etmi0byB0dXTD+XbAOcIJMp3b/97GeHVVg85E3nQpYBPrqq7KMDlOekd7HUoPubwwF+W5Q8ojHGQwv+vgYRt/TjzaWoqKnC1pJlwvhNMuTyPPe068XVbb0GhSzEKdT3QJlKa8RjiajHsdDBFFp9oAO9Xmd4niaeCBjTb8sgAHkBD98ry5q5C9ejDi+unnjafUqbc+LYQZgy21yrDcd3QfVPswCLpLnpfJRBDU/o4dX46vIeSj6+70bs5ujFhx2dlO4iITUUoud8zOQPxWbEnwppeeGte6uVKhu5duHT5I9V7MG9rIvVAQpLk6HdNuWDlGNXYDhogqULLv26b1CljdYMOgrf3LaNWgECio3M7Rufng7jP2bQTJbj2oFbirZGO6yoi6qJh25qgglpeHp3tOd/DhGnBbWbO9VCdOiTvoyk8cGk5fFJfQ3Aeo1m0R8I6ewIz95WQNJr9cJcFbRGOYG3Wj64v61fKfXeOPlr5Rn5zoA6y1Itz9lNe8B11Qq/ApagT1Wice7K1g4RiCOu32nWFQ86mTzdzdoiTdth3NHxmt8WnpY+SGuD46qdLDKz+qAHHId24erM0+yRMeTiCgHgME7ynzjJjvMCxHQfCBYZGZMK4egXPycqH4mvgxi/a/Ply/qLzgI4a7Pno2Z+3U6gglQkj5ItR8FNMdicPfEIzugLZLsyFImsOVgetFRU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8676002)(6486002)(7416002)(2616005)(53546011)(5660300002)(8936002)(186003)(316002)(54906003)(83380400001)(508600001)(38100700002)(86362001)(31696002)(66476007)(66556008)(36756003)(52116002)(31686004)(66946007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3MyM2JMUzdRbUhTUWt2RkpYWGJIQU40Q2RqMHJmb1VTVmd5UmZ1NXM4UjNU?=
 =?utf-8?B?ZEUrVkIrT2Y2MUtaNTk1V1JINEF0VkI1eWRjdEtVNEx5bnkrWmszclBjY0Rx?=
 =?utf-8?B?SVFDUUNUNXhjYmxpRzJQNkRzT2dpUTI3WWhORGFzSlNEMW9Cc29scm9hMXdD?=
 =?utf-8?B?NzRMV2RlZ0xhOWQyeFdjeWMwejViYmhZQWJSSHhLaDZPckZESGtYQmx0NHRs?=
 =?utf-8?B?NnhGcmgrR2NLSEdSaTVySm1RdWF0eU91YlZoc2hnS25DMkZCY1hkcWtFb2dO?=
 =?utf-8?B?UEV2eVJCYkxiUksxMHpUdEV6dVpSaHZ6NXI0NTdqbkpFYnRCeUc1ZzkrakVx?=
 =?utf-8?B?YUY2MkRxdTllN1Jhd0RLYmFteHNsOFFuWXp1aGNId3o1bGVnanQ4VExRZVlS?=
 =?utf-8?B?VXpZeFFSczl1dS9MWWNXN0x2L2dlTTNvQ2FPKzdQVjZnblFFZXR2TllWbGlC?=
 =?utf-8?B?a0RwWGdWa3JlNkxNWjJIQjZkSGdKWk9aNGE2OE42NlJDeUR0NU5RMFdQUlBu?=
 =?utf-8?B?N1p3VjdrdFhSWWZiTDRNWVFBbHhIaEEwUHc5dXY0WE5mbzVkVXROMTNSMTdL?=
 =?utf-8?B?R0JFOWY5R0l4MEVZa2lGeXU5MFlPOHlueW55UjFidkplZEpPSlIzYkFUTmY0?=
 =?utf-8?B?WC9jZnEzUjg4RERBaUZKdUxiWWRNckFGWVkvZ3NQMTlOTW50QldOYXM5dnlG?=
 =?utf-8?B?c1pHeWJWcVl2LzQrOXBGdklvMVg2dGdwTjE0dUxCMXhwaVB2REoreXRNaWxY?=
 =?utf-8?B?bGU3U09QbmFRZkFreWFMciswV1BWRzZ3YlBQSHNOMGs5SnlCVVQzQjRJSGwv?=
 =?utf-8?B?NEJYS1hNV09yTDY5VDJsYjBJSEk1QUs0cFFKRVJJZ0w4Z1NSSXNTNXNacWZt?=
 =?utf-8?B?a3l3MDZoUHljVlp1RVJnLzRmejhrTUEvS0hmUkFkcXI4SmNPSWRoQ1dKWW1n?=
 =?utf-8?B?THNleEwzSVZJWDVudlppQXRyMlRQdklkSDE2RVpCWjFhODVPY3JpekVZRHJh?=
 =?utf-8?B?bzZyemwvZXJicGlBdHd2ZjNNc3h1TGVSTkQ4OUZzV2N4dVNseDlaVHNwOEx5?=
 =?utf-8?B?MThoUW5hdG00a3E3aXVsOXFnWkk3eExOKzBqMlBoZGVqR09WekREL0ZNTktM?=
 =?utf-8?B?dHlCY1NOOGRqUFF4cUJLSS96WVZCOFRMRGplL2FtQ1NZS01qdXFUM1BZVjlJ?=
 =?utf-8?B?bHRSNkYvek04Wi9mTHgxL2VkRG5OQkY4dUNxRmZjVGZTa1g1MlFSd3ZYLy8x?=
 =?utf-8?B?YjB0cXNNWEZYaHkrSnJnaUFmS21KMHIwTVIvT1YyajlBaFZwWVZ2aE1XU2V5?=
 =?utf-8?B?bjJJanN6ODhqYWJ6dXhZaEJ0Ryt0NGhDdHFIT2E0cERnNlhHODJIM21jN040?=
 =?utf-8?B?K1BNQUg4bVh6U2ZxS2JOa2trbzNwWWlFa202Wnl4V2NuK3UxRHZvd0szdUJ1?=
 =?utf-8?B?OHdxNzBZYUd3YWFPY2hPVWZDUzBqRkFkZFpoTDVXbTVyYnAwZ28rYVE2S3NP?=
 =?utf-8?B?U3A4QkVoek1iNVBWTmFPV0FnbHhPYWUxdmJMT1RNL2huR1NzSTdoV0lyMk0r?=
 =?utf-8?B?TGFRWlI4b2lJQzNFT1d5UXhFSlZzZjcyK09hcGwvdWtSZS9zcFNIeFh0THVK?=
 =?utf-8?B?VnN0VkxJWlVwZWZmczZBL0lZRTRCNDk4eVJUNXE3ODkzQ21md2hIa0dodmE1?=
 =?utf-8?B?TGJwTEl0Wk51dGZmaUtlamYyMU5IN0s2SXM0YmZNTjlWRVV6NEJ5dDhhcVIx?=
 =?utf-8?B?dS9IZTQvSGdtR1VPd0dWUzc5cEJKN1dOanNDMTBEK1BHanZ0bjJndTRFa3pM?=
 =?utf-8?B?Y0c5Y09XbFpOMGp4MXlhNHYzb0VkS1RYZ3l5RU1za0hRVWE0YXZWSXVVNkth?=
 =?utf-8?B?MFAvbHZ1aTgxODZjZEdVZUNzY1ltako5T2g1MWRINzl3M2lXMmRuSVllRWZR?=
 =?utf-8?B?U29SN1JvVzg3OE4wU0p3eXMvaEdzTk40bkhvM0ZGeWpJclhsZkd2UUpiczhj?=
 =?utf-8?B?WExEaStXaHNaUVhydm90WUczNFZTbVJaNWtFSWlsNkRiQ29tUFhGOWZWM0FM?=
 =?utf-8?B?aFdKK25KQmpWZTJKZEdaaHVYVHZTVVhsbWhGZ2hWTXIzVzhueXA5QUJZeUpS?=
 =?utf-8?B?TUt6M1A2cVdDd3p2UGcrQmNydHJMSGNrMHpMZlJXbGdDZEg3RFljZUJpdXFG?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0266ee-a584-4fb6-0482-08d9aab97cf4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 17:33:09.3293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOp53Tq9/77VmBG3aj0sS+5L/sINrt3g/U0Muk2u+997YkIIeniIYcuAJUOkCgVr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4093
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 1ux8dr_YEhubvvKb3bfEYhg3N3n72Poy
X-Proofpoint-GUID: 1ux8dr_YEhubvvKb3bfEYhg3N3n72Poy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> This change adds eBPF iterator for buffers registered in io_uring ctx.
> It gives access to the ctx, the index of the registered buffer, and a
> pointer to the struct file itself. This allows the iterator to save
> info related to the file added to an io_uring instance, that isn't easy
> to export using the fdinfo interface (like being able to match
> registered files to a task's file set). Getting access to underlying
> struct file allows deduplication and efficient pairing with task file
> set (obtained using task_file iterator).
> 
> The primary usecase this is enabling is checkpoint/restore support.
> 
> Note that we need to use mutex_trylock when the file is read from, in
> seq_start functions, as the order of lock taken is opposite of what it
> would be when io_uring operation reads the same file.  We take
> seq_file->lock, then ctx->uring_lock, while io_uring would first take
> ctx->uring_lock and then seq_file->lock for the same ctx.
> 
> This can lead to a deadlock scenario described below:
> 
>        CPU 0                             CPU 1
> 
>        vfs_read
>        mutex_lock(&seq_file->lock)       io_read
> 					mutex_lock(&ctx->uring_lock)
>        mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
> 					mutex_lock(&seq_file->lock)
> 
> The trylock also protects the case where io_uring tries to read from
> iterator attached to itself (same ctx), where the order of locks would
> be:
>   io_uring_enter
>    mutex_lock(&ctx->uring_lock) <-----------.
>    io_read                                   \
>     seq_read                                  \
>      mutex_lock(&seq_file->lock)              /
>      mutex_lock(&ctx->uring_lock) # deadlock-`
> 
> In both these cases (recursive read and contended uring_lock), -EDEADLK
> is returned to userspace.
> 
> With the advent of descriptorless files supported by io_uring, this
> iterator provides the required visibility and introspection of io_uring
> instance for the purposes of dumping and restoring it.
> 
> In the future, this iterator will be extended to support direct
> inspection of a lot of file state (currently descriptorless files
> are obtained using openat2 and socket) to dump file state for these
> hidden files. Later, we can explore filling in the gaps for dumping
> file state for more file types (those not hidden in io_uring ctx).
> All this is out of scope for the current series however, but builds
> upon this iterator.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   fs/io_uring.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 139 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9e9df6767e29..7ac479c95d4e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -11132,6 +11132,7 @@ __initcall(io_uring_init);
>   BTF_ID_LIST(btf_io_uring_ids)
>   BTF_ID(struct, io_ring_ctx)
>   BTF_ID(struct, io_mapped_ubuf)
> +BTF_ID(struct, file)
>   
>   struct bpf_io_uring_seq_info {
>   	struct io_ring_ctx *ctx;
> @@ -11312,11 +11313,148 @@ const struct bpf_func_proto bpf_page_to_pfn_proto = {
>   	.arg1_btf_id	= &btf_page_to_pfn_ids[0],
>   };
>   
> +/* io_uring iterator for registered files */
> +
> +struct bpf_iter__io_uring_file {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct io_ring_ctx *, ctx);
> +	__bpf_md_ptr(struct file *, file);
> +	unsigned long index;

change "unisnged long" to either u32 or u64, maybe just u64?

> +};
> +
> +static void *__bpf_io_uring_file_seq_get_next(struct bpf_io_uring_seq_info *info)
> +{
> +	struct file *file = NULL;
> +
> +	if (info->index < info->ctx->nr_user_files) {
> +		/* file set can be sparse */
> +		file = io_file_from_index(info->ctx, info->index++);
> +		/* use info as a distinct pointer to distinguish between empty
> +		 * slot and valid file, since we cannot return NULL for this
> +		 * case if we want iter prog to still be invoked with file ==
> +		 * NULL.
> +		 */
> +		if (!file)
> +			return info;
> +	}
> +
> +	return file;
> +}
> +
> +static void *bpf_io_uring_file_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +	struct file *file;
> +
> +	/* Indicate to userspace that the uring lock is contended */
> +	if (!mutex_trylock(&info->ctx->uring_lock))
> +		return ERR_PTR(-EDEADLK);
> +
> +	file = __bpf_io_uring_file_seq_get_next(info);
> +	if (!file)
> +		return NULL;
> +
> +	if (*pos == 0)
> +		++*pos;
> +	return file;
> +}
> +
> +static void *bpf_io_uring_file_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +
> +	++*pos;
> +	return __bpf_io_uring_file_seq_get_next(info);
> +}
> +
> +DEFINE_BPF_ITER_FUNC(io_uring_file, struct bpf_iter_meta *meta,
> +		     struct io_ring_ctx *ctx, struct file *file,
> +		     unsigned long index)

unsigned long => u64?

> +
> +static int __bpf_io_uring_file_seq_show(struct seq_file *seq, void *v, bool in_stop)
> +{
> +	struct bpf_io_uring_seq_info *info = seq->private;
> +	struct bpf_iter__io_uring_file ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (!prog)
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.ctx = info->ctx;
> +	/* when we encounter empty slot, v will point to info */
> +	ctx.file = v == info ? NULL : v;
> +	ctx.index = info->index ? info->index - !in_stop : 0;
> +
> +	return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static int bpf_io_uring_file_seq_show(struct seq_file *seq, void *v)
> +{
> +	return __bpf_io_uring_file_seq_show(seq, v, false);
> +}
> +
[...]
