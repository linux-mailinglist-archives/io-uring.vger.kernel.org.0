Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9647C775F5C
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 14:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjHIMj2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 08:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjHIMj1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 08:39:27 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8006A10D2;
        Wed,  9 Aug 2023 05:39:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fe5eb84d8bso24077425e9.2;
        Wed, 09 Aug 2023 05:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691584765; x=1692189565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+nOv8tj+5clHRCkIDQ+yyUEXesE0Jl50xFzblYFJJxs=;
        b=qZPDZkb6sccbEozEzXAAPAPfVPXsek9ZlONV9Uvj5mal+lSDeTxwv65+b7QCHKSKIp
         7KWWTSEu1MpgQ0jB1AzaWsYW9XYF6+ilEyLrihSPVtctF0WB8fezLcaCf9Lc20Zz6CGn
         NpKx2NderX8pn/cZpAirFDuYp+IV98J0G7/epO85DhYEizwWT6jGiljQWT0xBv5ED6z0
         8KZqqr6rNrsPnm4N00tTD9QThFak29Y4TxCnh44cMb1wFJaX6hnupT28L3sgBFXN1kQR
         T3eZlVj4cYX4aPmfluEryoeU0vloAJsGH0u8BhOwoh79q8kMlIcJFQfsQFMN3fwsdNWA
         0rGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691584765; x=1692189565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+nOv8tj+5clHRCkIDQ+yyUEXesE0Jl50xFzblYFJJxs=;
        b=ln0cAEakTlm9t2EnxsrJeJidYPs66hLw7TcsSN51WW0aKuMhfWGN0SD5DLX4P/Vew8
         dZklc2rL6Yj84Df1poZsdbY89otcgcMKmazWQYvEcoqJveNLAOd/m5n81wERs1T0sFRs
         7XUv6TxbPBqVGqeK7mmuel2KPPxrAr6wExbv+a2uwiUbQ7WzddAkTW6G5kzI4cMVv+EF
         mE/yR9AXGqQNOFLRD1JuShiUQmswpZwh2t2lS1yLMG98/IJWAkE3kh6O5UjSlH9zCY9/
         r8Vxn2xUQS2BKLd5nKDDZyAme0NfQQfetpYThJ3jQjptkTo3TEE8uV3XWX1Pd1cf6gh6
         ALuA==
X-Gm-Message-State: AOJu0YzJoNYFNgEWUYhijMj42sO8sZQ18VllVzvhJIAODvMl/31UP2Lj
        dVs2fa2JcJ1qiu47dK5ky4A7R1vSsFg=
X-Google-Smtp-Source: AGHT+IFWi05a/Z6VyqVp34kl4g5FZ6o3TRihTECbPWQ4IeJNVLc81H4EQz2KoSxHpsM4xEWwLv7vdA==
X-Received: by 2002:a7b:cb9a:0:b0:3f9:82f:bad1 with SMTP id m26-20020a7bcb9a000000b003f9082fbad1mr1845910wmi.40.1691584764671;
        Wed, 09 Aug 2023 05:39:24 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-78.dab.02.net. [82.132.230.78])
        by smtp.gmail.com with ESMTPSA id m11-20020a7bce0b000000b003fe20533a1esm1883522wmc.44.2023.08.09.05.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 05:39:24 -0700 (PDT)
Message-ID: <d5b427f9-aff3-061a-42c2-60db1c7b5e88@gmail.com>
Date:   Wed, 9 Aug 2023 13:37:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3] io_uring: set plug tags for same file
To:     Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>
References: <20230731203932.2083468-1-kbusch@meta.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230731203932.2083468-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/23 21:39, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> io_uring tries to optimize allocating tags by hinting to the plug how
> many it expects to need for a batch instead of allocating each tag
> individually. But io_uring submission queueus may have a mix of many
> devices for io, so the number of io's counted may be overestimated. This
> can lead to allocating too many tags, which adds overhead to finding
> that many contiguous tags, freeing up the ones we didn't use, and may
> starve out other users that can actually use them.
> 
> When starting a new batch of uring commands, count only commands that
> match the file descriptor of the first seen for this optimization. This
> avoids have to call the unlikely "blk_mq_free_plug_rqs()" at the end of
> a submission when multiple devices are used in a batch.

looks good and doesn't blow up on tests

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> v2->v3
> 
>    The previous attempted to split the setup and submit further, but was
>    requested to go back to this simpler version.
> 
>   block/blk-core.c               | 49 +++++++++++++++-------------------
>   block/blk-mq.c                 |  6 +++--
>   include/linux/blkdev.h         |  6 -----
>   include/linux/io_uring_types.h |  1 +
>   io_uring/io_uring.c            | 37 ++++++++++++++++++-------
>   5 files changed, 54 insertions(+), 45 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 99d8b9812b18f..b8f8aa1376e60 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1043,32 +1043,6 @@ int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
>   }
>   EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
>   
> -void blk_start_plug_nr_ios(struct blk_plug *plug, unsigned short nr_ios)
> -{
> -	struct task_struct *tsk = current;
> -
> -	/*
> -	 * If this is a nested plug, don't actually assign it.
> -	 */
> -	if (tsk->plug)
> -		return;
> -
> -	plug->mq_list = NULL;
> -	plug->cached_rq = NULL;
> -	plug->nr_ios = min_t(unsigned short, nr_ios, BLK_MAX_REQUEST_COUNT);
> -	plug->rq_count = 0;
> -	plug->multiple_queues = false;
> -	plug->has_elevator = false;
> -	plug->nowait = false;
> -	INIT_LIST_HEAD(&plug->cb_list);
> -
> -	/*
> -	 * Store ordering should not be needed here, since a potential
> -	 * preempt will imply a full memory barrier
> -	 */
> -	tsk->plug = plug;
> -}
> -
>   /**
>    * blk_start_plug - initialize blk_plug and track it inside the task_struct
>    * @plug:	The &struct blk_plug that needs to be initialized
> @@ -1094,7 +1068,28 @@ void blk_start_plug_nr_ios(struct blk_plug *plug, unsigned short nr_ios)
>    */
>   void blk_start_plug(struct blk_plug *plug)
>   {
> -	blk_start_plug_nr_ios(plug, 1);
> +	struct task_struct *tsk = current;
> +
> +	/*
> +	 * If this is a nested plug, don't actually assign it.
> +	 */
> +	if (tsk->plug)
> +		return;
> +
> +	plug->mq_list = NULL;
> +	plug->cached_rq = NULL;
> +	plug->nr_ios = 1;
> +	plug->rq_count = 0;
> +	plug->multiple_queues = false;
> +	plug->has_elevator = false;
> +	plug->nowait = false;
> +	INIT_LIST_HEAD(&plug->cb_list);
> +
> +	/*
> +	 * Store ordering should not be needed here, since a potential
> +	 * preempt will imply a full memory barrier
> +	 */
> +	tsk->plug = plug;
>   }
>   EXPORT_SYMBOL(blk_start_plug);
>   
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index d50b1d62a3d92..fc75fb9ef34ed 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -523,7 +523,8 @@ static struct request *blk_mq_rq_cache_fill(struct request_queue *q,
>   		.q		= q,
>   		.flags		= flags,
>   		.cmd_flags	= opf,
> -		.nr_tags	= plug->nr_ios,
> +		.nr_tags	= min_t(unsigned int, plug->nr_ios,
> +					BLK_MAX_REQUEST_COUNT),
>   		.cached_rq	= &plug->cached_rq,
>   	};
>   	struct request *rq;
> @@ -2859,7 +2860,8 @@ static struct request *blk_mq_get_new_requests(struct request_queue *q,
>   	rq_qos_throttle(q, bio);
>   
>   	if (plug) {
> -		data.nr_tags = plug->nr_ios;
> +		data.nr_tags = min_t(unsigned int, plug->nr_ios,
> +				     BLK_MAX_REQUEST_COUNT);
>   		plug->nr_ios = 1;
>   		data.cached_rq = &plug->cached_rq;
>   	}
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ed44a997f629f..a2a022957cd96 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -984,7 +984,6 @@ struct blk_plug_cb {
>   extern struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug,
>   					     void *data, int size);
>   extern void blk_start_plug(struct blk_plug *);
> -extern void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
>   extern void blk_finish_plug(struct blk_plug *);
>   
>   void __blk_flush_plug(struct blk_plug *plug, bool from_schedule);
> @@ -1000,11 +999,6 @@ long nr_blockdev_pages(void);
>   struct blk_plug {
>   };
>   
> -static inline void blk_start_plug_nr_ios(struct blk_plug *plug,
> -					 unsigned short nr_ios)
> -{
> -}
> -
>   static inline void blk_start_plug(struct blk_plug *plug)
>   {
>   }
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index f04ce513fadba..109d4530bccbf 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -175,6 +175,7 @@ struct io_submit_state {
>   	bool			need_plug;
>   	unsigned short		submit_nr;
>   	unsigned int		cqes_count;
> +	int			fd;
>   	struct blk_plug		plug;
>   	struct io_uring_cqe	cqes[16];
>   };
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 135da2fd0edab..36f45d234fe49 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2195,18 +2195,25 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   		return -EINVAL;
>   
>   	if (def->needs_file) {
> -		struct io_submit_state *state = &ctx->submit_state;
> -
>   		req->cqe.fd = READ_ONCE(sqe->fd);
>   
>   		/*
>   		 * Plug now if we have more than 2 IO left after this, and the
>   		 * target is potentially a read/write to block based storage.
>   		 */
> -		if (state->need_plug && def->plug) {
> -			state->plug_started = true;
> -			state->need_plug = false;
> -			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
> +	        if (def->plug) {
> +			struct io_submit_state *state = &ctx->submit_state;
> +
> +			if (state->need_plug) {
> +			        state->plug_started = true;
> +			        state->need_plug = false;
> +			        state->fd = req->cqe.fd;
> +			        blk_start_plug(&state->plug);
> +			} else if (state->plug_started &&
> +			           state->fd == req->cqe.fd &&
> +			           !state->link.head) {
> +			        state->plug.nr_ios++;
> +			}
>   		}
>   	}
>   
> @@ -2267,7 +2274,8 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>   }
>   
>   static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
> -			 const struct io_uring_sqe *sqe)
> +			 const struct io_uring_sqe *sqe,
> +			 struct io_wq_work_list *req_list)
>   	__must_hold(&ctx->uring_lock)
>   {
>   	struct io_submit_link *link = &ctx->submit_state.link;
> @@ -2315,7 +2323,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   		return 0;
>   	}
>   
> -	io_queue_sqe(req);
> +	wq_list_add_tail(&req->comp_list, req_list);
>   	return 0;
>   }
>   
> @@ -2400,6 +2408,8 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>   	__must_hold(&ctx->uring_lock)
>   {
>   	unsigned int entries = io_sqring_entries(ctx);
> +	struct io_wq_work_list req_list;
> +	struct io_kiocb *req;
>   	unsigned int left;
>   	int ret;
>   
> @@ -2410,9 +2420,9 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>   	io_get_task_refs(left);
>   	io_submit_state_start(&ctx->submit_state, left);
>   
> +	INIT_WQ_LIST(&req_list);
>   	do {
>   		const struct io_uring_sqe *sqe;
> -		struct io_kiocb *req;
>   
>   		if (unlikely(!io_alloc_req(ctx, &req)))
>   			break;
> @@ -2425,13 +2435,20 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>   		 * Continue submitting even for sqe failure if the
>   		 * ring was setup with IORING_SETUP_SUBMIT_ALL
>   		 */
> -		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
> +		if (unlikely(io_submit_sqe(ctx, req, sqe, &req_list)) &&
>   		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
>   			left--;
>   			break;
>   		}
>   	} while (--left);
>   
> +	while (req_list.first) {
> +		req = container_of(req_list.first, struct io_kiocb, comp_list);
> +		req_list.first = req->comp_list.next;
> +		req->comp_list.next = NULL;
> +		io_queue_sqe(req);
> +	}
> +
>   	if (unlikely(left)) {
>   		ret -= left;
>   		/* try again if it submitted nothing and can't allocate a req */

-- 
Pavel Begunkov
