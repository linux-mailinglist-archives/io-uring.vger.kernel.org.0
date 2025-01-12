Return-Path: <io-uring+bounces-5830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E52D0A0A802
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 10:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5A971888622
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 09:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4BA15CD49;
	Sun, 12 Jan 2025 09:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="euE49UPT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFAB18FDBA;
	Sun, 12 Jan 2025 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736674624; cv=none; b=S0UEfdXJ6DAdwEvNonJ71jek2/5r/DJy86jT9kPQCXlYEbAEHeFVatRdpWqGM4V8tIBqIhxVgJs+Ayke/NsLJuzEbaoUzCUTw+P9/oF8MDKjaGLRxCnvoHSsC8STjZvv6tdh5XKxHYJQP8VNWsBRqpheh5xvxGHrrV5EujmEBiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736674624; c=relaxed/simple;
	bh=ZIMLLtAPhZ+7Tg3hGHiQI8w5U7t85kdgcWit0we0+LE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LAugUNRXrCmzqWdUvclgrtk142oZcjY3VoGlJ+KR30u4Ov+QvuMj/xmKSCShvTZjdX2HNIf52P6vrtuyfAQiiKvHQLQhLGJQWHgGyMuBfuBJN9WTIYojWVmUnSWmBMZmTn+EVaEbfXzSa3jPCw8kqwwrcOHSHIv5PuvIR/Q+yc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=euE49UPT; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-216634dd574so37444135ad.2;
        Sun, 12 Jan 2025 01:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736674622; x=1737279422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BMKQUcDgVaPO2H691VPylKmZ2TSWdTuuFVdh5tTqnac=;
        b=euE49UPTrEOPO447IP8WSP6BHhF0rmfxUM/0ybfn3KHdfE8heiM2xfSo3sMG/4TFdZ
         h0efOguyLrrDP0LvgCM50yH/rpbaGctOxzlffNcth3WU+etdMby68N85Y1i6wPivhEsU
         uF6TP8o56IFtHpFL9XjUDLRm2gVJ8ds34YocVI8ReZDMFeynOi3Jr8YD5niSULU62Ha7
         ZNgoryjOMv26WRf/6L7w3dBWYLVmMGu02aYpG+nlvD+5jLeCrezO40UJFNlaLo5VXjL7
         bijVzJr/noyVycGWxL+IRdA0wRedFJMEGdEp6VDCiAbN+sP9GxUZOG9QGfVWpxVK3qLG
         Bb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736674622; x=1737279422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BMKQUcDgVaPO2H691VPylKmZ2TSWdTuuFVdh5tTqnac=;
        b=jmRnNWCwSHPPPJSYco+09E+V3aKaQ4vKhHFTNTDwl+rA/OgzhI62K03UwtZ4ZFXg5P
         AwbWdl++PNxNi3mkQa7kw9ZkBHFa4nlyeMuTwdLpWrQsIOFvHZ8QyrWXDATnjbEBQtrN
         Jr+U4i4zJTOFRmx17F8WGVP8rCxXmytdGlxvli0FYBkCDFM3JLl9hhp+uWO+nz7Hw+xP
         xFq7mTcO1DpgaVaStkLLaVHPGPgXsobokxFLrwqx7QfemsDX3A1b+Ef8hMLioeKVheIP
         ee3QplI2gipyizbU53/vtlgMcSS7x3ugL+mjxwnseDpbE5Si58WOmGFFV894myCED5Cb
         w9ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVRGI9Ix5xqZzuvTumWvRMTImwI5WiDQgzinjFze4QTAlj0ty3OFM9N8NKxt2AGPrNSNFc+RKfJ/w==@vger.kernel.org, AJvYcCWVWgHDpXJKc1noPHlFPNFPqp6IvIj6JQ32+GABm6P0VTQ7210mY/OQo1f7SlHCL9sqoL44Lscm9grnaf4A@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0FWMvOax51FuQvvij3VeHxHG7wJ/qamvxc856zxP7stbeYtG4
	HODoxYOKJIgQdOtHh/zL7CDQig+skQuLXLxR++nfzVBbshzdme9Dtwz3UQ==
X-Gm-Gg: ASbGncuLQ+KqhTbWkMA15aYxZxuDzhQCrjaacZlKqyLy4CR4pfk1+axtPzV5o9Lvimq
	W0NVmPODmzOD3+xnxdRcsp6hjXN4Le1zdH9ZJvvwNh/79G3hjxLG39P5CtZVmq5xLUbsvChIkd6
	ZjQvQBcOuCZ4Ic6AvDghIAPN+ldUoby9syy+yjWgRKlp8BieBikG/AkAHY6UDLi6vBFfu7B20Ij
	l2JwDV12IfRpAZOrt/Dlt6TB04KG4IInRKr2LMRZNmz8R6wnVFg2xyLwwjycMZMJCxJ9TlCr1sq
	1yH4ee8kIJy0AXN0Sz4rM1yBsPE3j6c2
X-Google-Smtp-Source: AGHT+IFIcHOax5U3GNZdWcO63GZpDG8iUKsft65JkYu8LBCo3Q1sElzosX8kF+6NG8SO2kFxBrtaig==
X-Received: by 2002:a17:902:d2d2:b0:216:3889:6f6f with SMTP id d9443c01a7336-21a83f4e4e9mr249048555ad.17.1736674621870;
        Sun, 12 Jan 2025 01:37:01 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f4c:d5a0:f0b6:d66:6352:a79c? ([2001:ee0:4f4c:d5a0:f0b6:d66:6352:a79c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f2192f7sm36614475ad.148.2025.01.12.01.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 01:37:00 -0800 (PST)
Message-ID: <1d0a7d54-fcc7-495a-b9e7-be3344d21b6c@gmail.com>
Date: Sun, 12 Jan 2025 16:36:56 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: annotate sqd->thread access with data race in
 cancel path
To: Pavel Begunkov <asml.silence@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
 Li Zetao <lizetao1@huawei.com>
References: <20250111105920.38083-1-minhquangbui99@gmail.com>
 <02961c66-19b2-4f55-b785-3c4a132a5da3@gmail.com>
 <524e9337-47af-4433-979d-b02788d41ca6@gmail.com>
 <cb3419a7-988e-4133-8ec0-c27953c5da4a@gmail.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <cb3419a7-988e-4133-8ec0-c27953c5da4a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/12/25 08:21, Pavel Begunkov wrote:
> On 1/11/25 13:57, Bui Quang Minh wrote:
>> On 1/11/25 19:02, Pavel Begunkov wrote:
>>> On 1/11/25 10:59, Bui Quang Minh wrote:
>>>> The sqd->thread access in io_uring_cancel_generic is just for debug 
>>>> check
>>>> so we can safely ignore the data race.
>>>>
>>>> The sqd->thread access in io_uring_try_cancel_requests is to check 
>>>> if the
>>>> caller is the sq threadi with the check ctx->sq_data->thread == 
>>>> current. In
>>>> case this is called in a task other than the sq thread, we expect the
>>>> expression to be false. And in that case, the sq_data->thread read 
>>>> can race
>>>> with the NULL write in the sq thread termination. However, the race 
>>>> will
>>>> still make ctx->sq_data->thread == current be false, so we can safely
>>>> ignore the data race.
>>>>
>>>> Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
>>>> Reported-by: Li Zetao <lizetao1@huawei.com>
>>>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>>>> ---
>>>>   io_uring/io_uring.c | 15 ++++++++++++---
>>>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index ff691f37462c..b1a116620ae1 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -3094,9 +3094,18 @@ static __cold bool 
>>>> io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>>>           ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
>>>>       }
>>>> -    /* SQPOLL thread does its own polling */
>>>> +    /*
>>>> +     * SQPOLL thread does its own polling
>>>> +     *
>>>> +     * We expect ctx->sq_data->thread == current to be false when
>>>> +     * this function is called on a task other than the sq thread.
>>>> +     * In that case, the sq_data->thread read can race with the
>>>> +     * NULL write in the sq thread termination. However, the race
>>>> +     * will still make ctx->sq_data->thread == current be false,
>>>> +     * so we can safely ignore the data race here.
>>>> +     */
>>>>       if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
>>>> -        (ctx->sq_data && ctx->sq_data->thread == current)) {
>>>> +        (ctx->sq_data && data_race(ctx->sq_data->thread) == 
>>>> current)) {
>>>>           while (!wq_list_empty(&ctx->iopoll_list)) {
>>>>               io_iopoll_try_reap_events(ctx);
>>>>               ret = true;
>>>
>>> data_race() is a hammer we don't want to use to just silence warnings,
>>> it can hide real problems. The fact that it needs 6 lines of comments
>>> to explain is also not a good sign.
>>>
>>> Instead, you can pass a flag, i.e. io_uring_cancel_generic() will have
>>> non zero sqd IFF it's the SQPOLL task.
>>
>> At first, I think of using READ_ONCE here and WRITE_ONCE in the sq 
>> thread termination to avoid the data race. What do you think about 
>> this approach?
> 
> Same thing, that'd be complicating synchronisation when there
> shouldn't be any races in the first place. Having no races is
> easier than wrapping them into READ_ONCE and keeping in mind
> what that's even fine.

Okay, I'll send another patch with a new flag for the cancel path.

> Btw, the line you're changing doesn't even look right. SQPOLL
> clears sqd->task right before starting with cancellations, so
> sounds like it's mindlessly comparing NULL == current.

Hmm, I think it's correct but quite easy to get confused here. In the 
io_sq_thread, we explicitly call io_uring_cancel_generic before setting 
sqd->thread = NULL. The later io_uring_cancel_generic call in do_exit 
actually does nothing as we already set the task_struct->io_uring to 
NULL in the previous call.

Thanks,
Quang Minh.


