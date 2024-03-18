Return-Path: <io-uring+bounces-1094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C4B87E8E1
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 12:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9F8280CC1
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 11:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8D637162;
	Mon, 18 Mar 2024 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcyqqdFE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B7B37159;
	Mon, 18 Mar 2024 11:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710762421; cv=none; b=YFhwrTFhdn8po5EifMtygzAl+dQRfZw4bOe2o4M+w6MT0E18A7DyGQcMD95JJGe+nViWs99Kf48VHxJSOY0HoeUeY+QlAgNbIuG1XL3NGjpdDoHfH2FTm8x9zdq0iprftWZl87k6ndqux/ihHGA3GcGbsukDWz/NGyPeYTXomgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710762421; c=relaxed/simple;
	bh=5d3HQzA/bkAQK2GIo52rHNgwV+grnRSyP5tXhwRyG2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0vQMmwg4JD2SiMsqboIOXgSdiU6JvfeTl+tt6OMTQJsgM8vHPuGBHmRc8Jg6AwO8cj/UJNMKZNeRLNATMbtZ/ocJMS4+6DlwPJ5ZrV9jw8PyvpAhuB0phP7ZoWfRylOJ6NKAgCeuHFjgSPZ+kT6Sx8P0bS57M99zOrftJdpJ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcyqqdFE; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-78822adc835so199913885a.3;
        Mon, 18 Mar 2024 04:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710762419; x=1711367219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9fOStv+bVP7UIOShrtPHs1XmVlAuBtCVhZwgtFniRfs=;
        b=bcyqqdFEqOhJKJwKpBeQUyyyjii+j+7kQUdcsfJ92GoPRFJioApwYvZvsPcYjzd21j
         RZIQiFJbdf85Ooahv9dY90v8AeE4R3w7NG4Ad5utjH5m4RPfRVFpjKGDoD1sSkhxnf29
         d47zONNXICUxAYFYz+TEK6YodG+ChVahqtCxLogSZq0YKIZk6ScvSsbGghyUntHkMCvT
         sW6yBXpbLYTrODJEt+36/q4BdBwMxp1+dvgbwaw4Aq/isl023STTWT5ozNdtmWNZ88RP
         Lj3RZT1UDWggTmGW5tVcQYTgzPn8ab1dlkV6I3fwkJ4Bv4dHZy2mswlAn9mHYawr2zrI
         q7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710762419; x=1711367219;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fOStv+bVP7UIOShrtPHs1XmVlAuBtCVhZwgtFniRfs=;
        b=krUCAWWJxqz2waFc/YjYJzjcwC/oNKLD9ObMX6Gb36eaJdHhthly5CW1y64IDyE9u4
         sjpt/FBrxS9Swe+/H2ZMGkDbjAB82iMKLuhGnnjUZSQFpLjF+ikekQ3yE2UlEtw+Q2C9
         UmmsM445R9FafrvuSDL4ApWdXGnCq8v4+mFJKr5C3I5ulcqDLkoEV0mmzlg08iKUjP2d
         lfSCz+EI11iD5nsdNS5cHgGqDw5gro5aZfUSvYVILuHgzfxK+Ovrf+R49dNTRBm/O3z5
         jCl/GX4XDH0rcqhCVPWa5E0G0kSEWYnEKvmakNL1iSiwm1+UtmmpgdTE03PVcl0zPHHI
         CqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEnqlgZgAZiee3C+LW3MwvEtkNeYWBtSot9ug8DJFocpk7mP2uPROBC/CHp+RdD/r4LBNNjoJPwxgS5K5emBTv5o+GI2/I4ufEbXo=
X-Gm-Message-State: AOJu0YyZavYcvbSiEGUptUn2vkXbaK2FedcMPwmd/Rku3QzaIgi7HyX/
	F142kmHCE4i5HBu6buCC8IVn9HE0/YTRFWZyXZDV11WUkRiEmUT76y/YcSex
X-Google-Smtp-Source: AGHT+IGBnTmGl0WUYK03OHJvi5GbxYLiCOFw1jkssILJuIfynPtcTqUs7/XjuhPMOdMcOPplZgWplQ==
X-Received: by 2002:a05:620a:57d3:b0:789:dd63:5f7e with SMTP id wl19-20020a05620a57d300b00789dd635f7emr12806206qkn.53.1710762419115;
        Mon, 18 Mar 2024 04:46:59 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id wj18-20020a05620a575200b00789e7ddf8a5sm2789362qkn.17.2024.03.18.04.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 04:46:58 -0700 (PDT)
Message-ID: <c6316d92-b274-4afd-9d08-946a26fe053d@gmail.com>
Date: Mon, 18 Mar 2024 11:45:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
 <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk> <ZferOJCWcWoN2Qzf@fedora>
 <ed73a4de-0b3b-4812-8345-40ea7fa39587@kernel.dk> <ZffmWuGsNH/QVC/O@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZffmWuGsNH/QVC/O@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 06:59, Ming Lei wrote:
> On Sun, Mar 17, 2024 at 09:11:27PM -0600, Jens Axboe wrote:
>> On 3/17/24 8:47 PM, Ming Lei wrote:
>>> On Sun, Mar 17, 2024 at 08:40:59PM -0600, Jens Axboe wrote:
>>>> On 3/17/24 8:32 PM, Pavel Begunkov wrote:
>>>>> On 3/18/24 02:25, Jens Axboe wrote:
>>>>>> On 3/17/24 8:23 PM, Ming Lei wrote:
>>>>>>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
>>>>>>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
>>>>>>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
>>>>>>>> pass and look for to use io_req_complete_defer() and other variants.
>>>>>>>>
>>>>>>>> Luckily, it's not a real problem as two wrongs actually made it right,
>>>>>>>> at least as far as io_uring_cmd_work() goes.
>>>>>>>>
>>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> oops, I should've removed all the signed-offs
>>>>>
>>>>>>>> ---
>>>>>>>>    io_uring/uring_cmd.c | 10 ++++++++--
>>>>>>>>    1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>>>>> index f197e8c22965..ec38a8d4836d 100644
>>>>>>>> --- a/io_uring/uring_cmd.c
>>>>>>>> +++ b/io_uring/uring_cmd.c
>>>>>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>>>>>>    static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>>>    {
>>>>>>>>        struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>>>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>>>>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
>>>>>>>> +
>>>>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>>>>> +    if (ts->locked)
>>>>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>>>>          ioucmd->task_work_cb(ioucmd, issue_flags);
>>>>>>>>    }
>>>>>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>>>>>>        if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>>>>>>            /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>>>>>            smp_store_release(&req->iopoll_completed, 1);
>>>>>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>>>>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>>>>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>>>>>>> +            return;
>>>>>>>>            io_req_complete_defer(req);
>>>>>>>>        } else {
>>>>>>>>            req->io_task_work.func = io_req_task_complete;
>>>>>>>
>>>>>>> 'git-bisect' shows the reported warning starts from this patch.
>>>>>
>>>>> Thanks Ming
>>>>>
>>>>>>
>>>>>> That does make sense, as probably:
>>>>>>
>>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>>> +    if (ts->locked)
>>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>>
>>>>>> this assumption isn't true, and that would mess with the task management
>>>>>> (which is in your oops).
>>>>>
>>>>> I'm missing it, how it's not true?
>>>>>
>>>>>
>>>>> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
>>>>> {
>>>>>      ...
>>>>>      if (ts->locked) {
>>>>>          io_submit_flush_completions(ctx);
>>>>>          ...
>>>>>      }
>>>>> }
>>>>>
>>>>> static __cold void io_fallback_req_func(struct work_struct *work)
>>>>> {
>>>>>      ...
>>>>>      mutex_lock(&ctx->uring_lock);
>>>>>      llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>>>>>          req->io_task_work.func(req, &ts);
>>>>>      io_submit_flush_completions(ctx);
>>>>>      mutex_unlock(&ctx->uring_lock);
>>>>>      ...
>>>>> }
>>>>
>>>> I took a look too, and don't immediately see it. Those are also the two
>>>> only cases I found, and before the patches, looks fine too.
>>>>
>>>> So no immediate answer there... But I can confirm that before this
>>>> patch, test passes fine. With the patch, it goes boom pretty quick.
>>>> Either directly off putting the task, or an unrelated memory crash
>>>> instead.
>>>
>>> In ublk, the translated 'issue_flags' is passed to io_uring_cmd_done()
>>> from ioucmd->task_work_cb()(__ublk_rq_task_work()). That might be
>>> related with the reason.
>>
>> Or maybe ublk is doing multiple invocations of task_work completions? I
>> added this:
> 
> Yes, your debug log & point does help.
> 
> This patch convert zero flag(!IO_URING_F_UNLOCKED) into IO_URING_F_COMPLETE_DEFER,
> and somewhere is easily ignored, and follows the fix, which need to be
> folded into patch 2.

Thanks, was totally unaware of this chunk. A side note, it's
better to be moved to uring_cmd, i'll do the change


> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 5d4b448fdc50..22f2b52390a9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3259,7 +3259,8 @@ static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
>                          /* ->sqe isn't available if no async data */
>                          if (!req_has_async_data(req))
>                                  cmd->sqe = NULL;
> -                       file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
> +                       file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL |
> +                                       IO_URING_F_COMPLETE_DEFER);
>                          ret = true;
>                  }
>          }


-- 
Pavel Begunkov

