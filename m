Return-Path: <io-uring+bounces-1025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C8A087DAB1
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D65B1C211A4
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBEA41B949;
	Sat, 16 Mar 2024 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sPo3bfGc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63D71A702
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710605653; cv=none; b=AXhSIrNAuKYdk01cbru+kcufG4Hs7w4C5GmtcH0EHoxhK7qdCwTY0tvGUNhZv21tbWM5WY5YlKCEOdZIwqQO7kqsk3pMLrxksAiiN6TGIZr/2NVSWf6cZQAlVX29fKqk5CTtHjT/E06yqCPg0BHHJGwXCYzcIze98Z+fN2vnErk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710605653; c=relaxed/simple;
	bh=Nfq+UT/oNnKb5vk0R1+zRuTDnVZdf6zKZVzZBaYfGfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Gm3Jox1ouRr7dcLhejkjSCdchgH87ODIete+fKu4ZmcIjKFaULhwoTzFY02N03JpRfLMqVZJhLzBWiwz9kicFt8psdnFZW+UOMdT3sxT1lrRm5vyf51KYP+M4c8qZIENQXA/RmKJ1b1W3hsjD5bNBGsmJj1OJqk9WejuSCmkOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sPo3bfGc; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dee6672526so2803445ad.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710605651; x=1711210451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EemyXo1L4J+rM6YeUNP6XPsjId+Q25jtES+gkv8dJyQ=;
        b=sPo3bfGcz+zXF7PxU7vyXsyhWgJnzuS9bPx/PZMZdJ2bniqcQhHCuIJEPsrTH//K+7
         3vML1Y8qqkfdKCCWsWY7tpuoXWRGwTIg2RZa7M0ozu73fwrvFnI5aH1vm9eRuKkN1ECA
         qh0zwU3yqBG/IVMAbYPniZmXdJO0w7+pwG4lDhxukOPODBe7/MEXGCf3cIoaaR84SYSR
         BVLRFuMC2o5HeNahE4Cx19taQjhZ0RiD9FQuPVnj5d0f5++22La9MW+ksJGbiVw719dq
         plB673YBPpOA5VmrYAolchAHZpXuBaH7rUoKM/1zDc+2fyb+/sWgD6KzCjQ6SJ2zJOVb
         oM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710605651; x=1711210451;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EemyXo1L4J+rM6YeUNP6XPsjId+Q25jtES+gkv8dJyQ=;
        b=SioPhFl0K7tdi023xEKJ9dn78Fvn/cifQhOCieZ+JzrEtyx0ztx8YkL2u2IdLyK8Z3
         rggOoJr3iQZMB71oC7e+a1G6IhKL2tshiyjUw+qV7afyhimiVJ+o9/Txd/5Vtyov2Lnw
         nWyuXpwmVj/7YA9CeFDuXLWWFy+pvDZYJJNStO4KQ5zHxSTbeqU/EOJ8B756OSWyMo4Q
         Om4tpZv/fq0AOsW4ilhT4g5H6mDijdeKM0OtYTUmWv7+Y1Q/RawW/9Rv0bGrcFi93CDP
         POS4A73c/D69njCCVhO/lGaXxtDTxF253kPT+1qe4SRKnBf5f+bVX3vLuSA9P9PPn0s6
         zjrA==
X-Forwarded-Encrypted: i=1; AJvYcCWjcOujWPzmXowFBJTBoxUpfoh2mXIE0EnrZ10QsTVbI7RpV8s7eP2/x4qPXeThPld/sIoKpOW8UQyDvVd4iGJjjFH0Ik/tNwI=
X-Gm-Message-State: AOJu0YwRxS0BZPfsJAWuzkwZE4+KEHo0s/qKv42yX/3LgkTca95o4zZT
	3wB6JZ5CWi76Y5ke/oBi6cu+j2ZmBcZaIRN7NemsRASAN+7qQ5knHNwJGvU9GTE=
X-Google-Smtp-Source: AGHT+IHuUPzqNKkQM/Ql6H+aUqk8u71oJk/SzNHvlh021GsQyUxybCkS8wTI89o93aNNW+N+lDOBCw==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr7614348plg.2.1710605650921;
        Sat, 16 Mar 2024 09:14:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ie15-20020a17090b400f00b0029de90f4d44sm4026713pjb.9.2024.03.16.09.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:14:10 -0700 (PDT)
Message-ID: <083d800c-34b0-4947-b6d1-b477f147e129@kernel.dk>
Date: Sat, 16 Mar 2024 10:14:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
 <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
 <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
 <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 5:28 PM, Pavel Begunkov wrote:
> On 3/15/24 23:25, Jens Axboe wrote:
>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>> potential errors, but we need to cover the async setup too.
>>>>>
>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>> off of an early submission failure path where def->prep has
>>>>> not yet been called, I don't think the patch will fix the
>>>>> problem.
>>>>>
>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>> [...]
>>>>>            def->fail(req);
>>>>>        io_req_complete_defer(req);
>>>>>    }
>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>            }
>>>>>            req->flags |= REQ_F_CREDS;
>>>>>        }
>>>>> -
>>>>> -    return def->prep(req, sqe);
>>>>> +    return 0;
>>>>>    }
>>>>>
>>>>>    static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>        int ret;
>>>>>
>>>>>        ret = io_init_req(ctx, req, sqe);
>>>>> -    if (unlikely(ret))
>>>>> +    if (unlikely(ret)) {
>>>>> +fail:
>>>
>>> Obvious the diff is crap, but still bugging me enough to write
>>> that the label should've been one line below, otherwise we'd
>>> flag after ->prep as well.
>>
>> It certainly needs testing :-)
>>
>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>> and hopefully not have to worry about it again. Do you want to clean it
>> up, test it, and send it out?
> 
> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
> report w/o fiddling with done_io as in your patch.

I gave this a shot, but some fail handlers do want to get called. But
they can't use sr->done_io at that point. I'll ponder this a bit and see
what the best generic solution is.

-- 
Jens Axboe


