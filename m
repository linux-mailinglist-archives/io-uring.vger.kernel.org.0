Return-Path: <io-uring+bounces-1027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC38C87DAD2
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66D4E1F2196E
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D7918C36;
	Sat, 16 Mar 2024 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuHpcuBU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F881BC5C
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710606608; cv=none; b=biqrHJPhQTV0cKq0GgpwhQf3NEajNkEXcna0IoenwFXwvHH+04FYQvFmeKYjH0SXa0ZYT8tSgcVya4HrcMy+805ZhmGn6tJM6e7Jbc8Puex+UZmRNfGmmu2rHkI3VK50f8I5P6r+rY0ZK8kZLTs4H4ud72pNamm54PI0GNjf+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710606608; c=relaxed/simple;
	bh=8SCHC7q+IIpGf5AtsLkJstM3IR33MhLfMTdzNDq+rhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ssxNREWNmIElsnXyYzguHBqrqztyTAoI2QGtjG/gxp/i3PbNBhRi5ac5u/K8H/Z1gBlyvXeOOKUbtYgKcCl/VIKLLJnyuIByTBul4snu3YjeI75ijgPEm2Ikh4HDHhy3tA7HBhtWX8JWMRXpgC637DsnEr6Epq8XWn7+4YPXRww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuHpcuBU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-41405d77c7bso6951415e9.3
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710606605; x=1711211405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6L8Dn0/wRJxtHVzVI0GlxGw4gGxdVi7iIYIU3w8wIFU=;
        b=WuHpcuBUEH4o51nrLESn3Co3oo4l2mQGa5xmwIXqub7si7XbS0cJgAFCE5A0jZnaxo
         A1has+i5Fpn+NGwIrp9jl9adSdKO/963kbxu6DJFKVNMTRR8JLCABscpSGsHqZJDHRhN
         PPWp6vcHUdZO34xeBpNIzi5i0u625A2pVCfkbfyVRwjl3IzDYe1wrWUKSEqD9DrCZHZP
         FiNE8TubhJ5Yqo3zCGlgPwRvLhLi7SCi2OCERy01y7DVysZtuHe54cNQBq3U+Bm0FxEX
         DxKpqveEQcExJutRa0Sq54Wa8tetTay4i4oTCIlyC1y4gByR20dMCa2R2jP2WK1VTB3c
         69Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710606605; x=1711211405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6L8Dn0/wRJxtHVzVI0GlxGw4gGxdVi7iIYIU3w8wIFU=;
        b=iSoOXTWMN8Kl7OntfwTMT4nI8ueddv+ESPBje4yLhz0CKV3iswW63sG1twTAvvzWQn
         pHU8+Llu3SeqmvWIv0cVsMrt+r7q4iiOPkimIgVvPjPtHHmfh3mQUyomgx+ZaEQFKm2C
         Oz4JbxWHUmlzxok9csTQn0L/uo/brjsSXKNeW0DEuj3KO9gAvKsX51gp/W1l/u4W5XZ3
         EZ6vc3d/ddAG2YOp5KLfr7RFG/VaehZSrGgP5+aB8DzkEzpNB2FsbcAg24LK/uGzSKww
         SNAQJOszlTmv+8d6Q3DIMXyXb0BqJeio58XnLxwpEH6yhWkR03yT92A5MoTYxgz4OYlb
         2jFg==
X-Forwarded-Encrypted: i=1; AJvYcCWkq0FF4Kps7IDql2QGEcZo4B3VCoyi1QocHnwiS3xfGReAvqjZ/etnqnf2vc3K+gtR98FpncLpijWZAuKA2XqpMrLxCDM1WGQ=
X-Gm-Message-State: AOJu0Ywxr7JUXKynVMJI1EbCsDbZpSrzwg1OQF5VXF/E9xOv031mrjBa
	gL11YY3a+VmlwOFV/Ljvy7troOV3co0Ro01p4hE82jvHF0yD3pYDgiUQ9Gdq
X-Google-Smtp-Source: AGHT+IGZau5Gf9m+QyF5W+/2o/HRR0TQ16XQjebaJnIqfb0iEmYgqfFsFnaEbeI2/l9S8eR2TGeTAg==
X-Received: by 2002:a05:6000:d49:b0:33e:6cce:c2ea with SMTP id du9-20020a0560000d4900b0033e6ccec2eamr6014608wrb.51.1710606605035;
        Sat, 16 Mar 2024 09:30:05 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id u8-20020a056000038800b0033ec9007bacsm1290103wrf.20.2024.03.16.09.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:30:04 -0700 (PDT)
Message-ID: <aae54a98-3302-477f-be3f-39841c1b20d4@gmail.com>
Date: Sat, 16 Mar 2024 16:28:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
 <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
 <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
 <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
 <083d800c-34b0-4947-b6d1-b477f147e129@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <083d800c-34b0-4947-b6d1-b477f147e129@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 16:14, Jens Axboe wrote:
> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>> On 3/15/24 23:25, Jens Axboe wrote:
>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>
>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>> off of an early submission failure path where def->prep has
>>>>>> not yet been called, I don't think the patch will fix the
>>>>>> problem.
>>>>>>
>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>> [...]
>>>>>>             def->fail(req);
>>>>>>         io_req_complete_defer(req);
>>>>>>     }
>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>             }
>>>>>>             req->flags |= REQ_F_CREDS;
>>>>>>         }
>>>>>> -
>>>>>> -    return def->prep(req, sqe);
>>>>>> +    return 0;
>>>>>>     }
>>>>>>
>>>>>>     static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>         int ret;
>>>>>>
>>>>>>         ret = io_init_req(ctx, req, sqe);
>>>>>> -    if (unlikely(ret))
>>>>>> +    if (unlikely(ret)) {
>>>>>> +fail:
>>>>
>>>> Obvious the diff is crap, but still bugging me enough to write
>>>> that the label should've been one line below, otherwise we'd
>>>> flag after ->prep as well.
>>>
>>> It certainly needs testing :-)
>>>
>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>> and hopefully not have to worry about it again. Do you want to clean it
>>> up, test it, and send it out?
>>
>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>> report w/o fiddling with done_io as in your patch.
> 
> I gave this a shot, but some fail handlers do want to get called. But

Which one and/or which part of it?

> they can't use sr->done_io at that point. I'll ponder this a bit and see
> what the best generic solution is.

-- 
Pavel Begunkov

