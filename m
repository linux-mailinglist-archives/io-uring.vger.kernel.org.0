Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAFD30F1A1
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 12:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhBDLJo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 06:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbhBDLJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 06:09:31 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0073C061786
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 03:08:51 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id a16so5712494wmm.0
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 03:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aGAsA1bgfm0HZOyyitRDPhn0jxLWuNEiYkye6XnvaLg=;
        b=Q7yiMD2pGAc9NRka3ZtrYq1M8fNtjqWbonq5jqGjJ9nhuk8BkGK8k2oQgK3AzlMlEy
         kQj8u5h+jenb8mvhQJ1b2D1H1q19QeF6H3Tx02GZo62XR/Yha06jvRZ22AS9+l9Ux5CE
         mMq+YxVXd4IObjhnhnyHstc1D3ZLc7l8a0C/txb2MCbhuaGVj4tLMfmxmu60Mpbr5leM
         iF/2iN+qudNf0md0R/6C96xDIFmc+lWdfgxZ4FM8G4owGMMBGbGBlUzTnnoXOznKdZjl
         FddDssigJ4d1piEQRC5FScVxcie8QLY3T+iJUcilmNxoH4cuOehIEnM0tYxRrJk5knQt
         b+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aGAsA1bgfm0HZOyyitRDPhn0jxLWuNEiYkye6XnvaLg=;
        b=LEi61IJbvK6YRht++gdBcNeToQHmIXcIrCs+RXOFOgRuZGrYt2PV5RgUj7B3bRUMk2
         7PXUapTXxca5eJhNdZEqLsDXk523VQwo8TuZkJ9so7PPEnS1n9CjoiI/wG1WpQlznfoz
         RyejnDA6bi6KZtf7PnqGsDjUxXS8G471TiGknzw15FtwH9HPwwVfhk7Wgh/HBDdUgJw1
         X85UzsIoQcExpCnpfSMXxZrap1kncSJ0dSWGrs9i0ECcSOa54IcW8TPl7vg5dWWDCCeB
         nzpIqhyuseP8DTlhP7SlStCRhhIsKkZdowLYYQQsW4dotXIB3PGxwoD96RM41l9pRgWt
         mNDA==
X-Gm-Message-State: AOAM531fv+rYXyBqxC2LiGm3YfW8oRgtrGWzSUp4BmLAJacYTERk/jKP
        lkIavOHztvGLHz7EMCBc0oGB4Oxvc5mrFQ==
X-Google-Smtp-Source: ABdhPJwYx9VFgJCeI4VzEpQLimaol0StE+oT0YgICfFK+Vx4OSOdDJagjh/D6Yb0840chOhG/9UCYA==
X-Received: by 2002:a1c:99d1:: with SMTP id b200mr6966303wme.37.1612436930438;
        Thu, 04 Feb 2021 03:08:50 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id z14sm7464666wrm.5.2021.02.04.03.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 03:08:49 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't modify identity's files uncess identity
 is cowed
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210204092056.12797-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <150e4e33-5c12-3ae3-9db3-2d85edb94c5f@gmail.com>
Date:   Thu, 4 Feb 2021 11:05:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210204092056.12797-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/02/2021 09:20, Xiaoguang Wang wrote:
> Abaci Robot reported following panic:
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 800000010ef3f067 P4D 800000010ef3f067 PUD 10d9df067 PMD 0
> Oops: 0002 [#1] SMP PTI
> CPU: 0 PID: 1869 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc3+ #1
> Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> RIP: 0010:put_files_struct+0x1b/0x120
> Code: 24 18 c7 00 f4 ff ff ff e9 4d fd ff ff 66 90 0f 1f 44 00 00 41 57 41 56 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 b5 6b db ff  41 ff 0e 74 13 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f e9 9c
> RSP: 0000:ffffc90002147d48 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88810d9a5300 RCX: 0000000000000000
> RDX: ffff88810d87c280 RSI: ffffffff8144ba6b RDI: 0000000000000000
> RBP: 0000000000000080 R08: 0000000000000001 R09: ffffffff81431500
> R10: ffff8881001be000 R11: 0000000000000000 R12: ffff88810ac2f800
> R13: ffff88810af38a00 R14: 0000000000000000 R15: ffff8881057130c0
> FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010dbaa002 CR4: 00000000003706f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __io_clean_op+0x10c/0x2a0
>  io_dismantle_req+0x3c7/0x600
>  __io_free_req+0x34/0x280
>  io_put_req+0x63/0xb0
>  io_worker_handle_work+0x60e/0x830
>  ? io_wqe_worker+0x135/0x520
>  io_wqe_worker+0x158/0x520
>  ? __kthread_parkme+0x96/0xc0
>  ? io_worker_handle_work+0x830/0x830
>  kthread+0x134/0x180
>  ? kthread_create_worker_on_cpu+0x90/0x90
>  ret_from_fork+0x1f/0x30
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace c358ca86af95b1e7 ]---
> 
> I guess case below can trigger above panic: there're two threads which
> operates different io_uring ctxs and share same sqthread identity, and
> later one thread exits, io_uring_cancel_task_requests() will clear
> task->io_uring->identity->files to be NULL in sqpoll mode, then another
> ctx that uses same identity will panic.
> 
> Indeed we don't need to clear task->io_uring->identity->files here,
> io_grab_identity() should handle identity->files changes well, if
> task->io_uring->identity->files is not equal to current->files,
> io_cow_identity() should handle this changes well.

Didn't look in the trace above, but the change looks good. I even did
it myself a couple of weeks ago, but it got dropped because of unrelated
hassle.

I'll test/review a bit later.

> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 38c6cbe1ab38..5d3348d66f06 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8982,12 +8982,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
>  
>  	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
>  		atomic_dec(&task->io_uring->in_idle);
> -		/*
> -		 * If the files that are going away are the ones in the thread
> -		 * identity, clear them out.
> -		 */
> -		if (task->io_uring->identity->files == files)
> -			task->io_uring->identity->files = NULL;
>  		io_sq_thread_unpark(ctx->sq_data);
>  	}
>  }
> 

-- 
Pavel Begunkov
