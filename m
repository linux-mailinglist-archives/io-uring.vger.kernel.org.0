Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A2877D675
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 00:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbjHOWwd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 18:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbjHOWwK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 18:52:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314AA1BD3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 15:52:09 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5255ce77d70so3920054a12.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 15:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692139927; x=1692744727;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tObdIAWqhNSGwAycudAoOhvDPw6msWxP+r6LmNoCwsk=;
        b=KU1kt/RS2uLKIhD410Y9ZGSiVtZDU6PSm+GnUla11QWSNQ1PmRFLSSS2r6fP06NELT
         canK5w0fb1P5DoZPNQhcm2EqtnAN/sWTm/I2Rjp+9FLIse1QYJHw9OQWuBxrM1T6728Q
         TtQsp/kgPnqISmkKjU7viHQGk6YgwezrYHUh1sTnmFpCqcjuT++PaC4TETMyy4lWr7oW
         4XfvggmXSWUfyq4cfaS4pNkJMc/h/sV0zwbs4Zyb5t7XhPk14LfD8Wc8YipORElcBCYY
         PXCwgy9wuqr/AtM2/IlEywSBvZkJu5RU0LtA09dJ1Sr9MCO99jfRwzi96Pg8g8LeV/s8
         PqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692139927; x=1692744727;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tObdIAWqhNSGwAycudAoOhvDPw6msWxP+r6LmNoCwsk=;
        b=YmIASm2Ia4du4fBcnY2yW1emjXzCwJ1kVzrQ62nPvag7dR41ksFIo8ywHkqol6SBaY
         EZBvT6iFJ6P+/ulgErEapjWWIkehadPkim3D1u3kMxhoZxdjYUr33UZrsckpkaUx3VMK
         g2fjLyz4byOLOl9ax9DBRZXg5cgGuFVvfDQMTVtqx6kiLUA/cerUkyPXhdxGqFWBcBJO
         MsaqJSY0xkp0mtbz9aNz7nmya3/e90G/TWpDi01ZioF8+P13urCSqdg89dHevL8n1o35
         6sisonGvNgv8O5XvjjlOURi0YJOOQlAmZnTno+c4X+dlQ4FyX6fSAVqVFNrj4CeMCAfc
         LG3w==
X-Gm-Message-State: AOJu0Yyz2mvgszjL+TvBffSNWs6zIyzYDLGv6tLRxGjhhinY+vkQosNa
        FG11rqF+5ThK/h/0P5GgGdOHLsQ4rio=
X-Google-Smtp-Source: AGHT+IEXjgpEzXsUXigh3zj99F9U062P4eiaw1Mcn2qyRz3q25wlSv9m5CtHFJ5mSqPPgeQpI11dnw==
X-Received: by 2002:aa7:cd59:0:b0:523:aef9:3b7b with SMTP id v25-20020aa7cd59000000b00523aef93b7bmr163691edw.4.1692139927388;
        Tue, 15 Aug 2023 15:52:07 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.132.194])
        by smtp.gmail.com with ESMTPSA id e14-20020aa7d7ce000000b005224c6b2183sm7462751eds.39.2023.08.15.15.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 15:52:07 -0700 (PDT)
Message-ID: <b91f7d43-4145-d9bb-c51b-e02ab200f56c@gmail.com>
Date:   Tue, 15 Aug 2023 23:50:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: move to using private ring references
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20230811171242.222550-1-axboe@kernel.dk>
 <20230811171242.222550-2-axboe@kernel.dk>
 <1b948d2e-c34f-6c12-cd9c-de9d42cb0fae@gmail.com>
 <8077359c-cb59-4964-8bde-f673e882dc12@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8077359c-cb59-4964-8bde-f673e882dc12@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/23 22:45, Jens Axboe wrote:
> On 8/15/23 11:45 AM, Pavel Begunkov wrote:
>> On 8/11/23 18:12, Jens Axboe wrote:
>>> io_uring currently uses percpu refcounts for the ring reference. This
>>> works fine, but exiting a ring requires an RCU grace period to lapse
>>> and this slows down ring exit quite a lot.
>>>
>>> Add a basic per-cpu counter for our references instead, and use that.
>>> This is in preparation for doing a sync wait on on any request (notably
>>> file) references on ring exit. As we're going to be waiting on ctx refs
>>> going away as well with that, the RCU grace period wait becomes a
>>> noticeable slowdown.
>>
>> How does it work?
>>
>> - What prevents io_ring_ref_maybe_done() from miscalculating and either
>> 1) firing while there are refs or
>> 2) not triggering when we put down all refs?
>> E.g. percpu_ref relies on atomic counting after switching from
>> percpu mode.
> 
> I'm open to critique of it, do you have any specific worries? The
> counters are per-cpu, and whenever the REF_DEAD_BIT is set, we sum on
> that drop. We should not be grabbing references post that, and any drop

Well, my worry is concurrent modifications and CPU caches

CPU0                  |   CPU1
queue tw // task 1    |
                       | close(ring_fd); // task 2
                       | exit_work() -> kill_refs();
execute tw            |
   handle_tw_list()    |
     get_ref()         |

Sounds like this will try to grab a ref after REF_DEAD_BIT

> will just sum the counters.

CPU0 (io-wq)               | CPU1
                            | exit_work() -> kill
io_req_complete_post()     | cancel request
   put_ref()                |   put_ref()

This one seems possible as well. Then let's say those 2
refs we're putting are the last. They both dec, but count
it to 1 because of caches => never frees the ring

I also think, if we combine these 2 scenarios, we get
concurrent put and get, which might result in UAF

>> - What contexts it can be used from? Task context only? I'll argue we
>> want to use it in [soft]irq for likes of *task_work_add().
> 
> We don't manipulate ctx refs from non-task context right now, or from
> hard/soft IRQ. On the task_work side, the request already has a
> reference to the ctx. Not sure why you'd want to add more. In any case,
> I prefer not to deal with hypotheticals, just the code we have now.

which is not enough to protect it, see [1]. Yes, I optimised it
later with [2] (which is a bit ugly and confusing), but it's not
a hypothetical.

[1] commit 9ffa13ff78a0a55df968a72d6f0ebffccee5c9f4
     io_uring: pin context while queueing deferred tw
[2] commit d73a572df24661851465c821d33c03e70e4b68e5
     io_uring: optimize local tw add ctx pinning


-- 
Pavel Begunkov
