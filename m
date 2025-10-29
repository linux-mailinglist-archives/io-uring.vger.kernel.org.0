Return-Path: <io-uring+bounces-10282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4FD4C1C07E
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 17:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBD0818822A3
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 16:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B647C2673B7;
	Wed, 29 Oct 2025 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYtU+fOu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02198284894
	for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754625; cv=none; b=KJKod6vfsVrRvDdS5F6PwbZ1b2YJ9mEUoqRHbSGPqTIa/auHt8rZKHoNlerZMvHkUii87hLdOyxY5qlqGFy5xrRumN4V9Fno7RjTf2Xjrkivw/Y1BhdcAt3cnXF+NusMpgQp1/Qzfhba4IKdgsVMjhs4Odc9/kLgcvvR6s7ccp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754625; c=relaxed/simple;
	bh=M3DOQyOvI3LmbmdRCNlHrBc81xduhBQno7/iH3hdhfE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IJpWw6VXBN22BtCZI0TultkMRrv1EgeWfq59jbc9w/i6p29PSOEP8j1CuKU5BoMUU0PFdeZDu6iya4JNKWiVOSXSPa9qStu2fPK8F5srC+fE1F8NVGX6EU7MhiqJcRf7EYije+J6R57OYY1IqSsNNEAcHY8xrLAIbgEj+xPcB0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYtU+fOu; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-471191ac79dso82355e9.3
        for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 09:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761754622; x=1762359422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r19O7EnwPyqRQN7zL+3HoUi/WiUMPXRqn5AkTu0OTA0=;
        b=MYtU+fOuZ7APu4wXgLcHitwLiXRT3uy7qTZ9TjdVaMQKRUmINS3msLqQs5dwevCv+H
         7UJIhWl+iZhADg2n3RZgtVpKxjMBvrV/DhjG8qKvq5oopsDO/McY/mBil+Xdv4+vuSPX
         0c5vnTT7ryM27AZhmOvaaBHHPEv0GfdBECtAHUTRjHM8FztxszAVXYcsbtFGl5ZVLif1
         gP4gtfZQr2VRb9AkL4Ww32CY4SjQ3iOnqD66crGTZ8zE3C/OgeDcFrxPWE0mjAadJwwM
         2gNqeWH0E/KOBJW841NAMTc3HGSY/SpkRDhmXcBPL3ypV3yF5YECjZY3KuG/9i4Up4EU
         r1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761754622; x=1762359422;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r19O7EnwPyqRQN7zL+3HoUi/WiUMPXRqn5AkTu0OTA0=;
        b=QGdkn/ThO0vuulwyttUF1J3gAIsNWsvnnMv563GIomRB768z4S64DewfivE0krpvIX
         N2uRxxeEz0H+pd4/idOuELxUH5dnF6WWVdCQQXqcJEh8FuoTiC6LxWqfF94/2ZAayxgH
         Oj4LFlxiDgbEH3h1XYaYVfAhluDTSfc73wvy5iL0oQ3G7yqyjdaPLb3pNrEAcQ6RcUpc
         Z1VRN18PyxVxtiAWcvJndiN8zN9+u5JVmqc/v4SkZNLWCgxYluRT73bXUrJpT9b1H6XQ
         QgZBbCyQd3Q2rYCzWQEZuW+9QR/mVreCX+1nKHGYlOxm4/3UqkOrKyGzeGutRKp/DE+R
         sjQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSv2ALRqtQW9ZpsMSMNk4OHpXH5WJauiGYVRS+mV7+fVo3cw6aQYOaTBvCwe4rIyYqZWDCranq6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvaaRE3sGV5I6rWtR6hzSBcFfPmk+qMAnHBHg9/NR55C+tIuNr
	U562sTgUtx0pbH29FYAggeoQD3Tvu+8Z49P0ws3my+r4E/dXitQVj5UY
X-Gm-Gg: ASbGnct/Xv8RK0r7YHQ8knYw8QQJScq6pMb3e0VkGX5fLVy5vyjsEV+YL78WaGAYnDw
	BuypYVbYsjg5uzgBuqgUeT17efstsv4xSVsEqQHhf7rlZHFVxQnM81lqQHxgDnAfC7LMP5A0QYo
	YW4b4LY08iUP5GJZuQll8w4peF2ZvReNy7myZDBvQqfX19UFCNWhuFob1Q1qgoDxuCJZwAMq6CG
	8pMoed+qXso9EP6a/NVN1Ge3PadJ3Nk6T8dv9k8mmlr7cpSbyyYQJn2LCosLynsmATKiXAHOVas
	igBxWxy31lEfOC7Ionz7E+vFn2igJ9BqfAAPqmHozznl3yVcOB08a3kA+3nK+nC/s5/Wl1lQ0NC
	fIAp3ftAt2hmKowafmhqh0DC+qFxGBGibP8ZuZMBopTAJCv5K+qDKT67wUt3TAU0/RfLkP6lev+
	ShuXLtR6AJ1+khFl9QkWpUKmDpiF1ZdSiEBNajthoFSwkJCfbIWi8=
X-Google-Smtp-Source: AGHT+IHFRnAAgsKvXzFS1zQn3Je4U806rAMKbOihzNs7VRnTahzLn81dM4S6TElF54S+7YPnSaTZSA==
X-Received: by 2002:a05:600c:3b15:b0:477:a58:2d6b with SMTP id 5b1f17b1804b1-4771e166da9mr36381215e9.7.1761754622193;
        Wed, 29 Oct 2025 09:17:02 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e12cb2asm55858605e9.0.2025.10.29.09.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 09:17:01 -0700 (PDT)
Message-ID: <9fe0088d-f592-47c4-8b95-7c85a494cf70@gmail.com>
Date: Wed, 29 Oct 2025 16:16:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] io_uring/zcrx: add refcount to ifq and remove
 ifq->ctx
From: Pavel Begunkov <asml.silence@gmail.com>
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
 <20251028174639.1244592-8-dw@davidwei.uk>
 <810d45da-7d60-460a-a250-eacf07f3d005@gmail.com>
Content-Language: en-US
In-Reply-To: <810d45da-7d60-460a-a250-eacf07f3d005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/29/25 15:22, Pavel Begunkov wrote:
> On 10/28/25 17:46, David Wei wrote:
>> Add a refcount to struct io_zcrx_ifq to track the number of rings that
>> share it. For now, this is only ever 1 i.e. not shared.
>>
>> This refcount replaces the ref that the ifq holds on ctx->refs via the
>> page pool memory provider. This was used to keep the ifq around until
>> the ring ctx is being freed i.e. ctx->refs fall to 0. But with ifq now
>> being refcounted directly by the ring, and ifq->ctx removed, this is no
>> longer necessary.
>>
>> Since ifqs now no longer hold refs to ring ctx, there isn't a need to
>> split the cleanup of ifqs into two: io_shutdown_zcrx_ifqs() in
>> io_ring_exit_work() while waiting for ctx->refs to drop to 0, and
>> io_unregister_zcrx_ifqs() after. Remove io_shutdown_zcrx_ifqs().
>>
>> So an ifq now behaves like a normal refcounted object; the last ref from
>> a ring will free the ifq.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   io_uring/io_uring.c |  5 -----
>>   io_uring/zcrx.c     | 24 +++++-------------------
>>   io_uring/zcrx.h     |  6 +-----
>>   3 files changed, 6 insertions(+), 29 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 7d42748774f8..8af5efda9c11 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3042,11 +3042,6 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>>               io_cqring_overflow_kill(ctx);
>>               mutex_unlock(&ctx->uring_lock);
>>           }
>> -        if (!xa_empty(&ctx->zcrx_ctxs)) {
>> -            mutex_lock(&ctx->uring_lock);
>> -            io_shutdown_zcrx_ifqs(ctx);
>> -            mutex_unlock(&ctx->uring_lock);
>> -        }
>>           if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>               io_move_task_work_from_local(ctx);
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index b3f3d55d2f63..6324dfa61ce0 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -479,7 +479,6 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
>>           return NULL;
>>       ifq->if_rxq = -1;
>> -    ifq->ctx = ctx;
>>       spin_lock_init(&ifq->rq_lock);
>>       mutex_init(&ifq->pp_lock);
>>       return ifq;
>> @@ -592,6 +591,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>       ifq = io_zcrx_ifq_alloc(ctx);
>>       if (!ifq)
>>           return -ENOMEM;
>> +    refcount_set(&ifq->refs, 1);
>>       if (ctx->user) {
>>           get_uid(ctx->user);
>>           ifq->user = ctx->user;
>> @@ -714,19 +714,6 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
>>       }
>>   }
>> -void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>> -{
>> -    struct io_zcrx_ifq *ifq;
>> -    unsigned long index;
>> -
>> -    lockdep_assert_held(&ctx->uring_lock);
>> -
>> -    xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
>> -        io_zcrx_scrub(ifq);
>> -        io_close_queue(ifq);
>> -    }
>> -}
>> -
>>   void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>   {
>>       struct io_zcrx_ifq *ifq;
>> @@ -743,7 +730,10 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>           }
>>           if (!ifq)
>>               break;
>> -        io_zcrx_ifq_free(ifq);
>> +        if (refcount_dec_and_test(&ifq->refs)) {
>> +            io_zcrx_scrub(ifq);
>> +            io_zcrx_ifq_free(ifq);
>> +        }
>>       }
>>       xa_destroy(&ctx->zcrx_ctxs);
>> @@ -894,15 +884,11 @@ static int io_pp_zc_init(struct page_pool *pp)
>>       if (ret)
>>           return ret;
>> -    percpu_ref_get(&ifq->ctx->refs);
>>       return 0;
> 
> refcount_inc();

Which would add another ref cycle problem, the same that IIRC
was solved with two step shutdown + release. I'll take a closer
look.

-- 
Pavel Begunkov


