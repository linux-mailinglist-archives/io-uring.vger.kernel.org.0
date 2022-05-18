Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8863A52C762
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiERXTq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiERXTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:19:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B99C03A4;
        Wed, 18 May 2022 16:19:45 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6Ed3023688;
        Wed, 18 May 2022 16:19:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qwpE1qW1S9XyUAwO5/z78Btuuc80aJw22DTCElGyjMQ=;
 b=eCr1Y9KQyLimtQyaGD0MBTvuA7684B4MQALzqmP6aM4oAr/WMi3mN6njmHiXlwVQuOtc
 Wed3tB9bpQyAfC7NnZ3OqH8Xtza2uGAMH7qQY6r6XwJyUZYHrMeMwrh0mrGugW7xRigW
 yxuEL96uRRTN8mgvSit9U+m0NNL5rI/bDF4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g59tbg83f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:19:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3lwHMbtB0MK6wr5mUYfZ7+NxJ0LEW7n+yX3aLtPEZ0FSXrD+qT+wR3FF6V0+aSJrIsR5Rz58nVFGKRoMZR5Tbvv/0TZybydlerrdxQEMtbOBhD1mek7e+iUPtbQDWers9W6J06caZGdKQ4AiYj8LHD3aEp20uQZYUGeVndBKWlAXLK8xHjRRgxk7jlchzhvsGhwCVJ5VYzA3s2B279ga1ioa2bGQ13YvbKXXKNH+WFOtg9/8lkm91TbWyVJiAcOQmaly50RwfQaPkxM+bPJAS2kzYpvcNTcOYFYAQAxUFOCLjf3zAJBopyngXsFMFec5i18XTjvgnUqABpftBVhRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwpE1qW1S9XyUAwO5/z78Btuuc80aJw22DTCElGyjMQ=;
 b=j1wGALOK2dihvTlXqj5NQ/TMFoXqoUw403xSTSGK7CoAX/e4fwmVHY8u+f9X/yD+4iIn3f+ONw4oAfgdiu+4eahoGS40eTgQy6TE1h5KPsq56X5sUjTELf70tNX7gBProyqpprWmKpuEHM6/ucAcIGQtpqRWzRdSa1c4qQkbAc2IONyV/rYWWEKK4iNGtvZ3yAZ3Iiz5MJq8zd9hqGa/93rKTlCDYPCBWmDBxA7srZmZz5K83WqOFVcen9rk4YMNf5kuYr+yrKUvwEBa7Y3JEcfjptFhaQ9YTK03FnbXpu/DF5pcUEw3b8GDXaCchv+tiooXF+NP+a/75oV/l65+pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:19:38 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:19:38 +0000
Message-ID: <5189d281-4354-6c98-d2df-78e6434e6c48@fb.com>
Date:   Wed, 18 May 2022 16:19:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 04/16] iomap: add async buffered write support
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-5-shr@fb.com>
 <20220517111447.bzzmdbmx6cebnugc@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220517111447.bzzmdbmx6cebnugc@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::18) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a22a1bff-b146-4607-d9c4-08da3924e0b3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB27736E7E49C9A7B024E4B6D5D8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRaxVFGjtCTXpgAoQ6wVg1yMk5Lz8++87yXhqJZePx0hhT8rTOluOke4zFnL2YgdhjuGK89Uilf/3flnyOu16chO9LyIwt6/eZbCteqtOy54TrlcddNDrTkrMH5C51pbgCzl7vB+Bga3m/iIVvl0mlH0OjN4/pYnvYWoX6PC3mdzZk5tR6KwpUFYvymFwb5qjajAT6xdDkrftdD03MV5pOPzTykbYXBLk+XeMVVskmhzz7IqUyaGMC8M+G3IRsApJFJOP8PxO96lF+YgOpRNgIMyeTlAvGT7xr+aWdEqUiH3P69Zp/CZhGG2Pny1upDRxAi6NP1/4f39zk+UsglpL2yf1CvGM4b8Z4/QD73viWietep063LKbjKW9DUdICLKa5h9XeKD1HaPF6t7+5acWoXU48eR2iYYsHruZpEfzFyC7rmxBX38PaLxNKr52rQTEgnPIn+3rJzihkz2FqACB5b3Q3BaQUIU1RggczHhyCjzxRo3KTCzMtcNHdeyjD5Dt5HPctRA7ZX7sVH/jQsDnf4ugT2EVU0iMh3HJhDQ/MF9gjhhceJVFWJ1LmA26xkoxp4JBfPXfQQm3AcpzIDMO7uX7o5hH2sRpkADz+AYnVw3mk8jJVXEtJ3yDlbphHTE451TME9dpU9Nmcd3tQina6paV6soSCpb5YQt3SFHH1uUVJEDqeHW0nx6MCd+2owhd3hhpLZOwKrpFlPzd3i1Y1rB1syj4rKStNISRx+I1gg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(2616005)(83380400001)(38100700002)(2906002)(8936002)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(6486002)(6916009)(508600001)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ull3M0NoYWViY0VMN1FBWG9ieWwwcUhsZlZ1ZGxrWkhiUG8wTUNXdHNjbDFh?=
 =?utf-8?B?UTJIekdla1JoTmxjQUVZdTFkV0dGWWNQU1dBWWtKbTVqaXZtRCs0citLS0lu?=
 =?utf-8?B?RDFiYjhKaTEyMlhCQW9VM1BYMDRPdnozWkFYYm4vdXQzR3hacHF0K2tRb0ZY?=
 =?utf-8?B?NDFCeFAvM3NmSmFlQ1hpVllXNDU4bE1iRGZ2RCsrejYrdUNuemhnR1plR0dV?=
 =?utf-8?B?NEhNL2wwZ081dE9BVkpkWlRBYVBlKzY1bm9rWEZ5ZjZxRUUrZ2dqdU81SUtY?=
 =?utf-8?B?QVBYa09IMnAyem1WcHhaMzZKemF4N29DVmh1ekhvUjY3MnM2bVBaMlhISVpq?=
 =?utf-8?B?RE9qNGJoWEU4YXVrakZDTWEzSThrVGlaUFNaZXhSYlhtdHk1UHRzSlhzQWxU?=
 =?utf-8?B?UGJoZUE4TEpOc1VOMlBDNFBaL0lyOVAzbVpvN2E4OFd2amFCZVZCL0I4YUFK?=
 =?utf-8?B?cjFLaFRHQitmck5lOHNYRzErYlFwcUtOcGNLamZpOGpaekJXdGJHbU5DTUZH?=
 =?utf-8?B?WVpaYjNNTVhZTmV1SzNqNXFRbGRzK2VZekV2RHNoV2xtUllCbGNtbG1ERWVV?=
 =?utf-8?B?MCtCQnpjRmNSMnBpTVl3STdkRmY4dndPMlptdnNiQ0p2d0ZHT0M5aFNOenR4?=
 =?utf-8?B?R01kRlFZQm1zVE5pd0lHQlR3S041aUJndUtON04zTXV4VGtSeS9LSkllb3V2?=
 =?utf-8?B?bGZLQkRoOEk5RGRNMktNN3pMY2FSZXJQVzV0YjZzTm55dWhxdzlxNDNyaHBu?=
 =?utf-8?B?UEg4Z0RQK2xPOVRLaWVITWlDbWUvcThSZW1YV29wcVRLOVJRYm5uZWpnZW1D?=
 =?utf-8?B?eFF2N1hSSXNHWFhZSjVKek5HbE11bFc1TDhabmEzM0t0dlZnZmVLTkp3Ry90?=
 =?utf-8?B?U0ZoQ242bDVsY2xOUG42RU1jWDEyQTB0RHZRUk55S0hnelp2Njl0cjZ1UElR?=
 =?utf-8?B?a29FL2RsZFhjTmp6UXdjVElmakJ0QkJKcU9rSzlwZzkvUFI0a0EyV0czMG43?=
 =?utf-8?B?M1NjZXhFdEQrNEhMQmFPcWdIK2kxS3N4VXd2em1xdUJja3U4SGVIVW9xYTR4?=
 =?utf-8?B?ZjE0L1F5aHZxaUxwUUpnRDd1VDByNnUzOThUbmxka2dNK3lJbnYwZitUVlBa?=
 =?utf-8?B?UkNMYzNIcWdRTWhsRDBDTXhOcUlNRVhHYmlxT3EwMlFlSm9pbTlLTXNOczA4?=
 =?utf-8?B?bXVocy94K3A4eGxrODF1a2FMWGlNOTN5WXVmOHp4YzlHdTBXRndnT2tLMzdY?=
 =?utf-8?B?ZUt5eFhuZG1TZ0NZTGt6S2tqUDVJRjlkWUU0ZjE5dzNFdG9Ya0Y3K1phRzQv?=
 =?utf-8?B?UTNnaEpEZmVPeG5oN0ZXU2syZDcveUdWOEFCd3JvSVZwZGxtMDZMQWxnUVc4?=
 =?utf-8?B?RHU5ZXIyN2E4NGdwbVZGaHFCU0pqeStTU01aZUJSNENLcUVFamEwMkhzakFp?=
 =?utf-8?B?S2tSUHBhQXF6WDJoelJqZHhnVHdWWDNxeFVjcjBSbG9FQUFreS9UaTlkcXlG?=
 =?utf-8?B?Y1FDVGp2SjVBZnJMOFVRYjMxR0hZcWl6dXMrMy8rNTlHLzNZNWlKbWlyVVBj?=
 =?utf-8?B?Y3ZMZnpiRWdmZlBLS1ZwcTRoMkZQQmFCbTJSYU5sZlV5VkdjcXNlY0pFM1Jj?=
 =?utf-8?B?VDdtZWlXVUh0R1JROWRxYjNZdmQ0N09aWmpKTTJ1Z3dKNm9UbFVTcm0xL29O?=
 =?utf-8?B?Y0lpUkJlYmZBVFZFU3F6K2l5aEdjTTlBTVVTUGN6Y1JJZGl1dmNIMmJocUNv?=
 =?utf-8?B?c2lpVHJ0dVB1U3dFdi9XRlR2MFBpL2R2V0RiOEhRdng2S242Y3NsaU1wYlpX?=
 =?utf-8?B?NG80eHRJZitpNDZvMS91UU9RTHVhOHpXcG91eDU0MUh0d1lOdEZrVGF0djBo?=
 =?utf-8?B?OTVXZjlQMmliMGhrV2Q1aVFsZzBxNm9TanJXU3NuR2krZGRoOFlvL0dpWktK?=
 =?utf-8?B?b0lES2NER1MxMW5CSDVoL3d0c3dha293TDMzK1NycTVMaFovaVhqaFFCQkFR?=
 =?utf-8?B?YWJKbXpOdWZheVdHaTFNaEVGWEhNNXp0eitQYWFCMFNvMnpNa0wyRlV1dlYw?=
 =?utf-8?B?RjFLNWhjTGhEL1J4eS9CSHpuc0djbjNUNkJGYWJLOU1INEJoKzltenl0K2xP?=
 =?utf-8?B?dkd4dnVnMHgxaUNRam1zdGQwUGRSdHdxZURzWmdINmxNYThTQmNtY21KTU1I?=
 =?utf-8?B?d200NVMrVUVheVo1ZmQyMFZQRUxuSmd3UVdheGo4RUxkdTlmUmNEY3NYMmk4?=
 =?utf-8?B?RExpME82bnk2UENLcVVaNnlpRENST0tCNHpQYnJsRXFxL3p3NFF2VTc0RUFa?=
 =?utf-8?B?ZXhjcG9EbkFvdmN1QTBBcVBOUVJpWFRUcHlaeG1LZmhxS1QwRzhGdlpPVzhh?=
 =?utf-8?Q?eaNPn9/SUUATEMpc=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22a1bff-b146-4607-d9c4-08da3924e0b3
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:19:37.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHfgQ2rw2n9iNzbaLCjTU+9Eq09hIF/FI9wiLuo0SK19jWja/2LcgYzzaHoH/h5/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-ORIG-GUID: XhVh0QPqxBrMD5ScJQUCDzNftnHKHhES
X-Proofpoint-GUID: XhVh0QPqxBrMD5ScJQUCDzNftnHKHhES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/17/22 4:14 AM, Jan Kara wrote:
> On Mon 16-05-22 09:47:06, Stefan Roesch wrote:
>> This adds async buffered write support to iomap. The support is focused
>> on the changes necessary to support XFS with iomap.
>>
>> Support for other filesystems might require additional changes.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/iomap/buffered-io.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 1ffdc7078e7d..ceb3091f94c2 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -580,13 +580,20 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>>  	size_t poff, plen;
>>  	gfp_t  gfp = GFP_NOFS | __GFP_NOFAIL;
>> +	bool no_wait = (iter->flags & IOMAP_NOWAIT);
>> +
>> +	if (no_wait)
>> +		gfp = GFP_NOIO;
> 
> GFP_NOIO means that direct reclaim is still allowed. Not sure whether you
> want to enter direct reclaim from io_uring fast path because in theory that
> can still sleep. GFP_NOWAIT would be a more natural choice...

I'll change it to GFP_NOWAIT in the next version of the patch series.
> 
> 								Honza
