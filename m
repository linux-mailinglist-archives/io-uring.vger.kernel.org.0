Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7551EE9E
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiEHPrk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiEHPrj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:47:39 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2104.outbound.protection.outlook.com [40.92.53.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B1210FE1
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F65b7dGcVxsSR5pk6Ta8MaP67tkJWSSR47zidcUiwHDdK53i0yYkN+DdVituFLGYI3s4UEuCxILs2sdtEUpbTwaM8h6r7vzwQI+sZu5frtywVEjaB1GkNNX8kDN4rmif2BtDiW8vJIqqEkWZ5dgwuUmntCDBdpgpMiQngZ81uKYAeun0vBl8ulcXxTvZo7kO0Oc4QpjtIXHkkpSTG+HapmrizTyMJr0y+eXqJXNDT9PGbddoetEoT3xVJeYEJP3ycn0/Ie1VvjhEV+pjt1wHBs9RN1m4gqU/B3Rnuqt+Yzprc86z3YWsPjex9Zo54k+CPzZkkUfyhDh6kLHNM5UFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wf+cJU1RskqE9ORtseALjODfwTdrb65WTO9QypFo9xY=;
 b=Tpr2OIVu/wfWQlqtzWtGD/Ec4yUENPlE/suE983SvRC7WBi5ndgoLVjT0KkOLeIwlqJQQlH18KrTVcQIR7NLXkIIf/2/JupxHF+UP47DsNNIIklt8KAe5Y8BsjCK038t9b+UTxwVJREwtJGYMEyC3qBbq+PgGrO+KMNIcCAYZlCh0LgBePONKlXseod+9J38MG7+0/YL06oBra6smguvvnEMay81Hohf4yDrp85z/3JFfWhVLK+w6ZgcaS6Lqh5Ga1qD5wVySbyZe5wjh4qL3QtDu1xrgIlbFBaFgFEdhg4b61Y63Psm1YSIyBlY4n173n/fixiMbJee3H6g3/XWQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wf+cJU1RskqE9ORtseALjODfwTdrb65WTO9QypFo9xY=;
 b=Jkg6ca5wUjrLEDWysZ3Xd3pCwF3DkfzME8INPngm8CKKFoAibb5J4jt/8/3irLRCMLiCdXKAlKVFrSUiSjGS7M19Eayb9Ealz3MIR1aw7uRyYftQo/4qNoHFdILqBpyDjeZBnvUzk516ib39GhBmwYZhJqSUJVtKUdTqaGjpuL3WMhLc5OSGID8QbnldmwtO9nOE74YKHBR/vKJBPuxxWd6p3RHERfrlnXWwTFOALwEVnbNnzcFZ4Sjz3DDlNR8tJQXuTbBdr0HjFpOOCwwUCrpRCDwU4+aaBbN8e/wlfIBNkQttE0SyOQbdQU1A7HwR67pXLunV0nyPs1Cu5/NABg==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by SG2PR01MB2871.apcprd01.prod.exchangelabs.com
 (2603:1096:4:37::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:43:46 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:43:46 +0000
Message-ID: <SG2PR01MB241141296FA6C3B5551EA2BBFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
Date:   Sun, 8 May 2022 23:43:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 0/4] fast poll multishot mode
Content-Language: en-US
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <SG2PR01MB241138EDCD004D6C19374E80FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
In-Reply-To: <SG2PR01MB241138EDCD004D6C19374E80FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [kqXAshE12Vc8BdAXr1RexJs1eyKoB7aN]
X-ClientProxiedBy: HK0PR03CA0103.apcprd03.prod.outlook.com
 (2603:1096:203:b0::19) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <92bcdc5f-7301-04c3-ba02-2aae5b878225@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 567d09a4-ec3c-4e53-a6b1-08da310989bf
X-MS-TrafficTypeDiagnostic: SG2PR01MB2871:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0o1QV9l8BcCWFYTUtB9Ut3yc4IdUA3w0C4n7Oi3tFV2QuWpbot6ZqXm+9LUALKEyCw98+BDZB2DseRjdArPhCnitAqkjpNND5uHdbO6NExGaAo0R13oRzFEbd2F78ToatqJnOkM7TolUnBrziAvbOeYwOUdw58PsxWfu82s8FRWfM1OOX28RCG/eR2IJpPrGKnFtCEJlHfdG7yV5SO+xN6uN86IeK/9HgsTnZkMtAm/GAaTqVC20u4KgxJAKDZDuRnWYRKdeSPsg2XGU0yp4cjpa8iL7aRLLlHVd7AnWadqwW0lxYw3PmblraG6folvpX1E2owiPdxRVPhgbtx7lHgVlrbpGRTKWQxM4k9C0qdJY+zufALhuOrAKeAV399M/6rsBDknrmbdk5z90dJ4K4Evd127MixwKC1f/R+Aw96KvLCuumpSqBX6+Z8PxI+iil61SUl2jU0uRlA15Z8vxMvoGl4/NoPaIvk2CJCsupPuI14HGPeEHu0dJuN/52RWKUAN6tuFvRUyGeq1FW6mWdVt3a7XO1JjVAeIPqcR6f4mANMB8aV6AHHkmQl/fYfrCepsYkYS2QdUOm7g9TnxvXN11kK4jFO3sE1UA0NTQVYHjTILABoyIZD9xpvzYsfby
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFBUYVJjQnNpdVgyMjE4SHNxOXNKMjM5RjBoUXpqVlZibHZsZE1RaEs3V0VX?=
 =?utf-8?B?VEFHMnN6cDQvVitNdnllTi9uaFQrZ2dMVFpwWmFvdURka3NhVldyWnpiTlFI?=
 =?utf-8?B?NEFrK3A4OFgwRFcwdHFPWkVaN1VOUDI1RXh3NU44Z1RSdzBuZWlhMlRINXgr?=
 =?utf-8?B?WXg0V2ZIanRudFZSanpscUoydCtKNkhCMkZvWXBWdllFVUxETEJQTU1CbzZF?=
 =?utf-8?B?d210RHl3aHRTdU5sTnVCbFM4eU1tblI3TGFKck9xcnI2QThZa1R6OXBYOFY3?=
 =?utf-8?B?QTA2WVF6Zk41enRyL0VNWFFORWdZenBvUVg2cG1oMnI2T01LK3VOdURUK3Qx?=
 =?utf-8?B?N1B4UlNsUlJTMVovYW1JRVlmNmx5bDZ0OHY3M1dXdDhCTy9HdVdqd2NETXJE?=
 =?utf-8?B?Ykh0MFU0LzArTGk5dnBhYkFkdHNSZDNURVJvSHQ5UE9ZeDhLQUE1T2Z3dWJi?=
 =?utf-8?B?cHY4NTl6eU5scXNycDBrWW1id3FKVzV6U3hoU1EyNnNjd2s1N1NVc01FejU5?=
 =?utf-8?B?QkZlNlZQZlk5aXJmZy9OZk4rZjlvVi9LR01VMTFRV1NSaXFBQXBCVkJkYVYx?=
 =?utf-8?B?ekZTcTZScXhKWXBhemNLVDNiSDNJaUtJQ3F5VzNYUXFUMjJ5MWxIVk4yakRZ?=
 =?utf-8?B?alRyMHRMcW8vcGZsR1ZsUW1CMnRmR3JNT2YzT3R3MXQ2OHJYQVA2ZlVkREMv?=
 =?utf-8?B?KytmM1ZydTllSmpBd1M4dyt2OEY1UkExcTladzBDQUFJRkhUSmhpWkNTTmFR?=
 =?utf-8?B?V3FwNVlmTk1qOVppd0VSdFBCRXYyam9YVVBvYmU0d09vQWowNWQ3S1JRN1Fw?=
 =?utf-8?B?THUwL0g4Mi9tZG9EcWo0eUxEMTNqNjBOQkVWckNjL3BlWGZUaEZzWXpGWlh1?=
 =?utf-8?B?Z0FWRi9WaHk4Z0hyQmI1eVd1Q2p5N0Z1b1locGtLRGVhaERGWUF1VEUrcUxN?=
 =?utf-8?B?SjBVODhCS3dxbTBkdWh5OWtZQmNEQzUyb0xocmhUTitRcm43TWJ1WUdOSVZs?=
 =?utf-8?B?alpQUitQZUZMWGJMTTErTDhrZkZmT0JSQmVkNUZzRzZJeTZLTCtHcEFTYjBq?=
 =?utf-8?B?YjJQUFkxNUtYcVZQendFTFlJTGZ3OFA5Mk9TQmU1ZURjYnJxOSsxZVg5czFm?=
 =?utf-8?B?Z0FTZU01a0JrNHl3VHcyUXZmbUVrYzhmbHhLdk5DK0I5UVhBeVgxcENJUm5V?=
 =?utf-8?B?b3hqQisxeXd4bEFKdWNzQlhVUng0QnZqelY3TjcvT2l5WElSWEdzM1hkVmJs?=
 =?utf-8?B?SkFRenZXR2JodnpoeUJKMkM4UGlDWGVNdFppSGZBOUorU1V0Rm9oODlqdXVD?=
 =?utf-8?B?ejkyQnNheGdoNXZUbFJGTTBuWEJva2ppTHJzUzZTd0Y2QThTeDN5WnNnWVZz?=
 =?utf-8?B?cys1OC9FRWF2eU5qc0RpTDVla0FDQlI1R05TMjRsd3dWcXVnK2Q1UXhvd2JH?=
 =?utf-8?B?RE5ZbWF6OVJhdzRCQVNVRGdSUXpUeGZrVzRYV2NRU2J3TENyOUJDS2VKcmNm?=
 =?utf-8?B?L2JuVHZOeUdYOEZSR0FiMGRRQ1VCZjFzWTBOeHJDZFhHTlQ1eUp5SGxTSkVv?=
 =?utf-8?B?N2M5dEhmTUVyL0dya0kvKzNYVXFLd1h3cEJMRGFLUDVKOWlmY3JlS29wcC9Y?=
 =?utf-8?B?TmhwYytKcUlqMWtnQ3JIeWFPS1FLb2Q2bkZUOGZleFlFSERYMUtWWEN1ek9K?=
 =?utf-8?B?MkhLQW1ZMnRra2cvbmxaZ3Z5UHcrVFBuVmtwd29pb1NVRzlCZjV4UTdpcWVY?=
 =?utf-8?B?M0pKZ0F4VzV6NVhxUGNBN3FsTDRXQlBQSk95all6SFRIcXpkNThwSDhPRDJs?=
 =?utf-8?B?RnJ1WG9VUVpOc1U5dEI0M0E1NlhzMUo0bmNpN3JWSXVFem9IMnhRSlJMVTJG?=
 =?utf-8?B?UE5abk9oQnBjYTlVRFVVVDljVyt4c2E3MWdSQ3FsRWJldHFLU0dkVE85cVRH?=
 =?utf-8?B?UVo1YkMveVNWSnRzSGJsMzExVGU5VVRBaU45WkE5S0ZBd1krMGJWN0lDblRP?=
 =?utf-8?B?ZFVKME42MzVBPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567d09a4-ec3c-4e53-a6b1-08da310989bf
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:43:46.3570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR01MB2871
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,FORGED_GMAIL_RCVD,
        FORGED_MUA_MOZILLA,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry for polluting the list, not sure why the cover-letter isn't
wired with the other patches..

Regards,
Hao

On 5/8/22 23:37, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Let multishot support multishot mode, currently only add accept as its
> first consumer.
> theoretical analysis:
>    1) when connections come in fast
>      - singleshot:
>                add accept sqe(userspace) --> accept inline
>                                ^                 |
>                                |-----------------|
>      - multishot:
>               add accept sqe(userspace) --> accept inline
>                                                ^     |
>                                                |--*--|
> 
>      we do accept repeatedly in * place until get EAGAIN
> 
>    2) when connections come in at a low pressure
>      similar thing like 1), we reduce a lot of userspace-kernel context
>      switch and useless vfs_poll()
> 
> 
> tests:
> Did some tests, which goes in this way:
> 
>    server    client(multiple)
>    accept    connect
>    read      write
>    write     read
>    close     close
> 
> Basically, raise up a number of clients(on same machine with server) to
> connect to the server, and then write some data to it, the server will
> write those data back to the client after it receives them, and then
> close the connection after write return. Then the client will read the
> data and then close the connection. Here I test 10000 clients connect
> one server, data size 128 bytes. And each client has a go routine for
> it, so they come to the server in short time.
> test 20 times before/after this patchset, time spent:(unit cycle, which
> is the return value of clock())
> before:
>    1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>    +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>    +1934226+1914385)/20.0 = 1927633.75
> after:
>    1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>    +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>    +1871324+1940803)/20.0 = 1894750.45
> 
> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
> 
> v1->v2:
>   - re-implement it against the reworked poll code
> 
> v2->v3:
>   - fold in code tweak and clean from Jens
>   - use io_issue_sqe rather than io_queue_sqe, since the former one
>     return the internal error back which makes more sense
>   - remove io_poll_clean() and its friends since they are not needed
> 
> v3->v4:
>   - move the accept multishot flag to the proper patch
>   - typo correction
>   - remove improperly added signed-off-by
> 
> v4->v5:
>   - address some email account issue..
> 
> 
> Hao Xu (4):
>    io_uring: add IORING_ACCEPT_MULTISHOT for accept
>    io_uring: add REQ_F_APOLL_MULTISHOT for requests
>    io_uring: let fast poll support multishot
>    io_uring: implement multishot mode for accept
> 
>   fs/io_uring.c                 | 94 +++++++++++++++++++++++++++--------
>   include/uapi/linux/io_uring.h |  5 ++
>   2 files changed, 79 insertions(+), 20 deletions(-)
> 
> 
> base-commit: 0a194603ba7ee67b4e39ec0ee5cda70a356ea618

