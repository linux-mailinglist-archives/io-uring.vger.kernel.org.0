Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDFA295881
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 08:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441485AbgJVGnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 02:43:02 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:19407 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409791AbgJVGnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 02:43:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UCok-t7_1603348979;
Received: from 30.225.32.203(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UCok-t7_1603348979)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Oct 2020 14:42:59 +0800
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <13c73e10-040f-9a0b-5396-b3f2a0c301b0@linux.alibaba.com>
Date:   Thu, 22 Oct 2020 14:42:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> Every close(io_uring) causes cancellation of all inflight requests
> carrying ->files. That's not nice but was neccessary up until recently.
> Now task->files removal is handled in the core code, so that part of
> flush can be removed.
I don't catch up with newest io_uring codes yet, but have one question about
the initial implementation "io_uring: io_uring: add support for async work
inheriting files": https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb323cc53e29d9cc696d606bb42736b32dd9825
There was such comments:
+static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+       int ret = -EBADF;
+
+       rcu_read_lock();
+       spin_lock_irq(&ctx->inflight_lock);
+       /*
+        * We use the f_ops->flush() handler to ensure that we can flush
+        * out work accessing these files if the fd is closed. Check if
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I wonder why we only need to flush reqs specifically when they access current->files, are there
any special reasons?

Regards,
Xiaoguang Wang

+        * the fd has changed since we started down this path, and disallow
+        * this operation if it has.
+        */
+       if (fcheck(req->submit.ring_fd) == req->submit.ring_file) {
+               list_add(&req->inflight_entry, &ctx->inflight_list);
+               req->flags |= REQ_F_INFLIGHT;
+               req->work.files = current->files;
+               ret = 0;
+       }
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 95d2bb7069c6..6536e24eb44e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8748,16 +8748,12 @@ void __io_uring_task_cancel(void)
>   
>   static int io_uring_flush(struct file *file, void *data)
>   {
> -	struct io_ring_ctx *ctx = file->private_data;
> +	bool exiting = !data;
>   
> -	/*
> -	 * If the task is going away, cancel work it may have pending
> -	 */
>   	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> -		data = NULL;
> +		exiting = true;
>   
> -	io_uring_cancel_task_requests(ctx, data);
> -	io_uring_attempt_task_drop(file, !data);
> +	io_uring_attempt_task_drop(file, exiting);
>   	return 0;
>   }
>   
> 
