Return-Path: <io-uring+bounces-5828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A566A0A6CD
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 02:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 267083A7320
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 01:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963773FF1;
	Sun, 12 Jan 2025 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSaLtLcD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA08B8F64;
	Sun, 12 Jan 2025 01:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736644835; cv=none; b=Iee6dX1SwZa6uiohLE9mflO22YhaCrfZFPJJt5x/mrZnZsZgNg1xs9HmU/5JNp5HxKHQlwsyuidsIcknF+Jnf9QBce8HOv5GEjtpTo4GvLENqJOqbuVt0OSJMTRthbJqYg8j0GYIHevuSGOt2prcmGXcq6qvg1F/wXbCWkiiis4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736644835; c=relaxed/simple;
	bh=vB/ZQH18a37xuZ9nmGdnFWobRttNbNuqce5uXSaqtLo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=RpQLXE3f5WTiAyN5XTxlwZm5eX0IDpkfLi4mWJfbHOwcufePawBICzx19EJnAjvZHUg9faK92r1oTEzqZfJDm5EzSNGp6H+Q6jd/wKnyBQdEHc/Ykn9qJERD2GWkz9O14g6K9iFSL9muDEXqYQiSyDhcbMW0po6U0a3JemPW2sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSaLtLcD; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab2aea81cd8so464915466b.2;
        Sat, 11 Jan 2025 17:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736644832; x=1737249632; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5vrFcms5fxWG4esirIHrIeThc1vObp50DTM9HCi2S2Q=;
        b=QSaLtLcDC+iAdJql1qHnTVZTbB/XrSA3b8fKvwgGvUUIzXa9QqkNkwKH7B1F8sxWVy
         1SvvMOEZYM/PnvfN+slcrDTym8SJZ0ldEipvwAbKyiCeP2O1FBow/VNrDIeO09XUXljb
         fXmRolxjrf7Ynn6xAbps88akrxdcRl2UQgl86nw8lK+3ywuZ3XDG4j3Jil37hN81BYSK
         WODuHHANbG3ZUhzqd9ywOYdzxHRshGgP9O8Ux2jYH89EUycpWD0TELkTE6bvE2cR0HBs
         F+TrcttJ9HNMl3nWgFUKXmB2zpj25YzzH00DsA1qJvsJ/JXRZrmkNFFk7OrxskcqgPkO
         KTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736644832; x=1737249632;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5vrFcms5fxWG4esirIHrIeThc1vObp50DTM9HCi2S2Q=;
        b=FYil1barlsjmrBAtP3bxZfftKVL66x7A54XmKTatWOfRLTm3FpzG6eW9HnMZsj+5p1
         SOOdeGIvUF+LdMtK5OxwKktjgE83/c+IrdfF39Iwak7hh4iISX84uEJlHXglVvBRP2b8
         3IICLit49n8K04CLKTqMvvE4DDfz3ND62a9oL1rj27qRfx2gr21Z/GZrK61ihOAGm+CC
         2bQ5PDtLpoJA2wJnGVFIq6vddrv9uvnDMoIDtZUTIHmwOJbNSAxKgQ57QVJdLpV+t577
         0kVd0AHVCH6TJhl3AOfnTbeXH3KzoqaPkMnMjb78itXOb2QvMgGpS8puPcQjxyW1eJ4R
         77NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCoiQtpHnv53NIffgH5D3Ua0AegeqkGcsWNfKTyHnHlyNVjvvFSiwcUL88Lk3oDphUJcOq8236f9NtQSWT@vger.kernel.org, AJvYcCW+FjGc6kkOXwxfGZquHUZlVAczIpyc0h7IvXp961bkR8i3aUMtna4LaWIXtF+bRQzVM5/TUI5v4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbB8voMpU4BuAB5hIVArY7QkOjDIW3pIqFdmPoe1kF7DmRMC/8
	v5O1W/0ulpAHFXlXpxUOYhPchBWVFSZZH6reGLEUaAe/LBwgly3G
X-Gm-Gg: ASbGncs1FSG3VdA6P0gIj07orv3QoLgFQwCBOMg8AzeNV8Io37ASD64M4yim1wjqfvh
	fmSeKBYQ+e9BfkUyIcwvAxrtLI0dt8O4ycwaisztl2IXwOrwN2tREoruJ8d3mCoPUWxDcyVNxoe
	YLNfWV1GDx9fWnmKqW6g+6ELLf/d4HW2yczkis11Ml4bVEDxcIfV/FI2amjMzj8j0hoZaPuZKYl
	AEYzTZQE7T4HPrdhPMOjbfiO5Yhhvxa8POoKFFfdm4opk5kc1INjGpi0Sh2kb5wWf4=
X-Google-Smtp-Source: AGHT+IH2mEEqtHX9A3xCcUxz/b6nClykN7ZAVMaY0Vuxlf4fWymFRiWSpfBpBlGS/1vHvWC339wvPw==
X-Received: by 2002:a17:907:86ac:b0:ab3:8b1:12aa with SMTP id a640c23a62f3a-ab308b117f8mr152475366b.8.1736644831742;
        Sat, 11 Jan 2025 17:20:31 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90df91esm320870866b.79.2025.01.11.17.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2025 17:20:31 -0800 (PST)
Message-ID: <cb3419a7-988e-4133-8ec0-c27953c5da4a@gmail.com>
Date: Sun, 12 Jan 2025 01:21:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: annotate sqd->thread access with data race in
 cancel path
To: Bui Quang Minh <minhquangbui99@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
 Li Zetao <lizetao1@huawei.com>
References: <20250111105920.38083-1-minhquangbui99@gmail.com>
 <02961c66-19b2-4f55-b785-3c4a132a5da3@gmail.com>
 <524e9337-47af-4433-979d-b02788d41ca6@gmail.com>
Content-Language: en-US
In-Reply-To: <524e9337-47af-4433-979d-b02788d41ca6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/11/25 13:57, Bui Quang Minh wrote:
> On 1/11/25 19:02, Pavel Begunkov wrote:
>> On 1/11/25 10:59, Bui Quang Minh wrote:
>>> The sqd->thread access in io_uring_cancel_generic is just for debug check
>>> so we can safely ignore the data race.
>>>
>>> The sqd->thread access in io_uring_try_cancel_requests is to check if the
>>> caller is the sq threadi with the check ctx->sq_data->thread == current. In
>>> case this is called in a task other than the sq thread, we expect the
>>> expression to be false. And in that case, the sq_data->thread read can race
>>> with the NULL write in the sq thread termination. However, the race will
>>> still make ctx->sq_data->thread == current be false, so we can safely
>>> ignore the data race.
>>>
>>> Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
>>> Reported-by: Li Zetao <lizetao1@huawei.com>
>>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>>> ---
>>>   io_uring/io_uring.c | 15 ++++++++++++---
>>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index ff691f37462c..b1a116620ae1 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3094,9 +3094,18 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>>           ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
>>>       }
>>> -    /* SQPOLL thread does its own polling */
>>> +    /*
>>> +     * SQPOLL thread does its own polling
>>> +     *
>>> +     * We expect ctx->sq_data->thread == current to be false when
>>> +     * this function is called on a task other than the sq thread.
>>> +     * In that case, the sq_data->thread read can race with the
>>> +     * NULL write in the sq thread termination. However, the race
>>> +     * will still make ctx->sq_data->thread == current be false,
>>> +     * so we can safely ignore the data race here.
>>> +     */
>>>       if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
>>> -        (ctx->sq_data && ctx->sq_data->thread == current)) {
>>> +        (ctx->sq_data && data_race(ctx->sq_data->thread) == current)) {
>>>           while (!wq_list_empty(&ctx->iopoll_list)) {
>>>               io_iopoll_try_reap_events(ctx);
>>>               ret = true;
>>
>> data_race() is a hammer we don't want to use to just silence warnings,
>> it can hide real problems. The fact that it needs 6 lines of comments
>> to explain is also not a good sign.
>>
>> Instead, you can pass a flag, i.e. io_uring_cancel_generic() will have
>> non zero sqd IFF it's the SQPOLL task.
> 
> At first, I think of using READ_ONCE here and WRITE_ONCE in the sq thread termination to avoid the data race. What do you think about this approach?

Same thing, that'd be complicating synchronisation when there
shouldn't be any races in the first place. Having no races is
easier than wrapping them into READ_ONCE and keeping in mind
what that's even fine.

Btw, the line you're changing doesn't even look right. SQPOLL
clears sqd->task right before starting with cancellations, so
sounds like it's mindlessly comparing NULL == current.

-- 
Pavel Begunkov


