Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C004391D8
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 10:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhJYJBQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 05:01:16 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:49815 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232099AbhJYJBN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 05:01:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtZ8W2d_1635152330;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtZ8W2d_1635152330)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 16:58:50 +0800
Subject: Re: [PATCH 5/8] io_uring: don't try io-wq polling if not supported
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634987320.git.asml.silence@gmail.com>
 <6401256db01b88f448f15fcd241439cb76f5b940.1634987320.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <48dc1e10-257b-d431-5ed3-3aa8742612f5@linux.alibaba.com>
Date:   Mon, 25 Oct 2021 16:58:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6401256db01b88f448f15fcd241439cb76f5b940.1634987320.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/23 下午7:13, Pavel Begunkov 写道:
> If an opcode doesn't support polling, just let it be executed
> synchronously in iowq, otherwise it will do a nonblock attempt just to
> fail in io_arm_poll_handler() and return back to blocking execution.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>
>   fs/io_uring.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bff911f951ed..c6f32fcf387b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6741,9 +6741,13 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   	}
>   
>   	if (req->flags & REQ_F_FORCE_ASYNC) {
> -		needs_poll = req->file && file_can_poll(req->file);
> -		if (needs_poll)
> +		const struct io_op_def *def = &io_op_defs[req->opcode];
> +		bool opcode_poll = def->pollin || def->pollout;
> +
> +		if (opcode_poll && file_can_poll(req->file)) {
> +			needs_poll = true;
>   			issue_flags |= IO_URING_F_NONBLOCK;
> +		}
>   	}
>   
>   	do {
> 

