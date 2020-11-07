Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DCF2AA816
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 22:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgKGVVP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 16:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGVVO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 16:21:14 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608EAC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 13:21:14 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id c9so4682151wml.5
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 13:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Errq3g+FkAHX6c1FZt8qmLvS+YrpmFBvPwR0JseowY=;
        b=f4kEjzi21jUHY/r3o77VZuWBjozhmYvuAnVhlqUJJ3dcK2LSIDkTxxyp4xxz68XmvN
         mFyho0rh1J3EtD8996QZxcQjE3+A7Bmx4nmwELJz62Yw3Lq1hbFv21/ODdGVR2iVe/wI
         q/9hGPwcxPaeNsAZXC8MJiyWPSDJVtdt5R7zzBinXdxE1znhRZUBHQN0IYv+3YDeGzs7
         8n7sgGAoNJAFI1ge5Z10d05ucHs+uZZtCZu+ku6tleYXWuhk674FjsAzub9MsA3DdgFm
         MVIUykKGqEP85HiSsLvLp+xbMGmPVdOf/HyRn9mWOXIyNvzQawmpCXp5rkMPAwTl7H/c
         EIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Errq3g+FkAHX6c1FZt8qmLvS+YrpmFBvPwR0JseowY=;
        b=TJ9nQR4OmuXwPO9fkJYHt/D2cU2H3SAn/+MNUbdiAkhV7RPkVolds+YUjI1URAWu3N
         5MArpGuOBCe4fIqpqqLZVF5ZmvYvPQDbVowt9WBmKvpdLqA9IMz7qyuunaqG8LOQoBzE
         o7XF9i/X8NgiFfoi/znxrvxaxAKbS5HXONZXkByQ1SrSfOgC68b3hy2YVN63YuAEhYIR
         2t3njNVXPMTHibcxtL8rEm0rwp6MX8emCZXUIo+RvBwixsfBFKAPvDSbp+Q9xXkeqNLW
         hB4mVvdwLe0KBkL3LxccBpXBZcmN7yjVzkmXoJV3I8gxZLuqJHhW2cIRogQtgm9u8OdY
         5HQA==
X-Gm-Message-State: AOAM532jwflbQtT5mouxtjma+wvNjSNpBoPL+uN1S5JhZgJZ9HN/fiLU
        puE2NH+cISEA21TN9F3XEV8=
X-Google-Smtp-Source: ABdhPJxiQCXKdM6mo1lJiyVshzVkEX6QataE0eZzPkIKXmzI+8/CWcehm6rEUjhizvOFpOrUplE2Vw==
X-Received: by 2002:a1c:2586:: with SMTP id l128mr6124944wml.149.1604784073161;
        Sat, 07 Nov 2020 13:21:13 -0800 (PST)
Received: from [192.168.1.96] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id k16sm1231338wrl.65.2020.11.07.13.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 13:21:12 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josef Grieb <josef.grieb@gmail.com>
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com>
Date:   Sat, 7 Nov 2020 21:18:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 21:16, Pavel Begunkov wrote:
> SQPOLL task may find sqo_task->files == NULL, so
> __io_sq_thread_acquire_files() would left it unset and so all the
> following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
> files.

Josef, could you try this one?

> 
> [  118.962785] BUG: kernel NULL pointer dereference, address:
> 	0000000000000020
> [  118.963812] #PF: supervisor read access in kernel mode
> [  118.964534] #PF: error_code(0x0000) - not-present page
> [  118.969029] RIP: 0010:__fget_files+0xb/0x80
> [  119.005409] Call Trace:
> [  119.005651]  fget_many+0x2b/0x30
> [  119.005964]  io_file_get+0xcf/0x180
> [  119.006315]  io_submit_sqes+0x3a4/0x950
> [  119.006678]  ? io_double_put_req+0x43/0x70
> [  119.007054]  ? io_async_task_func+0xc2/0x180
> [  119.007481]  io_sq_thread+0x1de/0x6a0
> [  119.007828]  kthread+0x114/0x150
> [  119.008135]  ? __ia32_sys_io_uring_enter+0x3c0/0x3c0
> [  119.008623]  ? kthread_park+0x90/0x90
> [  119.008963]  ret_from_fork+0x22/0x30
> 
> Reported-by: Josef Grieb <josef.grieb@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8d721a652d61..9c035c5c4080 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1080,7 +1080,7 @@ static void io_sq_thread_drop_mm_files(void)
>  	}
>  }
>  
> -static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
> +static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
>  {
>  	if (!current->files) {
>  		struct files_struct *files;
> @@ -1091,7 +1091,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
>  		files = ctx->sqo_task->files;
>  		if (!files) {
>  			task_unlock(ctx->sqo_task);
> -			return;
> +			return -EFAULT;
>  		}
>  		atomic_inc(&files->count);
>  		get_nsproxy(ctx->sqo_task->nsproxy);
> @@ -1105,6 +1105,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
>  		current->thread_pid = thread_pid;
>  		task_unlock(current);
>  	}
> +	return 0;
>  }
>  
>  static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
> @@ -1136,15 +1137,19 @@ static int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
>  					 struct io_kiocb *req)
>  {
>  	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	int ret;
>  
>  	if (def->work_flags & IO_WQ_WORK_MM) {
> -		int ret = __io_sq_thread_acquire_mm(ctx);
> +		ret = __io_sq_thread_acquire_mm(ctx);
>  		if (unlikely(ret))
>  			return ret;
>  	}
>  
> -	if (def->needs_file || (def->work_flags & IO_WQ_WORK_FILES))
> -		__io_sq_thread_acquire_files(ctx);
> +	if (def->needs_file || (def->work_flags & IO_WQ_WORK_FILES)) {
> +		ret = __io_sq_thread_acquire_files(ctx);
> +		if (unlikely(ret))
> +			return ret;
> +	}
>  
>  	return 0;
>  }
> @@ -2117,8 +2122,8 @@ static void __io_req_task_submit(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  
> -	if (!__io_sq_thread_acquire_mm(ctx)) {
> -		__io_sq_thread_acquire_files(ctx);
> +	if (!__io_sq_thread_acquire_mm(ctx) &&
> +	    !__io_sq_thread_acquire_files(ctx)) {
>  		mutex_lock(&ctx->uring_lock);
>  		__io_queue_sqe(req, NULL);
>  		mutex_unlock(&ctx->uring_lock);
> 

-- 
Pavel Begunkov
