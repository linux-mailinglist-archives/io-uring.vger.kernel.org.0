Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A629F613E0F
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 20:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJaTNP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 15:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJaTNO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 15:13:14 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5443101D4
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 12:13:12 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 192so11504013pfx.5
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 12:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mo5788nFvm+82Wn/IlwYL276eqqg/SuCApVO5yd7Xnw=;
        b=XLCFYTa6vixcJzsMHSbgGlLzlGBdXbaLMiuwItOJIAj/EYzsUsNu+7WYtr3J4ekQZh
         mMCD8DVI4RiWfrRncoMZIIKvLzYvMXf+9JagrIarlPlkWIZU9bLO89LevoKVZTZGyrWB
         /f+v6nc5KGjV809UPrSvXubn+q2rQ0mzvmUjyR7HubXPxyVq0d678T7KpiNRFHPqF13O
         fBvoMN/Tnc1QyKzOgAFrvpEA5SbUrx+Z3OftD6wFHpRTUf97Iqb2AO6r3nLwMS93OnLn
         ynYTYMv/pW1Cfo8fkyt0ZEYaMG5C3ogSQcvq1oX0F50acMloTnniA86bZ63yHg1/8Q26
         mQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mo5788nFvm+82Wn/IlwYL276eqqg/SuCApVO5yd7Xnw=;
        b=r8IDw1WksJi+r1EgBnRXM7+Ym84//K7AfDaA1b5fLE6Qdjt6XTgUVkWsInyN7JdKF0
         lkZa7zn1hm2FaUVE27uMdOa3VghYdtGAZT4qYGNk6VQkrRlNl9ZZCPWhCe2meYOCXCkZ
         L21myf3WvjgCDCJwLnfy9vc1VIBwY1xfBdEwUxiWQ0btPI8PpM29x3g8Q4SeK8vgbc41
         7sePMBthcfzcCApL8kvE4Texd47d/BgRFA8UAUiSDncqmRA4LiDLZFoYEV7BAhAr/69c
         VG6S4gUE0ml8CAgbw2BbVk5iM2Ruls2R3i/oYBm6eXCKbCIPI/bGaB8AHQgdaCwSVGFt
         DnBA==
X-Gm-Message-State: ACrzQf22CtF1TxmGX9HjS4ew48DT0/Tv5gYJC9JZ4VfCx22K61x6Q9vy
        7SjRKVvoJ0tCcMkglrSLRn6Feg==
X-Google-Smtp-Source: AMsMyM6SGxga90kw1lyST6O4OdB1Jyyv4oP3QdstG39ILdiroTYmQRux4+ZBz6IGf0w+3cJSsZYq5Q==
X-Received: by 2002:a63:d34c:0:b0:462:589b:b27e with SMTP id u12-20020a63d34c000000b00462589bb27emr14198689pgi.418.1667243592013;
        Mon, 31 Oct 2022 12:13:12 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id oj5-20020a17090b4d8500b0020ae09e9724sm4539673pjb.53.2022.10.31.12.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 12:13:11 -0700 (PDT)
Message-ID: <babb9c9a-cba6-fdb1-93ad-a7339c921ecb@kernel.dk>
Date:   Mon, 31 Oct 2022 13:13:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-next 04/12] io_uring: reschedule retargeting at
 shutdown of ring
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Cc:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-5-dylany@meta.com>
 <83a1653e-a593-ec0e-eb0d-7850d1a0c694@kernel.dk>
 <e56548935adffbbe3ee19a0701a25ee5fb97a79b.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e56548935adffbbe3ee19a0701a25ee5fb97a79b.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 10:44 AM, Dylan Yudaken wrote:
> On Mon, 2022-10-31 at 10:02 -0600, Jens Axboe wrote:
>> On 10/31/22 7:41 AM, Dylan Yudaken wrote:
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 8d0d40713a63..40b37899e943 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -248,12 +248,20 @@ static unsigned int
>>> io_rsrc_retarget_table(struct io_ring_ctx *ctx,
>>>         return refs;
>>>  }
>>>  
>>> -static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx)
>>> +static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx,
>>> bool delay)
>>>         __must_hold(&ctx->uring_lock)
>>>  {
>>> -       percpu_ref_get(&ctx->refs);
>>> -       mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, 60 *
>>> HZ);
>>> -       ctx->rsrc_retarget_scheduled = true;
>>> +       unsigned long del;
>>> +
>>> +       if (delay)
>>> +               del = 60 * HZ;
>>> +       else
>>> +               del = 0;
>>> +
>>> +       if (likely(!mod_delayed_work(system_wq, &ctx-
>>>> rsrc_retarget_work, del))) {
>>> +               percpu_ref_get(&ctx->refs);
>>> +               ctx->rsrc_retarget_scheduled = true;
>>> +       }
>>>  }
>>
>> What happens for del == 0 and the work running ala:
>>
>> CPU 0                           CPU 1
>> mod_delayed_work(.., 0);
>>                                 delayed_work runs
>>                                         put ctx
>> percpu_ref_get(ctx)
> 
> The work takes the lock before put(ctx), and CPU 0 only releases the
> lock after calling get(ctx) so it should be ok.

But io_ring_ctx_ref_free() would've run at that point? Maybe I'm
missing something...

In any case, would be saner to always grab that ref first. Or at
least have a proper comment as to why it's safe, because it looks
iffy.

>> Also I think that likely() needs to get dropped.
>>
> 
> It's not a big thing, but the only time it will be enqueued is on ring
> shutdown if there is an outstanding enqueue. Other times it will not
> get double enqueued as it is protected by the _scheduled bool (this is
> important or else it will continually push back by 1 period and maybe
> never run)

We've already called into this function, don't think it's worth a
likely. Same for most of the others added in this series, imho they
only really make sense for a very hot path where that branch is
inline.

-- 
Jens Axboe


