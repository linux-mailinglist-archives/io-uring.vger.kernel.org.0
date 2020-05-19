Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF221D9B94
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 17:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgESPqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 11:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgESPqB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 11:46:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827EDC08C5C0
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 08:46:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f6so22020pgm.1
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 08:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PvCPz3YR0vg4UlNDJvPu1bRvFpmBgPWFXeaDZ/wnDwg=;
        b=fRKYJKIWvYAWoGUUtzwGlL+6v+gQEocXrfwuxuzE8WdmXp4nn5B8aJWIvXMRG6g/Em
         iJlcn/+WgiQMI/jZ1d+H1vouO1GudBjXM5kkSkpgEX9lAjkF/LaO9iewr0TD/VgMmcRp
         fRSu6tUyiao5Xr++Q6Ldrc1ehhtMh1Sbpsyn0IzQL8AjfoDgxrc9yRrgAg+KGKLXMr5Y
         Axi6jfAyKJCQ9YP3KBrFJqAqGQmdhBF9cHnioW4nF9IcxErBr2EIHCwATym3C1fCqpep
         X+jA2B4kzF6P4CyPAX83U3HXyalIihuvDVw17qhlwlQ+mfvFOmuUYLK446nmrnHMlavs
         LOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PvCPz3YR0vg4UlNDJvPu1bRvFpmBgPWFXeaDZ/wnDwg=;
        b=keRtAlbqlesOLN8v+IcKL4MrQgcp7B09H5C5gbWcNGHLyamUMcRhexzdjijktPVKUC
         T//U1hyKigL+CgeYt92XpztVQdUuzCwFh5tnBHjUyCDQ0M2O0Uw6w4wx87G8ZXNL8ZG3
         0YU7KafqoEVsiVA7qsJa6yD5v2rToo57ZmuDl5tWln8KcYnzX2JzVdl9djV2pXhSG89t
         kXUUYAq/lfLb4qjtVJyZDRReE5a6c7qSUDYTyCfDFj/+1I8QG/DLBi3ueQW7OOdRcEcC
         Z6T8qbI0CoyUqPySubAqzri7nx59mOsgsrkrdW8OvxLDwpMYNjsfJffnXiSn+SxhG3Wb
         eo0Q==
X-Gm-Message-State: AOAM532vBJb1T32Dx/CAgahWDdMq3JpJw6SjzrnF5D+pp711/V+EST8N
        jSiBXFgvDqay6IHL1qTYKs14BxFq5jc=
X-Google-Smtp-Source: ABdhPJxMPSdcLnHwwzW1WaIJgu4ND+tqiQWIyzE79Zp1FNH574qvmdaLfUr8/5HXQO8htUwyp0UNdA==
X-Received: by 2002:a62:7707:: with SMTP id s7mr19700367pfc.90.1589903160015;
        Tue, 19 May 2020 08:46:00 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:14f4:acbd:a5d0:25ca? ([2605:e000:100e:8c61:14f4:acbd:a5d0:25ca])
        by smtp.gmail.com with ESMTPSA id y4sm6356551pfq.10.2020.05.19.08.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 08:45:59 -0700 (PDT)
Subject: Re: [RFC PATCH] io_uring: don't submit sqes when ctx->refs is dying
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200513123754.25189-1-xiaoguang.wang@linux.alibaba.com>
 <89e8a0b4-bc18-49c8-5628-93eb403622e2@kernel.dk>
 <1a5e92d0-02c7-44d9-07e5-50c0ca77b800@linux.alibaba.com>
 <c936eddd-f76d-9fac-09cb-717720c0da82@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <793ea8a8-b4a8-5ed9-9ce5-2a9cc0f2e143@kernel.dk>
Date:   Tue, 19 May 2020 09:45:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c936eddd-f76d-9fac-09cb-717720c0da82@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/20 3:23 AM, Xiaoguang Wang wrote:
> hi,
> 
>> hi,
>>
>>> On 5/13/20 6:37 AM, Xiaoguang Wang wrote:
>>>> When IORING_SETUP_SQPOLL is enabled, io_ring_ctx_wait_and_kill() will wait
>>>> for sq thread to idle by busy loop:
>>>>      while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
>>>>          cond_resched();
>>>> Above codes are not friendly, indeed I think this busy loop will introduce a
>>>> cpu burst in current cpu, though it maybe short.
>>>>
>>>> In this patch, if ctx->refs is dying, we forbids sq_thread from submitting
>>>> sqes anymore, just discard leftover sqes.
>>>
>>> I don't think this really changes anything. What happens if:
>>>
>>>> @@ -6051,7 +6053,8 @@ static int io_sq_thread(void *data)
>>>>           }
>>>>           mutex_lock(&ctx->uring_lock);
>>>> -        ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>>>> +        if (likely(!percpu_ref_is_dying(&ctx->refs)))
>>>> +            ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>>>>           mutex_unlock(&ctx->uring_lock);
>>>>           timeout = jiffies + ctx->sq_thread_idle;
>>>
>>> You check for dying here, but that could change basically while you're
>>> checking it. So you're still submitting sqes with a ref that's going
>>> away. You've only reduced the window, you haven't eliminated it.
>> Look at codes, we call percpu_ref_kill() under uring_lock, so isn't it safe
>> to check the refs' dying status? Thanks.
> Cloud you please have a look at my explanation again? Thanks.

Sorry for the delay - you are right, we only kill it inside the ring
mutex, so should be safe to check. Can we get by with just the very last
check instead of checking all of the cases?

-- 
Jens Axboe

