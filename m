Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F0A2337D5
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 19:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgG3RmB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 13:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Rl7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 13:41:59 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BC1C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:41:59 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r12so23159575ilh.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VuTTVNzESAT1CSSZ/z+M8cDkilGs89UXI3u+a6iHoXk=;
        b=QwjL57tQIRH73wp0eQsm5T7m5tw1ZFE9vuDZ5OsajxanuDXlUbZZD9XG1Yd1DMHwT1
         sFVXHut5AgOpSzOR/i1g7YdnU+FvWf/gpipc2ad2cX6b96NuaOcccsA63HYgFVfvf6KA
         Gbq90XzMwu74AkWPRCRTouGDo98MMBqK/5UwilN8NvmNTzuaNgrn+3gKeVA8YTFcpGX9
         hJijr2aCNbEhvSvgRQW0+y3sY/Z1/1oHX0XKXcK4yhDLxKFwjGx71fxVRr/4k0uVv7l8
         vL9kV7P7Rrxt6AiIoq9nEKoCicH2uaM9visVlf9AbBxQGxI10llVDiSVzvEwWvoZGt2Z
         pTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VuTTVNzESAT1CSSZ/z+M8cDkilGs89UXI3u+a6iHoXk=;
        b=AQCtipzS2Abpt9vMMOH32MfMUqxjTtmzDGVwkaj2tlQMCePCviBMeQn17+lRlflGhb
         sLZtzQlcypAip/IX8yh2uL1M/wXznnvuo1dKRR6Kn0UN8ba18Gpc22UdyYrovtLmnn+4
         vnEBcEI3ksYCso+TuGXiKKAkKnbKqqdwbTYs1/L1+dEiqifACDwciFgnKUh4pUU+r1r1
         qVfLveFOE32MIzg7dSEHpT+fW30SUxOJalHGC7t39NFLNoqvqpbX7DXvD4SLmClQsVZv
         WISrD53Y965wCgCDGYcra5KbLmXJFkIlDkKGAsSFEVdpOx448LMYS/ldmAZ3A2pd/OnB
         wZgw==
X-Gm-Message-State: AOAM532gXQ0CxckbZI/3l5cOmaWrEmJX1uC7poq42DKK/TZ0z/q2a0P4
        9EtzwoLEtNQ306lTNogqZgqVbjfh7c4=
X-Google-Smtp-Source: ABdhPJy2lpqZYAPFIpAlGp1erFbzgutAoKII3wf6yL7XAmtIPeOoeq/dXwaqkSmB1C/qqoSCOgBmog==
X-Received: by 2002:a05:6e02:1105:: with SMTP id u5mr10881426ilk.258.1596130918389;
        Thu, 30 Jul 2020 10:41:58 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n67sm2618658ild.71.2020.07.30.10.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 10:41:57 -0700 (PDT)
Subject: Re: [PATCH 3/6] io_uring: fix racy overflow count reporting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1596123376.git.asml.silence@gmail.com>
 <ba9c998d27e8e75467b09d8a2716cf6618b7cd93.1596123376.git.asml.silence@gmail.com>
 <d2347d32-7651-b34b-a7ca-5993b49a2147@kernel.dk>
 <07b1ee0e-72d9-a202-34ac-8095628c72f8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1bd125ff-4077-fda6-1c93-04c47ebdd1cc@kernel.dk>
Date:   Thu, 30 Jul 2020 11:41:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <07b1ee0e-72d9-a202-34ac-8095628c72f8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 11:33 AM, Pavel Begunkov wrote:
> On 30/07/2020 20:18, Jens Axboe wrote:
>> On 7/30/20 9:43 AM, Pavel Begunkov wrote:
>>> All ->cq_overflow modifications should be under completion_lock,
>>> otherwise it can report a wrong number to the userspace. Fix it in
>>> io_uring_cancel_files().
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 11f4ab87e08f..6e2322525da6 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7847,10 +7847,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>>>  				clear_bit(0, &ctx->cq_check_overflow);
>>>  				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
>>>  			}
>>> -			spin_unlock_irq(&ctx->completion_lock);
>>> -
>>>  			WRITE_ONCE(ctx->rings->cq_overflow,
>>>  				atomic_inc_return(&ctx->cached_cq_overflow));
>>> +			spin_unlock_irq(&ctx->completion_lock);
>>
>> Torn writes? Not sure I see what the issue here, can you expand?
> 
> No, just off-by-one(many). E.g.
> 
> let: cached_overflow = 0;
> 
>         CPU 1                   |               CPU 2
> ====================================================================
> t = ++cached_overflow // t == 1 |
>                                 | t2 = ++cached_overflow // t2 == 2
>                                 | WRITE_ONCE(cq_overflow, t2)
> WRITE_ONCE(cq_overflow, t1) 	|
> 
> 
> So, ctx->rings->cq_overflow == 1, but ctx->cached_cq_overflow == 2.
> A minor problem and easy to fix.

Ah yes, good point.

-- 
Jens Axboe

