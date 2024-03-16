Return-Path: <io-uring+bounces-1029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1DA87DAD6
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D25CA281DFC
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0E51172C;
	Sat, 16 Mar 2024 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJ3wuE89"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378AB1B952
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710606851; cv=none; b=ncCoZWxnfthdnxB01JQnW0AQTbcjj1wXoLUM41l/3LKJkqrWYXU/tDUW0iSf/hsc9m41QSbyIVScjYWuWpeLYJJ/e/d3adkaPcVr9kjo6WWUonswcgDgtoCUoEuGSHMIjTaE5kD2Fr07FiZtMrP2iJp1pRJcm75d9+AMOEh7Wh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710606851; c=relaxed/simple;
	bh=N2++aCRyO1lQnyoiL4cK//jcQJtdJCEjX66q9FgBeAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fMyuQR41ljSyFCIRfXHKj4Z2IpuCG2m7z0aqovFo3AnNoFMJvVzxxG7LyvBbzMz9D5tkpnyKd9Hh2wA1Ilqbqf0YGP8z5UK9p4OpwGCkkhiLlfvo2Zy1oc77j3nPkguvUUM8RVpE58scbDhYZPCKOdMFeHsH8QZHsDus0o/M+as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJ3wuE89; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4140870914fso3361395e9.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710606848; x=1711211648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xa5dLc4UAWBLH3qfJ1No8aTypzhWPtRONv+P9ixBOfg=;
        b=mJ3wuE89dom314fhXGtuP4EFIMf0bTdWkktHAYiCOD7EZR+8p0TA6rB2HpxRRGXlrg
         srbuKf0ktQURtl0oYJ7sfkajZctWGuq/LE/e6FKK/4ShPxrGjtw7CbpIRnB+FRNYOwWM
         eISDdlDIM82RwvwPDc0bXnl8VHPiPS69W7tyIZv88kA2GX0GiGy/prxUorX5hQ73Kbki
         u9TowV7xGIpZGXUg63c5TwOEe0QFeFCkOtmo/6uooBg1rbg7MppsP99uJWFyzfqELCKh
         LDSEubCHK3p3Z1dbGDb2P3NhnjkLysjB5jkAxbd+OLFUf79+5sNpWf0z2sfxVy9Awtit
         oAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710606848; x=1711211648;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xa5dLc4UAWBLH3qfJ1No8aTypzhWPtRONv+P9ixBOfg=;
        b=LXQmPwWTg31pdd/tJynxKYgloVmH/FVEEd2U5zCTvEQ/Fus6pLUzxAvUc801Zvpiiz
         NQQMOwhlNGahiR+VHmcUpSzH4gkI/oOwci9+5y/ISkT5/Fq71zr3AFAvtZNwWfzYzw9y
         OkM89ZCXCdLM9IuN8CU1LubmtfEdNYvr8nDmwzQLvMz/prfTLDwwcl9wZ1JPLnhmDJhN
         5k0LAD2KC0PVsyiKmjiFdWdp+FjfftctddkRjvJD3O46LxcMPyz4n18vXfwMPq3OswNf
         8qG5hrhAcxRtLm0fumujOg/pbXvaOPcX903e6KMuIDYviYnByySz5rzcH+SgwLihNGsK
         ZROw==
X-Forwarded-Encrypted: i=1; AJvYcCVvdSthOofPdVAlhhXuNyH4c9uMj6o+iTXUwqv+TX17OqLNI7gcfqq9pYWegwiJLIJN/w+EycHIzO8SO/4OLeowgeR9XKI2xVM=
X-Gm-Message-State: AOJu0YysnNzU/rZgCRYVT8UvruHsbs2w7BMI5y8gDMVaLAVCZGsQZ2zQ
	CcQVPXrM7HUDyo39RrajjokFOa4cw0TSQkng0kjOi7gRsnoc6sMN
X-Google-Smtp-Source: AGHT+IFGz/2MSPfB5utLJ5g7GyW4Ob4tamnnIUxmSVmGRUEil/n8SUC9qGDgYKk0l7MiBEnfbbG8dQ==
X-Received: by 2002:a05:600c:524a:b0:414:24f:f5ae with SMTP id fc10-20020a05600c524a00b00414024ff5aemr3428369wmb.24.1710606848300;
        Sat, 16 Mar 2024 09:34:08 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id o9-20020adfe809000000b0033ec6ebf878sm5672802wrm.93.2024.03.16.09.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:34:08 -0700 (PDT)
Message-ID: <6affbea3-c723-4080-b55d-49a4fbedce70@gmail.com>
Date: Sat, 16 Mar 2024 16:32:10 +0000
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
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
 <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
 <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
 <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
 <083d800c-34b0-4947-b6d1-b477f147e129@kernel.dk>
 <aae54a98-3302-477f-be3f-39841c1b20d4@gmail.com>
 <1e595d4b-6688-4193-9bf7-448590a77cdc@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1e595d4b-6688-4193-9bf7-448590a77cdc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/16/24 16:31, Jens Axboe wrote:
> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>> On 3/16/24 16:14, Jens Axboe wrote:
>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>
>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>> problem.
>>>>>>>>
>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>
>>>>>>>>
>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>> [...]
>>>>>>>>              def->fail(req);
>>>>>>>>          io_req_complete_defer(req);
>>>>>>>>      }
>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>              }
>>>>>>>>              req->flags |= REQ_F_CREDS;
>>>>>>>>          }
>>>>>>>> -
>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>
>>>>>>>>      static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>          int ret;
>>>>>>>>
>>>>>>>>          ret = io_init_req(ctx, req, sqe);
>>>>>>>> -    if (unlikely(ret))
>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>> +fail:
>>>>>>
>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>> that the label should've been one line below, otherwise we'd
>>>>>> flag after ->prep as well.
>>>>>
>>>>> It certainly needs testing :-)
>>>>>
>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>> up, test it, and send it out?
>>>>
>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>> report w/o fiddling with done_io as in your patch.
>>>
>>> I gave this a shot, but some fail handlers do want to get called. But
>>
>> Which one and/or which part of it?
> 
> send zc

I don't think so. If prep wasn't called there wouldn't be
a notif allocated, and so no F_MORE required. If you take
at the code path it's under REQ_F_NEED_CLEANUP, which is only
set by opcode handlers


> 
> I think the sanest is:
> 
> 1) Opcode handlers should always initialize whatever they need before
>     failure
> 2) If we fail before ->prep, don't call ->fail
> 
> Yes that doesn't cover the case where opcode handlers do stupid things
> like use opcode members in fail if they fail the prep, but that should
> be the smallest part.
> 

-- 
Pavel Begunkov

