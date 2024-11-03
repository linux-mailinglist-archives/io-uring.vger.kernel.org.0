Return-Path: <io-uring+bounces-4378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85EF09BA958
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A572280F71
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C011313AA2F;
	Sun,  3 Nov 2024 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSE2Vku/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5783433AB
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730674053; cv=none; b=UtE/VCxkrImWNpeJAuHnh+bMoeIol3llkiSiDr/65GdsM4/u4edifK0QNJNpiax8afIkMnWH/vFuZSfwsm6j6tiDkzOqhujn0OLJoPO6iZSCS6pQVHVNbt1nYRgeVKciaQihwXQnyXppAYZYiUwOMHnmeiBcbjRu5KO31eQBvUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730674053; c=relaxed/simple;
	bh=MeUxaHpRWkRVvbmsb+6vH/z2ihvy5YjLrHPXgw9A3P0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f9Kqo6kzzcubcIUhYo2hJ5S7AyI6yu7razkrUwOaF41Yy5//PtIvD1JFOsSZtC/5ZmLo9TRdwA5oUcmmK/poAcDEFz9hHGoWiTff7ARSHGPfnOFZDqg6cuLSDtmCq16Ac8kPsPOVMtthDqb4noCmlKC7NOeRrFEV0te1EAz8JTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSE2Vku/; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37d4b0943c7so2275311f8f.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 14:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730674049; x=1731278849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IP4dav/u2Od80zlFoi7PBluYVXGxYXI7+yEUt61Z23Q=;
        b=fSE2Vku/i6WwQD5Z+lGAHeFzhldolTwY7wsI0rZMnc+2IOxLLoEBmu2n3mfgxf94kh
         J0q40imBJUSuiuL0aWFfIHtmcs0JkDYXGxwU7IpmvB2J3KkmTwiuYSSqmHcy0Raj/C3R
         P4FVS8Jz5JfR113hvVjtWDI+vc5NkQYXH8gEBCIYI0UvuJGHOjEXx2AVsqGh+yTOAjJP
         E3W67N99iGXL+nyOoNNfK8IJZLsdRaVrtBwXhiZbujJOnBLRpWx0LVdJXwoqgz2UYrQc
         MzuWxJnoZ+/BK8pc7vhBFW3BAOcV/iBELBTVYdMLqOGPKCjsR3mVRkPpg9wAbhPFqiJo
         ACuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730674049; x=1731278849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IP4dav/u2Od80zlFoi7PBluYVXGxYXI7+yEUt61Z23Q=;
        b=k1k1L5AmUlwxYDhtxbbkwUZqHaMMypIHGJ1QRyRCZzwxAqMqfYvaFtQJE49ieXykV5
         FZdA4MqR/ANsvO2ZzFZfMhu3An5jyYpE3rdGHdhfx81m1ClK7VGXKcyYabyrXPFOJ72y
         /UYKOgcu8UeG3ujImlJM6cuHFwFiEEjb2iX8X6kLZdHaAWTJtL9qIW6c97OMtQmBy9zj
         AucrCCginsz8Z/tFDPugDTji0p6bSdKVTPl+7mwGrl7kfXmGYDmWkk4vKoJ2m9ztWCOR
         w9sAOxFhNBnOMw/XWvWCGBLYDuOzfFGVYo0AuifuQwXu76KYVlR72UdkJhNuIxrEFYeX
         06QA==
X-Forwarded-Encrypted: i=1; AJvYcCUCtyPz4hRammqdSiDb0SYzGhc7qONU8cDmhqCje5N1eTmsH8qXKjgJmmXeNhKujJTEt371HdSSdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoUA2ny1u4EXfasJ52bz5PYKdEsAjs/5QSx9KHSMOFxuYuRuOb
	N1hUBpgkZQZw/g+o7WCq3V33LQiJ+Bmjime6g5Ut1rhBblTCvsmecPrNHQ==
X-Google-Smtp-Source: AGHT+IE+rMpT+Zazhj+K0e2aW1E9Wdcxi7Bc2IDZHzsxKABYvv7U3cEZ8nXRJQJLveTyy2fkklzd2g==
X-Received: by 2002:a5d:4011:0:b0:37d:47ee:10d9 with SMTP id ffacd0b85a97d-38061172c9bmr20707900f8f.34.1730674049260;
        Sun, 03 Nov 2024 14:47:29 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9a9a53sm164436805e9.30.2024.11.03.14.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:47:28 -0800 (PST)
Message-ID: <4cd58a90-2cbb-443c-84ab-9a9e0805e72b@gmail.com>
Date: Sun, 3 Nov 2024 22:47:34 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
 <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
 <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
 <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
 <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
 <03d7e082-259a-4063-8a98-5a919ce0fe3e@gmail.com>
 <40c07820-e6e2-4d90-a095-31bb59cedb8d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <40c07820-e6e2-4d90-a095-31bb59cedb8d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/24 22:40, Jens Axboe wrote:
> On 11/3/24 3:36 PM, Pavel Begunkov wrote:
>> On 11/3/24 22:18, Jens Axboe wrote:
>>> On 11/3/24 3:05 PM, Pavel Begunkov wrote:
>>>> On 11/3/24 21:54, Jens Axboe wrote:
>>>>> On 11/3/24 2:47 PM, Pavel Begunkov wrote:
>>>>>> On 11/3/24 17:49, Jens Axboe wrote:
>>>>>> ...
>>>>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>>>>> ...
>>>>>>>          nd->head = prev_nd->head;
>>>>>>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>>>>>          notif->opcode = IORING_OP_NOP;
>>>>>>>          notif->flags = 0;
>>>>>>>          notif->file = NULL;
>>>>>>> -    notif->task = current;
>>>>>>> +    notif->tctx = current->io_uring;
>>>>>>>          io_get_task_refs(1);
>>>>>>>          notif->file_node = NULL;
>>>>>>>          notif->buf_node = NULL;
>>>>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>>>>> index 7db3010b5733..56332893a4b0 100644
>>>>>>> --- a/io_uring/poll.c
>>>>>>> +++ b/io_uring/poll.c
>>>>>>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>>      {
>>>>>>>          int v;
>>>>>>>      -    /* req->task == current here, checking PF_EXITING is safe */
>>>>>>> -    if (unlikely(req->task->flags & PF_EXITING))
>>>>>>> +    if (unlikely(current->flags & PF_EXITING))
>>>>>>>              return -ECANCELED
>>>>>>
>>>>>> Unlike what the comment says, req->task doesn't have to match current,
>>>>>> in which case the new check does nothing and it'll break in many very
>>>>>> interesting ways.
>>>>>
>>>>> In which cases does it not outside of fallback?
>>>>
>>>> I think it can only be fallback path
>>>
>>> I think so too, that's what I was getting at. Hence I think we should just
>>> change these PF_EXITING checks to be PF_KTHREAD instead. If we're invoked
>>> from that kind of context, cancel.
>>
>> Replacing with just a PF_KTHREAD check won't be right, you can
>> get here with the right task but after it has been half killed and
>> marked PF_EXITING.
> 
> Right, but:
> 
> if (current->flags & (PF_EXITING | PF_KTHREAD))
> 	...
> 
> should be fine as it'll catch both cases with the single check.

Was thinking to mention it, it should be fine buf feels wrong. Instead
of directly checking what we want, i.e. whether the task we want to run
the request from is dead, we are now doing "let's check if the task
is dead. Ah yes, let's also see if it's PF_KTHREAD which indirectly
implies that the task is dead because of implementation details."

Should be fine to leave that, but why not just leave the check
how it was? Even if it now requires an extra deref through tctx.

-- 
Pavel Begunkov

