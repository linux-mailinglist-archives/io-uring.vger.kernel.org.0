Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A8442DB26
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 16:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhJNOLS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 10:11:18 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:47001 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231754AbhJNOLR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 10:11:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Urt-uGS_1634220550;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Urt-uGS_1634220550)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Oct 2021 22:09:11 +0800
Subject: Re: [PATCH] io_uring: fix wrong condition to grab uring lock
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211014140400.50235-1-haoxu@linux.alibaba.com>
Message-ID: <adf008d8-b5ee-e87c-950a-b107c8f286d1@linux.alibaba.com>
Date:   Thu, 14 Oct 2021 22:09:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014140400.50235-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/14 下午10:04, Hao Xu 写道:
> Grab uring lock when we are in io-worker rather than in the original
> or system-wq context since we already hold it in these two situation.
> 
Fixes: b66ceaf324b3 ("io_uring: move iopoll reissue into regular IO path")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 73135c5c6168..e2ed21c65f71 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2890,7 +2890,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>   			struct io_ring_ctx *ctx = req->ctx;
>   
>   			req_set_fail(req);
> -			if (issue_flags & IO_URING_F_NONBLOCK) {
> +			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
>   				mutex_lock(&ctx->uring_lock);
>   				__io_req_complete(req, issue_flags, ret, cflags);
>   				mutex_unlock(&ctx->uring_lock);
> 

