Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C335F3A31
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 01:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJCX6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 19:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJCX6C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 19:58:02 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70100.outbound.protection.outlook.com [40.107.7.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AA62AE03;
        Mon,  3 Oct 2022 16:57:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQVQlrTGfq49zPDlMEIhrX6Sr+MKkTjNl3p5jJT+QIe9LWeLwYEcIwP98DRRj12oTamD3CsBWKm3bI9039LEmGNy4+meRXw3+azUXCIGRtZbR/X62cGCcR/lz1SIG48+Ch5CIjNBr0VMk4qFW/ljA4Jh6XcwiMXl2fTfqJiGUbs6yizZzdOguFozaQFAyyopD5iD7ZvpAKffc7vzrFn1pmMi3eEvifzF+HL6idL5JsU1Q569LAVUw3EmPkDZPfEgqimN2yQBdjDkBSyqstiPj+I7aNeYFt+26O43h7cgbl3MrmUJHdGgB6ROuWdaAkpkN9WNXHnwZHKotC2NP6QJFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24oYFCIIY7f1lMnXJe1thIBZaXHh0J67hGTR13NE+G0=;
 b=GzIuFCW5I3QJJnDujqZ5y19P4ZXbJtxCzJIAttVRHextCMaG5DxtdqUTH59eWo39WhjD+/Pd5d8gHQXGl7tJgxn9C9Npo0S7uDKcRTavi4dO+qEACjBjkb/dWQ6nsTKRxxgqs/ydfjCAEzrTDNexbvW8sU3T/zJQI9CtLbbpGQhz30mlX0ww/LXNwM+aGyB/rQgJnW/Atgy7f4cFG0lIavaWff0YUr4rFfzbFZ4qDuDnPDyXVFaS4/GQ/2LGc89z/TLS1p5GpX8qXM8d4CGTyBBfRcm8NtFxnHor94TMHqbcgxs2V8gcNOmc9Uew4PtaUNzMPtqQBIHDs+/O1QerHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24oYFCIIY7f1lMnXJe1thIBZaXHh0J67hGTR13NE+G0=;
 b=JGEm5foci57LCJIJwyy4b+hi1s941J2O2lXSMtpQ1FfqjxlB9WepBhp4ykm2oGZHzHdaKhVQQ7XdhfQQDz79xLX+ob42cKiq3nKMxq/54+JfS7fRD1y8TMhohVt34024koqGs/u7jY/izetRZ8ZkOZHaYrW36W0C203vkK4j7cRfCBpUn3z8nlD6PSFoOcQ4bKcB7wXZok/EQo0ne92qddsR+q+M3+zIf5h+M0ykwSF2uwzvjan2nd5QPgOGk+l93u7mMVCT5FPsmkt7evNJM6PLqVol3rXNvAMh42Bz6by3/PyVgAntaU8rmMyYn0W7om+RNvKjVO1UcIAaeVp67g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AS8PR08MB5943.eurprd08.prod.outlook.com (2603:10a6:20b:23e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 23:57:52 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::c82b:333d:9400:dbc9]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::c82b:333d:9400:dbc9%5]) with mapi id 15.20.5676.031; Mon, 3 Oct 2022
 23:57:52 +0000
Message-ID: <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
Date:   Tue, 4 Oct 2022 01:57:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <tom.leiming@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <Yzs9xQlVuW41TuNC@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0302CA0002.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::12) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AS8PR08MB5943:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ba94df7-c124-4dc5-6c72-08daa59b1538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c4ZrHYs2I+z0Tpxj6Ou1/13dI4X9nH5MqFf6VsZYR96jMhQ7EiurKnMq8XapApKCpjxWxevJYgFCQ99rc5TEKHQbvpWkyp9n/3H4ROETIAwnPXTt60VR0KSAqpZ95u/KW2vjQfzcYVmQpXYEDH8J0zb+ilY+prdXjUbGTGPFL926S2yuhQbV3Y7Mr3IbbrTHsQKjO39C8R2h29xFaEzUTfzu/XFaULYnWJx7o0AbCHo27Ft1ZBagKVSvxYdG9isF4Z82Qpxjo47suL2YqiRd6ujk3owHlNQ64py9WpVSIKbA0POlrwl7EEVNcU5bKLdBZfbzYrvBT8vIAcDQE96BSVgdceroBJT0ZLcSz2ai7p3S7EnHGUxBDpPBLZCz7cxnuCjQFWiPYrXvllmOW6YGatfnyZtzcp2kiVfCh2ndY1ihGwLr29dcCA02rA3oqK2ZObMAnoVGrOjqaUpmYJXX6otH5zGwpmcw1sxqpwLZT6k4+BLeeN6+kBPgJPRP32MFbE+DAtwVECbriSTSubOVZSZRA1f58X60xWQMV7MMNmSqknaAF20Si1HeNBd1qWbRqBPRfx38znFCmpxwUBlvmZUFEtsbFIwjob6j8jUkjoAn3UUQThooMqR6yLrVHYNuAQT3XFWsRujEgGdctar8D3tIteSOY3XRAkEx9yXHeOnc3PYHUwqC8NlHkIKsTA+OtX/byDduYSaYvzGrEJ0Of6g09Dy7LgYsf8XsVosl/S20XfaoQqtkWKv3gqyNgZhHgaKSL7X3v50BC2j/NZ2C5DjpbW2jOgX+ccF9Ll3KAvRyxE2qetoeRHbIbwhYgcnlAZjVNU5d+dvsLa32wfgoCUCLB2nDUlr4SBanfI2bo+SfmNkJ/QZGQDynjSJqLNYr3QQ2YpXM1m1K/51TIWuuJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39850400004)(396003)(366004)(346002)(451199015)(83380400001)(31686004)(36756003)(6506007)(86362001)(2906002)(31696002)(26005)(53546011)(6512007)(52116002)(38350700002)(38100700002)(110136005)(7416002)(66946007)(8936002)(41300700001)(66476007)(66556008)(5660300002)(4326008)(8676002)(186003)(2616005)(966005)(316002)(478600001)(6486002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGxuakY2a2pNRmtkcWI3RzJEbXdRSitHUFV3ZnhLQUVKRjAwUEZVaS9RMzlK?=
 =?utf-8?B?QzdqWWVCRkd6cTloQWk1T3d1dERRYldMamJvNHJmNFFYemhpV21oaGFXdEc2?=
 =?utf-8?B?NCtkTGFzMlduN2Y1NmprS095SXlsK2cwUG9WOTFPdlVEZ0F5UXVOY3ZVYlBV?=
 =?utf-8?B?OGIwZW5EK1dkV2Z3c2NVNWpYZTkvQ2o0eXh6QlNpSWlrOTN6WU5yYTkzTmFJ?=
 =?utf-8?B?ZXUxZVFVTnRNbjRlSDBzazhRajF1cllObW96MHpTVnZoYUE5a2tNb2hGemtF?=
 =?utf-8?B?RFRZcTBBMklwaGE0RzlVcERIeTlmdEJPSUNJN3BkZXY1TUxSeVJ6MnRjbGxr?=
 =?utf-8?B?YkU3emRKNFhEaGUzZElUMXRjdzNXT2JQRktVb2hZeDdVdGRBRDRsWTFRb1By?=
 =?utf-8?B?cDVjcGlUOUxXaHZJanpqbXJPWE80L2JmQmRmRTBVMEs3UHZlZ1J3MXhSclFl?=
 =?utf-8?B?WnZhMjRxeFA4SGtYalZpVFJWUUdyVng0R1VFWUpTWEZTLzJMRkFLcHFJc2lr?=
 =?utf-8?B?S2duTUtYRWJqMjVRZGE5emNrejVHNldkWXFaSVE5bW85STF1Z3VzOFBpOXRu?=
 =?utf-8?B?c1NrWHdNKys4eTNTVU9MVkJGRlRYZyt3L1gxTm1HM1FORmMwSitFRFpDNHJ3?=
 =?utf-8?B?N0orQzB4TEJZemxHNC81NEF6WDU2UU5QUU52a2NSY2ovbUdMbTVVYzBXREMr?=
 =?utf-8?B?dGwxQ1lSQ0hnSmRXK0R3MU8zcS9FSnBZMytFSytjSzZuSnpxMXd6MHl5NzU4?=
 =?utf-8?B?WlhPckZ6RGcyRTluSi9GOHNBT0dPbGpZNzVwZHRsdnlpWFR1ZjR1c0c4ckVD?=
 =?utf-8?B?bDF3QkFrN3c1YkJicUFMcUdaWUhzNnpqMWd0ZkRldVdNRHZEVDZkM2xUTGRL?=
 =?utf-8?B?L3NZT0lTR240d0JBOWZqZ3J6ekpUK1czd2J6MzJQL2Q0Snp0NGdFemdLTVhB?=
 =?utf-8?B?YmgweThrTHNVTlVTRmNXdUFTT0YzS0tvQUV6UmVjUVl4SmxIc3l0OUxLTEpi?=
 =?utf-8?B?czBnaDRTcTRweUhoZm9LQVFLMWYyUU1CcGhzRHpMbTFqcVNCdUxrcTJyb1hP?=
 =?utf-8?B?L1FZREpzK2JBTlNJRHc5NmVaL3drcCtvR0JGRXd2a2I1TTBIdlJPV3ZHK21J?=
 =?utf-8?B?SkF2L2NyTkp1SDZzdHgxNjVwaGpaRGFTOVBSeXNtUkIvSjZ0QVhnSHJxbUU3?=
 =?utf-8?B?cTBGQnVKWE1tMWRPMzdoYzVZTDA4NHZCa0FML0tia09WOUJDNWFQajgvS3Bq?=
 =?utf-8?B?dWV1blhIQ3l0a3ZmSmVLRmNBR2JyL2tWaWJZRjA3K1kxZzdpVzJCKzBZWTN0?=
 =?utf-8?B?dHFVb2VxSXloVjUzY2ZWRDVXUklLYmsrYmxnL0tUaEdwN0JnVDJrbGpiVEdo?=
 =?utf-8?B?NVNVMDhmdkg0UkFqNGF4cjI4VzZBb2h5aStLMXY0M1ZYdTFkWTI2K0s4K1pk?=
 =?utf-8?B?Y25QQkE2ZHpiYlYxeVgzVlJydVNzU01MTjJZemMveHNtTTRybEVxWjdlUVVX?=
 =?utf-8?B?T2hlRXRHRWpGUnU3amF4bXN6eXgvdGVNS1FYN2lYeFhFK1lGQlA1MDVSdExQ?=
 =?utf-8?B?NUNSUTFCR2NLWjgxazg4N3Nic3FlbTdkRTFvNFZaa2tHclNhMWxlZm9leXlD?=
 =?utf-8?B?RHNheWp3UzFzWE5Uc3lTZGFyNlREbms4OVI2WXVYaW50Q1RuaXptcDF3UXFP?=
 =?utf-8?B?bHMyUVlXSE9yZVQ5d2Jna21ldklnZWNhUUZ0ajZsVUxRV05scU5DNDcrYlFW?=
 =?utf-8?B?WTdObzdlMWpnWHhLWjRtanJSYXo0NC8xbElDd2xic1RDQkJlUnRURk10dWhs?=
 =?utf-8?B?bk1wOG1OWk1FTWJ2NjNJMzF1U1lDTDYvaTE0OC9JNG5DSklWWmhCVDBSdkt4?=
 =?utf-8?B?b2Zqdjh2WDB1Wlo5K3hWUzgrVFpwdk95aWNyTS9TVEZjMDhWYm9VZ1FldEV0?=
 =?utf-8?B?YW5aeXJjNmVZd2ZxTEZBSHBwMEg0RTFmV2JsNndsSDhrVlE5U01JRHdQNUNK?=
 =?utf-8?B?WmdqSkhEVk5pdEhIa1BZYk1IVjJseGk1Z0VoK0tUZ1R6NXhUT2pzNVcrOXky?=
 =?utf-8?B?N0JSTjhaOVBSVDJTNHpCTTNiUVQ5U1RFT1FYTFpVbWNzV0dQbHc1YUxPTXZ0?=
 =?utf-8?Q?DrBm/otXu5/1NGElqdfV8iD8v?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba94df7-c124-4dc5-6c72-08daa59b1538
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 23:57:52.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIwb+gYny3fXvy3+pLK5B1oFcsfMjRp6gEDVpfuOWxBHVwDBCftdJSX1cnzXsN8eMUYNK40q1Z4s2hF/NW45uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5943
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URI_DOTEDU
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/22 21:53, Stefan Hajnoczi wrote:
> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
>> ublk-qcow2 is available now.
> Cool, thanks for sharing!
yep

>> So far it provides basic read/write function, and compression and snapshot
>> aren't supported yet. The target/backend implementation is completely
>> based on io_uring, and share the same io_uring with ublk IO command
>> handler, just like what ublk-loop does.
>>
>> Follows the main motivations of ublk-qcow2:
>>
>> - building one complicated target from scratch helps libublksrv APIs/functions
>>    become mature/stable more quickly, since qcow2 is complicated and needs more
>>    requirement from libublksrv compared with other simple ones(loop, null)
>>
>> - there are several attempts of implementing qcow2 driver in kernel, such as
>>    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
>>    might useful be for covering requirement in this field
There is one important thing to keep in mind about all partly-userspace
implementations though:
* any single allocation happened in the context of the
    userspace daemon through try_to_free_pages() in
    kernel has a possibility to trigger the operation,
    which will require userspace daemon action, which
    is inside the kernel now.
* the probability of this is higher in the overcommitted
    environment

This was the main motivation of us in favor for the in-kernel
implementation.

>> - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
>>    performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
>>    is started
>>
>> - help to abstract common building block or design pattern for writing new ublk
>>    target/backend
>>
>> So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
>> device as TEST_DEV, and kernel building workload is verified too. Also
>> soft update approach is applied in meta flushing, and meta data
>> integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
>> test, and only cluster leak is reported during this test.
>>
>> The performance data looks much better compared with qemu-nbd, see
>> details in commit log[1], README[5] and STATUS[6]. And the test covers both
>> empty image and pre-allocated image, for example of pre-allocated qcow2
>> image(8GB):
>>
>> - qemu-nbd (make test T=qcow2/002)
> Single queue?
>
>> 	randwrite(4k): jobs 1, iops 24605
>> 	randread(4k): jobs 1, iops 30938
>> 	randrw(4k): jobs 1, iops read 13981 write 14001
>> 	rw(512k): jobs 1, iops read 724 write 728
> Please try qemu-storage-daemon's VDUSE export type as well. The
> command-line should be similar to this:
>
>    # modprobe virtio_vdpa # attaches vDPA devices to host kernel
>    # modprobe vduse
>    # qemu-storage-daemon \
>        --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
>        --blockdev qcow2,file=file,node-name=qcow2 \
>        --object iothread,id=iothread0 \
>        --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
>    # vdpa dev add name vduse0 mgmtdev vduse
>
> A virtio-blk device should appear and xfstests can be run on it
> (typically /dev/vda unless you already have other virtio-blk devices).
>
> Afterwards you can destroy the device using:
>
>    # vdpa dev del vduse0
but this would be anyway limited by a single thread doing AIO in
qemu-storage-daemon, I believe.


>> - ublk-qcow2 (make test T=qcow2/022)
> There are a lot of other factors not directly related to NBD vs ublk. In
> order to get an apples-to-apples comparison with qemu-* a ublk export
> type is needed in qemu-storage-daemon. That way only the difference is
> the ublk interface and the rest of the code path is identical, making it
> possible to compare NBD, VDUSE, ublk, etc more precisely.
>
> I think that comparison is interesting before comparing different qcow2
> implementations because qcow2 sits on top of too much other code. It's
> hard to know what should be accounted to configuration differences,
> implementation differences, or fundamental differences that cannot be
> overcome (this is the interesting part!).
>
>> 	randwrite(4k): jobs 1, iops 104481
>> 	randread(4k): jobs 1, iops 114937
>> 	randrw(4k): jobs 1, iops read 53630 write 53577
>> 	rw(512k): jobs 1, iops read 1412 write 1423
>>
>> Also ublk-qcow2 aligns queue's chunk_sectors limit with qcow2's cluster size,
>> which is 64KB at default, this way simplifies backend io handling, but
>> it could be increased to 512K or more proper size for improving sequential
>> IO perf, just need one coroutine to handle more than one IOs.
>>
>>
>> [1] https://github.com/ming1/ubdsrv/commit/9faabbec3a92ca83ddae92335c66eabbeff654e7
>> [2] https://upcommons.upc.edu/bitstream/handle/2099.1/9619/65757.pdf?sequence=1&isAllowed=y
>> [3] https://lwn.net/Articles/889429/
>> [4] https://lab.ks.uni-freiburg.de/projects/kernel-qcow2/repository
>> [5] https://github.com/ming1/ubdsrv/blob/master/qcow2/README.rst
>> [6] https://github.com/ming1/ubdsrv/blob/master/qcow2/STATUS.rst

interesting...

Den
