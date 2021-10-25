Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886834391C7
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 10:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhJYIzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 04:55:51 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:46618 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232217AbhJYIzu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 04:55:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtYSKbF_1635152006;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtYSKbF_1635152006)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 16:53:27 +0800
Subject: Re: [PATCH 2/8] io_uring: clean io_wq_submit_work()'s main loop
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634987320.git.asml.silence@gmail.com>
 <ed12ce0c64e051f9a6b8a37a24f8ea554d299c29.1634987320.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <4b0b81ce-0b39-c8b9-5dbe-130b14b0baab@linux.alibaba.com>
Date:   Mon, 25 Oct 2021 16:53:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ed12ce0c64e051f9a6b8a37a24f8ea554d299c29.1634987320.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/23 下午7:13, Pavel Begunkov 写道:
> Do a bit of cleaning for the main loop of io_wq_submit_work(). Get rid
> of switch, just replace it with a single if as we're retrying in both
> other cases. Kill issue_sqe label, Get rid of needs_poll nesting and
> disambiguate a bit the comment.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>
>   fs/io_uring.c | 40 ++++++++++++----------------------------
>   1 file changed, 12 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 736d456e7913..7f92523c1282 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6749,40 +6749,24 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		}
>   
>   		do {
> -issue_sqe:
>   			ret = io_issue_sqe(req, issue_flags);
> +			if (ret != -EAGAIN)
> +				break;
>   			/*
> -			 * We can get EAGAIN for polled IO even though we're
> +			 * We can get EAGAIN for iopolled IO even though we're
>   			 * forcing a sync submission from here, since we can't
>   			 * wait for request slots on the block side.
>   			 */
> -			if (ret != -EAGAIN)
> -				break;
> -			if (needs_poll) {
> -				bool armed = false;
> -
> -				ret = 0;
> -				needs_poll = false;
> -				issue_flags &= ~IO_URING_F_NONBLOCK;
> -
> -				switch (io_arm_poll_handler(req)) {
> -				case IO_APOLL_READY:
> -					goto issue_sqe;
> -				case IO_APOLL_ABORTED:
> -					/*
> -					 * somehow we failed to arm the poll infra,
> -					 * fallback it to a normal async worker try.
> -					 */
> -					break;
> -				case IO_APOLL_OK:
> -					armed = true;
> -					break;
> -				}
> -
> -				if (armed)
> -					break;
> +			if (!needs_poll) {
> +				cond_resched();
> +				continue;
>   			}
> -			cond_resched();
> +
> +			if (io_arm_poll_handler(req) == IO_APOLL_OK)
> +				return;
> +			/* aborted or ready, in either case retry blocking */
> +			needs_poll = false;
> +			issue_flags &= ~IO_URING_F_NONBLOCK;
>   		} while (1);
>   	}
>   
> 

