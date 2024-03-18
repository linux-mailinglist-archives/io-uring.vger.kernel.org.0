Return-Path: <io-uring+bounces-1085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5853287E241
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D75FD1F2161C
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E301EB2B;
	Mon, 18 Mar 2024 02:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZwtmkcyS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD361EB4B
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 02:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710729985; cv=none; b=cbJNtLJBEyrH20/pSCTZ5NzMfWu85AuwSIU3DI8cP3FfVdkJSX5JYlcqHXlnUSOpNsIciWY8Ftk5JcWkyXonFJPKS/xj1pE3J28M/cRmddP4vc3lHZKj6cp2ukZe5RPp/Osyeymq18eg6r58sk3j01LjUVNbT0HVa5oohN4kgIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710729985; c=relaxed/simple;
	bh=/Fc+4oRkovkzFAOhEmV/xQeoPBkNvhIu3HLuHMHDw7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k79OSTVB8Sdm/WWbTJISrt3HNab/97qfhiNLsIwQFHd09t/gcBtoHRTVW85tpP0rXnrp3kqDqxrjjXjfEQ3Y7EDFI5tveQ+czXO6AtZsE8mXXbgPIbobzNj+16SFF+FotBUybCvArMjs2/e0AvjV34QGdwVvIWX69RUaWq9+z4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZwtmkcyS; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-29df844539bso644166a91.1
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 19:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710729983; x=1711334783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KjWfVw0geUGg9os2zUxZI97lEAPbX7MKsu9VHaF/9Gc=;
        b=ZwtmkcySgF+bypDPDGt8aqG1XAOKA7RVAfl2jD0WdsxR0YxFIxEhmPPLPcr1lgSWwr
         m3OQLDs4lES1F1k2FF5Yjn+wdUXqx4PzFlPN9gB+f+vDIX4TTx4V6tgp9qbdeUwyE9bO
         pnIyIrokoyFr0Q9zat+cBJNsdhkozBkWMnT49r7jkAOUSaCjFg0M5Cqt3RhwY8wDmPV7
         sG8EMuIf173AMNbsS87QYtzGGiew6nvpeDLnQ5ipp/IoqdHD0m0GkHtp8IQoPFmv2tYM
         3Oed6zDSQ+eA1UPSdRvBA6kesRZ3NK0ns+sT8Gvd3D8/DjB8iksEtf2OUl3LtrzJzfSo
         wMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710729983; x=1711334783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KjWfVw0geUGg9os2zUxZI97lEAPbX7MKsu9VHaF/9Gc=;
        b=N24u/7cDLegJrFhSCRoUkwqYefT9kPf3Pn9cHRwQUhpWmNrryAnlBiEl83RhiBpWK1
         7Yf4r34lTnnlTITB4CG94ObFEmZg6HEdD6wgv2mL4lvHIpsr6ygv/126h+j2Z6aL9REX
         AJ7GUfO0I6Ond1hE8E4c203KbaW6PpSan4gAm2yVY7fsXIg8d/Fh290FKHIiI42qH52L
         NfxyhsP8sXQy+q/KWuXhxQvp/s4PtnTICaDihey+5s9SayjfxHWfXRt8+qNyZ0uKUEBd
         HgekNW7j60MivlozF4wSQkbD0oXKDvr7uZZ2juiq+7qbefQ+HJXgON3BtyAXfaOakc/R
         5Klg==
X-Gm-Message-State: AOJu0Yx4d9+TsuEzp8jFE4Yh41gWsm6FYOwygNYPZpypOJoQW6bq62Bu
	0Glhmwd7/GgEy0yDgHfpP7sjVQl9cdCvwZLsbGlbwz3Pdx7WqUOBvC06+mlOECk=
X-Google-Smtp-Source: AGHT+IH2JhxGa6l1KueVze5LCL1jEexDSTp81Aeij3wHWUgS2Na6kIRx8SWSA5T147mgUW+NuRE9cg==
X-Received: by 2002:a17:902:ea03:b0:1dd:a3d6:3aff with SMTP id s3-20020a170902ea0300b001dda3d63affmr12244830plg.3.1710729982860;
        Sun, 17 Mar 2024 19:46:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id jj18-20020a170903049200b001dffa017c5esm3594937plb.22.2024.03.17.19.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 19:46:22 -0700 (PDT)
Message-ID: <704be04f-ef96-4e24-a968-753bf483bc30@kernel.dk>
Date: Sun, 17 Mar 2024 20:46:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
 <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk>
 <33800cbe-f87b-42e6-93ca-d1d1840deecf@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <33800cbe-f87b-42e6-93ca-d1d1840deecf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 8:43 PM, Pavel Begunkov wrote:
>>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>>> index f197e8c22965..ec38a8d4836d 100644
>>>>>> --- a/io_uring/uring_cmd.c
>>>>>> +++ b/io_uring/uring_cmd.c
>>>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>>>>    static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>    {
>>>>>>        struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
>>>>>> +
>>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>>> +    if (ts->locked)
>>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>>          ioucmd->task_work_cb(ioucmd, issue_flags);
>>>>>>    }
>>>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>>>>        if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>>>>            /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>>>            smp_store_release(&req->iopoll_completed, 1);
>>>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>>>>> +            return;
>>>>>>            io_req_complete_defer(req);
>>>>>>        } else {
>>>>>>            req->io_task_work.func = io_req_task_complete;
>>>>>
>>>>> 'git-bisect' shows the reported warning starts from this patch.
>>>
>>> Thanks Ming
>>>
>>>>
>>>> That does make sense, as probably:
>>>>
>>>> +    /* locked task_work executor checks the deffered list completion */
>>>> +    if (ts->locked)
>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>
>>>> this assumption isn't true, and that would mess with the task management
>>>> (which is in your oops).
>>>
>>> I'm missing it, how it's not true?
>>>
>>>
>>> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
>>> {
>>>      ...
>>>      if (ts->locked) {
>>>          io_submit_flush_completions(ctx);
>>>          ...
>>>      }
>>> }
>>>
>>> static __cold void io_fallback_req_func(struct work_struct *work)
>>> {
>>>      ...
>>>      mutex_lock(&ctx->uring_lock);
>>>      llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>>>          req->io_task_work.func(req, &ts);
>>>      io_submit_flush_completions(ctx);
>>>      mutex_unlock(&ctx->uring_lock);
>>>      ...
>>> }
>>
>> I took a look too, and don't immediately see it. Those are also the two
>> only cases I found, and before the patches, looks fine too.
>>
>> So no immediate answer there... But I can confirm that before this
>> patch, test passes fine. With the patch, it goes boom pretty quick.
> 
> Which test is that? ublk generic/004?

Yep, it won't make it through one run of:

sudo make test T=generic/004

with it.

>> Either directly off putting the task, or an unrelated memory crash
>> instead.
> 
> If tw locks it should be checking for deferred completions,
> that's the rule. Maybe there is some rouge conversion and locked
> came not from task work executor... I'll need to stare more
> closely

Yeah not sure what it is, but I hope you can reproduce with the above.

-- 
Jens Axboe


