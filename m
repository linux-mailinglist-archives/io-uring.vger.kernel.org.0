Return-Path: <io-uring+bounces-1971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 056458D1CC2
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 15:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8454F1F23CB2
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 13:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA6D16FF4D;
	Tue, 28 May 2024 13:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKJ3b2Ff"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578ED16F0DD
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902301; cv=none; b=s/G824UT9z+s8vcdOMwU1bH71K5OlhGHvxhmn++3xrVJOTAmX/Kagh+n4fF/8z/x0pZ+dK1I3jFtgCY7v/5HWj+pEzCo8yb3NxfBYBWGjJy0VTKrTz1wisIhN7+KTacen4jir+BNoV1JpCnM8N732svRQOgWStJFkFMbfIfrHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902301; c=relaxed/simple;
	bh=pm+7JSCjBAmb33wHnriqa29NOXCw5mic5y0v2DrsbR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hRt+58TNtOSE5WdjZRSYrd9jw1kQ3eQcs4cCjOgmXsbb0Xk4jsuQkosVHoXFvyDWcZ95Q5tfE3VS8AxWcYs0PKRw8JTHVDvcxUKFvQN3bEPCqvmHr2oKg8WX/lfT2Dgh+4otc5ATlXKrB2cN634KcL68HEhNfVWTY/sZlOU2T18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKJ3b2Ff; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57864327f6eso1366676a12.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 06:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716902298; x=1717507098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1td+aBLMKzX6KiRbW9Wp05C7i+VNI5uZDFSzpJIYoGI=;
        b=LKJ3b2FfZci88UURlTpX4ito1rnahmxbuM4R1fFm5L4WVP4Uyn5UN1cybVnJDsWuYR
         y/iknLSr7dok53Z0OP4u9e9Uph9l4F5AMJ15cMX0mtOUApLKpESfe+0C417T5x84sT49
         vfbYmPmydcv/1cl78hbSWbRmYoC/7FmkqHO/tUZbtbdvIqUvUYnf1GIhEhg8yx9moiT1
         QSXk/+8YK7TFkgCABzCmcz7wETaG21xF+pCsjZvGMJvPqdICa/z/7gVjyqe/eX35oxle
         6NiHGXfXt5fG2qi5eDS4cFnfYY/pqrqFt/l2tVijKNsC9SuGpWpA2u0xYafI/t44f126
         TnKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716902298; x=1717507098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1td+aBLMKzX6KiRbW9Wp05C7i+VNI5uZDFSzpJIYoGI=;
        b=ZFrL2nt2MdmwY0R/5QdEnwmu6TlmwIcqKgAICrHqwX8ZGLyNu265Xjv6uqXTMiPF3+
         4Pnf0Zybh/x0N63Qe/47IYKlpPuNd9OZnBHeUm0GxDK31+502xuGQAeLqTrRfOi8fw89
         II8IfnlTiYnzaCgP+k/7dnAQmlWzJBSg01/umBqlt4+b3AEwYrqhX9BA1omBBLv9SCaJ
         TojUMRepO6/QCET2giwkTucconf0CCExOB9jNCRBkXP/+IvycqLN45D83cNnFCfUVjzV
         +AflDDHwfZrSxzISMZroZmCu4NUclPP9LquyVPM1UtmI/CHW3Dv/ch4YVcV4Yq0mZsr4
         i2aA==
X-Forwarded-Encrypted: i=1; AJvYcCWj5FK3mu61oA4Qi7NBX457csCQA2XHKtdm8jYO4EfxRqRmzpmbPbNpWcxgWtGeb9wN5E1s18TY0EsPsDpR/C8p2o2Q/v44fd8=
X-Gm-Message-State: AOJu0YwNq7RUhIWpsI4mwNF0YN7VDVUHmsX0iI5J/PRVPEWV6Ufp61eS
	7totHUNNuWmJLUNfjhah/7zbiboCn2if+/ojA1/vFrHUrvEf6uk+C9u2Vw==
X-Google-Smtp-Source: AGHT+IFJ7qbCO0ZkUT8BN0HxXTahGTJNk8VHUMEQW+CckBXXWaaXXYykzln7YUCff5EOAw9DxvnyWQ==
X-Received: by 2002:a50:d783:0:b0:578:5f9d:9ab7 with SMTP id 4fb4d7f45d1cf-5785f9d9c01mr10776600a12.17.1716902297548;
        Tue, 28 May 2024 06:18:17 -0700 (PDT)
Received: from [192.168.42.21] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-579cec28c0dsm3404349a12.66.2024.05.28.06.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 06:18:16 -0700 (PDT)
Message-ID: <a9988b65-2a66-4af8-9fb4-ed7648d96b58@gmail.com>
Date: Tue, 28 May 2024 14:18:20 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work
 for data messages
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <20240524230501.20178-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240524230501.20178-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/24 23:58, Jens Axboe wrote:
> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
> to the target ring. Instead, task_work is queued for the target ring,
> which is used to post the CQE. To make matters worse, once the target
> CQE has been posted, task_work is then queued with the originator to
> fill the completion.
> 
> This obviously adds a bunch of overhead and latency. Instead of relying
> on generic kernel task_work for this, fill an overflow entry on the
> target ring and flag it as such that the target ring will flush it. This
> avoids both the task_work for posting the CQE, and it means that the
> originator CQE can be filled inline as well.
> 
> In local testing, this reduces the latency on the sender side by 5-6x.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index feff2b0822cf..3f89ff3a40ad 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>   	io_req_queue_tw_complete(req, ret);
>   }
>   
> +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
> +{
> +	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
> +	size_t cqe_size = sizeof(struct io_overflow_cqe);
> +	struct io_overflow_cqe *ocqe;
> +
> +	if (is_cqe32)
> +		cqe_size += sizeof(struct io_uring_cqe);
> +
> +	ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
> +	if (!ocqe)
> +		return NULL;
> +
> +	if (is_cqe32)
> +		ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
> +
> +	return ocqe;
> +}
> +
> +/*
> + * Entered with the target uring_lock held, and will drop it before
> + * returning. Adds a previously allocated ocqe to the overflow list on
> + * the target, and marks it appropriately for flushing.
> + */
> +static void io_msg_add_overflow(struct io_msg *msg,
> +				struct io_ring_ctx *target_ctx,
> +				struct io_overflow_cqe *ocqe, int ret)
> +	__releases(target_ctx->uring_lock)
> +{
> +	spin_lock(&target_ctx->completion_lock);
> +
> +	if (list_empty(&target_ctx->cq_overflow_list)) {
> +		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
> +		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);

TASKRUN? The normal overflow path sets IORING_SQ_CQ_OVERFLOW


> +	}
> +
> +	ocqe->cqe.user_data = msg->user_data;
> +	ocqe->cqe.res = ret;
> +	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
> +	spin_unlock(&target_ctx->completion_lock);
> +	mutex_unlock(&target_ctx->uring_lock);
> +	wake_up_state(target_ctx->submitter_task, TASK_INTERRUPTIBLE);
> +}

-- 
Pavel Begunkov

