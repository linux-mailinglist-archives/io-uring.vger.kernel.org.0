Return-Path: <io-uring+bounces-1046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D665B87DB1E
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 634751F22174
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6065618EA1;
	Sat, 16 Mar 2024 17:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3xjNKCa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7391C684
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710611067; cv=none; b=Fcgvpr5dpiXCEByDihGfd0gapD8XqShQZTRrEoe7duydlRUT6z2uoIczzGC+4lmZgG/z5sj441NRwr5g0XbdX/fnU3D8PmW57Cm/5ybIsqg1EzD0iYoJ4mDmeQJIL5obkDNqAbCfpgrzYZAIRXWSTmlgh3lowU+wOBbzL24HKls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710611067; c=relaxed/simple;
	bh=sk0EUxVsEQpPNO1u0Bakw4WrRHOwRy/0mfv2hLLE2IA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uUn82Q4456xzSbgXE3j+cdk4LU+BzC/r8JYz3m53+WGOHFOqGi85Wx0NiVr2v2dzcTh94xeFYY/ffzofRZu9H73ctt5FR/SsOf+VcolPeCyPSxxbsgZwCMB0+EmSXzaVETZxu4rrm1dupU9qIuaLTP9ZcfoBbuTe5ZdZK0S78as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d3xjNKCa; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41409c98fb9so2105945e9.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710611064; x=1711215864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JmDVMWskPdcrS3b69aLn6jskbqxqB5UQlbo2E5H5NkA=;
        b=d3xjNKCaXDt7wGXMsqgLAlBaHRr8ne8A/luVXpUntryguc9hVd4PxIdtQBN68vgKNv
         HR8LCQrnfMwwan55qZVqke5nbRIgmkFEjQcGeZY4SI8Xl5K0o+PDxEz1NVMkyxDskhdM
         RQZX9FxRa3KaDwr4/rU6U0+DfKAeDBR2x8RROwVQytxEowqsFDrXc7W2VXQMihXeEKWQ
         kseGeLtaNp2ZM/SlF5jJYSXAk9NzRzN0KYnwN/NpVrd0dEg5jcwdw10UD9O4FcLCRc+f
         uQfsm09emFO0d7YMV6vQ6daaEnFLapyutjvjDgUZjvpd8FVCBRHf982RTUXS3CJYF/4O
         qC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710611064; x=1711215864;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JmDVMWskPdcrS3b69aLn6jskbqxqB5UQlbo2E5H5NkA=;
        b=knddc18D8/x0wbCqzXdr0KMwxrxGlSlXB8DLz0fJ4E3eEzGd83R00/x0DNE1Dl8KWp
         VUKS9krHtrm0f0qiYWXaPCHewN0+LH/7jhm5FjpLpj9I+AIHmrIZbLv/u+tapI9lA62+
         tCrIs7Gd9ej6I/G0HRF1zJ8lRmvZUp0sKUNcQYCSrRquBFnrxljdKCI6deI1MnHhI35t
         qJOrCBgGF4leTuu/Jnr3l30u34hyyneP38ab1f3QlyBlGc5d2Hiuah6RrQmNT8QcIG9P
         n8mHSsy37OFJYQjyK/D6sYgFAb/yu3g43bFzG5Hw57T/0bEz+hvMgI97X1Vy/fRjinvV
         TWEA==
X-Forwarded-Encrypted: i=1; AJvYcCVBI/Jz17fTCSG3fp8S74X6hkf+E95VlnMOPahgXQ2ksCrfLRZRI9jc3OO/dADEEPbP4hhg4HQRU9GmX7ubgfbQuK9Z8tMOZZg=
X-Gm-Message-State: AOJu0YyK2G4F+V7ESwAPzxt/uLG9LjuxGgSRIIYJ4IFLFF+v/LLQCwg5
	l7YpTStCgHXDAMAXt8BPdhi7cZ/7lkq5Q9Wu9KuJafL0qwNTC5/g
X-Google-Smtp-Source: AGHT+IEU+KCkuy/DbbLfmksUoDBh21S9akLDsl1lReXHEifGW1nOPzHsQ8MyJBfypYh/9uW5vj4ujg==
X-Received: by 2002:adf:f287:0:b0:33e:7c19:dec8 with SMTP id k7-20020adff287000000b0033e7c19dec8mr4693899wro.21.1710611063493;
        Sat, 16 Mar 2024 10:44:23 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id l21-20020a056000023500b0033ec312cd8asm5860517wrz.33.2024.03.16.10.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 10:44:23 -0700 (PDT)
Message-ID: <d344ee99-365d-40da-ba29-ecb953364e2b@gmail.com>
Date: Sat, 16 Mar 2024 17:42:18 +0000
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
 <30535d27-7979-4aa9-b8f7-e35eb51dedb0@gmail.com>
 <0f3bc43a-7533-40b2-b9c8-615abf4f81c1@kernel.dk>
 <34586d43-2553-402e-b53b-a34b51c8f550@gmail.com>
 <a7d4d0d6-1b0f-4618-8c87-b831e653993c@kernel.dk>
 <fe6e491c-f661-45db-90aa-f58cf9032cb4@gmail.com>
 <c2e551c2-446e-4f83-89b2-ccdfa6438ce0@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c2e551c2-446e-4f83-89b2-ccdfa6438ce0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 17:01, Jens Axboe wrote:
> On 3/16/24 10:57 AM, Pavel Begunkov wrote:
>> On 3/16/24 16:51, Jens Axboe wrote:
>>> On 3/16/24 10:46 AM, Pavel Begunkov wrote:
>>>> On 3/16/24 16:42, Jens Axboe wrote:
>>>>> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>>>>>> On 3/16/24 16:36, Jens Axboe wrote:
>>>>>>> On 3/16/24 10:32 AM, Pavel Begunkov wrote:
>>>>>>>> On 3/16/24 16:31, Jens Axboe wrote:
>>>>>>>>> On 3/16/24 10:28 AM, Pavel Begunkov wrote:
>>>>>>>>>> On 3/16/24 16:14, Jens Axboe wrote:
>>>>>>>>>>> On 3/15/24 5:28 PM, Pavel Begunkov wrote:
>>>>>>>>>>>> On 3/15/24 23:25, Jens Axboe wrote:
>>>>>>>>>>>>> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>>>>>>>>>>>>>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>>>>>>>>>>>>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>>>>>>>>>>>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>>>>>>>>>>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>>>>>>>>>>>>>> async handlers. But if we then fail setting it up and want to post
>>>>>>>>>>>>>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>>>>>>>>>>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>>>>>>>>>>>>>> potential errors, but we need to cover the async setup too.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>>>>>>>>>>>>>> off of an early submission failure path where def->prep has
>>>>>>>>>>>>>>>> not yet been called, I don't think the patch will fix the
>>>>>>>>>>>>>>>> problem.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ->fail() handlers are fragile, maybe we should skip them
>>>>>>>>>>>>>>>> if def->prep() wasn't called. Not even compile tested:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>>>>>> index 846d67a9c72e..56eed1490571 100644
>>>>>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>>>> [...]
>>>>>>>>>>>>>>>>                  def->fail(req);
>>>>>>>>>>>>>>>>              io_req_complete_defer(req);
>>>>>>>>>>>>>>>>          }
>>>>>>>>>>>>>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>>>                  }
>>>>>>>>>>>>>>>>                  req->flags |= REQ_F_CREDS;
>>>>>>>>>>>>>>>>              }
>>>>>>>>>>>>>>>> -
>>>>>>>>>>>>>>>> -    return def->prep(req, sqe);
>>>>>>>>>>>>>>>> +    return 0;
>>>>>>>>>>>>>>>>          }
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>          static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>>>>>>>>>>>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>>>>>>>>>>>>>              int ret;
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>              ret = io_init_req(ctx, req, sqe);
>>>>>>>>>>>>>>>> -    if (unlikely(ret))
>>>>>>>>>>>>>>>> +    if (unlikely(ret)) {
>>>>>>>>>>>>>>>> +fail:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Obvious the diff is crap, but still bugging me enough to write
>>>>>>>>>>>>>> that the label should've been one line below, otherwise we'd
>>>>>>>>>>>>>> flag after ->prep as well.
>>>>>>>>>>>>>
>>>>>>>>>>>>> It certainly needs testing :-)
>>>>>>>>>>>>>
>>>>>>>>>>>>> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
>>>>>>>>>>>>> and hopefully not have to worry about it again. Do you want to clean it
>>>>>>>>>>>>> up, test it, and send it out?
>>>>>>>>>>>>
>>>>>>>>>>>> I'd rather leave it to you, I suspect it wouldn't fix the syzbot
>>>>>>>>>>>> report w/o fiddling with done_io as in your patch.
>>>>>>>>>>>
>>>>>>>>>>> I gave this a shot, but some fail handlers do want to get called. But
>>>>>>>>>>
>>>>>>>>>> Which one and/or which part of it?
>>>>>>>>>
>>>>>>>>> send zc
>>>>>>>>
>>>>>>>> I don't think so. If prep wasn't called there wouldn't be
>>>>>>>> a notif allocated, and so no F_MORE required. If you take
>>>>>>>> at the code path it's under REQ_F_NEED_CLEANUP, which is only
>>>>>>>> set by opcode handlers
>>>>>>>
>>>>>>> I'm not making this up, your test case will literally fail as it doesn't
>>>>>>> get to flag MORE for that case. FWIW, this was done with EARLY_FAIL
>>>>>>> being flagged, and failing if we fail during or before prep.
>>>>>>
>>>>>> Maybe the test is too strict, but your approach is different
>>>>>> from what I mentioned yesterday
>>>>>>
>>>>>> -    return def->prep(req, sqe);
>>>>>> +    ret = def->prep(req, sqe);
>>>>>> +    if (unlikely(ret)) {
>>>>>> +        req->flags |= REQ_F_EARLY_FAIL;
>>>>>> +        return ret;
>>>>>> +    }
>>>>>> +
>>>>>> +    return 0;
>>>>>>
>>>>>> It should only set REQ_F_EARLY_FAIL if we fail
>>>>>> _before_ prep is called
>>>>>
>>>>> I did try both ways, fails if we just have:
>>>>
>>>> Ok, but the point is that the sendzc's ->fail doesn't
>>>> need to be called unless you've done ->prep first.
>>>
>>> But it fails, not sure how else to say it.
>>
>> liburing tests? Which test case? If so, it should be another
> 
> Like I mentioned earlier, it's send zc and it's failing the test case
> for that. test/send-zerocopy.t.
> 
>> bug. REQ_F_NEED_CLEANUP is only set by opcodes, if a request is
>> terminated before ->prep is called, it means it never entered
>> any of the opdef callbacks and have never seen any of net.c
>> code, so there should be no REQ_F_NEED_CLEANUP, and so
>> io_sendrecv_fail() wouldn't try to set F_MORE. I don't know
>> what's wrong.
> 
> Feel free to take a look! I do like the simplicity of the early error
> flag.

./send-zerocopy.t works fine


diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ea7e5488b3be..de3a2c67c4a7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -478,6 +478,7 @@ enum {
  	REQ_F_CAN_POLL_BIT,
  	REQ_F_BL_EMPTY_BIT,
  	REQ_F_BL_NO_RECYCLE_BIT,
+	REQ_F_UNPREPPED_FAIL_BIT,
  
  	/* not a real bit, just to check we're not overflowing the space */
  	__REQ_F_LAST_BIT,
@@ -556,6 +557,8 @@ enum {
  	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
  	/* don't recycle provided buffers for this request */
  	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
+
+	REQ_F_UNPREPPED_FAIL	= IO_REQ_FLAG(REQ_F_UNPREPPED_FAIL_BIT),
  };
  
  typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 846d67a9c72e..6523fa4c5630 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -993,7 +993,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
  
  	req_set_fail(req);
  	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
-	if (def->fail)
+	if (!(req->flags & REQ_F_UNPREPPED_FAIL) && def->fail)
  		def->fail(req);
  	io_req_complete_defer(req);
  }
@@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
  		}
  		req->flags |= REQ_F_CREDS;
  	}
-
-	return def->prep(req, sqe);
+	return 0;
  }
  
  static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
@@ -2250,7 +2249,13 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
  	int ret;
  
  	ret = io_init_req(ctx, req, sqe);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		req->flags |= REQ_F_UNPREPPED_FAIL;
+		return io_submit_fail_init(sqe, req, ret);
+	}
+
+	ret = def->prep(req, sqe);
+	if (ret)
  		return io_submit_fail_init(sqe, req, ret);
  
  	trace_io_uring_submit_req(req);


-- 
Pavel Begunkov

