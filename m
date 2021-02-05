Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE5331024B
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 02:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhBEBfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 20:35:03 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56805 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232726AbhBEBfC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 20:35:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNvCpgG_1612488858;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UNvCpgG_1612488858)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Feb 2021 09:34:19 +0800
Subject: Re: [PATCH] io_uring: don't modify identity's files uncess identity
 is cowed
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20210204092056.12797-1-xiaoguang.wang@linux.alibaba.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <7297b50d-0fe8-3424-1664-a3a74c92879d@linux.alibaba.com>
Date:   Fri, 5 Feb 2021 09:34:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204092056.12797-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A typo in subject, 'uncess' -> 'unless'?

Thanks,
Joseph

On 2/4/21 5:20 PM, Xiaoguang Wang wrote:
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
