Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD3443FC50
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 14:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhJ2M3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 08:29:54 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:53507 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230492AbhJ2M3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 08:29:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uu9TBqr_1635510443;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uu9TBqr_1635510443)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 20:27:23 +0800
Subject: Re: [PATCH liburing] io-cancel: add check for -ECANCELED
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211019092352.29782-1-haoxu@linux.alibaba.com>
Message-ID: <ed9793a5-92e8-f5d9-3a33-d263bf5e760e@linux.alibaba.com>
Date:   Fri, 29 Oct 2021 20:27:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211019092352.29782-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ping this one since test/io-cancel will be broken
if the async hybrid logic merges to 5.16
在 2021/10/19 下午5:23, Hao Xu 写道:
> The req to be async cancelled will most likely return -ECANCELED after
> cancellation with the new async bybrid optimization applied. And -EINTR
> is impossible to be returned anymore since we won't be in INTERRUPTABLE
> sleep when reading, so remove it.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   test/io-cancel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/io-cancel.c b/test/io-cancel.c
> index b5b443dc467b..c761e126be0c 100644
> --- a/test/io-cancel.c
> +++ b/test/io-cancel.c
> @@ -341,7 +341,7 @@ static int test_cancel_req_across_fork(void)
>   				fprintf(stderr, "wait_cqe=%d\n", ret);
>   				return 1;
>   			}
> -			if ((cqe->user_data == 1 && cqe->res != -EINTR) ||
> +			if ((cqe->user_data == 1 && cqe->res != -ECANCELED) ||
>   			    (cqe->user_data == 2 && cqe->res != -EALREADY && cqe->res)) {
>   				fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
>   				exit(1);
> 

