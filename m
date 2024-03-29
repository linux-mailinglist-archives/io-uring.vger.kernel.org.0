Return-Path: <io-uring+bounces-1320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1D6891F32
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49B581F2EC8F
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980EE15382F;
	Fri, 29 Mar 2024 12:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biH9cdyj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F6153BD6
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 12:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711716887; cv=none; b=d8up8q0SF9B1bphLwrtSC8S70LeOXx3ztaSZZCA2XeNoIwcZlN6Q9f5/viWfrrw3fBGQRkWF5Smb4pFbHyEn40BdiR2eXx0mKbLZiJBPqhnrNE+WKKqXLYjnPPUFuzKOBzZsADoJefFpk1Kkn8H4ADynKMgKctF9/VHvEt4nf4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711716887; c=relaxed/simple;
	bh=lIQVnioxNwflADLHvUcOtpHggCNdWPNHVtlvfFCvPog=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C6AttK/VR2rXg+tN028CTJON1GExxpQlrYnC2KdwEuRuLh//P7rq56kO7O3LWkJ9kQ/C6efRH4L6LrElkX15AzAUsbPDqETCtbFIFetYz8sC0FuZKWkaFhTOk4Wn7KOVmJ1VKNbsc2vbcgIRZV8tzx7cccr/HUWiB0wGqXLvys0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=biH9cdyj; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a466e53f8c0so249107666b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 05:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711716884; x=1712321684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Mr9W7trQAZaY8XZXdmZtoVEgVlmUveFDCA7yG6YPL4=;
        b=biH9cdyj7hiIv05J9CVXJZ6UOK52vjeEJdZPLegRQNGX8d8TiYuxhM7K/KhmTGTVQa
         zc2hygQT4y3avXvdY2k8HcIfQV6IoV3qPuCxDgGnXSpN5j1d5En1e+O4/1nS+7CoqmzC
         yfEwvTgCTu4ysFu1IVTtx0ALJzCur0x67dzHXDn4TGVUSDuTCzdRBLe9ZzyXltiamFOe
         77Rm7hoHNfBLrOX6ohFr9VozNQ2BnUfCnn/jggyhKEG7ESLR57Rv6SKyGdMK8JlsOtpj
         r9s5fXlAd0tzfPGW0xyDWvsGJ7sZUJ2jQtZlux9aIQLS4pjOCqZHR0yDHXqdUeI5EssE
         OPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711716884; x=1712321684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Mr9W7trQAZaY8XZXdmZtoVEgVlmUveFDCA7yG6YPL4=;
        b=cAYuPXGAR7hRSjPvAof/mduX6dfgZPeWeYhClbqebNkFfvtu9sL7Wbo1aBq8nEJjCv
         Elobw9HJzrRZEQy130GlQ73zHt44dRYaYpY0Z8ic0Ks6LqMFUQQK6x5KdEsr7ZVWHDxR
         0RQq6+aOayWEHa4MgLdhHgpHUhuFudWJlxMcvD33V4/XupoVWCPU4pGEb9NcQI31EMz3
         HCLrTFVzZ2UfGS8HelYvCeauOxSRLQcNt2B6fLzY/KfbvOuRSi1pgRMW+ymrSMSIM9oN
         SMrI6qj75dVRi4hGzlMRTfxZhhjly6qTJaWwMMq3CoWmnYZGN47ysncHuLqqhqP/jiCi
         SyXA==
X-Forwarded-Encrypted: i=1; AJvYcCVS8ZuBKwYHaK2ucJENlKvZ7lTisE1ecR19GWc8YL1HxOB6O1x+VofoYbSLQYu0nkgb4A0Ud0np37v25crmwFRBmq1miUQThgI=
X-Gm-Message-State: AOJu0Yxb4gITjYItSPsycD80PYttbnmYZob6ZwgL8DlmPTOdwlL82ZyT
	WFxNFPsWrXZvgM0yhHfI3qB6vj1GkfvI/AMS0JFMQZ2CkdCPDkPk
X-Google-Smtp-Source: AGHT+IEx+AZ6/otWILmQj9yCfTEQ68qaAPSQJx41TrumVXg4A08x4rEf4fzqmyAW8SRnAlWvZyQcKw==
X-Received: by 2002:a17:906:6811:b0:a4e:1597:eb2f with SMTP id k17-20020a170906681100b00a4e1597eb2fmr1594689ejr.11.1711716883776;
        Fri, 29 Mar 2024 05:54:43 -0700 (PDT)
Received: from [192.168.42.210] (82-132-222-240.dab.02.net. [82.132.222.240])
        by smtp.gmail.com with ESMTPSA id x18-20020a1709060a5200b00a46ab3adea5sm1903829ejf.113.2024.03.29.05.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 05:54:43 -0700 (PDT)
Message-ID: <4edaf418-2012-4f85-9984-2130235cd31c@gmail.com>
Date: Fri, 29 Mar 2024 12:54:40 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240328185413.759531-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 18:52, Jens Axboe wrote:
> Use the exported helper for queueing task_work, rather than rolling our
> own.
> 
> This improves peak performance of message passing by about 5x in some
> basic testing, with 2 threads just sending messages to each other.
> Before this change, it was capped at around 700K/sec, with the change
> it's at over 4M/sec.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/msg_ring.c | 27 ++++++++++-----------------
>   1 file changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index d1f66a40b4b4..e12a9e8a910a 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -11,9 +11,9 @@
>   #include "io_uring.h"
>   #include "rsrc.h"
>   #include "filetable.h"
> +#include "refs.h"
>   #include "msg_ring.h"
>   
> -
>   /* All valid masks for MSG_RING */
>   #define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
>   					IORING_MSG_RING_FLAGS_PASS)
> @@ -21,7 +21,6 @@
>   struct io_msg {
>   	struct file			*file;
>   	struct file			*src_file;
> -	struct callback_head		tw;
>   	u64 user_data;
>   	u32 len;
>   	u32 cmd;
> @@ -73,26 +72,20 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
>   	return current != target_ctx->submitter_task;
>   }
>   
> -static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
> +static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
>   {
>   	struct io_ring_ctx *ctx = req->file->private_data;
> -	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
>   	struct task_struct *task = READ_ONCE(ctx->submitter_task);
>   
> -	if (unlikely(!task))
> -		return -EOWNERDEAD;
> -
> -	init_task_work(&msg->tw, func);
> -	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
> -		return -EOWNERDEAD;
> -
> +	__io_req_set_refcount(req, 2);

I'd argue it's better avoid any more req refcount users, I'd be more
happy it it dies out completely at some point.

Why it's even needed here? You pass it via tw to post a CQE/etc and
then pass it back via another tw hop to complete IIRC, the ownership
is clear. At least it worth a comment.


> +	req->io_task_work.func = func;
> +	io_req_task_work_add_remote(req, task, ctx, IOU_F_TWQ_LAZY_WAKE);
>   	return IOU_ISSUE_SKIP_COMPLETE;
>   }
>   
> -static void io_msg_tw_complete(struct callback_head *head)
> +static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
>   {
> -	struct io_msg *msg = container_of(head, struct io_msg, tw);
> -	struct io_kiocb *req = cmd_to_io_kiocb(msg);
> +	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
>   	struct io_ring_ctx *target_ctx = req->file->private_data;
>   	int ret = 0;
>   
> @@ -120,6 +113,7 @@ static void io_msg_tw_complete(struct callback_head *head)
>   
>   	if (ret < 0)
>   		req_set_fail(req);
> +	req_ref_put_and_test(req);
>   	io_req_queue_tw_complete(req, ret);
>   }
>   
> @@ -205,16 +199,15 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
>   	return ret;
>   }
>   
> -static void io_msg_tw_fd_complete(struct callback_head *head)
> +static void io_msg_tw_fd_complete(struct io_kiocb *req, struct io_tw_state *ts)
>   {
> -	struct io_msg *msg = container_of(head, struct io_msg, tw);
> -	struct io_kiocb *req = cmd_to_io_kiocb(msg);
>   	int ret = -EOWNERDEAD;
>   
>   	if (!(current->flags & PF_EXITING))
>   		ret = io_msg_install_complete(req, IO_URING_F_UNLOCKED);
>   	if (ret < 0)
>   		req_set_fail(req);
> +	req_ref_put_and_test(req);
>   	io_req_queue_tw_complete(req, ret);
>   }
>   

-- 
Pavel Begunkov

