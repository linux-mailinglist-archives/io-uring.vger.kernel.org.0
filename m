Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFFA51DE49
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 19:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbiEFRYH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 13:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbiEFRYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 13:24:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1BBBC35;
        Fri,  6 May 2022 10:20:21 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m2-20020a1ca302000000b003943bc63f98so4747527wme.4;
        Fri, 06 May 2022 10:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WUxbNWTLni10lJjuJKJhKbb9v83zEQhRp5eBEL96koM=;
        b=GkIrv3mzT75Qub63q/lxL4l/qsbAtTc6bey39A77NKKwdKDr66+pqkJKYFhIlswFGl
         5hX0kglY89GXZNy6MoAAQpy/gJBhMi2yGVVsNMh4gUmoKFbReu8B7eaK9esWgGrXWpfJ
         QU2GINJJr4xvfY4kQI5P5kEFM+m78dthKOuI8cOiP7rzkZaYkabF0pouynJHvk4/n+BL
         kPGasrMnyPbqYCqxLyzzcM2WRhH4KBWFkV1Pw3IehEN0d/aENH9MGRs35zL8JVNNhoEQ
         4JQ4mMLJAJ/oGQJft/0bnm0i1dP84fbIDEGhcfPT6yFjjwDQ0Xfc9sYP5M5dtqz+/bfB
         b0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WUxbNWTLni10lJjuJKJhKbb9v83zEQhRp5eBEL96koM=;
        b=Rrb9iyQeq9qltGX/IARUnyVRVh2JbxnOYn4y8Dg68wd6IKi4vO8gF4RsaArQt8abMe
         rddpFm7wMCXPID2ZfU48jKNVOs13gunQB8W6mhUoLsZFssogHr/7HbXJqKx/cHmCa2uB
         GbB6e114IeTuGTwsb7aTdx0JjqITjF6K5N0xIIaNMrmiU6f5pTteR/8loOPe7Z82b7/l
         VnHJl9FARr+oG1urcy2lofISCmiRjlvAL3yhrsdwPGomGBWo2XTRTgWsgcje2UJMl2rJ
         cAh6t/UqD8PyLD6ratj000HSAyYLpmWFe5zLD2sGKYyFWzgNI6mhzLLYAqTn5o43FvfP
         fHNQ==
X-Gm-Message-State: AOAM532jiPCuR0f6m869JPgs1QQde65yqXcDKROBCiWCGiR0wQvmJL9Z
        MZA5TzE2gNh2/ARknvm6wwQ=
X-Google-Smtp-Source: ABdhPJzBE5WGIiKr8hh0XhehyriBLlbcS+nn9cmXFMkw5iwducWe9VtTfC97AnS2rDg1b438hvKf2w==
X-Received: by 2002:a05:600c:ad1:b0:394:1585:a164 with SMTP id c17-20020a05600c0ad100b003941585a164mr10837341wmr.101.1651857620015;
        Fri, 06 May 2022 10:20:20 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.75])
        by smtp.gmail.com with ESMTPSA id x5-20020a05600c2d0500b003942a244f45sm4971966wmf.30.2022.05.06.10.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 10:20:19 -0700 (PDT)
Message-ID: <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
Date:   Fri, 6 May 2022 18:19:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220506070102.26032-4-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 08:01, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> For operations like accept, multishot is a useful feature, since we can
> reduce a number of accept sqe. Let's integrate it to fast poll, it may
> be good for other operations in the future.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   fs/io_uring.c | 41 ++++++++++++++++++++++++++---------------
>   1 file changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8ebb1a794e36..d33777575faf 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5952,7 +5952,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
>    * either spurious wakeup or multishot CQE is served. 0 when it's done with
>    * the request, then the mask is stored in req->cqe.res.
>    */
> -static int io_poll_check_events(struct io_kiocb *req, bool locked)
> +static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   	int v;
> @@ -5981,17 +5981,26 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
>   
>   		/* multishot, just fill an CQE and proceed */
>   		if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
> -			__poll_t mask = mangle_poll(req->cqe.res & req->apoll_events);
> -			bool filled;
> -
> -			spin_lock(&ctx->completion_lock);
> -			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
> -						 IORING_CQE_F_MORE);
> -			io_commit_cqring(ctx);
> -			spin_unlock(&ctx->completion_lock);
> -			if (unlikely(!filled))
> -				return -ECANCELED;
> -			io_cqring_ev_posted(ctx);
> +			if (req->flags & REQ_F_APOLL_MULTISHOT) {
> +				io_tw_lock(req->ctx, locked);
> +				if (likely(!(req->task->flags & PF_EXITING)))
> +					io_queue_sqe(req);

That looks dangerous, io_queue_sqe() usually takes the request ownership
and doesn't expect that someone, i.e. io_poll_check_events(), may still be
actively using it.

E.g. io_accept() fails on fd < 0, return an error,
io_queue_sqe() -> io_queue_async() -> io_req_complete_failed()
kills it. Then io_poll_check_events() and polling in general
carry on using the freed request => UAF. Didn't look at it
too carefully, but there might other similar cases.


> +				else
> +					return -EFAULT;
> +			} else {
> +				__poll_t mask = mangle_poll(req->cqe.res &
> +							    req->apoll_events);
> +				bool filled;
> +
> +				spin_lock(&ctx->completion_lock);
> +				filled = io_fill_cqe_aux(ctx, req->cqe.user_data,
> +							 mask, IORING_CQE_F_MORE);
> +				io_commit_cqring(ctx);
> +				spin_unlock(&ctx->completion_lock);
> +				if (unlikely(!filled))
> +					return -ECANCELED;
> +				io_cqring_ev_posted(ctx);
> +			}
>   		} else if (req->cqe.res) {
>   			return 0;
>   		}
> @@ -6010,7 +6019,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	int ret;
>   
> -	ret = io_poll_check_events(req, *locked);
> +	ret = io_poll_check_events(req, locked);
>   	if (ret > 0)
>   		return;
>   
> @@ -6035,7 +6044,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	int ret;
>   
> -	ret = io_poll_check_events(req, *locked);
> +	ret = io_poll_check_events(req, locked);
>   	if (ret > 0)
>   		return;
>   
> @@ -6275,7 +6284,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct async_poll *apoll;
>   	struct io_poll_table ipt;
> -	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
> +	__poll_t mask = POLLERR | POLLPRI;
>   	int ret;
>   
>   	if (!def->pollin && !def->pollout)
> @@ -6284,6 +6293,8 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>   		return IO_APOLL_ABORTED;
>   	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
>   		return IO_APOLL_ABORTED;
> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
> +		mask |= EPOLLONESHOT;
>   
>   	if (def->pollin) {
>   		mask |= POLLIN | POLLRDNORM;

-- 
Pavel Begunkov
