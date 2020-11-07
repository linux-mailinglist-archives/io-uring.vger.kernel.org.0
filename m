Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175702AA845
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 23:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgKGWaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 17:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGWaJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 17:30:09 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C058FC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 14:30:09 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id f12so1214768pjp.4
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 14:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z4CTzF8taWA1BUQEpBfHutXb06Pzq4R5XNa6HAXn6mU=;
        b=t5Th/mv9/kLdNzwP8M1geqS0wTm6YY7fIyEB/A74valWqCa0p0yNVRekunSVS21lh2
         HmtG9M78QgWu7k4Dw/5ZvJd9avRjaJ8VmX0lzv58tf2PEYUums0s24qvg5cgnRjyGREB
         QNLootRIn+HBmejiWYSofS4NcvPeFT/PDdItbn3MsR/SPWc2AGM/qitEFEF4hPFc+VO5
         c+0WclVTcG6nOaUxkw/hZO33kg3pRVTw7lqbxAbmms9PgOfx9RGUs1Sbit2budD5ugJq
         /Q5cmKReOqXs/3E0QAlAX33bleYoRcSq75U6LoQdAg/Ku4AmRpzqmJcnh/vE6WC6eI3+
         oJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z4CTzF8taWA1BUQEpBfHutXb06Pzq4R5XNa6HAXn6mU=;
        b=ihDf3T9HNoN+bPUM/V+9IKJJueoO+CAAy+Kthu3ztGBwgNsgQhlr9V3kn9yZdT8MDr
         /L8eht1LYUmYQjRSGXMwGY0kQF/XR2eTACv575tHm/e+3sW1/HlpNsmmj67+21PBewS1
         25mablOwx0N/pRHpEkJ0Hy1Q3Pvy4NNFT93LWC9D0D1pe+GTQ/1ExzX+0UIpIbIO/l6c
         tbtZRI8wJLgcH73Te2HbVTlZccetwg6rSjG7SKl9EL0kWNVehBxgU2CetrZ00Shshvq1
         ZudABlRj+f9ntKR7/W7tT+CQh07UjY4BgNECusqLO+DY5lvq2d00cbs2WlVtzIHOQs1R
         ytHg==
X-Gm-Message-State: AOAM533P4TylLx6Q67xLRADbszgegtg7iALi6l542VqGG1/PmC1ywgDc
        +iMCQ4vl/+peLTnR5bWMoAdlmnyYnW46XA==
X-Google-Smtp-Source: ABdhPJwytn9UYA9zsfhWqRBd9UGxcXbfg22Jx99x1Dcpo7JrMxcx+CAY/+vIckVbnFf/Ar85YYZXeA==
X-Received: by 2002:a17:902:9006:b029:d6:e5d0:abfd with SMTP id a6-20020a1709029006b02900d6e5d0abfdmr6818174plp.69.1604788209318;
        Sat, 07 Nov 2020 14:30:09 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c140sm6513121pfb.124.2020.11.07.14.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 14:30:08 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Josef Grieb <josef.grieb@gmail.com>
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dd1253a1-e7aa-57a6-9851-7f7d4dfd9a92@kernel.dk>
Date:   Sat, 7 Nov 2020 15:30:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/20 2:16 PM, Pavel Begunkov wrote:
> SQPOLL task may find sqo_task->files == NULL, so
> __io_sq_thread_acquire_files() would left it unset and so all the
> following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
> files.
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

I don't think we should use -EFAULT here, it's generally used for trying
to copy in/out of invalid regions. Probably -ECANCELED is better here,
in lieu of something super appropriate. Maybe -EBADF would be fine too.

-- 
Jens Axboe

