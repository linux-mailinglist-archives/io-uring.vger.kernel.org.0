Return-Path: <io-uring+bounces-1323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E6B8920C5
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0EF287003
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704EA2F50;
	Fri, 29 Mar 2024 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnnUN6ls"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D201DDFC
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727167; cv=none; b=XbhjguGGG6NvnIIM83vZQWDYC0+G4L+PZRUIz+27BsUSX7R3yfMDm601J9Zr9vimx2e6GDzCXCIK2YevcZuIUITe3M3WzNdCOInHbq0SURk1zBxrVORPTAwUec0D04wGOnpX4J42Jq54AiwGTV7QB8lBLbf26OrSPFODO84tqII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727167; c=relaxed/simple;
	bh=IlMUMfBT/dZ0FwxVL3FrfNvZTKmhRVzyXW6rkVgZBBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GHicSbF7lhrUfRknp3E/H8NvDQoTZERNEUuYmelLCJF2r/zodUn+qoMVwpwVH5Ub+2k1h7VRTe+yuX+niEFUHyaulnUPBTT0Z9oK8Uthlk52WkGEFPJ1moqy5u60AQYot2qXj2gZ/Bj5p7LbAz6Buka7uzQLbULXi9rIL17O1jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DnnUN6ls; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-56c404da0ebso3169616a12.0
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 08:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711727164; x=1712331964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/UEbRQOnzLyXzPxWmk3OOWOzS/LnOnfFV5GfppO1BRg=;
        b=DnnUN6lsnUilEzjxr32H9FzkN6gM/1F0aft12friyc9fuUSXo093dOaXO8LcwHw18l
         tX++LEzbMa09fBZgFTnjYobnoMJrUgGy6YM6EDOdMOwdDbIhZsBVRbl5dQ5GX80oJ0D6
         r0xmLHArEiRNd1ODwxRBfXQqbhl2C6QmpLgmH+IzqS9PRXMBg8/pfD+cnuYUxXQiYBRh
         gOGIQCh+Mn13QQojakQIx+PwWQXeKNSbDF7Ag6NeSWxKrc1DS7SKN5ngQBoKT1UPbA8O
         ziNsLk8v8MhJXL8CTBLtmSsEFVGCXo0j9clS0ESn7tHEM/4ZyJHYE7dsgVP6FYjMemJr
         bv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711727164; x=1712331964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/UEbRQOnzLyXzPxWmk3OOWOzS/LnOnfFV5GfppO1BRg=;
        b=pFQdvlclLfUFvVo4XqP8bqGKh8KgKfy9Gb4o/dQu6gRMbv8paTtLVRL8T4ru77thPy
         XVze0geFAdscpcFdxPRZaeuDhI32P6ch3KXAtHSV2H/Zaqo8xxEUqS0G9OFlbB7XC33j
         a92floD1AhL+ifHW8jZImsUSdi95HLy/bRrzpaH0cjNI7QgjQ9ywwXxs0APSx6t//aRb
         UAJbCS7ZpceDjPNjISgQoevKxZqsSBlym8kBZ8YXG/sANYfzsPQm79THygzqEGj51b+7
         XVDsWwSmv0Gzx1dWH/TjekdX5CCYPkWzmvWq+nAyl2ddTI7Y2NQFXM/vNwWLwCLkON75
         8mtw==
X-Forwarded-Encrypted: i=1; AJvYcCXjf+/CoOZdJeFHtY12matft6w28759d9xJQEJfNgYyJ6QHo1x1i74fJYSFGNj4io3L+RYkhpNKUpWTBwKDFYWmNhRQuiuQo4I=
X-Gm-Message-State: AOJu0Yz8SOfLI1OIPxj8hsvxFwVU1XOyu4UktgZCzEAiDl574t66tOZH
	xhANIOxkcPaLQtpUuMz9Yke7vd/CEvbKtU7JEWDpEx0My6ao6as5gwyLXNAG
X-Google-Smtp-Source: AGHT+IGyuqli5WB0fWegjhsWM5t5GcvB7q2K+AU7ppubXHyFQQLQaNNoHyYQ3PgWOfTV7g0yo5KnyQ==
X-Received: by 2002:a05:6402:348a:b0:568:9d96:b2d1 with SMTP id v10-20020a056402348a00b005689d96b2d1mr1957031edc.32.1711727163731;
        Fri, 29 Mar 2024 08:46:03 -0700 (PDT)
Received: from [192.168.8.112] ([148.252.140.106])
        by smtp.gmail.com with ESMTPSA id q14-20020a056402248e00b0056c5515c183sm1828179eda.13.2024.03.29.08.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 08:46:03 -0700 (PDT)
Message-ID: <388fe980-b5bc-4760-8287-412376a36cd3@gmail.com>
Date: Fri, 29 Mar 2024 15:46:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/msg_ring: improve handling of target CQE
 posting
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-4-axboe@kernel.dk>
 <4edaf418-2012-4f85-9984-2130235cd31c@gmail.com>
 <597e01b6-901e-41c3-85bb-fc58b5514715@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <597e01b6-901e-41c3-85bb-fc58b5514715@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 13:32, Jens Axboe wrote:
> On 3/29/24 6:54 AM, Pavel Begunkov wrote:
>> On 3/28/24 18:52, Jens Axboe wrote:
>>> Use the exported helper for queueing task_work, rather than rolling our
>>> own.
>>>
>>> This improves peak performance of message passing by about 5x in some
>>> basic testing, with 2 threads just sending messages to each other.
>>> Before this change, it was capped at around 700K/sec, with the change
>>> it's at over 4M/sec.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    io_uring/msg_ring.c | 27 ++++++++++-----------------
>>>    1 file changed, 10 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>>> index d1f66a40b4b4..e12a9e8a910a 100644
>>> --- a/io_uring/msg_ring.c
>>> +++ b/io_uring/msg_ring.c
>>> @@ -11,9 +11,9 @@
>>>    #include "io_uring.h"
>>>    #include "rsrc.h"
>>>    #include "filetable.h"
>>> +#include "refs.h"
>>>    #include "msg_ring.h"
>>>    -
>>>    /* All valid masks for MSG_RING */
>>>    #define IORING_MSG_RING_MASK        (IORING_MSG_RING_CQE_SKIP | \
>>>                        IORING_MSG_RING_FLAGS_PASS)
>>> @@ -21,7 +21,6 @@
>>>    struct io_msg {
>>>        struct file            *file;
>>>        struct file            *src_file;
>>> -    struct callback_head        tw;
>>>        u64 user_data;
>>>        u32 len;
>>>        u32 cmd;
>>> @@ -73,26 +72,20 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
>>>        return current != target_ctx->submitter_task;
>>>    }
>>>    -static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
>>> +static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
>>>    {
>>>        struct io_ring_ctx *ctx = req->file->private_data;
>>> -    struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
>>>        struct task_struct *task = READ_ONCE(ctx->submitter_task);
>>>    -    if (unlikely(!task))
>>> -        return -EOWNERDEAD;
>>> -
>>> -    init_task_work(&msg->tw, func);
>>> -    if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
>>> -        return -EOWNERDEAD;
>>> -
>>> +    __io_req_set_refcount(req, 2);
>>
>> I'd argue it's better avoid any more req refcount users, I'd be more
>> happy it it dies out completely at some point.
>>
>> Why it's even needed here? You pass it via tw to post a CQE/etc and
>> then pass it back via another tw hop to complete IIRC, the ownership
>> is clear. At least it worth a comment.
> 
> It's not, it was more documentation than anything else. But I agree that
> we should just avoid it, I'll kill it.

Great, it was confusing and I don't think it's even correct. In case
it comes with refcounting enabled you'd get only 1 ref instead of
desired 2. See how io_wq_submit_work() does it. Probably it's better
to kill the "__" set refs helper.

-- 
Pavel Begunkov

