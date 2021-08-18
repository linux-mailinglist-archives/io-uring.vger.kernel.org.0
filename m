Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FF63F0185
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 12:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhHRKVL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 06:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhHRKVL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 06:21:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D50C061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 03:20:36 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k8so2689436wrn.3
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 03:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QhvMLFNzssaX8yJ5zwT9taeQ+rtXqMPbwDxRkXEMC54=;
        b=Y5tf6y2ZYQBaTVJaQbrN5YZjp4BEDMq+edtEZtozquYcdSwBZ1E6LBsWHMBpW9Y9kg
         YeLxijY32Jv2mZwaeXs+gCpC0mf2Cekd6JWe2SByFaO/RRPltp2Ebx5x08DoKLyeEvvO
         rRTkoZ+NAzoqaaYJvwKnDf6lVKNmkqzqtWMGGinUrb8oQHXwc5RM8BXo+IiL0bT4TlUk
         70XBV5V26O4uKulLpPC3OkNi5xguE85PqjmjIOGiJcaAjvadn8JggPOEzcIEAmzcLBzs
         WIKsQDvL5Tpb6Bxr7hF/xm0dBsEe3H6lS6SRHrQEnZdA+d67KQW4T0Eati4jIOZo/qnh
         3rhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QhvMLFNzssaX8yJ5zwT9taeQ+rtXqMPbwDxRkXEMC54=;
        b=tJ3dO3P8yzOPsZ01sJkODJdJxnTMdYO1okGEniaCP91LI7mGDnr6R6EMHnjjUY5S/5
         k0Z7cT+a/tunb+vU+Ktx9OuKMk4qxJB0+3m2yu0SGftPqSfEy+sDUMQkbXOsD6Wnhyqw
         dzvum+v+Uy1PAnKefwEpCs9SBLy6IuGvBpN4W80vuJ1o3e2YdMBjYIHWpBXvToKesw7/
         1u8TanlLpjAm0uPV09g+xKJVgWraEh5NMVuAnuMWefU7BJXdqevkWMIuquqlE03lWRu3
         z7mj8rl6abPJ6XgMf3I2piH4fnU4Hcej1IOGWBL9aQg8JEvK7k/O3alXmbPiN+J7X3Vq
         Eb3g==
X-Gm-Message-State: AOAM530qhWDE7Z/XY0n7wQk3Le8/5BJCJMoja3tY37DFTQqevhmOxoMy
        xSBaUkP/+6lNaTcBuaSrrJo=
X-Google-Smtp-Source: ABdhPJyyuzAtQ9pg/qu840r5pfxlu1LWMfolufJtXL4aFgKaG2X1eNO13Hqe0odO7rFIQLTlzloR5g==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr9339392wrp.176.1629282035188;
        Wed, 18 Aug 2021 03:20:35 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id b12sm6466456wrx.72.2021.08.18.03.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 03:20:34 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: fix failed linkchain code logic
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210818074316.22347-1-haoxu@linux.alibaba.com>
 <20210818074316.22347-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d23478e6-2d2f-dbc1-91c0-b091b3c6cbc9@gmail.com>
Date:   Wed, 18 Aug 2021 11:20:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818074316.22347-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/21 8:43 AM, Hao Xu wrote:
> Given a linkchain like this:
> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
> 
> There is a problem:
>  - if some intermediate linked req like req1 's submittion fails, reqs
>    after it won't be cancelled.
> 
>    - sqpoll disabled: maybe it's ok since users can get the error info
>      of req1 and stop submitting the following sqes.
> 
>    - sqpoll enabled: definitely a problem, the following sqes will be
>      submitted in the next round.
> 
> The solution is to refactor the code logic to:
>  - link a linked req to the chain first, no matter its submittion fails
>    or not.
>  - if a linked req's submittion fails, just mark head as
>    failed. leverage req->result to indicate whether the req is a failed
>    one or cancelled one.
>  - submit or fail the whole chain
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 86 ++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 58 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c0b841506869..383668e07417 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1920,11 +1920,13 @@ static void io_fail_links(struct io_kiocb *req)
>  
>  	req->link = NULL;
>  	while (link) {
> +		int res = link->result ? link->result : -ECANCELED;

btw, we don't properly initialise req->result, and don't want to.
Perhaps, can be more like 

res = -ECANCELLED;
if (req->flags & FAIL)
	res = req->result;


> +
>  		nxt = link->link;
>  		link->link = NULL;
>  
>  		trace_io_uring_fail_link(req, link);
> -		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
> +		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
>  		io_put_req_deferred(link);
>  		link = nxt;
>  	}
> @@ -5698,7 +5700,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (is_timeout_link) {
>  		struct io_submit_link *link = &req->ctx->submit_state.link;
>  
> -		if (!link->head)
> +		if (!link->head || link->head == req)
>  			return -EINVAL;
>  		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
>  			return -EINVAL;
> @@ -6622,17 +6624,38 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	__must_hold(&ctx->uring_lock)
>  {
>  	struct io_submit_link *link = &ctx->submit_state.link;
> +	bool is_link = sqe->flags & (IOSQE_IO_LINK | IOSQE_IO_HARDLINK);
> +	struct io_kiocb *head;
>  	int ret;
>  
> +	/*
> +	 * we don't update link->last until we've done io_req_prep()
> +	 * since linked timeout uses old link->last
> +	 */
> +	if (link->head)
> +		link->last->link = req;
> +	else if (is_link)
> +		link->head = req;
> +	head = link->head;

It's a horrorsome amount of overhead. How about to set the fail flag
if failed early and actually fail on io_queue_sqe(), as below. It's
not tested and a couple more bits added, but hopefully gives the idea.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba087f395507..3fd0730655d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6530,8 +6530,10 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
 		return;
 
-	if (likely(!(req->flags & REQ_F_FORCE_ASYNC))) {
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC|REQ_F_FAIL)))) {
 		__io_queue_sqe(req);
+	} else if (req->flags & REQ_F_FAIL) {
+		io_req_complete_failed(req, ret);
 	} else {
 		int ret = io_req_prep_async(req);
 
@@ -6640,19 +6642,17 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
-		if (link->head) {
-			/* fail even hard links since we don't submit */
+		/* fail even hard links since we don't submit */
+		if (link->head)
 			req_set_fail(link->head);
-			io_req_complete_failed(link->head, -ECANCELED);
-			link->head = NULL;
-		}
-		io_req_complete_failed(req, ret);
-		return ret;
+		req_set_fail(req);
+		req->result = ret;
+	} else {
+		ret = io_req_prep(req, sqe);
+		if (unlikely(ret))
+			goto fail_req;
 	}
 
-	ret = io_req_prep(req, sqe);
-	if (unlikely(ret))
-		goto fail_req;
 
 	/* don't need @sqe from now on */
 	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
@@ -6670,8 +6670,10 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		struct io_kiocb *head = link->head;
 
 		ret = io_req_prep_async(req);
-		if (unlikely(ret))
-			goto fail_req;
+		if (unlikely(ret)) {
+			req->result = ret;
+			req_set_fail(link->head);
+		}
 		trace_io_uring_link(ctx, req, head);
 		link->last->link = req;
 		link->last = req;
