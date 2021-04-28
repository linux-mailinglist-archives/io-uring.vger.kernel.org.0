Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB0336DB38
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 17:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhD1PKG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 11:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbhD1PJ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 11:09:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB8FC061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 08:09:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lp8so2906774pjb.1
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 08:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2mmKE/lEqerd0CqPFzK40zp7fZpIFpsFqfpQFPxKSVI=;
        b=1HqQ1/mEJjL68KxrbxKESTiaLyk3ESgqVIRr2wyHjlCigbXRa6W2nHgubjIwd4TW1S
         0BNDh1u7rkUGOFfGKtVIaF2zutmnlqhSLfVxZE1qICZ70dUK3hYZXFGXdxsZJzhabfdI
         eEIEEJx0hQmjeOmVOfr5Z33t5Z/pG6IMqMKdK0Xk+H7Iz0L/Zesi5/REd4atynzVOQWa
         LO8QCQWNV3Fgtv6YG2fqHQu3wUQyxQDg7tA6rWCpWYnPL9z/MZK0ET2fbMflX6C6DBAQ
         DC36+y7fl9ZeIawHEgB/HVgP9rbL16rkFCrXwv82AEbeu4q5S82bbA9GGxJl4KzustZk
         vhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2mmKE/lEqerd0CqPFzK40zp7fZpIFpsFqfpQFPxKSVI=;
        b=BvICB6OhY+eAZM7VwpP9A/GDh8CID0G9xusJyffr0CKt9OV84CCzrTAIdv5D1ROl4C
         +bJlQtnrfAc/pBYPfX138e6rKBqLJPsGTEe7j/4HeHe3eoWf24u3yJDuc74YpvWkdJG9
         kkg04xCD01KvOU+Nzm6sb4EunqDLIM8XSLSR+ypfmpJEkVHkJeQvP/gK/R0/958CLmgR
         hBJ8h5A0cW/XO6kN9DiUsvvHS7syi7ZD0EXzKE64/+bbMjhliGZS9BpS7OeLR824HBG1
         0PXQ/TVuBQd7XjsvqgDszlA3Wy7Lq0tOSc7nmcASDGQpnbGOjqRUyhue76aFA6gNfYSJ
         2E/w==
X-Gm-Message-State: AOAM533Wijhi2+97m7YqTbA01Qr8wWsW8Q2yFd7CoR2rZnJivJb9QO5q
        KIzcAukb2nPxCVBFxtWQdZfq2A==
X-Google-Smtp-Source: ABdhPJyfRdnLPF4UBqXlF2ZDwSHFGcUW7b21YjDvI2epDGUHmwWgLUOkh4BnHzxBn+mZaTz551OPWA==
X-Received: by 2002:a17:90b:1d92:: with SMTP id pf18mr33935245pjb.71.1619622551980;
        Wed, 28 Apr 2021 08:09:11 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o187sm59710pfb.190.2021.04.28.08.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 08:09:11 -0700 (PDT)
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
 <ae723745-ed9b-1de3-e8fc-b4f6e320f17a@kernel.dk>
 <f13139f3-37ef-e86f-5225-b49a03decbef@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0df5d2f7-9a09-5cf9-dcab-07fe3328fbf4@kernel.dk>
Date:   Wed, 28 Apr 2021 09:09:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f13139f3-37ef-e86f-5225-b49a03decbef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 8:56 AM, Pavel Begunkov wrote:
> On 4/28/21 3:53 PM, Jens Axboe wrote:
>> On 4/28/21 8:50 AM, Pavel Begunkov wrote:
>>> On 4/28/21 3:39 PM, Jens Axboe wrote:
>>>> On 4/28/21 8:34 AM, Pavel Begunkov wrote:
>>>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>>>> sqes are submitted by sqthread when it is leveraged, which means there
>>>>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>>>>> number of sqes in the original task context.
>>>>>> Tests result below:
>>>>>
>>>>> Frankly, it can be a nest of corner cases if not now then in the future,
>>>>> leading to a high maintenance burden. Hence, if we consider the change,
>>>>> I'd rather want to limit the userspace exposure, so it can be removed
>>>>> if needed.
>>>>>
>>>>> A noticeable change of behaviour here, as Hao recently asked, is that
>>>>> the ring can be passed to a task from a completely another thread group,
>>>>> and so the feature would execute from that context, not from the
>>>>> original/sqpoll one.
>>>>>
>>>>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>>>>> ignored if the previous point is addressed.
>>>>
>>>> I mostly agree on that. The problem I see is that for most use cases,
>>>> the "submit from task itself if we need to enter the kernel" is
>>>> perfectly fine, and would probably be preferable. But there are also
>>>> uses cases that absolutely do not want to spend any extra cycles doing
>>>> submit, they are isolating the submission to sqpoll exclusively and that
>>>> is part of the win there. Based on that, I don't think it can be an
>>>> automatic kind of feature.
>>>
>>> Reasonable. 
>>>  
>>>> I do think the naming is kind of horrible. IORING_ENTER_SQ_SUBMIT_IDLE
>>>> would likely be better, or maybe even more verbose as
>>>> IORING_ENTER_SQ_SUBMIT_ON_IDLE.
>>>>
>>>> On top of that, I don't think an extra submit flag is a huge deal, I
>>>> don't imagine we'll end up with a ton of them. In fact, two have been
>>>> added related to sqpoll since the inception, out of the 3 total added
>>>> flags.
>>>
>>> I don't care about the flag itself, nor about performance as it's
>>> nicely under the SQPOLL check, but I rather want to leave a way to
>>> ignore the feature if we would (ever) need to disable it, either
>>> with flag or without it.
>>
>> I think we just return -EINVAL for that case, just like we'd do now if
>> you attempted to use the flag as we don't grok it. As it should be
>> functionally equivalent if we do the submit inline or not, we could also
>> argue that we simply ignore the flag if it isn't feasible to submit
>> inline.
> 
> Yeah, no-brainer if we limit context to the original thread group, as
> I described in the first reply.

Yep, that's a requirement for any kind of sanity there.

-- 
Jens Axboe

