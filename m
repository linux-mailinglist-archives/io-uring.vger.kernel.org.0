Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7E736DA46
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbhD1OzN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240401AbhD1Oxs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:53:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB53C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:53:02 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h20so32973395plr.4
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uxZXFq1gOhA41AHGx4UhrUYIu8KFPFEEay0EO3AGBKE=;
        b=wCY7QGO2U8YR5o2ZsEpF4Bw4VwFZNjnpP1TzAwOfrPO+qTM53gDAl9uhW4RmjKbsGF
         F1GGSXtcMr9MZVCVQtF06kMi9w2epbwpdj+YcuOCrA0UQnloU4Psqt2GMn436s+Luuos
         0IaVNgK1qwDindm8yK4pJtntUrW4OKZ3EtPP6SsbN+pZCwqSN2H496e6Rcf9XFYe3tOC
         pqmFUt4AEzQRFVxTwdomyWE+Kf9O4hm3Zat0hcOMumj4CFDYUi03vvjXJ/titiVMvQ0u
         Yl3SVpXPvoPB6Dqv/jrslFvAlm3hMzGC1RlfVj6eAd8iygrr9ndJzgYb+p34wJGxzBjy
         6pJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxZXFq1gOhA41AHGx4UhrUYIu8KFPFEEay0EO3AGBKE=;
        b=gDuNqZmas3Eh/Hf6fdnrGTAShsuD8bXFWnaQvT6vUf7YAGx4JbYa+cOL1/qz1NwCma
         tdFOkW4gi7/ph3XcDkSb2ESkNAc1ELpVbcZkTG8Y8YYA9rdFKtqvWjqnl5cBcRt2xQwh
         TYXENYKnoJZZC95DPdRvkBCQBSRBxRT9hZhemJQf4YQ7wo+5qHru9FX9LenyoOE/O02j
         7l3lngjDx18MW0Em0tj0aI0ZFnRZd+ghmvwz2HCRtDllDDuuGbTxuA/XYDioiJIaSy7x
         ieYv1MkaKc5wrNozcVaqiI5KHGO6LchmrWMW21Sq7+io9W/uNwKwNNvFLwa7zO5+gCL/
         H0pQ==
X-Gm-Message-State: AOAM5309hQGFPlKCAsNO0GkGK8EIxWfsFcwGeVS8TBxJetKFVBzjXmm2
        YCa+wGSp3/RFWp/Di6VKEjv/G6UCB7aCqw==
X-Google-Smtp-Source: ABdhPJyOMMb1OZhRZEmI8RWFGbAh50qkQ3SzhBKkbKhXQs+M/hpXkLN/9vlyWZ/hoqYVVqeCKa8hPQ==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr881808pjb.159.1619621581616;
        Wed, 28 Apr 2021 07:53:01 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r1sm165449pjo.26.2021.04.28.07.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:53:01 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
 <093a196a-1925-4f0d-aa2f-0cc1d46484c8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ae723745-ed9b-1de3-e8fc-b4f6e320f17a@kernel.dk>
Date:   Wed, 28 Apr 2021 08:53:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <093a196a-1925-4f0d-aa2f-0cc1d46484c8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 8:50 AM, Pavel Begunkov wrote:
> On 4/28/21 3:39 PM, Jens Axboe wrote:
>> On 4/28/21 8:34 AM, Pavel Begunkov wrote:
>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>> sqes are submitted by sqthread when it is leveraged, which means there
>>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>>> number of sqes in the original task context.
>>>> Tests result below:
>>>
>>> Frankly, it can be a nest of corner cases if not now then in the future,
>>> leading to a high maintenance burden. Hence, if we consider the change,
>>> I'd rather want to limit the userspace exposure, so it can be removed
>>> if needed.
>>>
>>> A noticeable change of behaviour here, as Hao recently asked, is that
>>> the ring can be passed to a task from a completely another thread group,
>>> and so the feature would execute from that context, not from the
>>> original/sqpoll one.
>>>
>>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>>> ignored if the previous point is addressed.
>>
>> I mostly agree on that. The problem I see is that for most use cases,
>> the "submit from task itself if we need to enter the kernel" is
>> perfectly fine, and would probably be preferable. But there are also
>> uses cases that absolutely do not want to spend any extra cycles doing
>> submit, they are isolating the submission to sqpoll exclusively and that
>> is part of the win there. Based on that, I don't think it can be an
>> automatic kind of feature.
> 
> Reasonable. 
>  
>> I do think the naming is kind of horrible. IORING_ENTER_SQ_SUBMIT_IDLE
>> would likely be better, or maybe even more verbose as
>> IORING_ENTER_SQ_SUBMIT_ON_IDLE.
>>
>> On top of that, I don't think an extra submit flag is a huge deal, I
>> don't imagine we'll end up with a ton of them. In fact, two have been
>> added related to sqpoll since the inception, out of the 3 total added
>> flags.
> 
> I don't care about the flag itself, nor about performance as it's
> nicely under the SQPOLL check, but I rather want to leave a way to
> ignore the feature if we would (ever) need to disable it, either
> with flag or without it.

I think we just return -EINVAL for that case, just like we'd do now if
you attempted to use the flag as we don't grok it. As it should be
functionally equivalent if we do the submit inline or not, we could also
argue that we simply ignore the flag if it isn't feasible to submit
inline.

-- 
Jens Axboe

