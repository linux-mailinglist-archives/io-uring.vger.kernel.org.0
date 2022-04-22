Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77E150C30A
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiDVWPB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiDVWOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:14:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110C22C043
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:03:31 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23MHtDP1007042;
        Fri, 22 Apr 2022 14:03:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ws2cuSS1k/6/JlTyuxokcp+/DWjQNsfkQYXZC9pq9ns=;
 b=h4kUJo+Hjq1ns36YSq/UQFpMlEXPF5KKaJdHeR877vo3eX49YA9dMwtA2uZGyQCGdjPg
 QkMQLlRelSFPH96cR2YHpx44uE6F24QS6bUScIpg/5FsuJIgpZPwS1aLbqkqfuvBFuZl
 4rPB3bc7fzrA/Jycl4z53vCcKNF30Lfsm6g= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fka36a4s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 14:03:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEulrCrcLa27qH8Q2xmO1++KjDE99W2zpAv9U65edBvGbfFFzPJCxgfbb5Eu/9AJRN+tS1m4vtx0MJl39eWMGAT6fRGaTxBQCv0iJh/9z6M0tVXIcTQpPpqiyC5gV5Fjo2FwsMKm/JrQ6zmPzPAC4VgCMuD5n3PhWeVh1JEHGSSA1r6qwePIC1PuObFDgKsJrUYFA4kfl6kZxWsR5UcuCYOcelTCjq+LmVkXR2xAQvv1FARm9g/r/6JPb3lIZMxmlsnFC+mz1acVJcxe0lBrIPiBpX1/qwHEQuImh6k1/jEsmK5a6qCF0urTaLWZ0M8TarjT28DMKM81l2J5NvC87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ws2cuSS1k/6/JlTyuxokcp+/DWjQNsfkQYXZC9pq9ns=;
 b=DxFTjelr1hkGcm/gap155NsQhRU74WhYltLpWOl1dgVy+rEU7E2QrW9ww74qj/7rR2IqAbnVhm1IlzrP1wq6vgoGcogkc8ExjNDNWNX9xpv6Q3U3KSfWH2TRi00jDszNnu1jfUyaDP1VLQ4+mCdNTbUlGedWe+8N21t+WKZnr3qxtYe4viavjpiu+/UVWHeu19GsjnGz2TBR/4YuLnwdv7gagZ4XYkg2F/FUdbwdGTkuS5e4TAoNZbmYvJP3pWfSizyIN1+buUjH2pSEcvm2DsDmN9xnRr0MKZUCfyk9J70ebOpAoXLWxeFm04SIDWQKk3PdWsbKbMZPnuEBipTTVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BL0PR1501MB2084.namprd15.prod.outlook.com (2603:10b6:207:1e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 21:03:25 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 21:03:25 +0000
Message-ID: <62ff32c8-1a93-ad92-86bc-dd6b32359ea6@fb.com>
Date:   Fri, 22 Apr 2022 14:03:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org
References: <20220420191451.2904439-1-shr@fb.com>
 <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
 <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
 <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
 <5008091b-c0c7-548b-bfd4-af33870b8886@gmail.com>
 <CGME20220421190013epcas5p45c713cd8b430f41a8e33e36c7a21fffa@epcas5p4.samsung.com>
 <7dfcf6e8-ac16-5ab1-cb71-6ef81849af82@kernel.dk>
 <20220422030918.GA20692@test-zns>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220422030918.GA20692@test-zns>
Content-Type: text/plain; charset=UTF-8
X-ClientProxiedBy: BYAPR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::26) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0a21bad-f3b7-4313-bad8-08da24a38a61
X-MS-TrafficTypeDiagnostic: BL0PR1501MB2084:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB2084D146AA2455BD9C1C4DC2D8F79@BL0PR1501MB2084.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPWj8OXoCKi4hO1B1QruYz8tXYIWWZf7XEeP5lvbkdNQIAW5zbE2HrPU7CAK1R1WN1pKwP0OxLw1kjcT2kuHJCWGk55+RK3szV7d25ke2GkAIgPTpt4sY3PxYMmxOvcJcZuaycCIWZmqHvsdVvfJpYj4U7IUeDUKNrxOc/dJXIgE3kizNP980aOmtRfS9QgVSFMUmni6FeVEhQh7gw7nXVapRjiikFD3bVGx33xTM73f9zWuge8kzEjn1IEnDrJ7V1y3Hra6Av2Zf6YVi6Tp5udTMOPoUt8RFk1KOcAxZJEKgkBfkDyJuwnT1qU3fp/MFToXeovwu9SKSWjCf01lTFPD0sXAEZS7PAZEDC5x9eFDxfhGrQQF3n4jHCYDhD3281965XR7QcPqB3nqe0eYavoBa2FRRqLfEP/QbdyY8s/GDLpvS0GT9TLeN4OJkHybq6AL7g5lDYtJUXmNI+rTc7b6gKQ7QNuogdolC1v++piEqnmzTI8QRekZL7L8gNoMIF5znjqZivAnAdXQXbruJxBewr8o5Tb9LCuZ+jjJRknwS2fZWA8neAPagTlwsrGU80YIdVWqGV8BfAwNrQI68Qu/RBmCJWuqBoB+rfqZUh/z62zr8B4T6+/iokVp8Y4hTKdLNfjiBQ/qdWSHQ0PF+tNjb9scdkcHVopannOl5V4sI5bxBDCwAw8Oitg1GaPPboyAKd/l0vLMtPx7whUxozP2bi2AmP4x9/1UD13N+ZC/YhiyP/jkdOr8JQMuykztIOD64bQ9p5YtmjOs45wCJw78Ec+zpXiJuxzzcjHEzcxA02ZMBDY1woIcyizMWO2w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6486002)(31696002)(316002)(6666004)(6512007)(6506007)(4326008)(31686004)(8676002)(2906002)(86362001)(66476007)(66556008)(66946007)(508600001)(38100700002)(8936002)(110136005)(36756003)(83380400001)(2616005)(5660300002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0w0ckZNcWVGYkZpSFJ3NXIvaVkwY3Z6TEczR1dER2RjVUU0ZHlvSk1iL05s?=
 =?utf-8?B?MVZqY01RZ2JvcC8xRG14Ui9wQVkvU3l2VnllaDRVUVQxZTJPU0pCZUlOVS83?=
 =?utf-8?B?emhKd0J5bk9jNjZjSFlhVjN4anc4R3VERnhnU09hK01PU2tIL1ZUSkk0OTNI?=
 =?utf-8?B?aS9qSlN1NTMwMDhCL3Q4UkwxVExlTmFpbVRxSVBYdXJZL2VONmVvU3BOWUxG?=
 =?utf-8?B?eFRwUHR5S29hcVRiam8rZEYvalNyQ2pLclRMRXI1bHRQaHc4bDFDUDBRQVVW?=
 =?utf-8?B?L2tWeUxOOXJ1cjhURjNSYTREd2tvNzNoUHRMYU12OVpvRCtpWEFpMUdPK1oy?=
 =?utf-8?B?UnNxRmJ1NjlSZUgvSnAzeGlNb2ZaR3pxZFJZQnBtM3FTYmNlS1FWTGlUNUpE?=
 =?utf-8?B?d2s2S3ZnVVNPS0MwQzhMRGdUVTA3cm1YbFlqaGRUTSsyT29idlcxYytBd3lt?=
 =?utf-8?B?VXdKL0UrdGRFU08vR0hySjlBckRzc0grUWRKTndvemRmUEI4WWFWT1QrejlP?=
 =?utf-8?B?SlZ2QUtGMlQ0MUxPQ05PREZwSjZLanV2TndhczByZ2Z3TGdkSVVsN3NVeDVv?=
 =?utf-8?B?bkVnemZVaVZOa1BqM0lKMnVYQTZDclE0SjZEYWVKVHVWVmFOWHJBS3VSaDJV?=
 =?utf-8?B?eGRoNTA4bXZWdHlWeXR2azVzd25PQmtDQVVLK3hZQU9DWnAwQUc2eVgwSDBB?=
 =?utf-8?B?RGlHeENoNVJ6RDR0d09Fa0ZXSHFrS2NHZmFPSFFaUCt3aDFEYWJkb3NjaDho?=
 =?utf-8?B?cTBoL2FudExuQVZvRmVGTk1SSE1lazFWbi9ZNGJhQUd3WHlXUTRNQU9HdUtv?=
 =?utf-8?B?UW5XdGV0aXNHNExvbkJ2dks2dmhnQUhucHdUOUNVeDNlMEdSZFdmVmR3RFdZ?=
 =?utf-8?B?alQwdE96ZHhPTnBhY3RYdVMxcGtmaXZOTGVVSS9adC95SG9DNVJJSHJmMmtx?=
 =?utf-8?B?aVZpanI5eDEwYW9kQjZycGFDbWpaZVpnaitoWnZYR1Yyc2thclJrOUU2eHNW?=
 =?utf-8?B?K0xDZGNKZFpOdWpmYkpsZ25kbnlKZS81bUhYcDhpVWE5RDJFVG90SE90YWRT?=
 =?utf-8?B?RjVSVk9Ob1ZXVmxPYU9HV0N4dWdZdWcxQWtkZHRQS0ovOWtKczZ0bzdobTQ5?=
 =?utf-8?B?dUNFWjFLSTk0QmwxUnZaZ2VvaHQyZjJZY0hza0VXbDFraXR2dGYyaTdySkVr?=
 =?utf-8?B?RjJwSFVMRHlhdkkwSVA4dGdGc3U2WnZ2R3pZam5IVHA4QVBaMWM1bkNESmVz?=
 =?utf-8?B?WmZrQmFRaXcyc3dNcjV1UjNtRjJVMkpnb1JDSDdWOTZZMVUzd2EvNFdiM3NO?=
 =?utf-8?B?S21vNC9iL1R2Q3Ruc3ZjUmRKUXJicUpIekZDdDM5RUhicEM3UFMwaUliOFF6?=
 =?utf-8?B?TzdWK0cwR0xHbkF1eE54Y29jMkZIYW5oeDB4U084YzAySFUxbGRRS0trRktU?=
 =?utf-8?B?Wm9qOWkrT0pXTkFNVjFKSHM3OXFibFY1OGQxUkgrYXZnM2FnTnNjMEpvSnpR?=
 =?utf-8?B?QmJETENyakJRYlBGWG5SMU5taElqUWhXWXQwVEpybWpSdG1zbTlIdmpSRlE2?=
 =?utf-8?B?cVFZOHlicmtKMyt4NVRJZG9mVHFVRmNkTTdPbWNZVXJlL3IwaVZidWRoVEdY?=
 =?utf-8?B?RTVFcHJQY1phZ01lOU5jR2FldjM0dWhDVGpUdldUd3ExSVE5c1VQSGh6eWNX?=
 =?utf-8?B?aG5ibWkvTVUzeEkxZlppdHR0TVVXY1BDSm9ZWFNjN0hROXlROG96VWtBWXBK?=
 =?utf-8?B?TzFKZXZIdGFyTWdPYXg4WVltZnZEbm5rSk1hckw1SUVMZVZndVY2VmFJc3VW?=
 =?utf-8?B?cXBhN1hFbVBQNTFqbE42aklaclBnS0tpellqdjVvRnExUi81QkFVQkdobGd5?=
 =?utf-8?B?cUZRSWo1ODJ1VFBZU3h3Q3lzczBHUjN2Z1YvUGxIUVRSR1lFNDBsVDZHNzBD?=
 =?utf-8?B?RVVGSWlqdWlaZWIwcmlWUVREaVlpdTBVV2M0T0hxOHlGZkpmdCtXWGVXSURQ?=
 =?utf-8?B?dmdCQm1IdEVXa1dDVHBWYTRwaCtmdHZKeVJsdExoQnJHMjZPVWZRWFNsTzhB?=
 =?utf-8?B?MjhjWWVNNUxPM0ZmSGRLblUwcHphM29qcm9GTi9wQWxLeURUT0Zva0hJcVhx?=
 =?utf-8?B?TERBQkNyNERZY0VXbGtrTEgyTWtpYkdKbnAxY1JHQVFPQ1RqVXo3K1JOeGpG?=
 =?utf-8?B?VHIzY21jc2JBYnZiVy93SjBYa2M3VjFEYmZZSThreVV0WHRpUnhOYWdrbnFw?=
 =?utf-8?B?aDR3NWpVUGlCOVl3dHhScE5DeGhSTkFjbjVLUW9CZFpkbHBiWitzbUlBbW82?=
 =?utf-8?B?bURZdDBuYXZTSWpIOXZrU2krZkxiYnRUQ1ZhQXdzR0FlL0ROeFdSZUx3L1dC?=
 =?utf-8?Q?EBqrANTybfdPdMDE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a21bad-f3b7-4313-bad8-08da24a38a61
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 21:03:24.9400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oS/D81m0/ICJliTHPrYtRovpEKelPr9yUcAJ8+udaEn4LyBA6ahVpQ+EPlz3CkZ+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2084
X-Proofpoint-ORIG-GUID: OZLIH3Ln9-nt5GEOa15-xvSXfyIzh3O-
X-Proofpoint-GUID: OZLIH3Ln9-nt5GEOa15-xvSXfyIzh3O-
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_06,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/21/22 8:09 PM, Kanchan Joshi wrote:
> On Thu, Apr 21, 2022 at 12:59:42PM -0600, Jens Axboe wrote:
>> On 4/21/22 12:57 PM, Pavel Begunkov wrote:
>>> On 4/21/22 19:49, Stefan Roesch wrote:
>>>> On 4/21/22 11:42 AM, Pavel Begunkov wrote:
>>>>> On 4/20/22 23:51, Jens Axboe wrote:
>>>>>> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>>>>>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>>>>>> To support the longer CQE's the allocation part is changed and when the CQE is
>>>>>>> accessed.
>>>>>>>
>>>>>>> The allocation of the large CQE's is twice as big, so the allocation size is
>>>>>>> doubled. The ring size calculation needs to take this into account.
>>>>>
>>>>> I'm missing something here, do we have a user for it apart
>>>>> from no-op requests?
>>>>>
>>>>
>>>> Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
>>>> (https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)
>>>>
>>>> They will use the large SQE and CQE support.
>>>
>>> I see, thanks for clarifying. I saw it used in passthrough
>>> patches, but it only got me more confused why it's applied
>>> aforehand separately from the io_uring-cmd and passthrough
>>
>> It's just applied to a branch so the passthrough folks have something to
>> base on, io_uring-big-sqe. It's not queued for 5.19 or anything like
>> that yet.
>>
> Thanks for putting this up.
> I am bit confused whether these (big-cqe) and big-sqe patches should
> continue be sent (to nvme list too) as part of next
> uring-cmd/passthrough series?
> 

I'll sent version 3 also to the nvme list.

> And does it make sense to squash somes patches of this series; at
> high-level there is 32b-CQE support, and no-op support.
> 
