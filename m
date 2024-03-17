Return-Path: <io-uring+bounces-1048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD0687E008
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EF65B21020
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 20:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5031BC4F;
	Sun, 17 Mar 2024 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReKmI0ty"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E1333D2
	for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710708417; cv=none; b=tm+D+HTPGLDjqnJYbqhJi1obe6hHXlwe21dQ83BzM0CuXknG/3+mqeh0bWGH+Ka5jKiRPdU3cfNuthfSwfKfBmDsZK9beX99THmHNJkUGnKRGKgZNeJeQsx82hxUA0xW9uNkqA4YyzrkvN8C9zST8KFN6AhxrVAa0o9IUn78xCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710708417; c=relaxed/simple;
	bh=MDgCBA8sn2BqqDmSaulnhbXvyp+LxBzT7I+ptZyNrgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=revFuT4vl+izKl7mvApPbQO85dy8LpuxWfCTsi7oXDBVu24V/zdwZMSx1xntZ9JCXxFFR+Mi8oSsxu7G8ApfO8ZQ69FTXTXtARXfUCHMZK5KqiBBlKRtvz373JhRT20Ctc0d/jzDXZjl53JmDLF5RYpojltNaVBKcr+dhUI6aFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ReKmI0ty; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-568aa282ccdso3216606a12.3
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 13:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710708414; x=1711313214; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KBuk2RQ4z3s2r3cUtAWtVEWBf9EGrQXlO0UpOsRYAeM=;
        b=ReKmI0tyB/7cDOlOzpfUOIvbYi4X7BxaDcZHwWNQ4D3bsDmFgMN/zIO2r0pfPxz2e1
         E0lU2GR5UtmNrOpoy+X6inXwAMPttEVb8QCYbwqAIPg6KOJL7TphxEUyv6wWo7P4LorP
         1hpC8rqBuRupPbD/NLO1rTXXmAwg2UJLm08YP3L5cXfR4FaWoPJVG7l+XHj7B7DIRJTb
         Eb7upweYXH81oMpIte8DSoO8coE9hT2oekXQEOZUsnGJWC9WGza9ztVuM+kCsmgfA2nr
         o0F7UWz6LG37L1f6j3yaq57X/PAXDFsktJyQJHq5xPk9pKRmlC0fV3TJpxYyyBGPtFyX
         D3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710708414; x=1711313214;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBuk2RQ4z3s2r3cUtAWtVEWBf9EGrQXlO0UpOsRYAeM=;
        b=ZrBe2oCbbff8VyuOGM8bdjHvahFF5w3iU9l3C/1Fnd+uPuXZYOCvSRbnuHxxO7IsHc
         C0jDk3QxEUq6BBvDGMzMmEaJwmdX3cfZ3vIxZGzwgV88wJPIxwK6xkTt9dpdVHzBvIn5
         BOEl57yL6YMaWkhLd4KSF6Qe3CzMO5caPwTXQPPuKFdWYzStVLeiyBL4QoKiPV6rSpdK
         7Eus71zvm9hF699of2G8Nvdphd5Ny32xd5vPscObAGEzdHG2quvcNetrvT0gXN3UG024
         ZtSWRdXzZYiM+6HDCow5xaOqqe/t3E8zdyhnDdJLujYgx7VUOQ8KbHlcozyDctx5qpeh
         s8kg==
X-Forwarded-Encrypted: i=1; AJvYcCUPBg/AiCExxNMEBcybEHkHcckKnkM+gW39FUiqED4rEGAOCyISnGxcFiYWqukeXb1aot4hIuwlvh5Vo0T7pRIJL/CD8RgKbOA=
X-Gm-Message-State: AOJu0YzJ/fbYT53r3jGZb36xzBFkMNn7z9ApnhHczt+zrZtksYs5vszC
	1tRYbAhD0LIMJgoLXescc15q0wTqQFQd94QW21z9yf94talooEsPbRBz+SoN
X-Google-Smtp-Source: AGHT+IF2vAJ2y1xDXhtmXx6S/mYhFJZKCqL0zRm8xve2XeG3gNxIs8/b9KCr2pybxtCQSgHnWeak3A==
X-Received: by 2002:a17:907:6d0d:b0:a46:a927:115e with SMTP id sa13-20020a1709076d0d00b00a46a927115emr3726966ejc.39.1710708413734;
        Sun, 17 Mar 2024 13:46:53 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906845900b00a4652efd795sm4106083ejy.83.2024.03.17.13.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 13:46:53 -0700 (PDT)
Message-ID: <33ac665f-97d1-45ce-ba63-3d8087175970@gmail.com>
Date: Sun, 17 Mar 2024 20:45:43 +0000
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
 <d344ee99-365d-40da-ba29-ecb953364e2b@gmail.com>
 <8487b07e-6510-409e-8939-0908cc1930d7@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8487b07e-6510-409e-8939-0908cc1930d7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 23:58, Jens Axboe wrote:
> On 3/16/24 11:42 AM, Pavel Begunkov wrote:
>> On 3/16/24 17:01, Jens Axboe wrote:
>>> On 3/16/24 10:57 AM, Pavel Begunkov wrote:
>>>> On 3/16/24 16:51, Jens Axboe wrote:
>>>>> On 3/16/24 10:46 AM, Pavel Begunkov wrote:
>>>>>> On 3/16/24 16:42, Jens Axboe wrote:
>>>>>>> On 3/16/24 10:36 AM, Pavel Begunkov wrote:
>>>>>>>> On 3/16/24 16:36, Jens Axboe wrote:
...
>>>>>>>>
>>>>>>>> It should only set REQ_F_EARLY_FAIL if we fail
>>>>>>>> _before_ prep is called
>>>>>>>
>>>>>>> I did try both ways, fails if we just have:
>>>>>>
>>>>>> Ok, but the point is that the sendzc's ->fail doesn't
>>>>>> need to be called unless you've done ->prep first.
>>>>>
>>>>> But it fails, not sure how else to say it.
>>>>
>>>> liburing tests? Which test case? If so, it should be another
>>>
>>> Like I mentioned earlier, it's send zc and it's failing the test case
>>> for that. test/send-zerocopy.t.
>>>
>>>> bug. REQ_F_NEED_CLEANUP is only set by opcodes, if a request is
>>>> terminated before ->prep is called, it means it never entered
>>>> any of the opdef callbacks and have never seen any of net.c
>>>> code, so there should be no REQ_F_NEED_CLEANUP, and so
>>>> io_sendrecv_fail() wouldn't try to set F_MORE. I don't know
>>>> what's wrong.
>>>
>>> Feel free to take a look! I do like the simplicity of the early error
>>> flag.
>>
>> ./send-zerocopy.t works fine
> 
> Huh, I wonder what I messed up. But:

My blind guess would be it called ->prep(), which is assumingly
failed, but then there was no ->fail() following it. BTW, we might
want to loose up that case, similar to mshots sendzc might decide
not to post notifications for any reason and the user should always
check F_MORE first.

>> @@ -2250,7 +2249,13 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>       int ret;
>>   
>>       ret = io_init_req(ctx, req, sqe);
>> -    if (unlikely(ret))
>> +    if (unlikely(ret)) {
>> +        req->flags |= REQ_F_UNPREPPED_FAIL;
>> +        return io_submit_fail_init(sqe, req, ret);
>> +    }
>> +
>> +    ret = def->prep(req, sqe);
>> +    if (ret)
>>           return io_submit_fail_init(sqe, req, ret);
> 
> this obviously won't compile, assuming this is not the one you ran.

Urgh, yeah, some left unstaged



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
index 846d67a9c72e..1231f8c53014 100644
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
+	ret = io_issue_defs[req->opcode].prep(req, sqe);
+	if (ret)
  		return io_submit_fail_init(sqe, req, ret);
  
  	trace_io_uring_submit_req(req);


-- 
Pavel Begunkov

