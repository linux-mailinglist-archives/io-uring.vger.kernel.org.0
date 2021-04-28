Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E736D4C1
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 11:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhD1J2w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 05:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhD1J2w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 05:28:52 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15CAC061574
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 02:28:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n84so6175782wma.0
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 02:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YRHuhMwDCrPHV/QDc4nWNRUB5omGRLxOSJ/I1S5Etmk=;
        b=VC04ropbsaswc4s9FxoYnasuBBZyFGW7+tdBnJ+zdvrfEB0VWCrPTzOV/nQvEMBO7Z
         S1ISmWENzL7QgU1p7jHju9b7wUO8uigZtq86YUUvYN5/bEfpMityUh/7XbX0S7z81nMF
         BowjQWHBP2N0jW8zN1XNmwyoeZwtDB0srv/+vRD28qVrxxOdrF39TstxFq2EsYwegD9G
         1KayMdpNkVJQthaRgWejR6s+eS6vV7u8/My0+LFpqZjLLywAxiW2rozH9CPnlPibffsY
         XJLVp0CQVwRhvS80jI6/PKiVyt0gj2h/XIuFjSSxz3BQKCdddRO1ueOYMSD6cq6LLSoC
         Co+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YRHuhMwDCrPHV/QDc4nWNRUB5omGRLxOSJ/I1S5Etmk=;
        b=uMHXvvPw2uzmvzjdrTQIqxzP3rpt2ySasphy23V22HKo5b5loSNfykjhmusoANcg9Z
         GH37c6Bz0RsQBRQZLWi5Nc0QUpDeEGtVdxeMirG2eosP+jQpWkG0iiGDsVjIqgPbNMXM
         yofSFZQpK+IfeoiSIas717yQ+nLd1zwAny8JAVSVqMdAZkopVNGcw737WtWUXmFMBucD
         FieuGEhchK5WszlOVfH1Hu1VN1NUHAboC81dphtOx5u6T9Q9wcxMD4Vcrl51qsOgrZMu
         7wigqNfg7n77CDhQ8r7DEXvhHk38jh52FWKpeATCBPtDY9gNqTQ8r5Nyj7NiGXWFeMRu
         xKxw==
X-Gm-Message-State: AOAM530ep+P356da2P8Ja9HUf/t8p1LUYv5fLqyiX5lO3zq8nWhqmrIl
        Q/fbyOVDGyq6+JHcZfDqX18dQN5kznQ=
X-Google-Smtp-Source: ABdhPJxfQufFY9EXMPjJlfL74khSP0Pc5h+g9oxeuR5bOzg2h/N3XDSamsCIOcLhpia+vfBvksL6fQ==
X-Received: by 2002:a1c:7711:: with SMTP id t17mr7585246wmi.6.1619602086779;
        Wed, 28 Apr 2021 02:28:06 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id v185sm3132816wmb.25.2021.04.28.02.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 02:28:06 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: don't set IORING_SQ_NEED_WAKEUP when
 sqthread is dying
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619527526-103300-1-git-send-email-haoxu@linux.alibaba.com>
 <24c7503d-769f-953e-854f-5090b4bfca3b@gmail.com>
 <68ce18b8-7bbd-f655-c745-f7cfaac76457@linux.alibaba.com>
 <dbc1ccd4-54ae-3bf1-d15a-0322cfeeb885@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <06b764e1-adfa-dfdc-2e28-1fdfba49b970@gmail.com>
Date:   Wed, 28 Apr 2021 10:28:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dbc1ccd4-54ae-3bf1-d15a-0322cfeeb885@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 7:38 AM, Hao Xu wrote:
> 在 2021/4/27 下午10:35, Hao Xu 写道:
>> 在 2021/4/27 下午9:13, Pavel Begunkov 写道:
>>> On 4/27/21 1:45 PM, Hao Xu wrote:
>>>> we don't need to re-fork the sqthread over exec, so no need to set
>>>> IORING_SQ_NEED_WAKEUP when sqthread is dying.
>>>
>>> It forces users to call io_uring_enter() for it to return
>>> -EOWNERDEAD. Consider that scenario with the ring given
>>> away to some other task not in current group, e.g. via socket.
>>>
>> Ah, I see. Thank you Pavel.
> Here I've a question: for processes that aren't in same group, io_uring
> is now designed that sqthread cannot be shared between these processes?

Right, sqthread can't be shared by rings created in different thread
groups, but it doesn't mean the ring itself can't be shared.

> But It seems if users do fork(), they can still call io_uring_enter()
> in the forked task?

IIRC, forking CLONE_THREAD task is discouraged but allowed, but in any
case it's ok from the io_uring perspective. Requests will be fully
executed in the context of the sqpoll task

>>> if (ctx->flags & IORING_SETUP_SQPOLL) {
>>>     io_cqring_overflow_flush(ctx, false);
>>>
>>>     ret = -EOWNERDEAD;
>>>     if (unlikely(ctx->sq_data->thread == NULL)) {
>>>         goto out;
>>>     }
>>>     ...
>>> }
>>>
>>> btw, can use a comment
>>>
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c | 2 --
>>>>   1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 6b578c380e73..92dcd1c21516 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -6897,8 +6897,6 @@ static int io_sq_thread(void *data)
>>>>       io_uring_cancel_sqpoll(sqd);
>>>>       sqd->thread = NULL;
>>>> -    list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>>>> -        io_ring_set_wakeup_flag(ctx);
>>>>       io_run_task_work();
>>>>       io_run_task_work_head(&sqd->park_task_work);
>>>>       mutex_unlock(&sqd->lock);
>>>>
>>>
> 

-- 
Pavel Begunkov
