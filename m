Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E4C4CCBA5
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 03:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiCDCSw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 21:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiCDCSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 21:18:51 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4725649FAB
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 18:18:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m22so6245361pja.0
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 18:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jS+WusDimvE8zDmHWBhmi1daUh6Dhb47oS4mrHoRdro=;
        b=0pqs6A+beiJBlsgFJEFBc+lg6PvV5rcyUGAXveMfbEJO2z+Rf36ErAUqTH95WJu1Ih
         +Aku0aw7rM7/eFT+hLJpzoCQdYf2LFIAviYgpUSM+ar1eES4O2ZITOmxLMQtVAjzflUw
         T0rmvka/2PGVOCs6kl9o8rLLNIuNedeEUsYVtu8gLra2HNvvQTL99Cm+v6QmrxEXWA+w
         dCWM8aACJVTlLOPU3oOwSrG6vbDIc5hPkjbMBbJdmRZxO11hc/RfTxZnVk+UG8GYmBxu
         TDUOnlZOZD62f5SUHXstrI8/PyGxNA+8JwyfQ0LBNFEvkCG7BUH/KbsN3zvtA1Zc2zkF
         Y0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jS+WusDimvE8zDmHWBhmi1daUh6Dhb47oS4mrHoRdro=;
        b=M30Tg/0i6JoQ4nsZglrNMzJmwPHoD7fDbfsZCE9/BfoZxrW1p5gPBExtBA1MVEIvwI
         o4ivr0+jdmDBDafLa0mRvTCru2pd6KbbSctZKxuo4rCAVsbjGbOUqWdWrff1AqPu7HFO
         C0lx3h/KijiCRw2PcOhRN8qZ8PWhYTeITlbHGN98hRB3npt0+crNo07hBzBYsViNKR9E
         fcuWlzNwP+gsN2sfbFyd5SIBUaeOmWDtr0B0PKix41PQkQL3N1lyp6nMxS5k+CjvD2KK
         UK5ocBOIpkwxgjlDYNVy2wdegW1ckoiNbE4hm66qZ+pUluoEHQpyy35xESuGVWXqL3dm
         iksA==
X-Gm-Message-State: AOAM532Yv3RDlT85tH1+EtVpHJHzukcKHDOTBnfZPG5vru9fS9JhApjC
        EsGORZVlfwDns1PW80uXlKiNbhDdkXBClg==
X-Google-Smtp-Source: ABdhPJwRel0ma9V801T6mgri9MHL/gQrdsSNdvKTR+Zz67N0lCGxpifcWgokg87SPf3dtJCsRPvAIQ==
X-Received: by 2002:a17:90b:3b45:b0:1bf:275d:e3a6 with SMTP id ot5-20020a17090b3b4500b001bf275de3a6mr1008809pjb.157.1646360283561;
        Thu, 03 Mar 2022 18:18:03 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ck20-20020a17090afe1400b001bd0494a4e7sm3452666pjb.16.2022.03.03.18.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 18:18:02 -0800 (PST)
Message-ID: <bf325a86-91a4-aa70-dbda-9b12b3677a8c@kernel.dk>
Date:   Thu, 3 Mar 2022 19:18:01 -0700
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
 <559685fd-c8aa-d2d4-d659-f4b0ffc840d4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <559685fd-c8aa-d2d4-d659-f4b0ffc840d4@gmail.com>
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

On 3/3/22 6:49 PM, Pavel Begunkov wrote:
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
> 
> Is the bench single threaded (including io-wq)? Because if it
> is, get/put shouldn't do any atomics and I don't see where the
> result comes from.

Yes, it has a main thread and IO threads. Which is not uncommon, most
things are multithreaded these days...

-- 
Jens Axboe

