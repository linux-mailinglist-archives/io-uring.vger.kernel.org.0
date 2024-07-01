Return-Path: <io-uring+bounces-2399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A176B91E037
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 15:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6232C285085
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 13:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F74215A87C;
	Mon,  1 Jul 2024 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3rWn+98"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C754A158D9F
	for <io-uring@vger.kernel.org>; Mon,  1 Jul 2024 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719839174; cv=none; b=MMYVrR6iUJGfqpthp9htz46MgI+vtZtVC9yOWrrQJcX5DJeYIooo3L5Kx09NuEyx7WJ4W0YCd9Eb1zPbinv8v6s1mfE2kQCGCRc6ejOsiVp49C/5xQxPr5tn77AOLN8sbgOSaMs8ourpf5mf+fITtnA7YomZ22qXZkKPPEr0Wp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719839174; c=relaxed/simple;
	bh=e9fmKiipX8LCcYp7gI5T7gb9wezZoRd85FeZ/eUNvmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZUuucFe7q1EcwVbqWW7nnTCoXiFsdRectDrZj9uEW/YD5ortlCPQE6t5msPhq1GLBBuDZLQcC/ybaPI3Cr/dEbdrr42Sh6bOuHGoGxI/i6eKbXj2E8MYK8vGOXwW4QMUG6N7jN3qMjYhxBzRKZXsFj7USy3dQaY10ikk9aX+qnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3rWn+98; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57d06101d76so232633a12.3
        for <io-uring@vger.kernel.org>; Mon, 01 Jul 2024 06:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719839171; x=1720443971; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E/o8ImH9R7txIe3wpkdOGe7ZTkeBANZx0gumFohQTJ8=;
        b=k3rWn+98o3ybr864I0A0xvlvgVHdBVB0ZEPylg2dQfhsMfTUuuyxlDnAH2lEKyb3yr
         3LGA1m9GViQPSKEJyyEfose6eJjJpoRZOs2L5D7DjtHBR9Elqa5YKvBJUgcPrXqirlT4
         T35C6Hnr0xYs6mnKBp65yNyDTZIyUOKcVrn7EGI/LF6knJxtmCDIs3WIhMj+zwNQOxqT
         sk3KY1W/IUZbz9bN5/tPLWLQlyQd+aCo05/si+LZ/+zvLj84u3fIO2cT398ue9qzFTkn
         rNCwmZAxL/qi7yLslBw3hPxHaBpF8Fcpl7ZgClhd2Kk70aqFd+aNCECTIHjG1ACk2Rjl
         SQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719839171; x=1720443971;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/o8ImH9R7txIe3wpkdOGe7ZTkeBANZx0gumFohQTJ8=;
        b=AZJy2X8kLfelDwi+5hpuBgGDvR0wNkqjdmv5GJdFKteEolYW9sRRz0FbKV7nrQzwo6
         cA4h2k9Lei7A7og6eQMMLFHKkzdofnllPmkcLuyIDMP/ZusP9trwxvqpsht8+6ep+MVt
         XQVD6EvAgGZZC1p0C7/S6o7UBYAPgchRbWqc3EKHHcPeK7O4VcSmnXkAbtz/Z0bldoig
         i+d592WKHKAP4Wrb1k7MJ/jYZIJu/W26dnIlesC2ASi1bLHNqHtGLHUeq2Xeh+QYIyal
         vtiG+0heWsMLLLFpkP3lFWazwfAIJ/V8hOG4CTTLSLdEuHveUwAUt0pQuWBoBOezDtrL
         S89A==
X-Forwarded-Encrypted: i=1; AJvYcCVU1tshaF64fg5yqvnbnFxD39GjlC/liSnF4xYeX+sP7VeXd0Rz8nM5L3Bk1e2EKgV8mGbNvJAOsPGpxj5EI9v3fPLADS1VxtU=
X-Gm-Message-State: AOJu0Yx1K649gvI/M657BPdW603RxeusGeyR9oVHSfqprNKlInyMLzIZ
	8QofOxLoC6KzUY3a/gDqwJUXOl/oB3pj/sKCJLhFx4RZISfo3FKpnS+WSA==
X-Google-Smtp-Source: AGHT+IFT/XN03uHXA2vno4hkKz46U5lhEAjljEb1AFRTAyKe9iJu3NmmnGpdK4ddS5LnJwGJWDSloQ==
X-Received: by 2002:a05:6402:5203:b0:585:3a33:9de0 with SMTP id 4fb4d7f45d1cf-587a0bfc64cmr4252838a12.26.1719839170697;
        Mon, 01 Jul 2024 06:06:10 -0700 (PDT)
Received: from [192.168.42.232] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614d50b27sm4386971a12.70.2024.07.01.06.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 06:06:10 -0700 (PDT)
Message-ID: <097a2a9c-a1b3-4fdb-b097-2c82375c1eb3@gmail.com>
Date: Mon, 1 Jul 2024 14:06:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring/msg_ring: improve handling of target CQE
 posting
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240618185631.71781-1-axboe@kernel.dk>
 <20240618185631.71781-5-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240618185631.71781-5-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/24 19:48, Jens Axboe wrote:
> Use the exported helper for queueing task_work for message passing,
> rather than rolling our own.
> 
> Note that this is only done for strict data messages for now, file
> descriptor passing messages still rely on the kernel task_work. It could
> get converted at some point if it's performance critical.
> 
> This improves peak performance of message passing by about 5x in some
> basic testing, with 2 threads just sending messages to each other.
> Before this change, it was capped at around 700K/sec, with the change
> it's at over 4M/sec.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/msg_ring.c | 90 +++++++++++++++++++++++----------------------
>   1 file changed, 47 insertions(+), 43 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index 9fdb0cc19bfd..ad7d67d44461 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -13,7 +13,6 @@
>   #include "filetable.h"
>   #include "msg_ring.h"
>   
> -
>   /* All valid masks for MSG_RING */
>   #define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
>   					IORING_MSG_RING_FLAGS_PASS)
> @@ -71,54 +70,43 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
>   	return target_ctx->task_complete;
>   }
>   
> -static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
> +static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
>   {
> -	struct io_ring_ctx *ctx = req->file->private_data;
> -	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
> -	struct task_struct *task = READ_ONCE(ctx->submitter_task);

Not about this series particularly, but sounds like msg requests
should be REQ_F_INFLIGHT, but there is a chance lazy file assignment
is enough.

> -
> -	if (unlikely(!task))
> -		return -EOWNERDEAD;
> +	struct io_ring_ctx *ctx = req->ctx;
>   
> -	init_task_work(&msg->tw, func);
> -	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
> -		return -EOWNERDEAD;
> +	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
> +	kmem_cache_free(req_cachep, req);
> +	percpu_ref_put(&ctx->refs);
> +}
>   
> -	return IOU_ISSUE_SKIP_COMPLETE;
> +static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
> +			       int res, u32 cflags, u64 user_data)
> +{
> +	req->cqe.user_data = user_data;
> +	io_req_set_res(req, res, cflags);
> +	percpu_ref_get(&ctx->refs);
> +	req->ctx = ctx;
> +	req->task = READ_ONCE(ctx->submitter_task);

Missing a null check, apart from that the patchset looks right

> +	req->io_task_work.func = io_msg_tw_complete;
> +	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
>   }

-- 
Pavel Begunkov

