Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88D96BD8A3
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 20:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCPTIz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 15:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjCPTIy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 15:08:54 -0400
Received: from cmx-torrgo001.bell.net (mta-tor-005.bell.net [209.71.212.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E923FB9A;
        Thu, 16 Mar 2023 12:08:47 -0700 (PDT)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [209.226.249.40]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63EA076D037F9B71
X-CM-Envelope: MS4xfLlIA33266vX+o/4HAIpSDfpB6XpBMDwbwu7Bt6uAF+CkD00FDQy1yopj/ejHq66qsNS3GcmnjXkzikgA5ytx8KLzd3PPxAeMGGfDH2SGIHITO9OifEt
 j0oiafSGqXHA9JeI0CibGvV6OrSn3Bp9vGz7942sqcOdY6eQDyXyG1ea7qBXrtd5zz0Qw4zHN8ZULrMlCA46i0K4NoymRVShExFxd81f+3qUOyrEDh95JSHT
 2iO1VPkdjnNAml1SLhJsVRlL4ezc14DF7KNgHE0xv4vqOPK15qVDMNSFm3rEZ6Y76t3lZ8NYgCG+tiY7oMX1pVLkd2wR/s2bcEofBJCc8es=
X-CM-Analysis: v=2.4 cv=M8Iulw8s c=1 sm=1 tr=0 ts=64136922
 a=qOHgmCO8ryfXM3F4aXJsSA==:117 a=qOHgmCO8ryfXM3F4aXJsSA==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=WYfWEHSwCSjVw156SGwA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (209.226.249.40) by cmx-torrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63EA076D037F9B71; Thu, 16 Mar 2023 15:08:18 -0400
Message-ID: <babf3f8e-7945-a455-5835-0343a0012161@bell.net>
Date:   Thu, 16 Mar 2023 15:08:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Helge Deller <deller@gmx.de>,
        io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-03-15 5:18 p.m., Jens Axboe wrote:
> On 3/15/23 2:38 PM, Jens Axboe wrote:
>> On 3/15/23 2:07?PM, Helge Deller wrote:
>>> On 3/15/23 21:03, Helge Deller wrote:
>>>> Hi Jens,
>>>>
>>>> Thanks for doing those fixes!
>>>>
>>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>>> One issue that became apparent when running io_uring code on parisc is
>>>>> that for data shared between the application and the kernel, we must
>>>>> ensure that it's placed correctly to avoid aliasing issues that render
>>>>> it useless.
>>>>>
>>>>> The first patch in this series is from Helge, and ensures that the
>>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>>>> there.
>>>>>
>>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>>> ring mapped provided buffers that have the kernel allocate the memory
>>>>> for them and the application mmap() it. This brings these mapped
>>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>>
>>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>>> there are others) are impact to any degree as well...
>>>> It would be interesting to find out. I'd assume that other arches,
>>>> e.g. sparc, might have similiar issues.
>>>> Have you tested your patches on other arches as well?
>>> By the way, I've now tested this series on current git head on an
>>> older parisc box (with PA8700 / PCX-W2 CPU).
>>>
>>> Results of liburing testsuite:
>>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>
> If you update your liburing git copy, switch to the ring-buf-alloc branch,
> then all of the above should work:
With master liburing branch, test/poll-race-mshot.t still crashes my rp3440:
Running test poll-race-mshot.t Bad cqe res -233
Bad cqe res -233
Bad cqe res -233

There is a total lockup with no messages of any kind.

I think the io_uring code needs to reject user supplied ring buffers that are not equivalently mapped
to the corresponding kernel pages.  Don't know if it would be possible to reallocate kernel pages so they
are equivalently mapped.

Dave

-- 
John David Anglin  dave.anglin@bell.net

