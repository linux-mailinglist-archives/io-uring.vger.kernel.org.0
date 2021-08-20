Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096EA3F2C08
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 14:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhHTM1t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 08:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbhHTM1t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 08:27:49 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A79C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 05:27:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f5so13968049wrm.13
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 05:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wHFxCheSsrN3nspqoNCaMARfQo5F5QHAviFxT3WbjEQ=;
        b=ncpwhT7lcJLux9iM3RXFe33/JNvvlpMfQY3xb2KwzqN1J4tB9niYm/Rnb0SbsK9ddK
         9sB/XsoMlST6v+tCuAIijD3XVo+cf13ZEubR8x8Pvu/O3l3j+cLJuc/l7eEIhZSNV1jJ
         hmLi4x4105WRdzEjn3hs1OCobwxyJt29JgS50s86oFhalkjuICisjo7jVsiQc4/etygo
         IvcqavcVAU6tmE8aajo3MJTZGyoK+hYvSyKN/25WY519i6+Y027/fblpZxcsgS+rLO34
         Cg+qhCUMV6fmsrCOfNq1X8T2lsovzmkLu4dsDN3Baz/JyiSu6iKdWWPf27Zh4PazLvrz
         SQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wHFxCheSsrN3nspqoNCaMARfQo5F5QHAviFxT3WbjEQ=;
        b=QXiIqs/BcgdbW/XCFOoA24/6m5qfAEPkrHxsBEQWsU0zyHkXl5aZb7vHKPpY+PMHky
         HHKGBzSMEWUq+2h1RjswQtLK8ZJVOZSkmlGSf53oth+KNsE7c5u7XOAOltBIgYQ/K1Ry
         pGo/Qbce3t1byuXqnaxLoW+yqXtFPTf0Ck7g2tV/h374IXEJXbcsn6gOc8oySm3epYdm
         ZfVBq92eLONGKKBZAAqZv8kUNTFvRhBEUXY7uUMzvyryDmDxiYIHgiK3kJx6IxBfhYFV
         BiMiafm4qiwlJID3AOdcX/pam9Mzm3qvjwg6nTsi1+N/vR0BzR9VtJprizbN9ncgA2Qw
         c2zQ==
X-Gm-Message-State: AOAM532LqfHxtf0hZ+uM05g8FrCKJ1h66YzQAuQsZQBApNb191jYlSp2
        UJNrWT1+PqKODg2BvTeWYOZC2VIANN0=
X-Google-Smtp-Source: ABdhPJxf1agB9tasQVMuSla1kYBiDsxgaEKYyuohrDSczwmnw/To94Di2567yDGfhJ74ifFb7MPnyA==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr9680963wrx.280.1629462429592;
        Fri, 20 Aug 2021 05:27:09 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id l2sm5046554wme.28.2021.08.20.05.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 05:27:09 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1629286357.git.asml.silence@gmail.com>
 <8b941516921f72e1a64d58932d671736892d7fff.1629286357.git.asml.silence@gmail.com>
 <a02fcefe-3a55-51fb-9184-6a49596226cf@linux.alibaba.com>
 <0fcdffe3-024d-2f0f-78f1-938594f68995@gmail.com>
 <459bb482-e9bd-1457-95f9-3251394747c9@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: flush completions for fallbacks
Message-ID: <332dad28-891b-f2ab-a2ae-fb044d1785d5@gmail.com>
Date:   Fri, 20 Aug 2021 13:26:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <459bb482-e9bd-1457-95f9-3251394747c9@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 11:16 AM, Hao Xu wrote:
> 在 2021/8/20 下午5:49, Pavel Begunkov 写道:
>> On 8/20/21 10:21 AM, Hao Xu wrote:
>>> 在 2021/8/18 下午7:42, Pavel Begunkov 写道:
>>>> io_fallback_req_func() doesn't expect anyone creating inline
>>>> completions, and no one currently does that. Teach the function to flush
>>>> completions preparing for further changes.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    fs/io_uring.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 3da9f1374612..ba087f395507 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1197,6 +1197,11 @@ static void io_fallback_req_func(struct work_struct *work)
>>>>        percpu_ref_get(&ctx->refs);
>>>>        llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
>>>>            req->io_task_work.func(req);
>>>> +
>>>> +    mutex_lock(&ctx->uring_lock);
>>>> +    if (ctx->submit_state.compl_nr)
>>>> +        io_submit_flush_completions(ctx);
>>>> +    mutex_unlock(&ctx->uring_lock);
>>> why do we protect io_submit_flush_completions() with uring_lock,
>>> regarding that it is called in original context. Btw, why not
>>> use ctx_flush_and_put()
>>
>> The fallback thing is called from a workqueue not the submitter task
>> context. See delayed_work and so.
>>
>> Regarding locking, it touches struct io_submit_state, and it's protected by
>> ->uring_lock. In particular we're interested in ->reqs and ->free_list.
>> FWIW, there is refurbishment going on around submit state, so if proves
>> useful the locking may change in coming months.
>>
>> ctx_flush_and_put() could have been used, but simpler to hand code it
>> and avoid the (always messy) conditional ref grabbing and locking.

> I didn't get it, what do you mean 'avoid the (always messy) conditional
> ref grabbing and locking'? the code here and in ctx_flush_and_put() are
> same..though I think in ctx_flush_and_put(), there is a problem that
> compl_nr should also be protected.

Ok, the long story. First, notice a ctx check at the beginning of
ctx_flush_and_put(), that one is conditional. Even though we know
it's not NULL, it's more confusing and might be a problem for
static and human analysis.

Also, locking is never easy, and so IMHO it's preferable to keep
lock() and a matching unlock (or get/put) in the same function if
possible, much easier to read. Compare

ref_get();
do_something();
ref_put();

and

ref_get();
do_something();
flush_ctx();

I believe, the first one is of less mental overhead.

-- 
Pavel Begunkov
