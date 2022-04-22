Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB6B50C56C
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 02:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiDWACu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 20:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiDWAC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 20:02:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CC01FB8A6
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 16:59:31 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23ML6mUT004938;
        Fri, 22 Apr 2022 16:59:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H018jueOdz+hA+AbuAnaXkReYt+mhBrnxOcJYJYrBPw=;
 b=bevk0ljqTdF1MdD9tHQMZJnJeAru4hhmQNh3hHkmGvuu7d3EWXZ9YB/2GuumDBXJzfHt
 5bdBvbsUkRCFTrS28FL5kZYP7TDa7eCatWnOV6IeVeJKqjFxTsu44GIhX9tJcp1rrWTa
 30IpEdD9J3FIHDgqs9trWW+GOSOKnnzs3ME= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkuvh4gkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 16:59:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPA5stkHU18CiV2ulepEz7/pKd2le5hF5EppTRRsZj73VhNzseqhHTLafvkE08fU+jMFhWju1F5HY2MpzQgtpHY8bfMZ7nSeQrPmR1bVobJTlg0x2HMuB9UfBwWQQTxdPew08FlmoYUwBxfNPybEGQlA4I1KRl84bslnSAGOPVYXT+BNq3uMGmc1NqDq1oMvWc34BSX64TxFDsSwJqrkekxVuAUIlOnGqJP1oKCoOb5De34WNDdROCJ2Fm/ArpmLOW1St1C2DBO7cxQExjkYUWqVZqrVF8pE5qMqk1yVGsn6obfirJ6EIDndtv9yD1EdQ3pVqVM8DG5+aOn8JPqtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H018jueOdz+hA+AbuAnaXkReYt+mhBrnxOcJYJYrBPw=;
 b=hCauKJzkNiT1VZLMivagJTmIGrOQaWvSinGxQ8OPaB/LIXV3X4d8C2Djj3xOzwdUYw+NuAxpIEXsuS2sfBMtZ983XcjbQUgztsriCmKiyGwfWBGQcxuIQZqYyUCu7xGY6ZQbARe4EAya8RXK+A0q3haw+JBgUsS7O58jlMb8NSVNQWV4om8G3wuuYUNy67QmQiqvNT2tQ+Y10NjttudZn82sLPE2sP2O4OtOIQZVatua1HtVH7Qt3D0IY8zciZMAKsiIjWjrRBea/a4JxMD1t0pnyZpndMp9Tsh8rJ8EspvZfNi49sA6EtwtbEeWkLU8LsjrXyM/V6GwE6COk1QdPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by CH2PR15MB3589.namprd15.prod.outlook.com (2603:10b6:610:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 23:59:28 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2%9]) with mapi id 15.20.5186.017; Fri, 22 Apr 2022
 23:59:28 +0000
Message-ID: <07dfb173-67d0-a80c-d485-8fb3f16a0a5b@fb.com>
Date:   Fri, 22 Apr 2022 16:59:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2 06/12] io_uring: modify io_get_cqe for CQE32
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20220420191451.2904439-1-shr@fb.com>
 <20220420191451.2904439-7-shr@fb.com>
 <CA+1E3rKEr4ULc=065kRu_p1265vTE4x+0q+XNa49ie-YRXabdA@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CA+1E3rKEr4ULc=065kRu_p1265vTE4x+0q+XNa49ie-YRXabdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0063.prod.exchangelabs.com (2603:10b6:a03:94::40)
 To MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3ed9ba1-abaa-4cfc-f667-08da24bc2246
X-MS-TrafficTypeDiagnostic: CH2PR15MB3589:EE_
X-Microsoft-Antispam-PRVS: <CH2PR15MB35895929DD3E87D593FBDF3DD8F79@CH2PR15MB3589.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPrsk94n2M2u32suskB9lriepCbWYg9b2c60NneoUYaioxlml4Equ2AAYj3ahy5Kpdssz6NMckvLRDK374EjWIbw+mGS2EwsMi07yHE2q1iR6Vr5/hJyR7y7x88b3ylh7lDTjNW3N+G0nQV1mZBxTdJPNf+QT1hbIzIV3hQGDg83/gzLsVnLOIwXJO6fpUKCyfMv39bPIhofnryJV5T2MUUOXmv5ypmNqIzjKTDxUR1wmQIZp4UN+8fUYYyXRBAPWAycvWhtgxdkmA+CNByzXqDapbFcJlIiWoRPrJANdLusW+IBCgBpJM0ui5TGAjkUgovCP6B0IJBM1r2ersVHC3X6k1DBm3Ip4SB0QwJ7vCNKJp7cEt09HW66q3M+PPMY2UtZ+s+XdDK+R7eFxjBqGnW/fJUFwt3HBbB0DHZnPBqnLwHeCtN0vLva/VYMwIN9xuaOfRp2y6ByVgvkZRROL2n0ih9xgchCoD07bQI/REdkToKwvna1FuC5dJqwf1M5NnPdNqLa+OpRR+3AaRlaA6I8+HTBpv7OXEBTqDMOWWdRnlsj9Kjlv9sY4C9Rij6OjvflIG9ha4SDozVtuioph004QT6VCIyjMFLiX87kRzWuAMuo+nYTmBzNIN/AF5FnUjCzM9MNftA6DEOTXbwECDanx4hyZ1Xd/NhcPR2rrzAFJgPGbyFnEpHSc9ErxZnvRzDgbUxmb4P3YTCJ7RW2dGjB/H52/iobLwOJVNe9YGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2906002)(31696002)(508600001)(66556008)(6916009)(6512007)(31686004)(36756003)(316002)(86362001)(66476007)(66946007)(6486002)(4326008)(8676002)(186003)(5660300002)(2616005)(83380400001)(6666004)(6506007)(53546011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjlSaE5ocjRxeFViTUpOTnZEZ2V1eWhqbUtjSWE3L3ZqekFGZkJjaGJWQjF2?=
 =?utf-8?B?M2dUMVg3eDROQWg1YUJRT01BdmtZd3lleDBJK3BGN1pUMmxjSGRvRjlUTEpB?=
 =?utf-8?B?U0JtdlJXY2xNSE9xdDQrbHBNbXZwMFZ1STBFREpOODErNDVEakNRTmVPeEw1?=
 =?utf-8?B?NkxDeFl1Ynl1aGhJOE5PVE9CeGVIZWJXdzY4eStXZGQ1Q2dyMGRuSXdUU0pO?=
 =?utf-8?B?amVnUEdOZTNMQTZIR1ZiSEVaNVZRWEZHb2tqeUxWY3VOL203RklTeVZZNUZK?=
 =?utf-8?B?UGdodEFwU3lETXRmU2NUcFVhR3IzRVhmRFRJOCs5a0t6QVVCMXRDaEFLQ2JP?=
 =?utf-8?B?TTlndDRxcU1KczJlQXpMUWV6QkNaaWpXWHowaDJoOFhWNE1wYzZHdGI2ZVBJ?=
 =?utf-8?B?RlpPYWVCSmM0SG51VlQ4U1kvTC9xNlg0d3NLdmhpbWVqVjFVRGZxcU83RXlZ?=
 =?utf-8?B?NDZ1bEJWVDdlZUorV2dRdkxkbXlqdHFKOGl5UEFUMlVESXh6Y21Oa2J5emZz?=
 =?utf-8?B?dEtySHp4T0hNMHVMVHMzaXlVY3YzYTFyRkxvWC9xTmlwWWh1US9ydmhkNmw2?=
 =?utf-8?B?L2Q4TUpCeGRuUUFGdHhUUkZDSEFoTGRXYzJxLzl3R3p5aWxFOS9sZzRLUitv?=
 =?utf-8?B?bHh1WWlXd204RE12R3prL2I2RmZTS2FvVkxOZThnUWxlTXRvZ3RZdFFqUEho?=
 =?utf-8?B?WXdSSlNCVUEza21TaXpaQU9STTZ2SzBNaGczUmtBcUV0cENkSGhwSk0vWUdN?=
 =?utf-8?B?SnIwVUVUY1QyWHdtQVg4Z1k5ZjRlckNJT3cyMURMemc5eCtFQjZnYWVESUVD?=
 =?utf-8?B?d3p0QUhHOVpjR09KV2hiTFdmQXJGZkkvSDVqTGIySEh0SEhDN0tYdTk5MkNQ?=
 =?utf-8?B?NFNRRWZOYkVYMGlFWVpYeUhDTWp1d3NGdFZhbHlDQUNkRW1xN2tNVmdUS1BM?=
 =?utf-8?B?bHl4VlNlbkl2N0FHZjlRa21OR3NOcnl5RkZuTFNBOUxJOURLQ25icDVmdWk5?=
 =?utf-8?B?MjVqWjFLQkxUa3MydnNzellMNTZKS2RmR2d1UVFzOU4rbkY1Zk5ub1R2RWll?=
 =?utf-8?B?Z3c3R0luNFM3THY1VFpWVkdnYnpkaUpHVnZIVkkyMzQyRW9hZXRDSUxZWkgy?=
 =?utf-8?B?T3F4LzYrc29iNUgyZ1dhUXRvTnkvQkFNNGIxeU1IdFlvL1FtZ0k1U2VSMTBX?=
 =?utf-8?B?bElvOTNFYmZyNGRVNWVwSmplejI1U0RVbzdFbTRaVmJJQ0Q1SFZNdHBHYjNL?=
 =?utf-8?B?NmoxeXZEVnkyY3JXWHc4UDFjTWhFNnhRTzgrVVY4N2F2UGVObGRCYWlmcUFD?=
 =?utf-8?B?QVE3cVU2bVdSUjJxSlY3TnRNWGpnUktoR3hlZXc2N1BNU2ZUczVPOFNIazQ2?=
 =?utf-8?B?UTZGNUNZZVpocHBPY3hOMjJTQmdhQkl3WS9PdjVhaStFRjg1RVQxQ2x6ZUN0?=
 =?utf-8?B?L2NtQWFiZDRnZ1R0T0pPVXNuT0JBVWxmcmxCRjI5eEIrRXNMTXNsT1hZTkNU?=
 =?utf-8?B?dFcxQ1JkMGhXbndrM3FuMGFzc0JzQzE3OGdrMFRWOTRiYSt1T1JxeTNBbzg1?=
 =?utf-8?B?WTBzRklkUTdnVUNCYzVmTkhocHBGZG1zY1d1aW9mN0YvS0Q5Z3VkQ1VuOFdT?=
 =?utf-8?B?d3VkREM0KzBpdEFHeE14UVhNcXRHbFQrUThiUEdJWWJiQlhYVTRwOWlMc3dh?=
 =?utf-8?B?K3RDUWhpZEtHcUJFZ2w4RmROOEx4VFArZ252WTFKR01DUGNaV2QwRjdwaUYv?=
 =?utf-8?B?cmRXcGZwVExLSWxBbGFud0dQSW1HOVMwTFJwLy9XSXMvTlBiWnhlNU9rNGFV?=
 =?utf-8?B?VWIwRkNMOEJCaStUT0ZMR3o5K3JYeWpZVmFZZ1o3ZWVVMEd6VEhIWDBDUytM?=
 =?utf-8?B?QUFBU3ROeHpKSi9ZaVVDV01qNldlbW91OWdVcGxib0kxNk9laXRNcjZRT0kr?=
 =?utf-8?B?SFdGNXNUQjlaTFgyTW03Y3RBcU5TWHMyTWRTRi94QlYrRGRzNEhzOExhQkZN?=
 =?utf-8?B?NGsvcktwQUdhT1pMNnpOcDQ1eXlLY3BseERLMU1Zak1EQ0ttMkFtZjJJaUJk?=
 =?utf-8?B?aUlCQ2taWGV4SWpnYVc2Si9vaGtDOWh0N2xEYnVQZVZlRHVYcVg1MThWUmlx?=
 =?utf-8?B?cjJ0d1E2SFpJWjJMais0OUhBRTRvREIvamFhazZDZVdsRGl6eU5IWlNPRXJ4?=
 =?utf-8?B?ZUxZbHNVM3lod1dSclBJa0Exc0JJQWhYU3ZmVm1Iekg4VGNWQ3Zvb3JMbTFZ?=
 =?utf-8?B?VnN4VWFUVjNqQkNRbUptejFmRFEyV0I4ZFVQb21kRkR6cWZwL2V0a2U1QzJw?=
 =?utf-8?B?czlzWkZtZ2dMaUxWWjJEQ1NhS1FsOVJIMjg3Z3laVS9LU3NpeENRcFkvYjlR?=
 =?utf-8?Q?THamcOn5Chd149p4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ed9ba1-abaa-4cfc-f667-08da24bc2246
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 23:59:28.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwmotLKpW+n8RAcwFVm0U/Mfob5PXYPfh9LJCK2LLSZweVrbYkSXIh9x7zlY1Xyo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3589
X-Proofpoint-GUID: GE-yHHgpLf-eih25pHqsjb2y5eGU1L6o
X-Proofpoint-ORIG-GUID: GE-yHHgpLf-eih25pHqsjb2y5eGU1L6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_07,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/21/22 6:25 PM, Kanchan Joshi wrote:
> On Thu, Apr 21, 2022 at 3:54 PM Stefan Roesch <shr@fb.com> wrote:
>>
>> Modify accesses to the CQE array to take large CQE's into account. The
>> index needs to be shifted by one for large CQE's.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c93a9353c88d..bd352815b9e7 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1909,8 +1909,12 @@ static noinline struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>>  {
>>         struct io_rings *rings = ctx->rings;
>>         unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>> +       unsigned int shift = 0;
>>         unsigned int free, queued, len;
>>
>> +       if (ctx->flags & IORING_SETUP_CQE32)
>> +               shift = 1;
>> +
>>         /* userspace may cheat modifying the tail, be safe and do min */
>>         queued = min(__io_cqring_events(ctx), ctx->cq_entries);
>>         free = ctx->cq_entries - queued;
>> @@ -1922,12 +1926,13 @@ static noinline struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>>         ctx->cached_cq_tail++;
>>         ctx->cqe_cached = &rings->cqes[off];
>>         ctx->cqe_sentinel = ctx->cqe_cached + len;
>> -       return ctx->cqe_cached++;
>> +       ctx->cqe_cached++;
>> +       return &rings->cqes[off << shift];
>>  }
>>
>>  static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>>  {
>> -       if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
>> +       if (likely(ctx->cqe_cached < ctx->cqe_sentinel && !(ctx->flags & IORING_SETUP_CQE32))) {
>>                 ctx->cached_cq_tail++;
>>                 return ctx->cqe_cached++;
>>         }
> 
> This excludes CQE-caching for 32b CQEs.
> How about something like below to have that enabled (adding
> io_get_cqe32 for the new ring) -
> 

What you describe below I tried to avoid: keep the current indexes and pointers
as they are and only when we access an element calculate the correct offset into the
cqe array.

I'll add caching support for V3 in a slightly different way.

> +static noinline struct io_uring_cqe *__io_get_cqe32(struct io_ring_ctx *ctx)
> +{
> +       struct io_rings *rings = ctx->rings;
> +       unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
> +       unsigned int free, queued, len;
> +
> +       /* userspace may cheat modifying the tail, be safe and do min */
> +       queued = min(__io_cqring_events(ctx), ctx->cq_entries);
> +       free = ctx->cq_entries - queued;
> +       /* we need a contiguous range, limit based on the current
> array offset */
> +       len = min(free, ctx->cq_entries - off);
> +       if (!len)
> +               return NULL;
> +
> +       ctx->cached_cq_tail++;
> +       /* double increment for 32 CQEs */
> +       ctx->cqe_cached = &rings->cqes[off << 1];
> +       ctx->cqe_sentinel = ctx->cqe_cached + (len << 1);
> +       return ctx->cqe_cached;
> +}
> +
> +static inline struct io_uring_cqe *io_get_cqe32(struct io_ring_ctx *ctx)
> +{
> +       struct io_uring_cqe *cqe32;
> +       if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
> +               ctx->cached_cq_tail++;
> +               cqe32 = ctx->cqe_cached;
> +       } else
> +               cqe32 = __io_get_cqe32(ctx);
> +       /* double increment for 32b CQE*/
> +       ctx->cqe_cached += 2;
> +       return cqe32;
> +}
