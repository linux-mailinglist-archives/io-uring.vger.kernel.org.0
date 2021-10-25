Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E764391D3
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 10:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhJYJAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 05:00:40 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43489 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232168AbhJYJAj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 05:00:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtZ8Vz4_1635152295;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtZ8Vz4_1635152295)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 16:58:16 +0800
Subject: Re: [PATCH 4/8] io_uring: check if opcode needs poll first on arming
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634987320.git.asml.silence@gmail.com>
 <9adfe4f543d984875e516fce6da35348aab48668.1634987320.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <b8b93b8e-f313-35f0-84ad-ad60ffcc2b2f@linux.alibaba.com>
Date:   Mon, 25 Oct 2021 16:58:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9adfe4f543d984875e516fce6da35348aab48668.1634987320.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/23 下午7:13, Pavel Begunkov 写道:
> ->pollout or ->pollin are set only for opcodes that need a file, so if
> io_arm_poll_handler() tests them first we can be sure that the request
> has file set and the ->file check can be removed.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>
>   fs/io_uring.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 58cb3a14d58e..bff911f951ed 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5584,12 +5584,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>   	struct io_poll_table ipt;
>   	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
>   
> -	if (!req->file || !file_can_poll(req->file))
> -		return IO_APOLL_ABORTED;
> -	if (req->flags & REQ_F_POLLED)
> -		return IO_APOLL_ABORTED;
>   	if (!def->pollin && !def->pollout)
>   		return IO_APOLL_ABORTED;
> +	if (!file_can_poll(req->file) || (req->flags & REQ_F_POLLED))
> +		return IO_APOLL_ABORTED;
>   
>   	if (def->pollin) {
>   		mask |= POLLIN | POLLRDNORM;
> 

