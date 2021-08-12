Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0753E9F78
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 09:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhHLHfC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 03:35:02 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:47372 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231331AbhHLHfB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 03:35:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UilCpv2_1628753675;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UilCpv2_1628753675)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 15:34:35 +0800
Subject: Re: [PATCH 3/3] io_uring: code clean for completion_lock in
 io_arm_poll_handler()
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <20210812041436.101503-1-haoxu@linux.alibaba.com>
 <20210812041436.101503-4-haoxu@linux.alibaba.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <cb6e6b18-62c2-bcde-d0a8-d10a768e2e0a@linux.alibaba.com>
Date:   Thu, 12 Aug 2021 15:34:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812041436.101503-4-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 8/12/21 12:14 PM, Hao Xu wrote:
> We can merge two spin_unlock() operations to one since we removed some
> code not long ago.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b29774aa1f09..9cbc66b52643 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5231,13 +5231,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  
>  	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>  					io_async_wake);
> -	if (ret || ipt.error) {
> -		spin_unlock(&ctx->completion_lock);
> -		if (ret)
> -			return IO_APOLL_READY;
> -		return IO_APOLL_ABORTED;
> -	}
> -	spin_unlock(&ctx->completion_lock);
> +	spin_unlock_irq(&ctx->completion_lock);

This looks weird.
You replace spin_unlock() with spin_unlock_irq() without any spin_lock()
changes.

Thanks,
Joseph 

> +	if (ret || ipt.error)
> +		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
> +
>  	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
>  				mask, apoll->poll.events);
>  	return IO_APOLL_OK;
> 
