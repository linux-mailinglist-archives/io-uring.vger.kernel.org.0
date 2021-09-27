Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F77419525
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhI0NfY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:35:24 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:42633 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234269AbhI0NfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:35:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpoqG.B_1632749623;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpoqG.B_1632749623)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 21:33:44 +0800
Subject: Re: [PATCH 1/2] io_uring: fix concurrent poll interruption
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927123600.234405-1-haoxu@linux.alibaba.com>
 <20210927123600.234405-2-haoxu@linux.alibaba.com>
Message-ID: <923f4afd-f9e0-dde9-3186-fd72b7e37dd7@linux.alibaba.com>
Date:   Mon, 27 Sep 2021 21:33:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927123600.234405-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/27 下午8:35, Hao Xu 写道:
> There may be concurrent poll interruptions:
> 
> async_wake()
> ->del wait entry
> ->add to tw list
>                         async_wake()
>                         ->del wait entry
>                         ->add to tw list
> 
> This mess up the tw list, let's avoid it by adding a if check before
> delete wait entry:
> async_wake()
> ->if empty(wait entry)
>      return
> ->del wait entry
> ->add to tw list
>                         async_wake()
>                         ->if empty(wait entry)
>                             return <------------will return here
>                         ->del wait entry
>                         ->add to tw list
I now think the issue may not exist, since async_wake() is protected by
poll->head->lock, so the wait entry has already been deleted when the
second time event happens and try to visit the wait list to wakeup it.
> 
> Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8317c360f7a4..d0b358b9b589 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5245,6 +5245,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>   
>   	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
>   
> +	if (list_empty(&poll->wait.entry))
> +		return 0;
>   	list_del_init(&poll->wait.entry);
>   
>   	req->result = mask;
> 

