Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DB91EBDBA
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgFBONw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 10:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBONv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 10:13:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E55C08C5C0;
        Tue,  2 Jun 2020 07:13:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r15so3284983wmh.5;
        Tue, 02 Jun 2020 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=620qNBOcG6B1tL2G5KN1nGka3Y3eV855G4nRd31cB/g=;
        b=pEiK76GUfECMMh7p6iixv+TojW4SqeYW2/H9HZUO5ToxHDGogJXJ8TT64O+pklo2OC
         IFfa0Nvv2YkKD2A9YTv2BMfe7TMGY0Z521DSVcPB2mrf1HXSU4YrWrQxThwzf9m+Z/HH
         kDbn2WStIxQ/CkVFgehheGIeDG3vM48oHaOrYgpIHbyuPuIz5AYDA1nKrLb41LrGtcos
         NIw2O0CWG/6AjhdOzcTWc600uSbOalSNCnrpfm1jTPG1m96BPnYAAV58Xdx+KYWaq/N3
         h2NRrlancweR3/aVMnb8vmrC8FsaBIuThUx/Fmp5S/GDT8B7mlAVkjMntzDnw3PH6FBp
         DeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=620qNBOcG6B1tL2G5KN1nGka3Y3eV855G4nRd31cB/g=;
        b=HRJCyYaTVdG/ILr6rjIt86UOsociKkIz6rGQJ5yZ7rTiZqhN2fO8Cy8Jwu3yygigK/
         aKdxia1nZ5UhRM/jzSWZPCf0nfRWhwlZNUf0bkLWZPRWD6mUlxyNyF0u6m1JwKjqlYBT
         n25h0sXf4PbQP1bGPyQ68hHk7mltSSqn7JNnf64+LLB8iiH+CBCQJJuj2ZPX3xEXTqN4
         lHkO4lVo7wkYbIRqG1fsx+Kz8hxjll/JPWaJWQlTRLUoh2bbRdJciFqn/87t5AOVjYST
         LedDaLBHVAD3BSQ6658hooYDKgDhlQyG2sMVWpi4RqAVn0nSVZGX4zXf2NX+nhqRFFNP
         BDDw==
X-Gm-Message-State: AOAM532irOnPzxUBW/irHDlH58xuhU3mDMQmm+7V4oq3a9uk8X+OUqnD
        RXiMfd3P7jvPq3ax0sT7yExgh9ko
X-Google-Smtp-Source: ABdhPJyQarfh0+AY6RidR3a8yFd4KsABn2631aiXvSyMEz9ijrEIdJH7BRppWkAqInCOZ9e4xD4dFQ==
X-Received: by 2002:a1c:dc44:: with SMTP id t65mr4640511wmg.128.1591107229699;
        Tue, 02 Jun 2020 07:13:49 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id d13sm3508700wmb.39.2020.06.02.07.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 07:13:49 -0700 (PDT)
Subject: Re: [PATCH 1/4] io_uring: fix open/close/statx with {SQ,IO}POLL
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591100205.git.asml.silence@gmail.com>
 <aacbeec9c7ed21971119aec3669dff7f707bccb2.1591100205.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b3e14e84-727a-9edc-8e69-d41282123241@gmail.com>
Date:   Tue, 2 Jun 2020 17:12:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <aacbeec9c7ed21971119aec3669dff7f707bccb2.1591100205.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/06/2020 15:34, Pavel Begunkov wrote:
> Trying to use them with IORING_SETUP_IOPOLL:
> 
> RIP: 0010:io_iopoll_getevents+0x111/0x5a0
> Call Trace:
>  ? _raw_spin_unlock_irqrestore+0x24/0x40
>  ? do_send_sig_info+0x64/0x90
>  io_iopoll_reap_events.part.0+0x5e/0xa0
>  io_ring_ctx_wait_and_kill+0x132/0x1c0
>  io_uring_release+0x20/0x30
>  __fput+0xcd/0x230
>  ____fput+0xe/0x10
>  task_work_run+0x67/0xa0
>  do_exit+0x353/0xb10
>  ? handle_mm_fault+0xd4/0x200
>  ? syscall_trace_enter+0x18c/0x2c0
>  do_group_exit+0x43/0xa0
>  __x64_sys_exit_group+0x18/0x20
>  do_syscall_64+0x60/0x1e0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_do_iopoll()
{
	...
	ret = kiocb->*ki_filp*->f_op->iopoll(kiocb, spin);
}

Hmm, I'll double check later that only read*/write* can be done
with IOPOLL, and send a follow-up patch if necessary.

> 
> Also SQPOLL thread can't know which file table to use with
> open/close. Disallow all these cases.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 732ec73ec3c0..7208f91e9e77 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2990,6 +2990,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	const char __user *fname;
>  	int ret;
>  
> +	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
> +		return -EINVAL;
>  	if (sqe->ioprio || sqe->buf_index)
>  		return -EINVAL;
>  	if (req->flags & REQ_F_FIXED_FILE)
> @@ -3023,6 +3025,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	size_t len;
>  	int ret;
>  
> +	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
> +		return -EINVAL;
>  	if (sqe->ioprio || sqe->buf_index)
>  		return -EINVAL;
>  	if (req->flags & REQ_F_FIXED_FILE)
> @@ -3373,6 +3377,8 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
>  
>  static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
>  	if (sqe->ioprio || sqe->buf_index)
>  		return -EINVAL;
>  	if (req->flags & REQ_F_FIXED_FILE)
> @@ -3417,6 +3423,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	 */
>  	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
>  
> +	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
> +		return -EINVAL;
>  	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
>  	    sqe->rw_flags || sqe->buf_index)
>  		return -EINVAL;
> 

-- 
Pavel Begunkov
