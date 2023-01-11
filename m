Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA76654BB
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 07:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjAKGjS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 01:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjAKGjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 01:39:14 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B88F001
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 22:39:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VZM69om_1673419147;
Received: from 30.221.146.235(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VZM69om_1673419147)
          by smtp.aliyun-inc.com;
          Wed, 11 Jan 2023 14:39:09 +0800
Message-ID: <3ed001f3-a33c-cc69-be47-d5318de5ddcd@linux.alibaba.com>
Date:   Wed, 11 Jan 2023 14:39:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] io_uring: fix CQ waiting timeout handling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <f7bffddd71b08f28a877d44d37ac953ddb01590d.1672915663.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <f7bffddd71b08f28a877d44d37ac953ddb01590d.1672915663.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hello,

> Jiffy to ktime CQ waiting conversion broke how we treat timeouts, in
> particular we rearm it anew every time we get into
> io_cqring_wait_schedule() without adjusting the timeout. Waiting for 2
> CQEs and getting a task_work in the middle may double the timeout value,
> or even worse in some cases task may wait indefinitely.
>
> Cc: stable@vger.kernel.org
> Fixes: 228339662b398 ("io_uring: don't convert to jiffies for waiting on timeouts")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>
> v2: rebase
>
>  io_uring/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 472574192dd6..2ac1cd8d23ea 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2470,7 +2470,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
>  /* when returns >0, the caller should retry */
>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  					  struct io_wait_queue *iowq,
> -					  ktime_t timeout)
> +					  ktime_t *timeout)
>  {
>  	int ret;
>  	unsigned long check_cq;
> @@ -2488,7 +2488,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
>  			return -EBADR;
>  	}
> -	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
> +	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
>  		return -ETIME;
>  
>  	/*
> @@ -2564,7 +2564,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  		}
>  		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
>  						TASK_INTERRUPTIBLE);
> -		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
> +		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
>  		if (__io_cqring_events_user(ctx) >= min_events)
>  			break;
>  		cond_resched();
Does this bug result in any real issues?
io_cqring_wait_schedule() calls schedule_hrtimeout(), but seems that
schedule_hrtimeout() and its child functions don't modify timeout or expires
at all, so I wonder how this patch works. Thanks.

Regards,
Xiaoguang Wang


