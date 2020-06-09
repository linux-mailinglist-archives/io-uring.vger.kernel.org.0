Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552501F3621
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 10:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgFIIc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 04:32:58 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:51721 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbgFIIc6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 04:32:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.3ia1H_1591691574;
Received: from 30.225.32.164(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.3ia1H_1591691574)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Jun 2020 16:32:54 +0800
Subject: Re: [PATCH v6 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
References: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
 <20200609082512.19053-2-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <c6a149fd-98e6-2597-40d2-6d0a861e58c9@linux.alibaba.com>
Date:   Tue, 9 Jun 2020 16:32:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200609082512.19053-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

I also use below debug patch to run test cases in liburing:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3bec6057c189..119764d18a61 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5819,6 +5819,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
         refcount_set(&req->refs, 2);
         req->task = NULL;
         req->result = 0;
+       req->work.list.next = 0x1;
+       req->work.files = 0x2;
+       req->work.mm = 0x3;
+       req->work.creds = 0x4;
+       req->work.fs = 0x5;
+       req->work.flags = 0x6;
+       req->work.task_pid = 0x7;

All test cases pass.

Regards,
Xiaoguang Wang

> Basically IORING_OP_POLL_ADD command and async armed poll handlers
> for regular commands don't touch io_wq_work, so only REQ_F_WORK_INITIALIZED
> is set, can we do io_wq_work copy and restore.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> ---
> V3:
>    drop the REQ_F_WORK_NEED_RESTORE flag introduced in V2 patch, just
>    use REQ_F_WORK_INITIALIZED to control whether to do io_wq_work copy
>    and restore.
> 
> V6:
>    rebase to io_uring-5.8.
> ---
>   fs/io_uring.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bde8b17a7275..3bec6057c189 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4261,7 +4261,8 @@ static void io_async_task_func(struct callback_head *cb)
>   	spin_unlock_irq(&ctx->completion_lock);
>   
>   	/* restore ->work in case we need to retry again */
> -	memcpy(&req->work, &apoll->work, sizeof(req->work));
> +	if (req->flags & REQ_F_WORK_INITIALIZED)
> +		memcpy(&req->work, &apoll->work, sizeof(req->work));
>   	kfree(apoll);
>   
>   	if (!canceled) {
> @@ -4358,7 +4359,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>   		return false;
>   
>   	req->flags |= REQ_F_POLLED;
> -	memcpy(&apoll->work, &req->work, sizeof(req->work));
> +	if (req->flags & REQ_F_WORK_INITIALIZED)
> +		memcpy(&apoll->work, &req->work, sizeof(req->work));
>   	had_io = req->io != NULL;
>   
>   	get_task_struct(current);
> @@ -4383,7 +4385,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>   		if (!had_io)
>   			io_poll_remove_double(req);
>   		spin_unlock_irq(&ctx->completion_lock);
> -		memcpy(&req->work, &apoll->work, sizeof(req->work));
> +		if (req->flags & REQ_F_WORK_INITIALIZED)
> +			memcpy(&req->work, &apoll->work, sizeof(req->work));
>   		kfree(apoll);
>   		return false;
>   	}
> @@ -4428,7 +4431,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>   			 * io_req_work_drop_env below when dropping the
>   			 * final reference.
>   			 */
> -			memcpy(&req->work, &apoll->work, sizeof(req->work));
> +			if (req->flags & REQ_F_WORK_INITIALIZED)
> +				memcpy(&req->work, &apoll->work,
> +				       sizeof(req->work));
>   			kfree(apoll);
>   		}
>   	}
> 
