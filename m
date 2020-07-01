Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A11210B3A
	for <lists+io-uring@lfdr.de>; Wed,  1 Jul 2020 14:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgGAMr0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jul 2020 08:47:26 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:54722 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730671AbgGAMrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jul 2020 08:47:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U1MtaPW_1593607641;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0U1MtaPW_1593607641)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Jul 2020 20:47:21 +0800
Date:   Wed, 1 Jul 2020 20:47:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: fix req cannot arm poll after polled
Message-ID: <20200701124721.tn5oymcoslfabifo@e02h04398.eu6sqa>
References: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


It is true that this path is not perfect for poll, I mainly want to
solve this bug first.

I have considered to prevent the network fd from entering io-wq. It
is more reasonable to use poll for network fd. And since there is no
relationship between the sqes of the same network fd, each will receive
an EAGAIN and then arm poll, It is unreasonable to be wakeup at the same
time.  Although link can solve some problems.

Back to this question, I was able to reproduce this bug yesterday, but it
is strange that I tried various versions today, and I can't reproduce it
anymore.

The analysis at the time was that io_uring_release was not triggered. I
guess it is because mm refers to io_uring fd, and worker refers to mm and
enters schedule, which causes io_uring not to be completely closed.

But when I test today, it cannot be reproduced. When the process exits,
the network connection will always close automatically then the worker
exits the schedule. I don't know why it was not closed yesterday.

Sorry, I will test it later, if there is a conclusion I will report this
problem again.

Thanks jens and pavel for your time.

On Tue, Jun 30, 2020 at 08:41:14PM +0800, Xuan Zhuo wrote:
> For example, there are multiple sqes recv with the same connection.
> When there is no data in the connection, the reqs of these sqes will
> be armed poll. Then if only a little data is received, only one req
> receives the data, and the other reqs get EAGAIN again. However,
> due to this flags REQ_F_POLLED, these reqs cannot enter the
> io_arm_poll_handler function. These reqs will be put into wq by
> io_queue_async_work, and the flags passed by io_wqe_worker when recv
> is called are BLOCK, which may make io_wqe_worker enter schedule in the
> network protocol stack. When the main process of io_uring exits,
> these io_wqe_workers still cannot exit. The connection will not be
> actively released until the connection is closed by the peer.
>
> So we should allow req to arm poll again.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e507737..a309832 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4406,7 +4406,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>
>  	if (!req->file || !file_can_poll(req->file))
>  		return false;
> -	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
> +	if (req->flags & REQ_F_MUST_PUNT)
>  		return false;
>  	if (!def->pollin && !def->pollout)
>  		return false;
> --
> 1.8.3.1
