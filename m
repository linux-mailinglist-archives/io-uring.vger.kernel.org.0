Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4192A4CCBA6
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 03:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiCDCT4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 21:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiCDCT4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 21:19:56 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51343E5C2
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 18:19:09 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so6725887pjl.4
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 18:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=DnWkKbIgosDy7l8wQbX9bT6/GTjo/RBgH5YwF5tX11M=;
        b=ZbOlrW19qfF+/2OYN1hjOU89iTAk0u/RZhWBDlrTaLsEL16fvjrJEb0N3WQtHkXCYh
         FwYczuECVBNuZZT4nAswi7R0Ny40S0DyZO4J5MB4tJE/AOvDXdTGYTTwHtkAF2/LINnN
         fVxarAuWV629OvxzGadYCxfwCpeU3C4vyNNdblvcxDYd49AEoPplCLNDKoa+AEDpRA/1
         gjZUyaRfD/KfULIIpLRsMHfl/5/HfvHhN9bnCoSKvrhf+FWOSErHDIUZmo/pVd1ZqnxG
         MQV+aI3bk6oge7I2E421egsLss8l/lZeJnCIUZuFMpOlZpdRxQKqXTOlQUlQqa67S6Tm
         b5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DnWkKbIgosDy7l8wQbX9bT6/GTjo/RBgH5YwF5tX11M=;
        b=2TxQSF1zb5WZE6i6sO8XfOL5wuITNFcMi+BLNxo4hphxU7SZAZAYjLY/2rOwqs245V
         eZdrmqOfLZU4hkNy3TbjkEQMksJNX1ntNbUl78y69uKlGPNEqwEj4LsyiVmSr4kIpwdd
         p7jhvrWfyMSiI4XqZX8n2B8UX+yuCSegKhxG2Ycyr/LI1qkcS7BmykKtP61jpIlKXzw4
         OGNlFU2S2syuCK6xdnrWB3kkf7ehLcx2acT43oH5KcmvZxxO7ZSEpNINN0OtR6s4ShO1
         FC2aEZjjs3kde7jAXBSy+ppKJGGuRjbzng4yy4GFppkfcZoDUlWkT71wvnXnzdLx2kJ2
         XWnQ==
X-Gm-Message-State: AOAM531FPk/cSrl062V5TsUYkdxQIk33YgCZTN6E0xVxZBCpjf81LI5s
        8Aec04nqSjYzLHug8+N/CHvmOQ==
X-Google-Smtp-Source: ABdhPJw7U6qvItdPl5OnIRHLT5vQj+WihO9gqOThZnXvMVom2HAgXD+c/OcEJmE8DhZiVUCamSYV4g==
X-Received: by 2002:a17:90b:4394:b0:1bc:e369:1f2b with SMTP id in20-20020a17090b439400b001bce3691f2bmr8323655pjb.92.1646360349084;
        Thu, 03 Mar 2022 18:19:09 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y39-20020a056a00182700b004e19980d6cbsm3804798pfa.210.2022.03.03.18.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 18:19:08 -0800 (PST)
Message-ID: <69ef4007-45d6-3b15-022b-b00fc7182499@kernel.dk>
Date:   Thu, 3 Mar 2022 19:19:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <8e4ce4da-040f-70e6-8a9d-54e25c71222f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8e4ce4da-040f-70e6-8a9d-54e25c71222f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 6:52 PM, Pavel Begunkov wrote:
> On 3/3/22 16:31, Jens Axboe wrote:
>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>> The only potential oddity here is that the fd passed back is not a
>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>> that could cause some confusion even if I don't think anyone actually
>>>> does poll(2) on io_uring.
>>>
>>> Side note - the only implication here is that we then likely can't make
>>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>>> flag which tells us that the application is aware of this limitation.
>>> Though I guess close(2) might mess with that too... Hmm.
>>
>> Not sure I can find a good approach for that. Tried out your patch and
>> made some fixes:
>>
>> - Missing free on final tctx free
>> - Rename registered_files to registered_rings
>> - Fix off-by-ones in checking max registration count
>> - Use kcalloc
>> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
>> - Don't pass in tctx to io_uring_unreg_ringfd()
>> - Get rid of forward declaration for adding tctx node
>> - Get rid of extra file pointer in io_uring_enter()
>> - Fix deadlock in io_ringfd_register()
>> - Use io_uring_rsrc_update rather than add a new struct type
>>
>> Patch I ran below.
>>
>> Ran some testing here, and on my laptop, running:
>>
>> axboe@m1pro-kvm ~/g/fio (master)> t/io_uring -N1 -s1 -f0
>> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> submitter=0, tid=673
>> IOPS=6627K, IOS/call=1/1, inflight=()
>> IOPS=6995K, IOS/call=1/1, inflight=()
>> IOPS=6992K, IOS/call=1/1, inflight=()
>> IOPS=7005K, IOS/call=1/1, inflight=()
>> IOPS=6999K, IOS/call=1/1, inflight=()
>>
>> and with registered ring
>>
>> axboe@m1pro-kvm ~/g/fio (master)> t/io_uring -N1 -s1 -f1
>> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> submitter=0, tid=687
>> ring register 0
>> IOPS=7714K, IOS/call=1/1, inflight=()
>> IOPS=8030K, IOS/call=1/1, inflight=()
>> IOPS=8025K, IOS/call=1/1, inflight=()
>> IOPS=8015K, IOS/call=1/1, inflight=()
>> IOPS=8037K, IOS/call=1/1, inflight=()
>>
>> which is about a 15% improvement, pretty massive...
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ad3e0b0ab3b9..8a1f97054b71 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
> [...]
>>   static void *io_uring_validate_mmap_request(struct file *file,
>>                           loff_t pgoff, size_t sz)
>>   {
>> @@ -10191,12 +10266,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>       io_run_task_work();
>>         if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
>> -                   IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
>> +                   IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
>> +                   IORING_ENTER_REGISTERED_RING)))
>>           return -EINVAL;
>>   -    f = fdget(fd);
>> -    if (unlikely(!f.file))
>> -        return -EBADF;
>> +    if (flags & IORING_ENTER_REGISTERED_RING) {
>> +        struct io_uring_task *tctx = current->io_uring;
>> +
>> +        if (fd >= IO_RINGFD_REG_MAX || !tctx)
>> +            return -EINVAL;
>> +        f.file = tctx->registered_rings[fd];
> 
> btw, array_index_nospec(), possibly not only here.

Yeah, was thinking that earlier too in fact but forgot about it. Might
as well, though I don't think it's strictly required as it isn't a user
table.

-- 
Jens Axboe

