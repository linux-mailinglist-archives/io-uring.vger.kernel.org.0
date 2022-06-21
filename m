Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEDC55339C
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350742AbiFUNeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 09:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351744AbiFUNbI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 09:31:08 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFA818E17
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 06:28:35 -0700 (PDT)
Message-ID: <c9cd85d7-fcfb-0962-4517-9f1a07958627@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655818113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFn9V9hTT5zyZMWnEuGX+8SQPV48MvnqcS6i2MqayTA=;
        b=O1XFHLgPuLHbhlGGMl75+bsRmjlAvmgxpARQlXFQQLWao6+GKIQH1zzMwqLgJnDEzCutpU
        EwVvMh94m7CkQHTQRXeK6yCR330iR9831d9AxYwS0d9LlZdmA93TZ42UVRS40ehZsBVxDd
        GhP8hpc8rj1OcuzuNI4Ka4r6EB1S6sc=
Date:   Tue, 21 Jun 2022 21:28:25 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 5.19] io_uring: fix req->apoll_events
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/22 20:25, Pavel Begunkov wrote:
> apoll_events should be set once in the beginning of poll arming just as
> poll->events and not change after. However, currently io_uring resets it
> on each __io_poll_execute() for no clear reason. There is also a place
> in __io_arm_poll_handler() where we add EPOLLONESHOT to downgrade a
> multishot, but forget to do the same thing with ->apoll_events, which is
> buggy.
> 
> Fixes: 81459350d581e ("io_uring: cache req->apoll->events in req->cflags")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 87c65a358678..ebda9a565fc0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6954,7 +6954,8 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   		io_req_complete_failed(req, ret);
>   }
>   
> -static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
> +static void __io_poll_execute(struct io_kiocb *req, int mask,
> +			      __poll_t __maybe_unused events)
>   {
>   	req->cqe.res = mask;
>   	/*
> @@ -6963,7 +6964,6 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
>   	 * CPU. We want to avoid pulling in req->apoll->events for that
>   	 * case.
>   	 */
> -	req->apoll_events = events;
>   	if (req->opcode == IORING_OP_POLL_ADD)
>   		req->io_task_work.func = io_poll_task_func;
>   	else
> @@ -7114,6 +7114,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   	io_init_poll_iocb(poll, mask, io_poll_wake);
>   	poll->file = req->file;
>   
> +	req->apoll_events = poll->events;
> +
>   	ipt->pt._key = mask;
>   	ipt->req = req;
>   	ipt->error = 0;
> @@ -7144,8 +7146,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   
>   	if (mask) {
>   		/* can't multishot if failed, just queue the event we've got */
> -		if (unlikely(ipt->error || !ipt->nr_entries))
> +		if (unlikely(ipt->error || !ipt->nr_entries)) {
>   			poll->events |= EPOLLONESHOT;
> +			req->apoll_events |= EPOLLONESHOT;
> +		}
>   		__io_poll_execute(req, mask, poll->events);
>   		return 0;
>   	}
> @@ -7392,7 +7396,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>   		return -EINVAL;
>   
>   	io_req_set_refcount(req);
> -	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
> +	poll->events = io_poll_parse_events(sqe, flags);
>   	return 0;
>   }
>   

Make sense,
Reviewed-by: Hao Xu <howeyxu@tencent.com>
