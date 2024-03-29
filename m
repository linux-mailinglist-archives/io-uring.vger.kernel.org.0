Return-Path: <io-uring+bounces-1325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4F98920D0
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60C8C286615
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053A01C0DD4;
	Fri, 29 Mar 2024 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nO53dsBe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52032032A
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 15:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727277; cv=none; b=i6DD3Dzv72YXwRTKOWKwF30DfiRrtL2ST+Rc3FShIoeWLjWts1JqOnx7pqnOpm02SlTAzF2mwFmW+R1dFfSh8c7gq9SGTRJDEHuavKV9u9PKl8rh/M+TxL36YsxTHI/oUMnt1c5+LgO1zExnYbJKQ0UXQH9P9bo/p3rJ9hZ4C+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727277; c=relaxed/simple;
	bh=1LpZ9TWYiHOIFnnFaIwdGMHlOyBFyeEts3NDd/2Gaog=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=to9XI6IFlBAMXSNUOdidVHqiuQCJs2UgXAfDJQ9a1RZ7dppA4N3Mj4gGc8smuZO/ehomqnde/L5foqVo0BgR/EZBaH7lcyWb75bYwg7wXXUfocOuqXi0OOFJRz3VxJ3duVgUC7FjqChJDUegA4xwVGAz8JpFB+fOGB2x4rpjUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nO53dsBe; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-29df844539bso640406a91.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 08:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711727274; x=1712332074; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n1wXpNbWp2y8iWjLz0xgvSFUORkctTyy1kkcSpGKLHE=;
        b=nO53dsBe/ODC0DkuB7MBj7RFeYq9XCNfP/7RrLVbGjR1mOfO7baqYUXKYugPNJleg9
         qh/1/e1xbeimTLrdBQq1DIYQ9JsantqDe9srBOPn67VrdInkg5fMGnAUYL1S+98JmeMB
         e/7lzxvXDzkrWofJAivK2kI6LS2/IjEh1U04KTu+yob4D6Zn2Wm9HNFHxKpeEf4265bn
         LowD5HG4/+2f3DcYJNXgagnfp6nRf2J45hvZBWLc3HvuW+sK1j6ciHdk/jy2OQTUmyxr
         KcMuc8lVKvHmA2UpWxWkHbVG1sP1PPmIKEMDK0KohueKfT92M3wU7NsuLRkAuSUIzZLq
         /XbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711727274; x=1712332074;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n1wXpNbWp2y8iWjLz0xgvSFUORkctTyy1kkcSpGKLHE=;
        b=l+ZzojyrwTAKXU/F5W6Y8Umahlu/BWGAVjRg0l21w21F2TpSEH4pDsFlq1JC5m4vLE
         L0i/uZEKnT6MB4Zs7RgXpyX8YcmuW2nOcHhXJu1VM9oP+cK10i2jUAmCqk3TlUyL4ZiO
         P6j5WhNkMzW3jm1v06ElnJ39l3f5tFC2/ayUX4PhAhXAt2jNYMquv4OYW+laDAHaJ0kw
         jUbKugs/kDjr/xR6z9BbsA/JoC+8yXXOdmqH0Ed+E+JXOyW2rTweTxZDbsu9QfahjpCi
         0TyK5Gi89NNDQvdKrkdb+VvclirSgeWkaK4loEu5xxwR6v+CGU14fRdKVeWFu/xHjfmH
         4ppQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKzpeZIu9lqedjfKSMZBUvNkLpAeEPWtoBlRZKvwAb+POtbsQnZkM/cZnCaOJwUO+3W6qsTWcSM9FKFO5YBObLYPRMw9u4CqQ=
X-Gm-Message-State: AOJu0Yy9ZtaP/YN16EnBXNjbwoipOM6gRtfg34D+BieJwgwDZiOFnog0
	LTyLyWxMmekXGfRqwaqwZ+LbV+uWI06rhTd5VsF80fgTn2Eterg12ighrj0sD9s=
X-Google-Smtp-Source: AGHT+IHgyliJqrjpuoIxUrCmMDwCUmuV4/hRDLVS0loJknbQ6vMoK1ZH6DLmJu/vhZOQdL8dJKWMVQ==
X-Received: by 2002:a17:902:a610:b0:1dc:82bc:c072 with SMTP id u16-20020a170902a61000b001dc82bcc072mr2773874plq.1.1711727274126;
        Fri, 29 Mar 2024 08:47:54 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d48200b001dd652ef8d6sm3590933plg.152.2024.03.29.08.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 08:47:53 -0700 (PDT)
Message-ID: <441421d5-3db8-4701-b831-25f673327cf0@kernel.dk>
Date: Fri, 29 Mar 2024 09:47:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/msg_ring: improve handling of target CQE
 posting
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-4-axboe@kernel.dk>
 <4edaf418-2012-4f85-9984-2130235cd31c@gmail.com>
 <597e01b6-901e-41c3-85bb-fc58b5514715@kernel.dk>
 <388fe980-b5bc-4760-8287-412376a36cd3@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <388fe980-b5bc-4760-8287-412376a36cd3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 9:46 AM, Pavel Begunkov wrote:
> On 3/29/24 13:32, Jens Axboe wrote:
>> On 3/29/24 6:54 AM, Pavel Begunkov wrote:
>>> On 3/28/24 18:52, Jens Axboe wrote:
>>>> Use the exported helper for queueing task_work, rather than rolling our
>>>> own.
>>>>
>>>> This improves peak performance of message passing by about 5x in some
>>>> basic testing, with 2 threads just sending messages to each other.
>>>> Before this change, it was capped at around 700K/sec, with the change
>>>> it's at over 4M/sec.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    io_uring/msg_ring.c | 27 ++++++++++-----------------
>>>>    1 file changed, 10 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>>>> index d1f66a40b4b4..e12a9e8a910a 100644
>>>> --- a/io_uring/msg_ring.c
>>>> +++ b/io_uring/msg_ring.c
>>>> @@ -11,9 +11,9 @@
>>>>    #include "io_uring.h"
>>>>    #include "rsrc.h"
>>>>    #include "filetable.h"
>>>> +#include "refs.h"
>>>>    #include "msg_ring.h"
>>>>    -
>>>>    /* All valid masks for MSG_RING */
>>>>    #define IORING_MSG_RING_MASK        (IORING_MSG_RING_CQE_SKIP | \
>>>>                        IORING_MSG_RING_FLAGS_PASS)
>>>> @@ -21,7 +21,6 @@
>>>>    struct io_msg {
>>>>        struct file            *file;
>>>>        struct file            *src_file;
>>>> -    struct callback_head        tw;
>>>>        u64 user_data;
>>>>        u32 len;
>>>>        u32 cmd;
>>>> @@ -73,26 +72,20 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
>>>>        return current != target_ctx->submitter_task;
>>>>    }
>>>>    -static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
>>>> +static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
>>>>    {
>>>>        struct io_ring_ctx *ctx = req->file->private_data;
>>>> -    struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
>>>>        struct task_struct *task = READ_ONCE(ctx->submitter_task);
>>>>    -    if (unlikely(!task))
>>>> -        return -EOWNERDEAD;
>>>> -
>>>> -    init_task_work(&msg->tw, func);
>>>> -    if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
>>>> -        return -EOWNERDEAD;
>>>> -
>>>> +    __io_req_set_refcount(req, 2);
>>>
>>> I'd argue it's better avoid any more req refcount users, I'd be more
>>> happy it it dies out completely at some point.
>>>
>>> Why it's even needed here? You pass it via tw to post a CQE/etc and
>>> then pass it back via another tw hop to complete IIRC, the ownership
>>> is clear. At least it worth a comment.
>>
>> It's not, it was more documentation than anything else. But I agree that
>> we should just avoid it, I'll kill it.
> 
> Great, it was confusing and I don't think it's even correct. In case
> it comes with refcounting enabled you'd get only 1 ref instead of
> desired 2. See how io_wq_submit_work() does it. Probably it's better
> to kill the "__" set refs helper.

Yeah, I think there's a bit of room for cleanups on the refs side. But
thankfully it's not very prevalent in the code base.

-- 
Jens Axboe


