Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1024B3E50CB
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 03:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbhHJB4U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 21:56:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38128 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236481AbhHJB4T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 21:56:19 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17A1oQvx029772;
        Mon, 9 Aug 2021 18:55:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zcU+tvj2fuzw8NWUCuAsjgbGpROf8U49MJCYdFVLcAc=;
 b=nhwMopvXozRyGNw9aR+4i9C7ek4MgQJMlvaTPjDgbxTsesfT50A1wBidOjFJFYhSZTdC
 Brp3DDQMTl7kC1fMXDfCeQnmos2HT0efUq2HU3/HHB87oSHs95PE6YQYECaHptZntEx+
 sZVLuQ+r9t4tE99XPdAz5T37rx0ZbvdFMjE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3ab6mmudkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Aug 2021 18:55:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 18:55:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjCSa/UjIpqCtcBq4KLnxyb5DSbv6R4GSokAiu4tTwC3Uxw6KqeU+ou5CunFOiIj1H4AmbywPq4mvOhu6wCj/HfgP1roU4c1HIh9J8tfliTOqZmC5bysS0S01od1xr9pe4cBTFfP8cyeDd0Y3KpQ0JGoyxnQmMe5a5XvCL0444sYYpVmB+HUHRNlSNcH1D6l6dtKt+wBTdHsaG6sp7qr/l//dCeyyltKtPD3BgftjGKFTBC//zkbh7I4Wt3UpQqquyR9XaiBGZeb/H30yORXY/7kpOR2B5kiFncJ9CBCrFb7HY1zHELAEULz22c8drywOWUlzMpM3TxFnpelFy8LRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcU+tvj2fuzw8NWUCuAsjgbGpROf8U49MJCYdFVLcAc=;
 b=X599zQe1eTHb5YJPhzbPFWxeaf8EzL8y0Wjpe0A5k3Dv3Tm+KpQTmjX9g1s6wlxOijWk6q6imTeojVsgBp27gkItPcIOLXjcsirBVKlorK5MR58cMPQ6eM/ktGUAN994EcwsgWDw2DZ/pKgvdA3wxtNJu4lp97vLojKCHAhPu0nR7TixHwKssKagexE+5hsDBexEZVZ/8jTCZLukupAeTGIsY3IS7LKrYdiz5pk1swZDDJUtyN8BvGZumI0R1TugtSVeEDR/iVheXIbhu7iziOJc8avjlwpaKV8QRDFjdV2BovG1X+GxB1f6radxS1Fgc/0NwawAA88en+M7KHRLog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24)
 by SJ0PR15MB4680.namprd15.prod.outlook.com (2603:10b6:a03:37d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 01:55:55 +0000
Received: from BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::74ff:9128:bc99:e12d]) by BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::74ff:9128:bc99:e12d%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 01:55:55 +0000
Subject: Re: [PATCH] io_uring: be smarter about waking multiple CQ ring
 waiters
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <27997f97-68cc-63c3-863b-b0c460bc42c0@fb.com>
 <d6f7a325-62ef-ec7f-053d-411354d177f2@gmail.com>
From:   Jens Axboe <axboe@fb.com>
Message-ID: <4f310c1a-2630-75ba-1692-cc7d12c11fc0@fb.com>
Date:   Mon, 9 Aug 2021 19:55:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <d6f7a325-62ef-ec7f-053d-411354d177f2@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:a03:331::20) To BYAPR15MB2566.namprd15.prod.outlook.com
 (2603:10b6:a03:150::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.116] (198.8.77.61) by SJ0PR03CA0075.namprd03.prod.outlook.com (2603:10b6:a03:331::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 01:55:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6eb803ad-61fc-47a9-258a-08d95ba1fd96
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4680:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4680D6AF5C16ADFD673050C0C0F79@SJ0PR15MB4680.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: siUx1kQHqe13/Ufa5ZTCbCvE6FvTrLF0Pmbnq3YNB6xh0JNVi/IY5PTRh1Kd+yY87/GEvZiYQm6b23HU+pNn4kltg0isThd5w4PTifQ8IFyylT1Rcz1AoJjkXz/mhk3dAYosFUxEQ/UfmAxGRivYVThLa6V8TgchM4gcZSsRLGy9SzC+zKgmkp9Z2izYpEOQhBcCz92rWkiSOLuthTmQQyHi3mDxFxSHBDnHVXB4BT3iz/v+5w4sFfzyb9926uQsKPhUIrIOB9RXBysqZD2XwzgVnrwBbLHybUEUyDd9GZZl7svDb0ARbu52zmGqgYwEESDXhbX9l3u4fyRWWzhqPOeE8tnjJMJdtmHjRhDdStCJog41SYV3sI+CbBo8GFmzBO5JDyDdN8JykZ/zMzqmjsIs+ZLnpEYCxtpXg+EXNsM5gRo/nMV+wVFgtl6b/Uo0RBTNObUEMxTCoqkKHDVWfpWWP82AXo01DPhH+rubokRL6NVHGSRDT5DbBE4MfYwAEqDfiDxjVBtxtYhiFw2q7CJxCp/5WyF1rOk9bMdIpWvJsUrWDnzDJry3YEfqKQbbNW+HKpLhcne2DCp+IMg3M3u4frwqJwlPH6sNVIqizkcvJR9qcKMFhYnbvIQTnxMpN2osS7qef7ZGZF9zO9dSUS2D9vcsLKEJl6Nt2OBTMxe0V/5j8NJ6nUXL6dNew4A48ZPcaNi5iom79vhPbqheo8Q+2gkz9eIUshRXOamqWM8FKKDjUQ6Nsc0AW2WE0fTJoYsr5548S7adTBwNANTBjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2566.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(186003)(31686004)(26005)(5660300002)(478600001)(53546011)(36756003)(38100700002)(38350700002)(52116002)(31696002)(6486002)(956004)(316002)(66476007)(66556008)(66946007)(110136005)(86362001)(6666004)(2616005)(8936002)(2906002)(8676002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWtTMEJsUE5PK2NZZEIxY0RVTllYL0pBcEk2cTVJVWNaQmxkK2FqTzBRa09N?=
 =?utf-8?B?dFE4TkVGVENjRWRDVTZBeUl1Q2pKc01zaHpwQzVGbWEweHZjblFsNE5Xd3FQ?=
 =?utf-8?B?Ym9kakJBa2w1UURrWkpwSHFZUGRobDhSRzdwSDZrMXR1RFY4WXJhYi8rK0dY?=
 =?utf-8?B?cTJVQVZoS1lkK3dZbytLbU9YSU9ZTG56UGE4ZnptLzhTOHE0aEdTaFMycjhY?=
 =?utf-8?B?ZkRBSW9JRVlSSVNqSDk1Uk92NmlsNGV1emwwbCszMlNZeDhuWVJvVTB0SHNz?=
 =?utf-8?B?YjRRZWkwNU41ZWRjQ1JiYllKeW9wV1doZW9XK0s5TW9ERUFlQjJ5RjQ1cXNE?=
 =?utf-8?B?dmhMQWY5cERUSDczc2tJZy90d3hLQU9GVDhOZlRKaFhQYndWUWZxZDBQeVZ6?=
 =?utf-8?B?d1IydkI5MFpPZ2V2RmMyaFhnUlNFZG1lSmNvZVlmOEZaMjlNNDZlbGNTQXNx?=
 =?utf-8?B?bGVqTk9SdTJna1M0RGhzRzcwYWlNWW9RMHQrVk9FL2NUVFZiU3BPQWgzenli?=
 =?utf-8?B?ZHhoU1paRThPWXU1Rm1wSXVkNEJZSjRoTDFINDZWd2tRdUx2UTFBMnAybUcr?=
 =?utf-8?B?VlJDVEt2dnp5c2R0NlNCeU1oUkQ4c1F6YkcwL0txd0F0dWdlZEV6YisraUZr?=
 =?utf-8?B?YXlONlkvTnNDM0xYWGljbVhNUTdiSGpSRHVzbG1GYzVRRjVEZHdmcWtXNEgv?=
 =?utf-8?B?c0JyUDdHMmhNYWRJL1Z1cTZNakZ6R1A2ZENnc1VkYXFVbmdHZTBLTTFnc0w4?=
 =?utf-8?B?THI1K1pPRjNEUGliR1ZtcVZYSldURHRpaWVUNVBGTm9rRE5zUXBMTkFaZlU4?=
 =?utf-8?B?MjZTR2d5YkgybmU5SURiQ3dXeHFaZ04xa1Faa3J1aXpSaWpCZUZodm9LZEZ6?=
 =?utf-8?B?d3g2aWtnYll0K2xzZUQxL05XcTMzaUZmekQ3T2ZkOXc0S3hCMFBUTTEwQXA5?=
 =?utf-8?B?Rk93M0U2czBEN2ZIeGRUaEovVVErQ1JFZUhtNjJpTXBoaGZ3VG1PZ0JVeXVH?=
 =?utf-8?B?RHhkRHZmS2FmK21EQmxsaFF6cWwrWUJVOVIzUzA2NDBETFFjTmV1eGFERHYw?=
 =?utf-8?B?ZDFvZkJpYU1RMWtxSVpsOHJBMzcrSkR6VXRpMGFNQTduKzNuNExoeEl4dFdx?=
 =?utf-8?B?dUhtRjNRWDFZazVwQUttZlZQQkRKMVVxWUxMVVV0S3ZnaGw4emJKaUdHb0ND?=
 =?utf-8?B?RllNSFgzV0JrM1VJWjM0blNPTzhWT1hBUmFubkhjSEtoQlpDRGFaZkI5bXNZ?=
 =?utf-8?B?V0czN3o4VW1nUXNsdTllU0Y5Y1hyb2VJcm82UHh0bTRiQURyQkxoS1hQdVJo?=
 =?utf-8?B?ZVIwRzdXejFyN2VIcjAvejZmcXZvSVUwL0ZISkJuYzJOYmdwNnEvR2ZseXRl?=
 =?utf-8?B?VDhvK2EveEJKYVZDMmdMcmZNc2E2WXQvQ0E5UWc4c01QQzUrV2NMUFVlb2Zp?=
 =?utf-8?B?Z1RkU1ZpbjRCZ3Fxajc3RU90b3QraDE0MnhTR216d2s5NEltdXJONlJQNUNV?=
 =?utf-8?B?VUM3TCtTcGcvaWhKNzIvTHJ0VGdRRFNGTVFlNUFKQXpIcFg0UWFwRGtDR29Z?=
 =?utf-8?B?SlBCMTBCdllldXRXbWRTRDBJbFhlRk9rZFdmdG5NOUVSSTY0MDlQRGNxa0pX?=
 =?utf-8?B?Z3J1WkpJOVlHVDRqdFJGWTMrQXpCbnJTS1FxeVhHRG1HeDgvWDdPSXdoN3RE?=
 =?utf-8?B?dXB0dXFncUd0Nm1kb29PVHVRR0c0d2x4dWJxdGRESjB5Um9PTUJiRTByaklZ?=
 =?utf-8?Q?JIYlKGCS05dURQj0pg/liMg2kCT5sxfqcZXFDkM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb803ad-61fc-47a9-258a-08d95ba1fd96
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2566.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 01:55:55.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NaC2+jzuyFrnLcyUzZ46qVS4M7zDQmYB/jMKfOKOMAP9B9M9nQtTrih3jO31dXr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4680
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: rHGZFjbLkmfHERQ0zBw5PVctDHqioo9I
X-Proofpoint-ORIG-GUID: rHGZFjbLkmfHERQ0zBw5PVctDHqioo9I
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_09:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 7:42 PM, Pavel Begunkov wrote:
> On 8/6/21 9:19 PM, Jens Axboe wrote:
>> Currently we only wake the first waiter, even if we have enough entries
>> posted to satisfy multiple waiters. Improve that situation so that
>> every waiter knows how much the CQ tail has to advance before they can
>> be safely woken up.
>>
>> With this change, if we have N waiters each asking for 1 event and we get
>> 4 completions, then we wake up 4 waiters. If we have N waiters asking
>> for 2 completions and we get 4 completions, then we wake up the first
>> two. Previously, only the first waiter would've been woken up.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index bf548af0426c..04df4fa3c75e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1435,11 +1435,13 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>>  
>>  static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>>  {
>> -	/* see waitqueue_active() comment */
>> -	smp_mb();
>> -
>> -	if (waitqueue_active(&ctx->cq_wait))
>> -		wake_up(&ctx->cq_wait);
>> +	/*
>> +	 * wake_up_all() may seem excessive, but io_wake_function() and
>> +	 * io_should_wake() handle the termination of the loop and only
>> +	 * wake as many waiters as we need to.
>> +	 */
>> +	if (wq_has_sleeper(&ctx->cq_wait))
>> +		wake_up_all(&ctx->cq_wait);
>>  	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
>>  		wake_up(&ctx->sq_data->wait);
>>  	if (io_should_trigger_evfd(ctx))
>> @@ -6968,20 +6970,21 @@ static int io_sq_thread(void *data)
>>  struct io_wait_queue {
>>  	struct wait_queue_entry wq;
>>  	struct io_ring_ctx *ctx;
>> -	unsigned to_wait;
>> +	unsigned cq_tail;
>>  	unsigned nr_timeouts;
>>  };
>>  
>>  static inline bool io_should_wake(struct io_wait_queue *iowq)
>>  {
>>  	struct io_ring_ctx *ctx = iowq->ctx;
>> +	unsigned tail = ctx->cached_cq_tail + atomic_read(&ctx->cq_timeouts);
> 
> Seems, adding cq_timeouts can be dropped from here and iowq.cq_tail

Good point, we can drop it at both ends.

>>  	/*
>>  	 * Wake up if we have enough events, or if a timeout occurred since we
>>  	 * started waiting. For timeouts, we always want to return to userspace,
>>  	 * regardless of event count.
>>  	 */
>> -	return io_cqring_events(ctx) >= iowq->to_wait ||
> 
> Don't we miss smp_rmb() previously provided my io_cqring_events()?

For? We aren't reading any user modified pats.

> 
>> +	return tail >= iowq->cq_tail ||
> 
> tails might overflow

Indeed, I actually did fix this one before committing it.

-- 
Jens Axboe

