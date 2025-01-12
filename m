Return-Path: <io-uring+bounces-5832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D209BA0A88B
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 12:34:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7649166BA0
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 11:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3F019DF99;
	Sun, 12 Jan 2025 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRSbHe8J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F21F33F7;
	Sun, 12 Jan 2025 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736681641; cv=none; b=DMsG0dTL1t6WSE+z+/UdRcGg9Y+tc0JAauKthzNIwzVGBj0cd11PdXR1t8F3owD2aAFiOegidUcrmvK7PWdI0sSxntH5dz0pw1Rx2B2LlRkCqts5RQRqjkudgvAhexL9vsAMKthPZO5h7a4lF4g50i3YlNRLKATkVZVwyNa6wqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736681641; c=relaxed/simple;
	bh=ft9GtIVEE8bJ6BQFbp2ruDgz494Q9BQKe+s5bX4iItA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JKBslSQ/0gNXSQ+Z8PO3+hN03sQKZu+rI0jmQ60JLATQISrpW4fggFTRvcufoj7WB4jSIjBCxPilcHC2pW/xmdyJVelEWv6wa4z5l2b6pz7Klr6Q6Rl85+tnzIanK7UBWZZFc4a3x79eiCUqMCgoN7nzatfXUcQEPprlrFdNHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRSbHe8J; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa684b6d9c7so606747366b.2;
        Sun, 12 Jan 2025 03:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736681637; x=1737286437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wEz8L2QJPboBLs1Tcf2+zsINoGkwv+xMXGN23xxVN/s=;
        b=JRSbHe8JprklIjHxjQtucY3W2hYNhFPaP4dcCG1eCYsmkkY2cgn1JbyBLPK/u/38wM
         gipXPfAYZVkAISDKZa2mhr96FsDoXq7fd5h/4RRzsBj84d77EAC9Q1QVGPxC9oNqIfgO
         S7/yn/7xMDk/U1JRD2ZvW2sOvaeGCnuGpjSIZLg722ltgRI0quIVb89fKKTLACYhUBcZ
         ZUzXpex1yjZhKrk+lKB5qUVYNbNF+hWCeRbHUIG3bseQDxf9mQ0sfSkIDSKLABBNJ6CI
         y/CjF/ubSklkoEh48qULoPKKuABYtZjWbSbv86VnyOMTckIICSRFfBK79SnFgGaG9UqS
         xWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736681637; x=1737286437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEz8L2QJPboBLs1Tcf2+zsINoGkwv+xMXGN23xxVN/s=;
        b=sISAcF01NbcsNrKor4dypNE7V36op3TbC7WqTZfZJGrI3vENct9c2uLWAUuG6/5qNq
         cjk3mzfQF/NC5aNM3Vp4HKfbrLPHQeVN6zbXUvqkqmSth0PnSYDuHqWEfWcuvgh7o/No
         0DEZsc5gE0aq80cb0Xs7V5GE9zQmQIRsvCZR0yoX64hggdotZv4+MiyGmnMIyXM+mLbV
         fKCRO+9tuCKasdyvAu03fbkkj1Cj4PAe3q0po2/FIGC0sBoua48YAwVuEBq8+65ByLE3
         D91oFMJHOgqhWiz2fs0RRZqlrEt/czvkIDokT051MUbzbIvvmaE4c2hzWxwU1Uy9NS1k
         GVkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAYdR/1kvZZsXdh/p+QEozC07gy8GCJWNMLABVLH5Xdyz8Vqgv+dpQGBCc0p0+kEHKHC+w4HIQs+XYDAE0@vger.kernel.org, AJvYcCVHQbKlR++vaRviEO7i37df1VCf7Q2fQAECtrGs2h5aOEv3PNSRLO4wDjTX6B5TEk1JRhnmT41q4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ3mE6yfmkrRpG/8PM1Mf2am7iIDriwb5n96MgYfY8vI09khZh
	V/jKmigE4/WW0gFqeD4awEXI+fasDc301mrY4GILjs3pBu/kC3ek
X-Gm-Gg: ASbGncuoZMY2Hg6oXPiAIAssz8sV0hciLp2IrUkz9Z9bsGDJKX6CiaeRk37bD7gtV5H
	2RMOcddARg0EbkpoAh1+PGXN+q/n8eETMWCyEi0bElPc2/qtF89wQ1BvcG+S3cxM5FJ0ZTHkEkq
	VTTAJCgPxbviYaH3vdcyo6TkS/CaAxngHfi0WNJyoOjI+tEClAot762ufsQCLeg9Hlb+7rz4Rpz
	OdNFOcD6UOfzxBULbfZvztXviz+iTz/u62U5vnoSRQkOHBS0tWXAly6MWS8cupuW+g=
X-Google-Smtp-Source: AGHT+IFDMe7+jL/YVCncsDtGO5La7J5vPCA4sLGvZekHUFEH5+nLBlZtxa8n4xow0LZw2yCRDOqIbg==
X-Received: by 2002:a17:907:97d2:b0:aa6:96ad:f8ff with SMTP id a640c23a62f3a-ab2abc927abmr1511250466b.52.1736681637236;
        Sun, 12 Jan 2025 03:33:57 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90da0d9sm368066466b.67.2025.01.12.03.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 03:33:56 -0800 (PST)
Message-ID: <718a9f45-6883-4349-bd14-6447c6cddf87@gmail.com>
Date: Sun, 12 Jan 2025 11:34:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: annotate sqd->thread access with data race in
 cancel path
To: Bui Quang Minh <minhquangbui99@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
 Li Zetao <lizetao1@huawei.com>
References: <20250111105920.38083-1-minhquangbui99@gmail.com>
 <02961c66-19b2-4f55-b785-3c4a132a5da3@gmail.com>
 <524e9337-47af-4433-979d-b02788d41ca6@gmail.com>
 <cb3419a7-988e-4133-8ec0-c27953c5da4a@gmail.com>
 <1d0a7d54-fcc7-495a-b9e7-be3344d21b6c@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1d0a7d54-fcc7-495a-b9e7-be3344d21b6c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/12/25 09:36, Bui Quang Minh wrote:
> On 1/12/25 08:21, Pavel Begunkov wrote:
>> On 1/11/25 13:57, Bui Quang Minh wrote:
>>> On 1/11/25 19:02, Pavel Begunkov wrote:
>>>> On 1/11/25 10:59, Bui Quang Minh wrote:
>>>>> The sqd->thread access in io_uring_cancel_generic is just for debug check
>>>>> so we can safely ignore the data race.
>>>>>
>>>>> The sqd->thread access in io_uring_try_cancel_requests is to check if the
>>>>> caller is the sq threadi with the check ctx->sq_data->thread == current. In
>>>>> case this is called in a task other than the sq thread, we expect the
>>>>> expression to be false. And in that case, the sq_data->thread read can race
>>>>> with the NULL write in the sq thread termination. However, the race will
>>>>> still make ctx->sq_data->thread == current be false, so we can safely
>>>>> ignore the data race.
>>>>>
>>>>> Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
>>>>> Reported-by: Li Zetao <lizetao1@huawei.com>
>>>>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>>>>> ---
>>>>>   io_uring/io_uring.c | 15 ++++++++++++---
>>>>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index ff691f37462c..b1a116620ae1 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -3094,9 +3094,18 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>>>>           ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
>>>>>       }
>>>>> -    /* SQPOLL thread does its own polling */
>>>>> +    /*
>>>>> +     * SQPOLL thread does its own polling
>>>>> +     *
>>>>> +     * We expect ctx->sq_data->thread == current to be false when
>>>>> +     * this function is called on a task other than the sq thread.
>>>>> +     * In that case, the sq_data->thread read can race with the
>>>>> +     * NULL write in the sq thread termination. However, the race
>>>>> +     * will still make ctx->sq_data->thread == current be false,
>>>>> +     * so we can safely ignore the data race here.
>>>>> +     */
>>>>>       if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
>>>>> -        (ctx->sq_data && ctx->sq_data->thread == current)) {
>>>>> +        (ctx->sq_data && data_race(ctx->sq_data->thread) == current)) {
>>>>>           while (!wq_list_empty(&ctx->iopoll_list)) {
>>>>>               io_iopoll_try_reap_events(ctx);
>>>>>               ret = true;
>>>>
>>>> data_race() is a hammer we don't want to use to just silence warnings,
>>>> it can hide real problems. The fact that it needs 6 lines of comments
>>>> to explain is also not a good sign.
>>>>
>>>> Instead, you can pass a flag, i.e. io_uring_cancel_generic() will have
>>>> non zero sqd IFF it's the SQPOLL task.
>>>
>>> At first, I think of using READ_ONCE here and WRITE_ONCE in the sq thread termination to avoid the data race. What do you think about this approach?
>>
>> Same thing, that'd be complicating synchronisation when there
>> shouldn't be any races in the first place. Having no races is
>> easier than wrapping them into READ_ONCE and keeping in mind
>> what that's even fine.
> 
> Okay, I'll send another patch with a new flag for the cancel path.
> 
>> Btw, the line you're changing doesn't even look right. SQPOLL
>> clears sqd->task right before starting with cancellations, so
>> sounds like it's mindlessly comparing NULL == current.
> 
> Hmm, I think it's correct but quite easy to get confused here. In the io_sq_thread, we explicitly call io_uring_cancel_generic before setting sqd->thread = NULL. The later io_uring_cancel_generic call in do_exit actually does nothing as we already set the task_struct->io_uring to NULL in the previous call.

Yeah, you're right, mixed it up with normal user task
cancellation, which happen in the exit path.

-- 
Pavel Begunkov


