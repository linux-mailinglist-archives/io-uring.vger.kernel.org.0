Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE54318C9
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhJRMUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:20:11 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:51819 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhJRMUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:20:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UsfKwST_1634559477;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsfKwST_1634559477)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 20:17:57 +0800
Subject: Re: [PATCH v1] fs/io_uring: Hoist ret2 == -EAGAIN check in tail of
 io_write
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211018070242.20325-1-goldstein.w.n@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <f27e1842-f22e-a40d-7055-6f924b13100f@linux.alibaba.com>
Date:   Mon, 18 Oct 2021 20:17:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018070242.20325-1-goldstein.w.n@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/18 下午3:02, Noah Goldstein 写道:
> This commit reorganizes the branches in the tail of io_write so that
> the 'ret2 == -EAGAIN' check is not repeated and done first.
> 
> The previous version was duplicating the 'ret2 == -EAGAIN'. As well
> 'ret2 != -EAGAIN' gurantees the 'done:' path so it makes sense to
> move that check to the front before the likely more expensive branches
> which require memory derefences.
> 
> Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
> ---
> Generally I would want to rewrite this as:
> ```
> if (ret2 != -EAGAIN
>      || (req->flags & REQ_F_NOWAIT)
>      || (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL)))
>          kiocb_done(kiocb, ret2, issue_flags);
> else {
>      ...
> ```
To me, this one is clear enough and short, but I think better to:
if (ret2 != -EAGAIN || (req->flags & REQ_F_NOWAIT) ||
     (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))

if the first line doesn't exceed the line limit.

Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>
> 
> But the style of the file seems to be to use gotos. If the above is
> prefereable, let me know and I'll post a new version.
>   fs/io_uring.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d1e672e7a2d1..932fc84d70d3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3648,12 +3648,15 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	 */
>   	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
>   		ret2 = -EAGAIN;
> +
> +	if (ret2 != -EAGAIN)
> +		goto done;
>   	/* no retry on NONBLOCK nor RWF_NOWAIT */
> -	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
> +	if (req->flags & REQ_F_NOWAIT)
>   		goto done;
> -	if (!force_nonblock || ret2 != -EAGAIN) {
> +	if (!force_nonblock) {
>   		/* IOPOLL retry should happen for io-wq threads */
> -		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
> +		if (req->ctx->flags & IORING_SETUP_IOPOLL)
>   			goto copy_iov;
>   done:
>   		kiocb_done(kiocb, ret2, issue_flags);
> 

