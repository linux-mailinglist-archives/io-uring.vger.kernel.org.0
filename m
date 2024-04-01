Return-Path: <io-uring+bounces-1350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9674D894490
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CD8D28282B
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852C04D9E9;
	Mon,  1 Apr 2024 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XAUOqsPF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D051E4D59E
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994249; cv=none; b=o3No51dVEFHtnrRJDK5mdFWRpgxmMYpYgoJDW/WjwoytM1sFWMFlVgs/pQLvdkqRmPOFsVt6JnhY2yVhKpWVJJrv2gSGEbs4fgrItRgXZipMWjw0EoxEBo0OymOkxeBXHH8HA+gG85CX+vwslvxv5OXJtkUcP6kJzKRZ669JmTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994249; c=relaxed/simple;
	bh=pE94p9Us/mS9SBb4ifZXN3W9xdupnry5J+uMI3JjTr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hPgNgUH7/a7ZU7yOhhWsygO5eiCEg1B7yBv56o5ACw8y0mQwlPVpwhNyenMK4FWNz5wo4LbPar2zEteN6s3cIMUnj6YcB2Cx/v1+et1zmtT09rdqD7tRqkX+RrRuPsz9EJXXTJWtd0860++GlIAmlQorvLGr6SFvbs+qNpEXOJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=XAUOqsPF; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso1876987b3a.2
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1711994247; x=1712599047; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WaGRorBT9wtynShxwcMaIbzFa9RilgpuoC3Pe6KEEds=;
        b=XAUOqsPFhf1/9HdFhWmGBeiwdHCSckBpiq7MQH0BQ6+mFY3rxLyDZUKeL0ExeOb9Gp
         rQ6dw9t/wp/9C5IhhL3zp5WbnPCybABQ1gk3K0YGqNfi39Fp4nwiAGlfgctebZ6sdwSh
         hDFMjFMGzhP4s/vCbUQV/OO5ADCP11WLPvbMzhyc2cFz6t+uBap7azBh5UqUsTpfEwDw
         7N2WM9subRxRB//vuIXY5j5nGgG7DvRg7zlIo49zHkxe5PCo689ZcEU2TgXNizWa+gnE
         FBu54ffCvgLLPMwELr4wfNEVVZ8TEY3ozY5eAQexK74iX64zjpEu/cMTRaiNZlyI/wFH
         wFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994247; x=1712599047;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WaGRorBT9wtynShxwcMaIbzFa9RilgpuoC3Pe6KEEds=;
        b=DsFqLKgZsXBB9ktY1jYaVkqE4ksxFFiMhUIBifEziCuutng8wr0aNOYYFCjfSDGX6+
         L99+lNeh1tkR2G9wKMYBEE6UVpxiOnTOe46qtU9LAB08Q3p/J/xH62B1Ecd5a6dEQksH
         oWLIVn3zHcD+H3aYiMF1CRrdqQra8za7ISb7P9aEJuw6i+5UsDu/24cLLl+zQ8OPguvU
         gEMm/uFUWr48mfbHZeFUjNkwHZ1sm2oMNoynOX3lPY99lNbyfuYcj+pPUmjC0WgHKSaR
         jiNT//6aJ/9qwypnFXmz703sGiyORDlWyTwcdaNm4aZkhck7iDVGCEYrt8fsqkVjnDy6
         GoVw==
X-Forwarded-Encrypted: i=1; AJvYcCUSEye4ECMj6q/bA0ITuM+c73SDYEmQnMSBBGoQnWdJnX4ixHjhq0x4ALVDucOWdWo5iWA5jtqjvgGH8gOxGSv5TX2wG8afnx8=
X-Gm-Message-State: AOJu0YxFrLPptj1reUM9UNcjSfRwPyTZTYPACb/5vjGwQNB9+lW0OKdZ
	v+2qIl1Bl544tXkCj4QvoFI4bzYNU3TjYPgIK9tCRdcaxA21lhLEBVu3v5t+g7A=
X-Google-Smtp-Source: AGHT+IFOctQQNZ7iMkobRiq2sDhi9S7KL7xijSzq3YAWFYMIIxSgFMfFdgiJpaRuEIMMUNKerTcEZQ==
X-Received: by 2002:a05:6a00:2d07:b0:6ea:bd59:9389 with SMTP id fa7-20020a056a002d0700b006eabd599389mr10295316pfb.8.1711994246931;
        Mon, 01 Apr 2024 10:57:26 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:2:c51:2090:e106:83fa? ([2620:10d:c090:500::7:95f3])
        by smtp.gmail.com with ESMTPSA id y7-20020aa793c7000000b006e6fd17069fsm8125570pff.37.2024.04.01.10.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 10:57:26 -0700 (PDT)
Message-ID: <e9f801eb-07c0-4077-8e42-5387de587409@davidwei.uk>
Date: Mon, 1 Apr 2024 10:57:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/msg_ring: improve handling of target CQE
 posting
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240329201241.874888-1-axboe@kernel.dk>
 <20240329201241.874888-4-axboe@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20240329201241.874888-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-03-29 13:09, Jens Axboe wrote:
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
>  io_uring/msg_ring.c | 24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index d1f66a40b4b4..af8a5f2947b7 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -13,7 +13,6 @@
>  #include "filetable.h"
>  #include "msg_ring.h"
>  
> -
>  /* All valid masks for MSG_RING */
>  #define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
>  					IORING_MSG_RING_FLAGS_PASS)
> @@ -21,7 +20,6 @@
>  struct io_msg {
>  	struct file			*file;
>  	struct file			*src_file;
> -	struct callback_head		tw;
>  	u64 user_data;
>  	u32 len;
>  	u32 cmd;
> @@ -73,26 +71,18 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
>  	return current != target_ctx->submitter_task;
>  }
>  
> -static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
> +static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
>  {
>  	struct io_ring_ctx *ctx = req->file->private_data;
> -	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
> -	struct task_struct *task = READ_ONCE(ctx->submitter_task);
> -
> -	if (unlikely(!task))
> -		return -EOWNERDEAD;
> -
> -	init_task_work(&msg->tw, func);
> -	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
> -		return -EOWNERDEAD;
>  
> +	req->io_task_work.func = func;
> +	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
>  	return IOU_ISSUE_SKIP_COMPLETE;
>  }

This part looks correct. Now with io_req_task_work_add_remote(),
req->io_task_work.func is added to tctx->task_list, and queued up for
execution on the remote ctx->submitter_task via task_work_add(). The end
result is that the argument @func is executed on the remote
ctx->submitter_task, which is the same outcome as before.

Also, unsure how this hand rolled code interacted with defer taskrun
before but now it is handled properly in io_req_task_work_add_remote().

>  
> -static void io_msg_tw_complete(struct callback_head *head)
> +static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
>  {
> -	struct io_msg *msg = container_of(head, struct io_msg, tw);
> -	struct io_kiocb *req = cmd_to_io_kiocb(msg);
> +	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
>  	struct io_ring_ctx *target_ctx = req->file->private_data;
>  	int ret = 0;
>  
> @@ -205,10 +195,8 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
>  	return ret;
>  }
>  
> -static void io_msg_tw_fd_complete(struct callback_head *head)
> +static void io_msg_tw_fd_complete(struct io_kiocb *req, struct io_tw_state *ts)
>  {
> -	struct io_msg *msg = container_of(head, struct io_msg, tw);
> -	struct io_kiocb *req = cmd_to_io_kiocb(msg);
>  	int ret = -EOWNERDEAD;
>  
>  	if (!(current->flags & PF_EXITING))

