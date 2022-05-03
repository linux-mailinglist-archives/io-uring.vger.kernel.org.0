Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1351864B
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 16:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiECOSC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 10:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiECOSA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 10:18:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECBA18370;
        Tue,  3 May 2022 07:14:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k126so6567070wme.2;
        Tue, 03 May 2022 07:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UA5RI3XfypUIvddp9SAnxnP9knRMKrmXbjzDsquLbw8=;
        b=FosDc6/Dxy/gMuy59Wp0su9qryFg1d6U2vtMlCbE7PVTNVrs6Kiq2L6MRruQ71J6Yp
         hFnGGJrxeKghf7IRhhCwREp1/kd8D3rpMA7jPTsdVCCz64L8NlF1F8TRQznCoVRktBl8
         6shjVDrLkYurkVp0mhQEj331n80otrxEvw31ymnu0Ugl306CuBZCrMPZ2ob1+UFYqRTa
         BrS/Qbbdu02cDOtBCyx1dt3HBGTTs17rHGbZQkvgHJPtOkaZEEcG3rsl9gMFzhkRJEcy
         o6HJp68TD2Y79scDiENXEa+0OI201XK3sVGWsn8S7TbdS9O6IdgqBGtaY82QMd2stetJ
         zvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UA5RI3XfypUIvddp9SAnxnP9knRMKrmXbjzDsquLbw8=;
        b=6QGpMVhhfsgyDf16ricqEQne60LPZx+fIvt9TlMki/jqrKsVK193sZ0vaCMM7w8ZtD
         kr6ZKhKmMZyvEoPRJ4ziLkrv108L6QsOCVXUlL46t6zRMuoRTsgr03YPmatrK/66tT7K
         bkRFInLGEbvutaQ2R/8dA3pZX1ZjYSTevA19mHjaHiKsLkkMFYVZ4FVT3/1zu10ArUhN
         KyzkPw8VzSsPiZBA86KbQOTgTxo8K7OLZMowMG0x9snJti9GdSUPnA/n5+0bRzo7APAe
         nBxjL+/t7RYCPM+FL9asCLRsfBiAdIRmQP8p/nlQ7eBIc4Swsmcc/SCNPNCIafHu/EEB
         JE+w==
X-Gm-Message-State: AOAM5331alyW5Texa91bGivFMkmIT59G5X4vWr9Wyp1n7C5METikgSEs
        MKd6FRD/n2nFK875uxq/8fSmyc1lcTU=
X-Google-Smtp-Source: ABdhPJz4co/6BRz6V7CCbpc3x2L0s3OKoXIhGhuSrZUp7OK3lHUWSPYPXvMdYgxD5q5S2A9cPx3iJA==
X-Received: by 2002:a05:600c:4f10:b0:394:34d5:f85d with SMTP id l16-20020a05600c4f1000b0039434d5f85dmr3515874wmq.103.1651587266588;
        Tue, 03 May 2022 07:14:26 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.235.73])
        by smtp.gmail.com with ESMTPSA id h25-20020a7bc939000000b003942a244ee8sm1707419wml.45.2022.05.03.07.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 07:14:26 -0700 (PDT)
Message-ID: <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
Date:   Tue, 3 May 2022 15:14:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Daniel Harding <dharding@living180.net>,
        Jens Axboe <axboe@kernel.dk>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/22 08:37, Daniel Harding wrote:
> [Resend with a smaller trace]
> 
> On 5/3/22 02:14, Pavel Begunkov wrote:
>> On 5/2/22 19:49, Daniel Harding wrote:
>>> On 5/2/22 20:40, Pavel Begunkov wrote:
>>>> On 5/2/22 18:00, Jens Axboe wrote:
>>>>> On 5/2/22 7:59 AM, Jens Axboe wrote:
>>>>>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>>>>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>>>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
>>>>>>>>> very lightly modified version of Fedora's generic kernel config. After
>>>>>>>>> moving from the 5.16.x series to the 5.17.x kernel series, I started
>>>>>>>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
>>>>>>>>> time, but definitely more than 50% of the time. Bisecting narrowed
>>>>>>>>> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>>>>>> io_uring: poll rework. Testing indicates the problem is still present
>>>>>>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>>>>>>> codebases of either lxc or io-uring to try to debug the problem
>>>>>>>>> further on my own, but I can easily apply patches to any of the
>>>>>>>>> involved components (lxc, liburing, kernel) and rebuild for testing or
>>>>>>>>> validation.  I am also happy to provide any further information that
>>>>>>>>> would be helpful with reproducing or debugging the problem.
>>>>>>>> Do you have a recipe to reproduce the hang? That would make it
>>>>>>>> significantly easier to figure out.
>>>>>>>
>>>>>>> I can reproduce it with just the following:
>>>>>>>
>>>>>>>      sudo lxc-create --n lxc-test --template download --bdev dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic -a amd64
>>>>>>>      sudo lxc-start -n lxc-test
>>>>>>>      sudo lxc-stop -n lxc-test
>>>>>>>
>>>>>>> The lxc-stop command never exits and the container continues running.
>>>>>>> If that isn't sufficient to reproduce, please let me know.
>>>>>>
>>>>>> Thanks, that's useful! I'm at a conference this week and hence have
>>>>>> limited amount of time to debug, hopefully Pavel has time to take a look
>>>>>> at this.
>>>>>
>>>>> Didn't manage to reproduce. Can you try, on both the good and bad
>>>>> kernel, to do:
>>>>
>>>> Same here, it doesn't reproduce for me
>>> OK, sorry it wasn't something simple.
>>>> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>>>>
>>>>> run lxc-stop
>>>>>
>>>>> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
>>>>>
>>>>> so we can see what's going on? Looking at the source, lxc is just using
>>>>> plain POLL_ADD, so I'm guessing it's not getting a notification when it
>>>>> expects to, or it's POLL_REMOVE not doing its job. If we have a trace
>>>>> from both a working and broken kernel, that might shed some light on it.
>>> It's late in my timezone, but I'll try to work on getting those traces tomorrow.
>>
>> I think I got it, I've attached a trace.
>>
>> What's interesting is that it issues a multi shot poll but I don't
>> see any kind of cancellation, neither cancel requests nor task/ring
>> exit. Perhaps have to go look at lxc to see how it's supposed
>> to work
> 
> Yes, that looks exactly like my bad trace.  I've attached good trace (captured with linux-5.16.19) and a bad trace (captured with linux-5.17.5).  These are the differences I noticed with just a visual scan:
> 
> * Both traces have three io_uring_submit_sqe calls at the very beginning, but in the good trace, there are further io_uring_submit_sqe calls throughout the trace, while in the bad trace, there are none.
> * The good trace uses a mask of c3 for io_uring_task_add much more often than the bad trace:  the bad trace uses a mask of c3 only for the very last call to io_uring_task_add, but a mask of 41 for the other calls.
> * In the good trace, many of the io_uring_complete calls have a result of 195, while in the bad trace, they all have a result of 1.
> 
> I don't know whether any of those things are significant or not, but that's what jumped out at me.
> 
> I have also attached a copy of the script I used to generate the traces.  If there is anything further I can to do help debug, please let me know.

Good observations! thanks for traces.

It sounds like multi-shot poll requests were getting downgraded
to one-shot, which is a valid behaviour and was so because we
didn't fully support some cases. If that's the reason, than
the userspace/lxc is misusing the ABI. At least, that's the
working hypothesis for now, need to check lxc.

-- 
Pavel Begunkov
