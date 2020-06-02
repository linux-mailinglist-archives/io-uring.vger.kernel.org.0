Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D541EB2E8
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 03:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFBBQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 21:16:47 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56087 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725793AbgFBBQq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 21:16:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-KjqE5_1591060603;
Received: from 192.168.124.21(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-KjqE5_1591060603)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Jun 2020 09:16:43 +0800
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
Date:   Tue, 2 Jun 2020 09:16:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi Jens, Pavel,

Will you have a look at this V5 version? Or we hold on this patchset, and
do the refactoring work related io_wq_work firstly.

Regards,
Xiaoguang Wang


> Basically IORING_OP_POLL_ADD command and async armed poll handlers
> for regular commands don't touch io_wq_work, so only REQ_F_WORK_INITIALIZED
> is set, can we do io_wq_work copy and restore.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
> V3:
>    drop the REQ_F_WORK_NEED_RESTORE flag introduced in V2 patch, just
>    use REQ_F_WORK_INITIALIZED to control whether to do io_wq_work copy
>    and restore.
> ---
>   fs/io_uring.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8e022d0f0c86..b761ef7366f9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4527,7 +4527,8 @@ static void io_async_task_func(struct callback_head *cb)
>   	spin_unlock_irq(&ctx->completion_lock);
>   
>   	/* restore ->work in case we need to retry again */
> -	memcpy(&req->work, &apoll->work, sizeof(req->work));
> +	if (req->flags & REQ_F_WORK_INITIALIZED)
> +		memcpy(&req->work, &apoll->work, sizeof(req->work));
>   	kfree(apoll);
>   
>   	if (!canceled) {
> @@ -4624,7 +4625,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>   		return false;
>   
>   	req->flags |= REQ_F_POLLED;
> -	memcpy(&apoll->work, &req->work, sizeof(req->work));
> +	if (req->flags & REQ_F_WORK_INITIALIZED)
> +		memcpy(&apoll->work, &req->work, sizeof(req->work));
>   	had_io = req->io != NULL;
>   
>   	get_task_struct(current);
> @@ -4649,7 +4651,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>   		if (!had_io)
>   			io_poll_remove_double(req);
>   		spin_unlock_irq(&ctx->completion_lock);
> -		memcpy(&req->work, &apoll->work, sizeof(req->work));
> +		if (req->flags & REQ_F_WORK_INITIALIZED)
> +			memcpy(&req->work, &apoll->work, sizeof(req->work));
>   		kfree(apoll);
>   		return false;
>   	}
> @@ -4694,7 +4697,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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
