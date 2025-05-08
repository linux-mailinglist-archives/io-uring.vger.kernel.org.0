Return-Path: <io-uring+bounces-7908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8E1AAF530
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 10:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 761117A53EB
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 08:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F81A22068A;
	Thu,  8 May 2025 08:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EyRniOsN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7C61D63F5
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 08:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746691819; cv=none; b=u4bY58Qao8HzSMFnGhCK4eZeuDptYWnJoII+iP6EYEx2P6hMX13VbbT+W3Zjv9b/27/z5WZNzYuJ6eCuUI8wfI/m9oQS81mfMixJlzPXagGcBuThJ8J9DE6/xGQS4lAU3BI6Sy4/15mzyGWbvsCMmKwD0p0PhtSGoGeLNVrpPgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746691819; c=relaxed/simple;
	bh=YZ/m29kRWJkRQQlHN4Cbl+sutyN9Qmgm99DizmSRsZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eL4ZSkfZBp9a721jBOq2tm11fojhzoiWM11qV3vK7luWu2egzGhWtnZxBm9x1897CYGp6MCY0lbtHmBOYkRgHUBW3EI+FswDhZlP3P8hSTBhfulJmiusVsIWNGc5kXadZSCHtk3yW2tTIR2isfavRhSAAMGoGKt4qTtVokHSbOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EyRniOsN; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5fbeadf2275so1237978a12.2
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 01:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746691815; x=1747296615; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8rYi1G8UMlYlvdVinahBEXCUje+Zs1Vs9YXX8isy9UY=;
        b=EyRniOsNk9mvZUIH71WSQUZMR2L0F5Bq8C0VBa20EcoXfhXGANEI8ynN4OKcbes+F7
         svJMROvewAdHul26DCQeU8jBVTOKw7F3gI8PWeIC6mtoz6aId/hIkIGfg/DR4NT4s9cU
         hEqf2lzgGDUpf4r+k//V/BsQgZXwTFLOHiDTFRT7hsgOTZ4ZtdaTlTyVZ4sLtNwSeki2
         fKBVnNNVMBUJ6a2wfYT1ivACBzsL7kQQZhZjrwac43qyOZVKQ2bAyyIe9PW+qK8mdGXo
         hUDjPfUmQWxgO+R2y1HMqjUHipgMgWnMVbyawyyhUhTsS+aLAFSR6vsBLfjoZpUnjrbq
         2+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746691815; x=1747296615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rYi1G8UMlYlvdVinahBEXCUje+Zs1Vs9YXX8isy9UY=;
        b=qHLF8LotrX4MT9sL8tcS4nFzmfYm3kp4uA7zeBen8+6aQm7NADnWniY0WSUCMbUoS3
         AJPRX/5yKI/34II5yJGwOfrdX4l4DGeUwOX3O1Wjc7HcxrxZqh4zgrpJ1YxG58piDINl
         iCQB4rEquI05mhYMOPRsF5XOUonQFJDJTOuRGvJ0S9TsRNkVYpeMKFeU+xa7F68siYH3
         8/HWbA3f7h9vB0OXSR0STxHgahUz0RUPlyM6ubEzS9Vx0JUFgecEV5FCCsBkAFirChTl
         n+fAstkJlwCrDKEOhjej4G8BIB10x+XRIYDUOXhFpWDu3wu4hEZyMEpyGpSEjZwJg4ZW
         QKEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJy0wLQ2/9zhcQNDaHqYDBDrCVlnBqhkbkrZoqqOtyHJMCsogUvZkVPQjZij9Im7RVnKynRpIvBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJdr9apzD/R+Pe9uMEsuLG1ez7J8yi6HI0Oq+QLbfSy8G5kn6C
	Y4ecqnKHy2UG6/Pc+oal6z1vbTJLyYHsy9zMC0lcezS4QOLOu9cA
X-Gm-Gg: ASbGncsDyCyVlzqyu+BYuWzifrlxN+viRn2XHyy1ajhRHoGcjhjiOTM6lhjtmST4d9n
	lr8SRdPUZmueszPPICRneyYaO9jVTvRKu4+4kUmLd7whZtjvbUYIr93v554WfNyUBSGBSb55T0m
	cqgPV2dPwOWhKTQQOfly/3kRR3MSRtIutcyc4BQCAVUtmPxWd03jeOzKstpKnWCJFNHItq1zdOE
	5fXCJ6c+Qdam8EklNgo4wIFX7uTmz9KKqFN1tA5oH8Mv9+sif2bZKWAsqJSPKokAo2kiAj3/BIK
	NoVOhBMTkF9u4SCGtSo0USO2YQST5ZQ/zjHoFXqDIP1XYdBEX5DO
X-Google-Smtp-Source: AGHT+IE3FHz24JgrpNtu4PUOhFHc8X/VrZqHNe28sJptiQE5VYihgd0uiH5OWep17HySokLqi1Sr2g==
X-Received: by 2002:a05:6402:5211:b0:5f3:f8d5:4a6d with SMTP id 4fb4d7f45d1cf-5fbe9d8ecacmr5332630a12.6.1746691815135;
        Thu, 08 May 2025 01:10:15 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2f? ([2620:10d:c092:600::1:6858])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fa77b90080sm10999591a12.52.2025.05.08.01.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 01:10:13 -0700 (PDT)
Message-ID: <c0f72ca7-76f9-41b3-9bcd-18deba603ab3@gmail.com>
Date: Thu, 8 May 2025 09:11:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: use regular CQE posting for multishot
 termination
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <e837d840-4ff7-423a-a7a9-2196a7d44d26@kernel.dk>
 <1711744d-1dd1-4efc-87e2-6ddc1124a95e@gmail.com>
 <d0c88f28-3915-4860-93d7-3a383aff8061@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d0c88f28-3915-4860-93d7-3a383aff8061@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 00:11, Jens Axboe wrote:
...>>> This removes the io_req_post_cqe() flushing, and instead puts the honus
>>> on the poll side to provide the ordering. I've verified that this also
>>> fixes the reported issue. The previous patch can be easily backported to
>>> stable, so makes sense to keep that one.
>>
>> It still gives a bad feeling tbh, it's not a polling problem,
>> we're working around shortcomings of the incremental / bundled
>> uapi and/or design. Patching it in semi unrelated places will
>> defitely bite back.
> 
> I don't think that's fair, we should always strive to have as close to
> ordered completions as we can. The fact that multishot ends up using a

As a nice thing to have / perf / qos? Sure, but this makes it a
correctness requirement, which always takes precedence over any
future potential optimisation / cleanup that might lead to a rare
reordering.

> mix of both methods to fill CQEs is problematic.

It's a nuisance, I agree, but the problem here is introducing
implicit inter request ordering. I assume for incremental you're
returning {bid, len} and the user has to have a state to track
the current offset based on CQE ordering? In which case the
problem is really not returning the offset explicitly.


>> Can it be fixed in relevant opcodes? So it stays close to
>> those who actually use it. And let me ask since I'm lost in
>> new features, can the uapi be fixed so that it doesn't
>> depend on request ordering?
> 
> The API absolutely relies on ordering within a buffer group ID.
> 
> It can certainly be fixed at the opcode sites, but there'd be 3 spots in
> net and one in rw.c, and for each spot it'd be more involved to fix it.
But that's the spots that use provided buffers, while polling shouldn't
have a reason to know about provided buffers. For example, is it safe
to mix such mshot and oneshot requests? Let's say during initial
submission oneshot request succeeds and queues a deferred completion,
i.e. io_issue_sqe() -> io_req_complete_defer(). Next it submits an
mshot request, which posts some aux cqes, and only then we file a
CQE for the first request. Or it can be just an mshot executed not
from the polling loop but inline.

> 
...>>> +{
>>> +    bool filled;
>>> +
>>> +    filled = io_req_post_cqe(req, req->cqe.res, req->cqe.flags);
>>
>> posting and overflow must be under the same CQ critical section,
>> like io_cq_lock(). Just copy io_post_aux_cqe() and add
>> ctx->cq_extra--? Hopefully we'll remove the cq_extra ugliness
>> later and combine them after.
> 
> Would be great to combine those, as it stands there's a mix of them, and
> io_add_aux_cqe() for example does split locking. I'll update the
> locking.

It would be, but that's buggy and can cause reordering. io_add_aux_cqe()
doesn't split the _CQ critical section_, it relies / requires
DEFER_TASKRUN, and ->completion_lock is not equivalent to that.

>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>> index 8eb744eb9f4c..af8e3d4f6f1f 100644
>>> --- a/io_uring/poll.c
>>> +++ b/io_uring/poll.c
>>> @@ -312,6 +312,13 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>>>        return IOU_POLL_NO_ACTION;
>>>    }
>>>    +static void io_poll_req_complete(struct io_kiocb *req, io_tw_token_t tw)
>>> +{
>>> +    if (io_req_post_cqe_overflow(req))
>>> +        req->flags |= REQ_F_CQE_SKIP;
>>
>> Unconditional would be better. It'd still end up in attempting
>> to post, likely failing and reattemptng allocation just one
>> extra time, not like it gives any reliability. And if I'd be
>> choosing b/w dropping a completion or potentially getting a
>> botched completion as per the problem you tried, I say the
>> former is better.
> 
> Not sure I follow, unconditional what? SKIP? Yes that probably makes

Yes

io_req_post_cqe_overflow(req);
req->flags |= REQ_F_CQE_SKIP;

> sense, if we don't overflow post, it'll get logged as such anyway.

-- 
Pavel Begunkov


