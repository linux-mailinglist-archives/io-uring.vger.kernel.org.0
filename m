Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2E85F54A5
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 14:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiJEMiL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Oct 2022 08:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJEMiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Oct 2022 08:38:09 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2130.outbound.protection.outlook.com [40.107.105.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452D2264E;
        Wed,  5 Oct 2022 05:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmd0CNYYpzcVoO8fdMrz90dKWbqIXD9ql2+jteia7vEjaiGx/U4RxhL0N7GvwyPn3an5tvRF4FLQtrYwUx1IOS5MTjzxmaVpDng98pXGdrulMp+B+Xx+KXhiumOCk0bykjn87TvaVM23cqe/TvGgY8ys+zDuKK1Lv65bcb/ztMgawPMUOzx24SgDeJql8lssxL1rC9gIBE8KhufQlfS9A9mgdN3TGnWR76gv1Di2747BVAJ8wDwyLbwzckoEaoF1xkY2HNX0JFD4dBCyJPpNpocMyW7ObTscARqtVbbUKPB02zA8NMgSWFwhiRPB/UNxQidyyRMl82IoR5TBndVh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iA96MKAbvh54GAlM2Q3Qjv9bAr85bueTRaCyybmVKRM=;
 b=JFlpoQNVEqqEaiMT08C879Sz53bVgvmQu8BO6oMWZhHlb5S6usyqEYZGYLCJRsIYIGRFvkr2fp/4Z2hEd6RZ6nnKNb7Ti7FdonIidtXnO/pvH1E04QTqQYX9iV4KyH9G4qqlK1ONi4KNptPRSFZMRsJBwIJ7JxO4xct7+yp973gidCLd8QxXXc1mB+GKZBi0G/okRD0Ggkuw/lLL7XTkQ6Cz2aQ8YnB4383UF6+VKmAR5Cec6i1alRFr2Wx4Qb2Ey+P59qie0nzKOK3fz6Ls/FhYmhHHEgXmBeaD3/wuuHRqhzS6tNhJ2+qnrhvVZbLSbQR4dggAhbZlrXSBZOFuKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA96MKAbvh54GAlM2Q3Qjv9bAr85bueTRaCyybmVKRM=;
 b=oQbvOZVSpTocyhttrccCQIomwudmDEYE8cMW/hz4ARHV8ip1aukcO58PSVgC+TGBBSNin/aPdpE4p3QO8UdibzoIvcRBWUY3ljoviCB7Xmmn7wp7oAtiTAJ9PMtLTSN8zbSacfB/Zun7wohV/TQyfGiKZ0R0PHjJ8qJ5z4A8pzB8CXrTOEfLKdjAm0w4izfHP7G7rn7lxk9lVIBJs8Yxnisdh2hTDX32fksV6RiaDRtHDKxyyTkFu/KrOvLSrkF7HKpvB9Osi9K/HNOpQfhBwUVHElUmaXjtOQufwZl8GW4sLLvJBMJ7MIs/BO25RXckE3INvvCaXxbWe5fs2thT7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AS8PR08MB8327.eurprd08.prod.outlook.com (2603:10a6:20b:56e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 12:38:03 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::c82b:333d:9400:dbc9]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::c82b:333d:9400:dbc9%5]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 12:38:03 +0000
Message-ID: <4011cfc9-1f7d-2dbe-fc5b-2b43b960a79f@virtuozzo.com>
Date:   Wed, 5 Oct 2022 14:38:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590>
 <CAJSP0QUQgA8Az3Kx8-6ynbWxDxaSVW3xWOPj4VBPhhUhsRYT9g@mail.gmail.com>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <CAJSP0QUQgA8Az3Kx8-6ynbWxDxaSVW3xWOPj4VBPhhUhsRYT9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::6) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AS8PR08MB8327:EE_
X-MS-Office365-Filtering-Correlation-Id: 856d918b-1d5d-4fed-697b-08daa6ce7224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KlYmY4y8RFUkwOjr83eKVpjQPLAMU5mcxaFUcbZ2o4Z+pzRCZ9sgmfEiymG6DC91g4jZsJnRa+dYJAFIXDlwG8n9lfHQsnaJeGydl2t+gH7WHq0ijMiXnh9FO4an2GK7iwxVXz9b3VBnyL/jMTuCeLRaJwbrJnBXgvKkTnoFXXJYqkCv7bmPh+tKCXgx7XCEYPFAJ8EX9443UoxRDB7DNlN0tlL7n2KjPVyiNOjUoGx4djkLxVI5X5N6756ZvLsG68ihHGwUQdfElVwatg7c3GTGvcGK3LERnVKpu2RJnTs9q+wI8KOPWrEcPPcwbHyKHvx3HnkfBsBh6b7YefNBwL8ShOdgR4CWTt4PIrMZewAyEgef1tRDarjAOgkG3EdW5G0h8OOQBcNIZh/LaK88cHcPkDmLMWjNpqwIeqguX7jrh+2jZUDU645mvpLKjKVZwhqzxmPauaJJWPC7hd3Yf1hJUZ0+L8w6nI3Lb2aEk8iw5PQqg59afFDubXmw4J3q9xmNA0na02AxgHRllYQvqDiyEjwqc0vS5up0mNKQA2pmaOf+PE4Q1iKkb5/KkhIu/Jg8kaX/sG0qqbcNG1h6Fpty9U4Fg/p/1J2wRTVK9CpkSmCIIChETVto2CQ2CeKPBFVFTcnjl9nBNBQ8AIdP2iYCHvxZHwITiXq/ngFQBCfwJfvDBoZpbZ6UwAegiCceGbShaxyPy3QGYovpRIX8Crmh46bOrb0ZuIcpBvxyJV8crVu68tn8vjHcdj0fJ8vXEVsO5Qz8QH03E1ZDFhszRVLpVwniysnHK7UM0WMTzr2zaM1G3Vw91aTzVNpbwOUCmg3Tcpyi1LUYBLmcTqZl6E9qfBOJIe8iKvM05Nlw71s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(376002)(136003)(39850400004)(451199015)(31686004)(2906002)(7416002)(5660300002)(41300700001)(8936002)(2616005)(36756003)(966005)(31696002)(478600001)(38100700002)(6506007)(86362001)(38350700002)(8676002)(54906003)(107886003)(52116002)(53546011)(66476007)(316002)(66556008)(4326008)(110136005)(6512007)(26005)(66946007)(6486002)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTNSN29WM3J6SUNmdU1jK25YYzRIQzdmdG9nNlVnV1ZnMWtKRW1CTngrVC8x?=
 =?utf-8?B?OXI2OERSSDVTNVUwS1U1V1Q3VGJjZUZ1YTlKdDNOa2VZNHJTM29TNFhmaGN0?=
 =?utf-8?B?OC9JdUhMWTB1QXhjTlRrTmpMSUxENkRYVlBpM1JWYkY5ZGRIVUZ6TlVKV1hW?=
 =?utf-8?B?K0szdE1sb1NNRnVycS9qd09SYjFmN2xYK21ROXoydVFjVWlGdXdUMUFsQzEv?=
 =?utf-8?B?TGc3QzRkbUttUUhyak5wR1FYYlFlZXYxRDFocFZpTXpESEMrSkhhclZ6cVRU?=
 =?utf-8?B?bmN0TjJqai90bkFzWkJGTGpTWThtN0RsdUpyYUlUYkVVdHlhSkx3WlFEYXhk?=
 =?utf-8?B?RVVoajdpemFock50Y1I5RlhqMmJINGdaR2drS1ltYTFnSWdiaUhrYkdnNFdu?=
 =?utf-8?B?bzNtdFE1YzBHa2tDanlyMEZkM2JEMUprYjNXNFhLNGo0U2dUK0Y4bi9Oa0NJ?=
 =?utf-8?B?QkRnT082U0czVnZqWXV6cXN4R1VIV0NycHgzVjVIRW4zMjZ2MDlXTVJRUGJW?=
 =?utf-8?B?cXU3T3k1N09IOUdNSU1ZWTgrZEJ5V0cyYTVBRVRtQSs5eCt0aEZzUEU2ZHNJ?=
 =?utf-8?B?eVBhRnZiUU55Z2YwcDRiMUNRSnRLaW43TDl0NVlDazE3VGVzN2V1TUhkUGx2?=
 =?utf-8?B?T0lhMUFMZE0rMnZDYi94cDQvamlGeFVheGpmdEdUcDVGRHRxK3BzTEcvRWV5?=
 =?utf-8?B?WUZSeVU4a2NiRVZ0YitVZmplT1dqWk1WZll0MzhZTFZ5UDJqUkdtNEdlcksx?=
 =?utf-8?B?Uk5UVmZoRXVPMkhZSTBkeHI3WUpNV0p5VlFDN1R5QzJwYnFqdXpPTlNFRzJI?=
 =?utf-8?B?azUvVFdES2NCSEVTK2FncUxlVUJtZEExUzlCbnVweHRLNWR4cFU0aUdwU0U5?=
 =?utf-8?B?Um1LNXFUZ21UL2dDUkZqZ2NlQmVqSitIVDZNUXo1RVRxVUo4bFN5L2dRb1dv?=
 =?utf-8?B?YkxxZUNuN29ITWFkb09salU2dmhjQ0ordjMrYytXQkJqLy8wZjhSKzZWK1Jx?=
 =?utf-8?B?Y1pVTVlBajVNVlIySGkyK25mRHRwNHU2UDZpZ2lKSW1veEMyTGFJQzdCQUZ3?=
 =?utf-8?B?b1ZnQXk2a1JFVlJBMTR2ODN4TXVSYkNHRDROajMyNURtb0JrSVUvS09wYkJv?=
 =?utf-8?B?NGM4TUw2T1N6V2FYaGhsU1NHY1QzNndnN2M5Y3J5WG4wZTlUaHRHV3lEYWZR?=
 =?utf-8?B?Nk9lamlNS1FJd0YyNlJUaktXa0ZjenNGTzNjQmhyYVZCT2plZjdlVFR2anlK?=
 =?utf-8?B?eDIrdWVJc2o5OE1aOVJPbHJzei9jdDdhYzhVR1gzdjA0bW5VbHQ5eTF6aXN0?=
 =?utf-8?B?S1hJRGkxYlJ3RXdCY1FxME01eE0xZnpEV2hnbnpLNStxdmJNY1B1SVgvclk4?=
 =?utf-8?B?V1pGYlRHdnBzRkpiSFBhMTRzbmJWM29FRFZCT3F0ZFhVQVZyUnhEYm5BbWFB?=
 =?utf-8?B?V29mSURpbkxXYUhOaWxNYThyQ3VJMmFiY3NzZy9SMTVnZmZFdCswdmxDeWYz?=
 =?utf-8?B?SUdGby9kTDV4NkswNnZZK1VmWlZaMExqTFIwT0tMUjN1cHM2N0FhTzluZ00x?=
 =?utf-8?B?d0UrUE9IOHdPNFBvVVVzdXRNWkVrTmJjTGNSVUw0MUdjcU5EbmRORXRuWm0z?=
 =?utf-8?B?Q2Q1NjhGNUNYdEVsbnFPVm9iemtJcVpKUnhQcTFmdXI4R2xCVHEvcVk5ejFM?=
 =?utf-8?B?bGhlOCsveXFLNXEwdk1SSmNidGJZQUNLWllVNzFwbnhsakxnZmc1TjEyMXV3?=
 =?utf-8?B?NWErdzl5cmdOS2wzWVpZMmxyTEpObEVtYXZxY0VzUzFmdlV3a25HbDdkdzU5?=
 =?utf-8?B?VjVIK3BnRVdDV0Nab0E5RTZuL1F4c3V0VFRZVzM3TldhWk9YcnY2Y2pRTldG?=
 =?utf-8?B?elZLUmlDbDB4RWE3anJ4SHlkaVpaTFhQdGJ1VGtOUmxia2l3NTl6eVczOXZv?=
 =?utf-8?B?ZDB3UEUzOGJETGhmZDc1ZjlzZXdvUzQ5OGFMdFBtbUJndk9EajBmZHNCMFMy?=
 =?utf-8?B?NCthZ1Y1aEpYV2R4T1dtRklobDl6dHE3QW1iU0VMNWQyekdYNUZsejhkTlN3?=
 =?utf-8?B?Y00yQ3dwd3JIbDhIVkZ0cnFiWWdmb1BkYmpETmZTTFRDZVFlY29KRFZyY3dp?=
 =?utf-8?Q?jVxT2nf68nmWpy0b7yf7GED45?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856d918b-1d5d-4fed-697b-08daa6ce7224
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 12:38:03.5746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+9z+7KhUjFeIP6fZHheH9AybpYr4R358ILx0EDbmBlcKIkEfH8qRYeorHW10NL2y/x4xOWUjxC7VGg68iqbCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8327
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/5/22 14:21, Stefan Hajnoczi wrote:
> On Wed, 5 Oct 2022 at 00:19, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
>>> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
>>>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
>>>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
>>>>>> ublk-qcow2 is available now.
>>>>> Cool, thanks for sharing!
>>>>>
>>>>>> So far it provides basic read/write function, and compression and snapshot
>>>>>> aren't supported yet. The target/backend implementation is completely
>>>>>> based on io_uring, and share the same io_uring with ublk IO command
>>>>>> handler, just like what ublk-loop does.
>>>>>>
>>>>>> Follows the main motivations of ublk-qcow2:
>>>>>>
>>>>>> - building one complicated target from scratch helps libublksrv APIs/functions
>>>>>>    become mature/stable more quickly, since qcow2 is complicated and needs more
>>>>>>    requirement from libublksrv compared with other simple ones(loop, null)
>>>>>>
>>>>>> - there are several attempts of implementing qcow2 driver in kernel, such as
>>>>>>    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
>>>>>>    might useful be for covering requirement in this field
>>>>>>
>>>>>> - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
>>>>>>    performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
>>>>>>    is started
>>>>>>
>>>>>> - help to abstract common building block or design pattern for writing new ublk
>>>>>>    target/backend
>>>>>>
>>>>>> So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
>>>>>> device as TEST_DEV, and kernel building workload is verified too. Also
>>>>>> soft update approach is applied in meta flushing, and meta data
>>>>>> integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
>>>>>> test, and only cluster leak is reported during this test.
>>>>>>
>>>>>> The performance data looks much better compared with qemu-nbd, see
>>>>>> details in commit log[1], README[5] and STATUS[6]. And the test covers both
>>>>>> empty image and pre-allocated image, for example of pre-allocated qcow2
>>>>>> image(8GB):
>>>>>>
>>>>>> - qemu-nbd (make test T=qcow2/002)
>>>>> Single queue?
>>>> Yeah.
>>>>
>>>>>>      randwrite(4k): jobs 1, iops 24605
>>>>>>      randread(4k): jobs 1, iops 30938
>>>>>>      randrw(4k): jobs 1, iops read 13981 write 14001
>>>>>>      rw(512k): jobs 1, iops read 724 write 728
>>>>> Please try qemu-storage-daemon's VDUSE export type as well. The
>>>>> command-line should be similar to this:
>>>>>
>>>>>    # modprobe virtio_vdpa # attaches vDPA devices to host kernel
>>>> Not found virtio_vdpa module even though I enabled all the following
>>>> options:
>>>>
>>>>          --- vDPA drivers
>>>>            <M>   vDPA device simulator core
>>>>            <M>     vDPA simulator for networking device
>>>>            <M>     vDPA simulator for block device
>>>>            <M>   VDUSE (vDPA Device in Userspace) support
>>>>            <M>   Intel IFC VF vDPA driver
>>>>            <M>   Virtio PCI bridge vDPA driver
>>>>            <M>   vDPA driver for Alibaba ENI
>>>>
>>>> BTW, my test environment is VM and the shared data is done in VM too, and
>>>> can virtio_vdpa be used inside VM?
>>> I hope Xie Yongji can help explain how to benchmark VDUSE.
>>>
>>> virtio_vdpa is available inside guests too. Please check that
>>> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
>>> drivers" menu.
>>>
>>>>>    # modprobe vduse
>>>>>    # qemu-storage-daemon \
>>>>>        --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
>>>>>        --blockdev qcow2,file=file,node-name=qcow2 \
>>>>>        --object iothread,id=iothread0 \
>>>>>        --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
>>>>>    # vdpa dev add name vduse0 mgmtdev vduse
>>>>>
>>>>> A virtio-blk device should appear and xfstests can be run on it
>>>>> (typically /dev/vda unless you already have other virtio-blk devices).
>>>>>
>>>>> Afterwards you can destroy the device using:
>>>>>
>>>>>    # vdpa dev del vduse0
>>>>>
>>>>>> - ublk-qcow2 (make test T=qcow2/022)
>>>>> There are a lot of other factors not directly related to NBD vs ublk. In
>>>>> order to get an apples-to-apples comparison with qemu-* a ublk export
>>>>> type is needed in qemu-storage-daemon. That way only the difference is
>>>>> the ublk interface and the rest of the code path is identical, making it
>>>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
>>>> Maybe not true.
>>>>
>>>> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
>>>> and so far single io_uring/pthread is for handling all qcow2 IOs and IO
>>>> command.
>>> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
>> I tried to use it via --aio=io_uring for setting up qemu-nbd, but not succeed.
>>
>>> know whether the benchmark demonstrates that ublk is faster than NBD,
>>> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
>>> whether there are miscellaneous implementation differences between
>>> ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
>>> ublk and backend IO), or something else.
>> The theory shouldn't be too complicated:
>>
>> 1) io uring passthough(pt) communication is fast than socket, and io command
>> is carried over io_uring pt commands, and should be fast than virio
>> communication too.
>>
>> 2) io uring io handling is fast than libaio which is taken in the
>> test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
>> by io_uring.
>>
>> https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
>>
>> 3) ublk uses one single io_uring to handle all io commands and qcow2
>> backend IOs, so batching handling is common, and it is easy to see
>> dozens of IOs/io commands handled in single syscall, or even more.
> I agree with the theory but theory has to be tested through
> experiments in order to validate it. We can all learn from systematic
> performance analysis - there might even be bottlenecks in ublk that
> can be solved to improve performance further.
>
>>> I'm suggesting measuring changes to just 1 variable at a time.
>>> Otherwise it's hard to reach a conclusion about the root cause of the
>>> performance difference. Let's learn why ublk-qcow2 performs well.
>> Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I built
>> qemu from the latest github tree, and finally it starts to work. And test kernel
>> is v6.0 release.
>>
>> Follows the test result, and all three devices are setup as single
>> queue, and all tests are run in single job, still done in one VM, and
>> the test images are stored on XFS/virito-scsi backed SSD.
>>
>> The 1st group tests all three block device which is backed by empty
>> qcow2 image.
>>
>> The 2nd group tests all the three block devices backed by pre-allocated
>> qcow2 image.
>>
>> Except for big sequential IO(512K), there is still not small gap between
>> vdpa-virtio-blk and ublk.
>>
>> 1. run fio on block device over empty qcow2 image
>> 1) qemu-nbd
>> running qcow2/001
>> run perf test on empty qcow2 image via nbd
>>          fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, dio, hw queues:1)...
>>          randwrite: jobs 1, iops 8549
>>          randread: jobs 1, iops 34829
>>          randrw: jobs 1, iops read 11363 write 11333
>>          rw(512k): jobs 1, iops read 590 write 597
>>
>>
>> 2) ublk-qcow2
>> running qcow2/021
>> run perf test on empty qcow2 image via ublk
>>          fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
>>          randwrite: jobs 1, iops 16086
>>          randread: jobs 1, iops 172720
>>          randrw: jobs 1, iops read 35760 write 35702
>>          rw(512k): jobs 1, iops read 1140 write 1149
>>
>> 3) vdpa-virtio-blk
>> running debug/test_dev
>> run io test on specified device
>>          fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
>>          randwrite: jobs 1, iops 8626
>>          randread: jobs 1, iops 126118
>>          randrw: jobs 1, iops read 17698 write 17665
>>          rw(512k): jobs 1, iops read 1023 write 1031
>>
>>
>> 2. run fio on block device over pre-allocated qcow2 image
>> 1) qemu-nbd
>> running qcow2/002
>> run perf test on pre-allocated qcow2 image via nbd
>>          fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, dio, hw queues:1)...
>>          randwrite: jobs 1, iops 21439
>>          randread: jobs 1, iops 30336
>>          randrw: jobs 1, iops read 11476 write 11449
>>          rw(512k): jobs 1, iops read 718 write 722
>>
>> 2) ublk-qcow2
>> running qcow2/022
>> run perf test on pre-allocated qcow2 image via ublk
>>          fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
>>          randwrite: jobs 1, iops 98757
>>          randread: jobs 1, iops 110246
>>          randrw: jobs 1, iops read 47229 write 47161
>>          rw(512k): jobs 1, iops read 1416 write 1427
>>
>> 3) vdpa-virtio-blk
>> running debug/test_dev
>> run io test on specified device
>>          fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
>>          randwrite: jobs 1, iops 47317
>>          randread: jobs 1, iops 74092
>>          randrw: jobs 1, iops read 27196 write 27234
>>          rw(512k): jobs 1, iops read 1447 write 1458
> Thanks for including VDUSE results! ublk looks great here and worth
> considering even in cases where NBD or VDUSE is already being used.
>
> Stefan
+ Andrey Zhadchenko
