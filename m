Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE681C3BCE
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEDN4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 09:56:13 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:29910 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgEDN4N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 09:56:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TxU8bXZ_1588600560;
Received: from 30.0.151.1(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TxU8bXZ_1588600560)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 04 May 2020 21:56:01 +0800
Subject: Re: [PATCH] io_uring: fix mismatched finish_wait() calls in
 io_uring_cancel_files()
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200426075443.30215-1-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <b2e8ed1e-dc3b-1fbc-a44c-f72b40b09fa4@linux.alibaba.com>
Date:   Mon, 4 May 2020 21:56:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200426075443.30215-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

Ping.

Regards,
Xiaoguang Wang
> The prepare_to_wait() and finish_wait() calls in io_uring_cancel_files()
> are mismatched. Currently I don't see any issues related this bug, just
> find it by learning codes.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   fs/io_uring.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c687f57fb651..2d7a8d05ab10 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7356,11 +7356,9 @@ static int io_uring_release(struct inode *inode, struct file *file)
>   static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>   				  struct files_struct *files)
>   {
> -	struct io_kiocb *req;
> -	DEFINE_WAIT(wait);
> -
>   	while (!list_empty_careful(&ctx->inflight_list)) {
> -		struct io_kiocb *cancel_req = NULL;
> +		struct io_kiocb *cancel_req = NULL, *req;
> +		DEFINE_WAIT(wait);
>   
>   		spin_lock_irq(&ctx->inflight_lock);
>   		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
> @@ -7400,6 +7398,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>   			 */
>   			if (refcount_sub_and_test(2, &cancel_req->refs)) {
>   				io_put_req(cancel_req);
> +				finish_wait(&ctx->inflight_wait, &wait);
>   				continue;
>   			}
>   		}
> @@ -7407,8 +7406,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>   		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
>   		io_put_req(cancel_req);
>   		schedule();
> +		finish_wait(&ctx->inflight_wait, &wait);
>   	}
> -	finish_wait(&ctx->inflight_wait, &wait);
>   }
>   
>   static int io_uring_flush(struct file *file, void *data)
> 
