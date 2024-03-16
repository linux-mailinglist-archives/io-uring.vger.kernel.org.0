Return-Path: <io-uring+bounces-1033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A8987DADC
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 923D2281DE3
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF351199B4;
	Sat, 16 Mar 2024 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KW27Xtj/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AEE18C36
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710607134; cv=none; b=PKintwvuKB/3udmckSzEEGyfIc7vty6ZvkGAfjzA7FFhY9ID95vTOB5vAA7946WkVHHANV4M4W5XmwFU0gBKRKnQS5HDSM1/7vg4WDcaZhjN5Wz5gRGeHRT/UK5fldM9FB+IdidGDcowC6//3vj3zqjvb0KPQQJCyPJJ/BEeVH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710607134; c=relaxed/simple;
	bh=3SVmCbgb2upEAImYPiCULMHEpygtX6CarTWjSzsH344=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PzK0lsHsIxCjUyUoN4jUGBX3EN3k1ezHrB+gcH1/m5FHfSxLBWNws3dorVduhHOowiG1POdseQ954uH4J8xWvk65NKoxKHLMafAiE9l1hr905QO/OdPOqaLVGhm1xe/5WTneuXSWDcWd/1TckQfYgNLvhAI8Z+P3PptUtiokYXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KW27Xtj/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33ec7e38b84so1751621f8f.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710607131; x=1711211931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6vYnsD35mlF/IGd/xXqA65wNE3pSZGPvKHF0AQXS8GU=;
        b=KW27Xtj/XRYrGb3sRV0YXXzUZB1VgmNkXJIXi+5xP1THVQSZSNGyJ5cXYtnRAc+8G3
         biHmaLHghyiRRmD0Zu1dxI/P9FRTswXYN4RYoVATxQa/LtigFdD57k1FWteq/orO6OBg
         ssU4TB2wvwG4xHZxwOklumU5FyVvBq7pMr/5LPlfH6ywK/xxxWqn4XDRC6lZVHbA6qjH
         x5l3t48+JTTiexnBcuVwT8ScVBlaetFhCO5olRDJ6AUOLONpdN2/HbjbXTPQzKMjys1C
         ExZTwcrOUTyRwsslGW+JPnwOveFJHLl/WkZUSXbxFWsNLiCdsi6SLzpAdwDmn2FXuBGK
         rSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710607131; x=1711211931;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6vYnsD35mlF/IGd/xXqA65wNE3pSZGPvKHF0AQXS8GU=;
        b=JQ8Lq8wGZ5rDJ5lW129MifG8masQdwBJ5/YaBY79Crx2WQoEjp1eah955P0Ai7F3hQ
         Aoe5zUQRLif32vCrxx8aHYLAMUpFula39v6BLOH31fueZeJhia+d7l79afJS/HOn2CEQ
         Sz3a5WD7QfUJSDd/sysLJjEjVLsM0K/6yqt9q2PuLFIG/rFRNo1PVfdbyP5E3/B21cNn
         RQf6Orra8v49LpF8fVNWeFKUaQq1axMLqC8xzTk+BcbSSXxg/kRrzmrbHG48VXAOvkls
         iROztTSJ9PqTtkJh1MrcWCiTd7+8/173UXFnXRp3DBqbGyT/mPOyAdIAKONIErsLVHjR
         +hrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQojgQAGEVdZ+EejHYcxsZEJfJwKtJRnGUBA4Tl6HlZM+qeNIzz9nG3nI0xg4ZwSfYGs4NpxHdKYtrkVIgVuaf3VShwv6ZzWI=
X-Gm-Message-State: AOJu0Yw+uY01JaYZdbxGPqqCkC1biYSKS+JHiXRB3diC22bd9ZxUWc2C
	XOUOgt0R6bv/fZBzFjlLb6Q7rFNOPJuYgQBhiYHSBc7f51Nnb6EjOn2A52T4
X-Google-Smtp-Source: AGHT+IHV2+3QSK08+gPPnSeEBjlryk2L8Eya0CRV2aVExafwLYRQArm1+QXePaY9/lOFaQFGyprzBw==
X-Received: by 2002:adf:f6c1:0:b0:33d:5f98:82e3 with SMTP id y1-20020adff6c1000000b0033d5f9882e3mr5538179wrp.13.1710607131170;
        Sat, 16 Mar 2024 09:38:51 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id v3-20020adfe4c3000000b0033e052be14fsm5722103wrm.98.2024.03.16.09.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:38:50 -0700 (PDT)
Message-ID: <30535d27-7979-4aa9-b8f7-e35eb51dedb0@gmail.com>
Date: Sat, 16 Mar 2024 16:36:52 +0000
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
 <6affbea3-c723-4080-b55d-49a4fbedce70@gmail.com>
 <0224b8e1-9692-4682-8b15-16a1d422c8b2@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0224b8e1-9692-4682-8b15-16a1d422c8b2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 16:36, Jens Axboe wrote:
> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>> On 3/16/24 16:31, Jens Axboe wrote:
>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>
>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>> problem.
>>>>>>>>>>
>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>> [...]
>>>>>>>>>>               def->fail(req);
>>>>>>>>>>           io_req_complete_defer(req);
>>>>>>>>>>       }
>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>               }
>>>>>>>>>>               req->flags |= REQ_F_CREDS;
>>>>>>>>>>           }
>>>>>>>>>> -
>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>> +    return 0;
>>>>>>>>>>       }
>>>>>>>>>>
>>>>>>>>>>       static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>           int ret;
>>>>>>>>>>
>>>>>>>>>>           ret = io_init_req(ctx, req, sqe);
>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>> +fail:
>>>>>>>>
>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>> flag after ->prep as well.
>>>>>>>
>>>>>>> It certainly needs testing :-)
>>>>>>>
>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>> up, test it, and send it out?
>>>>>>
>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>
>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>
>>>> Which one and/or which part of it?
>>>
>>> send zc
>>
>> I don't think so. If prep wasn't called there wouldn't be
>> a notif allocated, and so no F_MORE required. If you take
>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>> set by opcode handlers
> 
> I'm not making this up, your test case will literally fail as it doesn't
> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
> being flagged, and failing if we fail during or before prep.

Maybe the test is too strict, but your approach is different
from what I mentioned yesterday

-	return def->prep(req, sqe);
+	ret = def->prep(req, sqe);
+	if (unlikely(ret)) {
+		req->flags |= REQ_F_EARLY_FAIL;
+		return ret;
+	}
+
+	return 0;

It should only set REQ_F_EARLY_FAIL if we fail
_before_ prep is called

-- 
Pavel Begunkov

