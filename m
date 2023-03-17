Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE49B6BED7F
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCQP5l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 11:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjCQP5k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 11:57:40 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5015E20F4
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 08:57:37 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id a13so2971142ilr.9
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 08:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679068657;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vfqe4t2ppotYns5itC6BRRHhJHYT2pBjDFGfNWmtPCs=;
        b=FaXuu9/Yu+CBgWI+17TmuzaQNZ5WyNcplR+txY++WEDogZnwaLwezMzp3G2+1raYDZ
         Y6GPt6epuKb0Ovkdj6+EO2ml9X9VdqiRPB1IGevsmRPXxA6i484z42Q+7wBhZp/qaIQs
         o82vzGykmxx/tTPo79fh6hr+SATnUnluQuuVsNuli6N01YJXmhZCcPx7ov70i0r4QcOM
         CEjEhcG4mhXyYCWI2LZlF3fdugEM8jdAEc/g4a24Jjd4XGxtMGw4g640pHo5iFOg3MA3
         Pog4YoGR96un92Jwe8e021G59+YvgWNHJDPPz6ZTg9FIToWEv539xC5q3YeMShb8NMQb
         BPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068657;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vfqe4t2ppotYns5itC6BRRHhJHYT2pBjDFGfNWmtPCs=;
        b=ZepYbaTYcs1ce/R5zipGErYi6cX6a8cgGslo1PiJkkDsVtM0Dn3cXBdjZJEup0EvsA
         BkAzDjeytPTuk8A/ZQXDagqS15TQ8R1Ni/Vf2NFjtb6hv+cVsuowSq3VqeUnvSFIGsab
         aLNc+DwYnyzDzqo6s8kGyeFR+Zly92xESmeuIItmO1Nh3921AQfHmRxoSh1KzhQAgKU3
         09SsJnopn2vAcQp44L8MIyIeJkJh9D1c6EV1lXgAtAKOO5cd+zdieyPfIAbHN6z6+dW8
         qB61KdsIFOn021lHpNgyfekef63KW6ifuV0az+2eau2Bu1dQXBUze2pecJf5nBOrMROc
         Td3A==
X-Gm-Message-State: AO0yUKWlIzULjF1xpRQ92t8PmMHV7E/p1E+nj6So818JnGSlMft1RcQZ
        f4fILYDdrjAZSPlRk5LvHNkdIA==
X-Google-Smtp-Source: AK7set9Xv4D8L0YXckSNN0ow4f/QTvzVaRR7UhMzMP15mkfy8o41+FjDuo1enmPmhEB2LxP/yktW8w==
X-Received: by 2002:a05:6e02:1ba9:b0:317:943c:2280 with SMTP id n9-20020a056e021ba900b00317943c2280mr4191270ili.0.1679068656989;
        Fri, 17 Mar 2023 08:57:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v5-20020a056e020f8500b00317b8e2c2b4sm692463ilo.39.2023.03.17.08.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 08:57:36 -0700 (PDT)
Message-ID: <f4da7453-49ef-73fb-7feb-fcca543bd37e@kernel.dk>
Date:   Fri, 17 Mar 2023 09:57:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
 <babf3f8e-7945-a455-5835-0343a0012161@bell.net>
 <29ef8d4d-6867-5987-1d2e-dd786d6c9cb7@kernel.dk>
 <42af7eb1-b44d-4836-bf72-a2b377c5cede@kernel.dk>
 <827b725a-c142-03b9-bbb3-f59ed41b3fba@kernel.dk>
 <31e9595d-691b-c87c-e38a-b369143fc946@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <31e9595d-691b-c87c-e38a-b369143fc946@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/23 9:36?AM, John David Anglin wrote:
> On 2023-03-16 10:17 p.m., Jens Axboe wrote:
>> On 3/16/23 8:09?PM, Jens Axboe wrote:
>>> On 3/16/23 1:46?PM, Jens Axboe wrote:
>>>> On 3/16/23 1:08?PM, John David Anglin wrote:
>>>>> On 2023-03-15 5:18 p.m., Jens Axboe wrote:
>>>>>> On 3/15/23 2:38?PM, Jens Axboe wrote:
>>>>>>> On 3/15/23 2:07?PM, Helge Deller wrote:
>>>>>>>> On 3/15/23 21:03, Helge Deller wrote:
>>>>>>>>> Hi Jens,
>>>>>>>>>
>>>>>>>>> Thanks for doing those fixes!
>>>>>>>>>
>>>>>>>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>>>>>>>> One issue that became apparent when running io_uring code on parisc is
>>>>>>>>>> that for data shared between the application and the kernel, we must
>>>>>>>>>> ensure that it's placed correctly to avoid aliasing issues that render
>>>>>>>>>> it useless.
>>>>>>>>>>
>>>>>>>>>> The first patch in this series is from Helge, and ensures that the
>>>>>>>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>>>>>>>>> there.
>>>>>>>>>>
>>>>>>>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>>>>>>>> ring mapped provided buffers that have the kernel allocate the memory
>>>>>>>>>> for them and the application mmap() it. This brings these mapped
>>>>>>>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>>>>>>>
>>>>>>>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>>>>>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>>>>>>>> there are others) are impact to any degree as well...
>>>>>>>>> It would be interesting to find out. I'd assume that other arches,
>>>>>>>>> e.g. sparc, might have similiar issues.
>>>>>>>>> Have you tested your patches on other arches as well?
>>>>>>>> By the way, I've now tested this series on current git head on an
>>>>>>>> older parisc box (with PA8700 / PCX-W2 CPU).
>>>>>>>>
>>>>>>>> Results of liburing testsuite:
>>>>>>>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>>>>>>>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>
>>>>>> If you update your liburing git copy, switch to the ring-buf-alloc branch,
>>>>>> then all of the above should work:
>>>>> With master liburing branch, test/poll-race-mshot.t still crashes my rp3440:
>>>>> Running test poll-race-mshot.t Bad cqe res -233
>>>>> Bad cqe res -233
>>>>> Bad cqe res -233
>>>>>
>>>>> There is a total lockup with no messages of any kind.
>>>>>
>>>>> I think the io_uring code needs to reject user supplied ring buffers that are not equivalently mapped
>>>>> to the corresponding kernel pages.  Don't know if it would be possible to reallocate kernel pages so they
>>>>> are equivalently mapped.
>>>> We can do that, you'd just want to add that check in io_pin_pbuf_ring()
>>>> when the pages have been mapped AND we're on an arch that has those
>>>> kinds of requirements. Maybe something like the below, totally
>>>> untested...
>>>>
>>>> I am puzzled where the crash is coming from, though. It should just hit
>>>> the -ENOBUFS case as it can't find a buffer, and that'd terminate that
>>>> request. Which does seem to be what is happening above, that is really
>>>> no different than an attempt to read/receive from a buffer group that
>>>> has no buffers available. So a bit puzzling on what makes your kernel
>>>> crash after that has happened, as we do have generic test cases that
>>>> exercise that explicitly.
>>>>
>>>>
>>>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>>>> index cd1d9dddf58e..73f290aca7f1 100644
>>>> --- a/io_uring/kbuf.c
>>>> +++ b/io_uring/kbuf.c
>>>> @@ -491,6 +491,15 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
>>>>           return PTR_ERR(pages);
>>>>         br = page_address(pages[0]);
>>>> +#ifdef SHM_COLOUR
>>>> +    if ((reg->ring_addr & (unsigned long) br) & SHM_COLOUR) {
>>> & (SHM_COLOUR - 1)) {
>>>
>>> of course...
>> Full version, I think this should do the right thing. If the kernel and
>> app side isn't aligned on the same SHM_COLOUR boundary, we'll return
>> -EINVAL rather than setup the ring.
>>
>> For the ring-buf-alloc branch, this is handled automatically. But we
>> should, as you mentioned, ensure that the kernel doesn't allow setting
>> something up that will not work.
>>
>> Note that this is still NOT related to your hang, I honestly have no
>> idea what that could be. Unfortunately parisc doesn't have a lot of
>> debugging aids for this... Could even be a generic kernel issue. I
>> looked up your rp3440, and it sounds like we have basically the same
>> setup. I'm running a dual socket PA8900 at 1GHz.
> With this change, test/poll-race-mshot.t no longer crashes my rp34404.
> 
> Results on master are:
> Tests timed out (2): <a4c0b3decb33.t> <send-zerocopy.t>

Take too long on your system.. Would work with bigger timeout.

> Tests failed (1): <fd-pass.t>

This one is missing a patch that'll go upstream today, and it's testing
for it and hence failing.

> Running test buf-ring.t 0 sec [0]
> Running test poll-race-mshot.t Skipped
> 
> Results on ring-buf-alloc are:
> Tests timed out (2): <a4c0b3decb33.t> <send-zerocopy.t>
> Tests failed (2): <buf-ring.t> <fd-pass.t>
> 
> Running test buf-ring.t register buf ring failed -22
> test_full_page_reg failed
> Test buf-ring.t failed with ret 1

The buf-ring failure with the patch from my previous message is because
it manually tries to set up a ring with an address that won't work. The
test case itself never uses the ring, it's just a basic
register/unregister test. So would just need updating if that patch goes
in to pass on hppa, there's nothing inherently wrong here.

> Running test poll-race-mshot.t 4 sec
> 
> Without the change, the test/poll-race-mshot.t test causes HPMCs on my rp3440 (two processors).
> The front status LED turns red and the event is logged in the hardware system log.  I looked at where
> the HPMC occurred but the locations were unrelated to io_uring.
> 
> I tried running the test under strace.  With output to console, the test doesn't cause a crash and it more
> or less exits normally (need ^C to kill one process).  With output to file, system crashes and file is empty
> on reboot.
> 
> fd-pass.t fail is new.
> 
> I don't think buf-ring.t and send_recvmsg.t actually pass on master with change.  Tests probably need
> updating.
> 
> The "Bad cqe res -233" messages are gone?

Those happened because we filled the buffers on the user side, but the
kernel side didn't see them due to the aliasing issue. Which means that
ring provided buffers now work.

-- 
Jens Axboe

