Return-Path: <io-uring+bounces-6603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41101A3F920
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF7C3AA4E8
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7591D5172;
	Fri, 21 Feb 2025 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MyPJgO5b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C8D125B9;
	Fri, 21 Feb 2025 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740152445; cv=none; b=lZgbZX6oTv4ceWSBMXUGJbqAJxaM5lIMbxAZlKJpPXBp806VUPOWK+Kghv4N1NvX03QpwUxRoOmplkR4D7iO/+WAJwkKkfj0/Ve9MNhhbwXwkduxbiThEwWFzK+T329J8gjUjYjB+16AjjsniCRNKiNx/glRAAXVD0X6mrj47so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740152445; c=relaxed/simple;
	bh=2bG/X7eyvLm8M6IJi8iaPhzGXLIPRfdB0gRqfbkRSdA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MdddqBx3ejethRSVMCXETngQQRlo3NAs4BqBgS80RWngGrkXvJB3pzESuPmZI8sjuo237uTksnkiJYUW/aCcQQRqYE4/J49TKYd8uxyNev4MaB6Hi1T4SBl8KYj1G5ui3DSeSJ+YiA9siMXEgJ1Gcgfb/fjexFIOcv0yHmWXyKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MyPJgO5b; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38f2b7ce319so1875419f8f.2;
        Fri, 21 Feb 2025 07:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740152440; x=1740757240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rk44QtnfjgtVNcKcENEDGVtkZ1QDJQv4Z2TzsMxhL2U=;
        b=MyPJgO5bNVYeC/g4tTdG0vh1GCwPYWf1UWghiIDGku6xTMhldGt7nF4n2ByVxuJbR+
         isB4Ofdc29jZgQTiGlS6wDYFemWXxVLeqmHO9b59/vsMVUEXuJ3HuMkcrSXie1owEFQV
         mRPC4T+kf/O7yJtEdzaB4dT9R4S7T+NfwlwW87o6mNLaAa+GsSj/99eac/6EvZ2/PYtd
         Ahs4dYWUdRyIKPV6tGrIrro6oNZb7Xd6jltzpvET7ArBa+3glZ7zsS+OMCzlCFqRJUU6
         WWu1OVJuEV12+0hH4f8LxlmfaPmnACC2Bghrs+v4oeV3xs+gK74E6kXpp6bORIFRUUsr
         NPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740152440; x=1740757240;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rk44QtnfjgtVNcKcENEDGVtkZ1QDJQv4Z2TzsMxhL2U=;
        b=GHhsXq9X3Q6GasOtWOVGssV8TRngKPZSPj4/YLroYW4SaU+Zuoi7hSCzA63JtWX3a/
         obnUpAnkNAbft2eE8y4vpPZxAkG96kMqQPdorwXqh6Ut8xTdc044fqSWKkdxemx7Kise
         khslQTqPjp1lJ/kKkgUowNmQ554GXaPY1sk0uYKzaWnxrO7ifbY/zZ9dPQ+uvDFBplyA
         WsvxCHGw7wX4xhlFN3P/bb+TibsVV3940rClSJM9wZYC4dt9guGho+VCQ2+r1p3tKbz5
         SXVmFpzUMVnS6Hsg8M9bG/MZHwlkyIdUFDgp35QQc8QsJPPyNPi3rkGsv1A5ZCz5NWSd
         iIAA==
X-Forwarded-Encrypted: i=1; AJvYcCVwplkm2bSVDHZ3esm2z63VUjEJUvwyd0mRjnz7Fnd5xvySxi/fNxTLf43UXMclI9TrNgcrxb6coQ==@vger.kernel.org, AJvYcCWOIhLKqxa8O7uhLGs1USqV/DKAvprq+R/tArRAPER1XGjaGLXTIrTsr2I+GZRwNVJHqudn56cDumWq/qeZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzGwWL0QsnVZlk5W/07gVUofuVfA99z/zvJGAnLKqMGsIOfiJoW
	ynnTLIPZFvFlCyyAL34wA4/GOcaA7uIwEtFodgt/Rx0yIV3gbGc8
X-Gm-Gg: ASbGnct+G5je0J8BWPOEG6JrBI9FeaFEYOE0pQMDDrcH2IAEvswm/h+fXlKCx450Wn2
	o3jzqK1zJv4cN3L9+PmYpemYZU43VZu7s5fbWXrxW08tnR24GMON3uCIVf2Ws+3iH6xx5xkNpmt
	6L0LB+avGtIz4e5CRzJibfbAgnruMhAn9F+Et8zNv2XTCezFEq+5qqPVQ5JkfO21Cpiz06JOLBv
	nzY5pAE6/IOYkHgMNNuDXttZhw1328OGpM3zKBbZiXKxqqdSoZIQpd5C3FRww/+3Sl6yXiXK6rh
	DWfvK2HCZ5Ji/epLYuE7OonRCdA4CmBAqYow
X-Google-Smtp-Source: AGHT+IE0D2+0v5XAMz0QpFurol3gWayIysE4X6rTQmc5nOhKidCqWu3G0BFWVINKBVa5Nz5sZpOwkg==
X-Received: by 2002:a05:6000:178c:b0:38f:32ac:7e55 with SMTP id ffacd0b85a97d-38f6f0bd36dmr3736605f8f.48.1740152439675;
        Fri, 21 Feb 2025 07:40:39 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02ce336sm21001345e9.2.2025.02.21.07.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 07:40:39 -0800 (PST)
Message-ID: <e90dbf62-0416-4754-be16-fedc1d48a3d7@gmail.com>
Date: Fri, 21 Feb 2025 15:41:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring/io-wq: try to batch multiple free work
From: Pavel Begunkov <asml.silence@gmail.com>
To: Bui Quang Minh <minhquangbui99@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
 <20250221041927.8470-3-minhquangbui99@gmail.com>
 <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
 <e4be0a96-8e09-4591-96fe-a1d38208875a@gmail.com>
 <b4e6ef48-6b3e-4b62-978c-6e80d3e9218e@gmail.com>
Content-Language: en-US
In-Reply-To: <b4e6ef48-6b3e-4b62-978c-6e80d3e9218e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/21/25 15:28, Pavel Begunkov wrote:
> On 2/21/25 14:52, Bui Quang Minh wrote:
>> On 2/21/25 19:44, Pavel Begunkov wrote:
>>> On 2/21/25 04:19, Bui Quang Minh wrote:
>>>> Currently, in case we don't use IORING_SETUP_DEFER_TASKRUN, when io
>>>> worker frees work, it needs to add a task work. This creates contention
>>>> on tctx->task_list. With this commit, io work queues free work on a
>>>> local list and batch multiple free work in one call when the number of
>>>> free work in local list exceeds IO_REQ_ALLOC_BATCH.
>>>
>>> I see no relation to IO_REQ_ALLOC_BATCH, that should be
>>> a separate macro.
>>>
>>>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>>>> ---
>>>>   io_uring/io-wq.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
>>>>   io_uring/io-wq.h    |  4 ++-
>>>>   io_uring/io_uring.c | 23 ++++++++++++++---
>>>>   io_uring/io_uring.h |  6 ++++-
>>>>   4 files changed, 87 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
>>>> index 5d0928f37471..096711707db9 100644
>>>> --- a/io_uring/io-wq.c
>>>> +++ b/io_uring/io-wq.c
>>> ...
>>>> @@ -601,7 +622,41 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
>>>>               wq->do_work(work);
>>>>               io_assign_current_work(worker, NULL);
>>>>   -            linked = wq->free_work(work);
>>>> +            /*
>>>> +             * All requests in free list must have the same
>>>> +             * io_ring_ctx.
>>>> +             */
>>>> +            if (last_added_ctx && last_added_ctx != req->ctx) {
>>>> +                flush_req_free_list(&free_list, tail);
>>>> +                tail = NULL;
>>>> +                last_added_ctx = NULL;
>>>> +                free_req = 0;
>>>> +            }
>>>> +
>>>> +            /*
>>>> +             * Try to batch free work when
>>>> +             * !IORING_SETUP_DEFER_TASKRUN to reduce contention
>>>> +             * on tctx->task_list.
>>>> +             */
>>>> +            if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>> +                linked = wq->free_work(work, NULL, NULL);
>>>> +            else
>>>> +                linked = wq->free_work(work, &free_list, &did_free);
>>>
>>> The problem here is that iowq is blocking and hence you lock up resources
>>> of already completed request for who knows how long. In case of unbound
>>> requests (see IO_WQ_ACCT_UNBOUND) it's indefinite, and it's absolutely
>>> cannot be used without some kind of a timer. But even in case of bound
>>> work, it can be pretty long.
>> That's a good point, I've overlooked the fact that work handler might block indefinitely.
>>> Maybe, for bound requests it can target N like here, but read jiffies
>>> in between each request and flush if it has been too long. So in worst
>>> case the total delay is the last req execution time + DT. But even then
>>> it feels wrong, especially with filesystems sometimes not even
>>> honouring NOWAIT.
>>>
>>> The question is, why do you force it into the worker pool with the
>>> IOSQE_ASYNC flag? It's generally not recommended, and the name of the
>>> flag is confusing as it should've been more like "WORKER_OFFLOAD".
>>
>>
>> I launched more workers to parallel the work handler, but as you said, it seems like an incorrect use case.
> 
> Not as much incorrect as generally inefficient and not recommended,
> especially not recommended before trying it without the flag. People
> often fall into the trap of "Oh, it's _async_, surely I have to set it",
> really unfortunate naming.
> 
>> However, I think the request free seems heavy, we need to create a task work so that we can hold the uring_lock to queue the request to ctx->submit_state->compl_reqs. Let me play around more to see if I can find an optimization for this.
> 
> That's because it's a slow fallback path for cases that can't do
> async for one reason or another, and ideally we wouldn't have it
> at all. In reality it's used more than I'd wish for, but it's
> still a path we don't heavily optimise.

Regardless of that, we probably can optimise bound requests
like above with jiffies, but sockets would fall into
the unbound bucket. Otherwise, someone would need to be able
to forcibly flush the list, like on timeout every N ms or
something similar.

> Btw, if you're really spamming iowq threads, I'm surprised that's
> the only hotspot you have. There should be some contention for
> CQE posting (->completion_lock), and probably in the iowq queue
> locking, and so on.

-- 
Pavel Begunkov


