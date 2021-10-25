Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8B24391D1
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhJYJAS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 05:00:18 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:47622 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231463AbhJYJAS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 05:00:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtZ8VvI_1635152274;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtZ8VvI_1635152274)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 16:57:55 +0800
Subject: Re: [PATCH 3/8] io_uring: clean iowq submit work cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634987320.git.asml.silence@gmail.com>
 <ff4a09cf41f7a22bbb294b6f1faea721e21fe615.1634987320.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <24c6fc94-f7a9-5a53-d29f-99e245672fb3@linux.alibaba.com>
Date:   Mon, 25 Oct 2021 16:57:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ff4a09cf41f7a22bbb294b6f1faea721e21fe615.1634987320.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/23 下午7:13, Pavel Begunkov 写道:
> If we've got IO_WQ_WORK_CANCEL in io_wq_submit_work(), handle the error
> on the same lines as the check instead of having a weird code flow. The
> main loop doesn't change but goes one indention left.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>
>   fs/io_uring.c | 59 +++++++++++++++++++++++++--------------------------
>   1 file changed, 29 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7f92523c1282..58cb3a14d58e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6721,6 +6721,8 @@ static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
>   static void io_wq_submit_work(struct io_wq_work *work)
>   {
>   	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> +	unsigned int issue_flags = IO_URING_F_UNLOCKED;
> +	bool needs_poll = false;
>   	struct io_kiocb *timeout;
>   	int ret = 0;
>   
> @@ -6735,40 +6737,37 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		io_queue_linked_timeout(timeout);
>   
>   	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
> -	if (work->flags & IO_WQ_WORK_CANCEL)
> -		ret = -ECANCELED;
> +	if (work->flags & IO_WQ_WORK_CANCEL) {
> +		io_req_task_queue_fail(req, -ECANCELED);
> +		return;
> +	}
>   
> -	if (!ret) {
> -		bool needs_poll = false;
> -		unsigned int issue_flags = IO_URING_F_UNLOCKED;
> +	if (req->flags & REQ_F_FORCE_ASYNC) {
> +		needs_poll = req->file && file_can_poll(req->file);
> +		if (needs_poll)
> +			issue_flags |= IO_URING_F_NONBLOCK;
> +	}
>   
> -		if (req->flags & REQ_F_FORCE_ASYNC) {
> -			needs_poll = req->file && file_can_poll(req->file);
> -			if (needs_poll)
> -				issue_flags |= IO_URING_F_NONBLOCK;
> +	do {
> +		ret = io_issue_sqe(req, issue_flags);
> +		if (ret != -EAGAIN)
> +			break;
> +		/*
> +		 * We can get EAGAIN for iopolled IO even though we're
> +		 * forcing a sync submission from here, since we can't
> +		 * wait for request slots on the block side.
> +		 */
> +		if (!needs_poll) {
> +			cond_resched();
> +			continue;
>   		}
>   
> -		do {
> -			ret = io_issue_sqe(req, issue_flags);
> -			if (ret != -EAGAIN)
> -				break;
> -			/*
> -			 * We can get EAGAIN for iopolled IO even though we're
> -			 * forcing a sync submission from here, since we can't
> -			 * wait for request slots on the block side.
> -			 */
> -			if (!needs_poll) {
> -				cond_resched();
> -				continue;
> -			}
> -
> -			if (io_arm_poll_handler(req) == IO_APOLL_OK)
> -				return;
> -			/* aborted or ready, in either case retry blocking */
> -			needs_poll = false;
> -			issue_flags &= ~IO_URING_F_NONBLOCK;
> -		} while (1);
> -	}
> +		if (io_arm_poll_handler(req) == IO_APOLL_OK)
> +			return;
> +		/* aborted or ready, in either case retry blocking */
> +		needs_poll = false;
> +		issue_flags &= ~IO_URING_F_NONBLOCK;
> +	} while (1);
>   
>   	/* avoid locking problems by failing it from a clean context */
>   	if (ret)
> 

