Return-Path: <io-uring+bounces-1084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AEB87E23A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E5AD283079
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3181DFF7;
	Mon, 18 Mar 2024 02:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+p393S3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1AF1DDF4;
	Mon, 18 Mar 2024 02:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710729887; cv=none; b=TRaZmmCm42kDmlrkzqI0GyEPfCgExZQHJW5gkfnWGbtPkzxbWZQsIcVdziUci8fLeoVvjA3kD2la9qwP94f0dDMvaa0s9uQULmPhgcZumjkZPz0NoG69c8zElu/IJtQsvbyiFyMPbhzA3cP6wALtVqzrMn+42Ws8ce2Gf94Fz+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710729887; c=relaxed/simple;
	bh=bA0lxvryyUIHPGvR3f5t32LcjDkWAMhBRiocGkf0kpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LFIYUgRQR9TM2sMKpt2tttfvKUYNtJZ76NJE31wsNvB1v29284adzMA34ZOp0TaOxhRXvAeMBQS6q3140oKi+JEb/yy6UpH3lo6M8ApzTkD/9lBEBSyPfexDU2hEn0IDZaStz7RQyjRUqRSAscfM3vlqN9duRxlOoJKdH64ZrKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+p393S3; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a46a7208eedso170740866b.0;
        Sun, 17 Mar 2024 19:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710729884; x=1711334684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Kn51c6ieAxrn0Bm5fxTFrEGCiDG2am3mjRCQ3ScC7w=;
        b=V+p393S3ASFjR3++e/LdURdgSIfjGeC5h8UD8eBeYBpzQfP1sT0KrOFhjKeeK0m3TD
         CSkxm36SE+O6QvjaDMciU4lfLJ1xDDfv0Kq5f1oqSkQtwXp73/uCC/NRKV8t819XVQxr
         Alh8+Au5qI20Y6an+YLnpef5ljs77bANpraj5VDv23pK1EwQ0IH1Wqa1gSCI5McHVVyl
         aT4dfvn6b9zv8Xlk2Hm+Jml7FEmRAarufWrQ6qY1KYk4YtfS5iWprDNjwG/hmrNGX3xC
         7HFKgFbbN1OrGplPm/9CowN2V2KCgYymToy4wGG6ha4k2mR0Jr/hFlbPVmr0ZGJEbL0Q
         KCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710729884; x=1711334684;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Kn51c6ieAxrn0Bm5fxTFrEGCiDG2am3mjRCQ3ScC7w=;
        b=ouutxzl+n0M19wCHlciSC6JMqOd3sgnllOZX2Rcvw38EYlSxkO3ACwaNQYOZ5La+5B
         Aas9oD9oga36/DFJS54BZauQL5FvLOw5Bot546/dQHsupSq3Sh8+I1hRviUeWC1K5Aq+
         t1aGL4ZOwH0v1f+DIwr/O2LokhEXdtCxaGCk5RLwGrZrRnHmoQ3+EucmI7wbExZwezbg
         KNQrh3uI7igi7WlwlBKEdv7L1QulKgDhgeoBzzvqI1eBy092vG4o/agjog50YvLvSIiS
         lgsOdmty2P8aO2iJE9oO5KzrIc2Ino/Lga5f+xI/8PvpQc+uYFlFKttmj9WOVjZ1KbuI
         6giw==
X-Forwarded-Encrypted: i=1; AJvYcCWqbkLqzZEcUdj688ycSd25+u7rdAB7bjxvhPvs4Zof0pvBBAZuLL6Y8aYftgPl5MPByyHkH8R5BGuNws2pcg5P0YPx3Q9D2JtzjqA=
X-Gm-Message-State: AOJu0YwTstOwS+gm9bPH/aGJiMtG7H9SkJcxGllF1OuFyzhTz1AhR9zN
	jjk2vCgcjZEXWjDGCL2kCI/RpT/R+e5TqlEx4npus1s2NhUyrilX
X-Google-Smtp-Source: AGHT+IFHBq7/cDRnzdPxgrET6KEaBvjC1/403J79wqlXUORBYKhZKoq+nIMDnLy2e9A8BXHh0G65QA==
X-Received: by 2002:a17:907:9706:b0:a46:a1d0:b57b with SMTP id jg6-20020a170907970600b00a46a1d0b57bmr4278112ejc.21.1710729883519;
        Sun, 17 Mar 2024 19:44:43 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id jl27-20020a17090775db00b00a45c9ea48e3sm4297474ejc.193.2024.03.17.19.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 19:44:43 -0700 (PDT)
Message-ID: <33800cbe-f87b-42e6-93ca-d1d1840deecf@gmail.com>
Date: Mon, 18 Mar 2024 02:43:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
 <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 02:40, Jens Axboe wrote:
> On 3/17/24 8:32 PM, Pavel Begunkov wrote:
>> On 3/18/24 02:25, Jens Axboe wrote:
>>> On 3/17/24 8:23 PM, Ming Lei wrote:
>>>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
>>>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
>>>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
>>>>> pass and look for to use io_req_complete_defer() and other variants.
>>>>>
>>>>> Luckily, it's not a real problem as two wrongs actually made it right,
>>>>> at least as far as io_uring_cmd_work() goes.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> oops, I should've removed all the signed-offs
>>
>>>>> ---
>>>>>    io_uring/uring_cmd.c | 10 ++++++++--
>>>>>    1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>> index f197e8c22965..ec38a8d4836d 100644
>>>>> --- a/io_uring/uring_cmd.c
>>>>> +++ b/io_uring/uring_cmd.c
>>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>>>    static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>    {
>>>>>        struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
>>>>> +
>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>> +    if (ts->locked)
>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>          ioucmd->task_work_cb(ioucmd, issue_flags);
>>>>>    }
>>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>>>        if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>>>            /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>>            smp_store_release(&req->iopoll_completed, 1);
>>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>>>> +            return;
>>>>>            io_req_complete_defer(req);
>>>>>        } else {
>>>>>            req->io_task_work.func = io_req_task_complete;
>>>>
>>>> 'git-bisect' shows the reported warning starts from this patch.
>>
>> Thanks Ming
>>
>>>
>>> That does make sense, as probably:
>>>
>>> +    /* locked task_work executor checks the deffered list completion */
>>> +    if (ts->locked)
>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>
>>> this assumption isn't true, and that would mess with the task management
>>> (which is in your oops).
>>
>> I'm missing it, how it's not true?
>>
>>
>> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
>> {
>>      ...
>>      if (ts->locked) {
>>          io_submit_flush_completions(ctx);
>>          ...
>>      }
>> }
>>
>> static __cold void io_fallback_req_func(struct work_struct *work)
>> {
>>      ...
>>      mutex_lock(&ctx->uring_lock);
>>      llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>>          req->io_task_work.func(req, &ts);
>>      io_submit_flush_completions(ctx);
>>      mutex_unlock(&ctx->uring_lock);
>>      ...
>> }
> 
> I took a look too, and don't immediately see it. Those are also the two
> only cases I found, and before the patches, looks fine too.
> 
> So no immediate answer there... But I can confirm that before this
> patch, test passes fine. With the patch, it goes boom pretty quick.

Which test is that? ublk generic/004?

> Either directly off putting the task, or an unrelated memory crash
> instead.

If tw locks it should be checking for deferred completions,
that's the rule. Maybe there is some rouge conversion and locked
came not from task work executor... I'll need to stare more
closely

-- 
Pavel Begunkov

