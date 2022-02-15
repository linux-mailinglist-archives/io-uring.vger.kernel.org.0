Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711304B7896
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 21:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbiBORic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 12:38:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbiBORib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 12:38:31 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175104D240;
        Tue, 15 Feb 2022 09:38:20 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21FHP7We006151;
        Tue, 15 Feb 2022 09:38:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=iD57xQ8T5fIs19Gtrefsr77g3z0aS4mYi8Ls9oTGvFk=;
 b=GPUzELGXZnRTQ4XlfAGmznGLCWTAT/DijAY1HPUD23wcowdAxdEnoard30TOIe8HnwKA
 1T/9oo9G7S/2wGMF3/OhxakzoKV6Uuj2wdrLlUb5kh8yLnZ0GJYgj7ySesUcfbpBt/Du
 7TJpIKVif6I8Dwxf/B+x4cUAriqPcYTvXpI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e825s5aar-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 09:38:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:38:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBnw50DElGc49J50GTXAGs5mTc97fEzxQQB9Xc/ymDikeABm93o8J786j3rGFmi9QW2eoZhUbWmxcI8rfezL/en1j6trovzKij/LJJHOk1Bfq27feglMmqVERKku2seI4tgpftXTqcdJtixX/N/wbLMP2Z4WidBl4s26DyT94zPNUMeffvCgSxypcVAyA6M0WCHqYAXNyacgkhpgSfobezDP2+myfRCWQtzphJft6Rzf85+9eusvAin6pX5n6RlAOTD3Fk92+4fOie5q5tKW3MZmNrEgUdhfxziYejCHXZlvK+f7hQ8aGsp5OjZ3sJkP6ljoiymWAvWaViDbR/LmOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iD57xQ8T5fIs19Gtrefsr77g3z0aS4mYi8Ls9oTGvFk=;
 b=X9/KUukF5Jenz4/36M86wTBwli224v3vQrQnOtiM81OjDYR0LXtsjOE3OyD3bjAJZN+16GtDk3uJ5MqJFtahR9FDd4i6RUuFEjz5PPiL7JxmUKgdPiwqrO5uQZAV2w5rUuk9DtykcBkhIruW+po0LRiOkda/XG+cxFEx9BH9/+25KQFExpefAi8uwzlF1QNy6IKHEuUbQVaFS/DdYLQ459rHhEwNN1U0w4vknyX6lG40Ad1k99Lat2qhGxr1sxsiUDsuCGYm7fYJsLTGqSWkGidlZBYK9c9IG8RNOxbWUxb2lDfShNA3aqtDccVR3x9d1qBC+QRy+DQpdRRG+W7OtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by BY5PR15MB3618.namprd15.prod.outlook.com (2603:10b6:a03:1b0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:38:14 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::981b:4822:be55:e113]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::981b:4822:be55:e113%5]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 17:38:14 +0000
Message-ID: <9f6a2751-41cf-6cd3-ef74-c8157af9730b@fb.com>
Date:   Tue, 15 Feb 2022 09:38:10 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v1 00/14] Support sync buffered writes for io-uring
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, <io-uring@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
 <fe10885d-78b7-a90a-01a0-60ac58d64357@linux.alibaba.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <fe10885d-78b7-a90a-01a0-60ac58d64357@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:102:1::31) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa3502bb-6675-4f55-625f-08d9f0a9f176
X-MS-TrafficTypeDiagnostic: BY5PR15MB3618:EE_
X-Microsoft-Antispam-PRVS: <BY5PR15MB3618DB9ADE293C6DA6A07258D8349@BY5PR15MB3618.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:129;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MkWUqB1fGXDtJhKpVPn/bgp7pZSHtjOR/LURkvE9SrD1jT1mEodUOh45rIz8d9/nyzlUltHn+fTUUQkWbCS6HJtG3m+9YlKjX+4cwmohG6ivB/JazIR6J0yWEuSUhcJ5bau4X1lBc3WNpdNHSdTJuztor+noHYHBqNjlSokj/3Yb5lzxQJN0DuPo7A5iZ4vAF0/q18EF8eJHnwj4IA4J+WqvfX8yEPPr1oholDmaG95XB+rMS+xzwCR1+LyM5TPIwqYsnPHgHXw/m3/M9/kj0DedH97LOSQTxfGYbBXBjOU6Wxo/spPWnSs/5rMydwBgL/l9iusOZDA/03TYOkIDCmmp8+yJDKj5z5V5Q0fXIDvcCZNpfOW+hrxoWBry8r1/SYTIdiVVrB97PJLMzkShD3e1iu07Q6GSp7GyK3gUjV6Y/0QWSn9qFRhebhTxpcQYQ1NQpvIFq7/9ecI4cRMt6ONgdBtq/RuIje7+ZaPgCZ/WWICDhMlRPcPK5vAlbKh4z8ul1H63GB3qoSPf+p622FtjHQY5L9KlcyB91VZoFqPazymaIOCzwAOh4HwcsUz4pA19OSirbmaDCdlAALxLixP0hSlT/HtHHkSJeImZTFbypR+H8x75tVtHsGc5mV747b78+AVg1WDvOmkuNj7pbbsjfO64F7fh1VAlzB3gqWrrMITc58UI6LKwLVDi5Zt1N5l8CAwZeU7n1pjN1IlscbSA1rHDdHUVRzXxB0HtrKBV9oFfzc920BDJTGGklBr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(8676002)(66946007)(6636002)(31696002)(2906002)(316002)(36756003)(86362001)(31686004)(8936002)(83380400001)(38100700002)(5660300002)(6506007)(6512007)(6666004)(2616005)(508600001)(53546011)(186003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFNEQXBubnFxQVFaQTRqajlUVXp3em00Wkc3VjVBY3hOaUxQL1lQNS9RWFNq?=
 =?utf-8?B?OUFhUUxCVnBWL2kzMjF1Mm5VNHN6YVdaTnZEajl0cVZreEppL0tUYU1HbU9D?=
 =?utf-8?B?NWZOTE83ckhaY0orRHhhakFFM3ptSEwrTG1sL1M4Uzh5UkdWTm9lNko1bHNp?=
 =?utf-8?B?TVpBcEdEc0dMcjB3MTkvamhIb3dMZ1NXaGdJVHRFU2craW44MWE0cVRmanM0?=
 =?utf-8?B?T2xVSHUwcWJickdoZHBSZFd0bjNhV0ZxMzQ1ZUN2UG0vRkdoZDJvbUkycnpK?=
 =?utf-8?B?UXJXYk9HaTdnbk9kL1RTZXE3WnlFMFYyQ0FOVXBXbFN4MGZnb0JpZUpSQkJo?=
 =?utf-8?B?bXI2R2UyamFhRmE3RVZ5L2RLbklFRUN4M1pSZXZtMDU3TmxoZjYxcjUzTEE0?=
 =?utf-8?B?eEZOcTV5TUYrdGRlTC9WeDJ6ZnN5Y2s1bEZYYms2eUFjWHkxdlIxcHcyaStE?=
 =?utf-8?B?bGEyTVA0c1FrdXk5SzNNaldBUW5XeldyUWtrMHZRV0RwU256c3ZwYmZNTHZT?=
 =?utf-8?B?YUExVmVDMllPcmhUYkkzK3NFMlZvc25ENFEydXN3RTUrZ3NEZzhNV01ERGpv?=
 =?utf-8?B?WXFnZVJxdmxJek9HT0tJNmZaNG11R0lpUVBPdVFoaHl6Y0NoSXhoZzR4dzhM?=
 =?utf-8?B?Y2wrOTBNYVljQ3dabDMrM2dUbEkydVV5YkNJWVRXOEUvK3o1MmsyNmlNSG55?=
 =?utf-8?B?TkdsUW9lK2hIOWZnWVgrU1hFa3BabHo1amhlQlFlRlR3c3JNS1RIQXFkd1ll?=
 =?utf-8?B?TFQ4VGI4WkRtUG40bzVqcitRQ2EzVkwySzZST2xwV1NxS2o1ZWlRdklWZzlU?=
 =?utf-8?B?UmNRZ0ZVYlJpNExRalhyTTltNEcwSERzTXcwOVUvT1BCMzdLQTgrR1Rnc284?=
 =?utf-8?B?TysvR0JUeGQyS1R2SnFjb0JSOGpjT29qVEV0eVFmQ3RwVURVOWpxbEpGbmNN?=
 =?utf-8?B?clp3d21PS3N3MGFQSTYwMU4ySk1uaWZWMzF6RVU4THEyTGpyMnhpY2NyY3lY?=
 =?utf-8?B?d1JteWc2YVIxRjlFZ1ZzM1lQVzRSNHE0MUc0Y0lhZnVIZmtldU00VnNBcjQv?=
 =?utf-8?B?U2wrNnFUc29LMFdFdjRPTlVJZ01pWGdLOEs0bVFONTNvUDBvS0ZRZ2JXUHRu?=
 =?utf-8?B?b1dFQUZjK1ZudFd4SmJTbEhpQnNlcmt2Kzhpamh4eDI2T0VRL0VNaFpBR2Rr?=
 =?utf-8?B?cVNnUDhiOGI5YXlWTzFJbUdxMDY1NXBaeWlnQ1VJVTR0V09pbEgydjBhOVN5?=
 =?utf-8?B?TmMxdjVRQnJjTkhiZ3pQL1M3MXYybFRjQWJEU2UrWXFDSGlHNXJ6SndTQmt6?=
 =?utf-8?B?QnJlaEovTnNOVXN6c09QU3dYSTNQMWl4ZnpLYXVvYnJ6UGcxUWZ6VEEvNDRQ?=
 =?utf-8?B?NHBNUkhoekwvV2J6U0NMaktuK0VlTFZ4Tkc0S3dPVHExV1YrTmliNkJnVHo5?=
 =?utf-8?B?cG9yMm9qVVJxaW50MDdtTGxadUtSY0g2QitPRlV2RVYxeG8zSGZ1WnVnbys3?=
 =?utf-8?B?aTRkUHFUQWJ4SXZndk9mekcwMzVGdUZVdFNwTFVRQ0U3YTVSS1Uxc28zVW1U?=
 =?utf-8?B?VExPcTZYK0NXOVdibEJyQU1pN3hjdjRGS080d3hYU1FWS1ljeTYyc25PK2xi?=
 =?utf-8?B?VjdmVHBRWnp4QUYxVHEvNHh0T2R6R0VMVm1BOEVUUEtNMlRncWNGTzVxc3I4?=
 =?utf-8?B?dFcybWRJSWlrRldkM21mYTBjbHBUb2pHNmlnUEk2dzFkVGhaS2FjOU9vRW5V?=
 =?utf-8?B?L250aTU3em9vT0ZmLzdISnQwejB6cUs4QkljYTdCbEdwWGJPaGNRREVBKy9J?=
 =?utf-8?B?S21OV3ZUMVN3UlQ3V1QycDlQSFBQWEIrM054OWxCK3VFZzRUNVhZRmxDUTM3?=
 =?utf-8?B?ZVBWc2hoN20wNXdmZmFLdUJXVGwvU2pHTWZPVlZyQk1sVXdmMWNjWGJhanhS?=
 =?utf-8?B?OVJhZ1k4TksxdENPdVZjUlFzUmlsNFBXVVBMakxnRkNNdU8vZnlqZS8rRmJk?=
 =?utf-8?B?aGxDSTNleWp5bVBqM0JCNVpzRi9VL3Mzc2VpSzNISnVmR253bXNsTFJCTjh1?=
 =?utf-8?B?dm5kNEFHcUlTbGZINXQ1NWJaVm45eCtSTTdITm5Ja1dyTnZJbXA2WDBvTDNj?=
 =?utf-8?B?NFpwUEMveW9uMDU4d3E3ZEJPZkdoYzhPQ1FSOXZncEpGU3VkcmpuME01OWQw?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3502bb-6675-4f55-625f-08d9f0a9f176
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:38:14.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8kTKQxum8JJiH2MYuZgwptXL4GD0LalulkFEkgovWAhRhCbmFs7Fki/5+qFIcts
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3618
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: aACaufvvylS2P8Bvn864rKykGgewZ-g7
X-Proofpoint-ORIG-GUID: aACaufvvylS2P8Bvn864rKykGgewZ-g7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 spamscore=0 clxscore=1011 adultscore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150101
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/14/22 7:59 PM, Hao Xu wrote:
> 在 2022/2/15 上午1:43, Stefan Roesch 写道:
>> This patch series adds support for async buffered writes. Currently
>> io-uring only supports buffered writes in the slow path, by processing
>> them in the io workers. With this patch series it is now possible to
>> support buffered writes in the fast path. To be able to use the fast
>> path the required pages must be in the page cache or they can be loaded
>> with noio. Otherwise they still get punted to the slow path.
>>
>> If a buffered write request requires more than one page, it is possible
>> that only part of the request can use the fast path, the resst will be
>> completed by the io workers.
>>
>> Support for async buffered writes:
>>    Patch 1: fs: Add flags parameter to __block_write_begin_int
>>      Add a flag parameter to the function __block_write_begin_int
>>      to allow specifying a nowait parameter.
>>         Patch 2: mm: Introduce do_generic_perform_write
>>      Introduce a new do_generic_perform_write function. The function
>>      is split off from the existing generic_perform_write() function.
>>      It allows to specify an additional flag parameter. This parameter
>>      is used to specify the nowait flag.
>>         Patch 3: mm: add noio support in filemap_get_pages
>>      This allows to allocate pages with noio, if a page for async
>>      buffered writes is not yet loaded in the page cache.
>>         Patch 4: mm: Add support for async buffered writes
>>      For async buffered writes allocate pages without blocking on the
>>      allocation.
>>
>>    Patch 5: fs: split off __alloc_page_buffers function
>>      Split off __alloc_page_buffers() function with new gfp_t parameter.
>>
>>    Patch 6: fs: split off __create_empty_buffers function
>>      Split off __create_empty_buffers() function with new gfp_t parameter.
>>
>>    Patch 7: fs: Add aop_flags parameter to create_page_buffers()
>>      Add aop_flags to create_page_buffers() function. Use atomic allocation
>>      for async buffered writes.
>>
>>    Patch 8: fs: add support for async buffered writes
>>      Return -EAGAIN instead of -ENOMEM for async buffered writes. This
>>      will cause the write request to be processed by an io worker.
>>
>>    Patch 9: io_uring: add support for async buffered writes
>>      This enables the async buffered writes for block devices in io_uring.
>>      Buffered writes are enabled for blocks that are already in the page
>>      cache or can be acquired with noio.
>>
>>    Patch 10: io_uring: Add tracepoint for short writes
>>
>> Support for write throttling of async buffered writes:
>>    Patch 11: sched: add new fields to task_struct
>>      Add two new fields to the task_struct. These fields store the
>>      deadline after which writes are no longer throttled.
>>
>>    Patch 12: mm: support write throttling for async buffered writes
>>      This changes the balance_dirty_pages function to take an additonal
>>      parameter. When nowait is specified the write throttling code no
>>      longer waits synchronously for the deadline to expire. Instead
>>      it sets the fields in task_struct. Once the deadline expires the
>>      fields are reset.
>>         Patch 13: io_uring: support write throttling for async buffered writes
>>      Adds support to io_uring for write throttling. When the writes
>>      are throttled, the write requests are added to the pending io list.
>>      Once the write throttling deadline expires, the writes are submitted.
>>      Enable async buffered write support
>>    Patch 14: fs: add flag to support async buffered writes
>>      This sets the flags that enables async buffered writes for block
>>      devices.
>>
>>
>> Testing:
>>    This patch has been tested with xfstests and fio.
>>
>>
>> Peformance results:
>>    For fio the following results have been obtained with a queue depth of
>>    1 and 4k block size (runtime 600 secs):
>>
>>                   sequential writes:
>>                   without patch                 with patch
>>    throughput:       329 Mib/s                    1032Mib/s
>>    iops:              82k                          264k
>>    slat (nsec)      2332                          3340
>>    clat (nsec)      9017                            60
>>                        CPU util%:         37%                          78%
>>
>>
>>
>>                   random writes:
>>                   without patch                 with patch
>>    throughput:       307 Mib/s                    909Mib/s
>>    iops:              76k                         227k
>>    slat (nsec)      2419                         3780
>>    clat (nsec)      9934                           59
>>
>>    CPU util%:         57%                          88%
>>
>> For an io depth of 1, the new patch improves throughput by close to 3
>> times and also the latency is considerably reduced. To achieve the same
>> or better performance with the exisiting code an io depth of 4 is required.
>>
>> Especially for mixed workloads this is a considerable improvement.
>>
>>
>>
>>
>> Stefan Roesch (14):
>>    fs: Add flags parameter to __block_write_begin_int
>>    mm: Introduce do_generic_perform_write
>>    mm: add noio support in filemap_get_pages
>>    mm: Add support for async buffered writes
>>    fs: split off __alloc_page_buffers function
>>    fs: split off __create_empty_buffers function
>>    fs: Add aop_flags parameter to create_page_buffers()
>>    fs: add support for async buffered writes
>>    io_uring: add support for async buffered writes
>>    io_uring: Add tracepoint for short writes
>>    sched: add new fields to task_struct
>>    mm: support write throttling for async buffered writes
>>    io_uring: support write throttling for async buffered writes
>>    block: enable async buffered writes for block devices.
>>
>>   block/fops.c                    |   5 +-
>>   fs/buffer.c                     | 103 ++++++++++++++++---------
>>   fs/internal.h                   |   3 +-
>>   fs/io_uring.c                   | 130 +++++++++++++++++++++++++++++---
>>   fs/iomap/buffered-io.c          |   4 +-
>>   fs/read_write.c                 |   3 +-
>>   include/linux/fs.h              |   4 +
>>   include/linux/sched.h           |   3 +
>>   include/linux/writeback.h       |   1 +
>>   include/trace/events/io_uring.h |  25 ++++++
>>   kernel/fork.c                   |   1 +
>>   mm/filemap.c                    |  34 +++++++--
>>   mm/folio-compat.c               |   4 +
>>   mm/page-writeback.c             |  54 +++++++++----
>>   14 files changed, 298 insertions(+), 76 deletions(-)
>>
>>
>> base-commit: f1baf68e1383f6ed93eb9cff2866d46562607a43
>>
> It's a little bit different between buffered read and buffered write,
> there may be block points in detail filesystems due to journal
> operations for the latter.
> 

This patch series only adds support for async buffered writes for block
devices, not filesystems.
