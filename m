Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFF2542F31
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 13:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiFHL2R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 07:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiFHL2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 07:28:17 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD0B188E95
        for <io-uring@vger.kernel.org>; Wed,  8 Jun 2022 04:28:14 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w27so26601236edl.7
        for <io-uring@vger.kernel.org>; Wed, 08 Jun 2022 04:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ooa0ts79AhsM4MjeUdR7S19XIdWN9TmCmO69zPY+Sb8=;
        b=ITM033+xUinVgi0x+lJ5hziMfbItv9+EkKEwUgjZcNO86JrtLiWsOVDx9rwsSqCwZ/
         pNx30atbY5esY7TRCG8N35xf07hsx1wSP/SCT/ph+zlDg6xtW1kbfJlN5W6DdPEt0zdL
         SKcP3PpIGvN6TUeld6g5nKYCInUU3s7GDlDgSH4XT4Gn4jIZOx9lz9IZ9RqHFleIP8+S
         jAupZdZLxndIuY5vhFmKPkOfEsqFBOGCL11IashGdA9Z7hDWntVUDJcsm157oMzxkxNB
         FB+1gvSdm8i42u0R9Qz/FWW9cJPUuvVSPqNPZI/3PreJ1Vqv898SnD3JF7R45kn9TNrf
         /gsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ooa0ts79AhsM4MjeUdR7S19XIdWN9TmCmO69zPY+Sb8=;
        b=0ZQLXmK27pUyYgqZOtUBM5yo30zH6zPF1srMh+GctXv+NTv3q/VdhrcZoia8OuU676
         +O5ePtJNkt4tt5JQ2QKsdCPsnAGJ8vWwd2vvBKOQrRqh7uXc0gJ7Bo2yMBaCOAW/7xr0
         QTQ+pDJxumHNPkqn0GKY8JY6L/8eGkZV5Kld8pXyOFa7f0yzxiqKrTF+bdSSM4b2FIlA
         +522TLS3R2elDPHtk2BikxvznI2M97bTTMkLQ/n4JkCrRtgdmKhcrj/wDfYPGrKMkLLH
         ZpMhwLCkrqZ5D5Ucd1MHwiY7A94LISEhU9sCYKlic7k4PPV0+EUWpwzd+y0vW2X6CbNL
         w96A==
X-Gm-Message-State: AOAM531vpZvhTrkDamyxyfldhXeLlwvqGVFRPOdhhARZCkvmwGjgyYdJ
        hGoQ3whLwQlF7lwMZoK5PkOf/bADzh4=
X-Google-Smtp-Source: ABdhPJwlqka8bnjAJv8yfcwplbTPQCoB7wFoWVqXKZl9fsD4wpCSbbabS9hyllmC0SLMYKdcXDyytQ==
X-Received: by 2002:a05:6402:1d4a:b0:42e:9ec8:320b with SMTP id dz10-20020a0564021d4a00b0042e9ec8320bmr30126718edb.119.1654687693160;
        Wed, 08 Jun 2022 04:28:13 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h9-20020a1709063b4900b007043b29dfd9sm8981604ejf.89.2022.06.08.04.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 04:28:12 -0700 (PDT)
Message-ID: <f56d0b6e-29a0-c00a-f2cc-8c554d7101b4@gmail.com>
Date:   Wed, 8 Jun 2022 12:27:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220608111259.659536-1-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220608111259.659536-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/22 12:12, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new io_hash_bucket structure so that each bucket in cancel_hash
> has separate spinlock. Use per entry lock for cancel_hash, this removes
> some completion lock invocation and remove contension between different
> cancel_hash entries.

Thanks for making the changes, the big picture looks good,
I'll review in a day or two


> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
> 
> v1->v2:
>   - Add per entry lock for poll/apoll task work code which was missed
>     in v1
>   - add an member in io_kiocb to track req's indice in cancel_hash
> 
> v2->v3:
>   - make struct io_hash_bucket align with cacheline to avoid cacheline
>     false sharing.
>   - re-calculate hash value when deleting an entry from cancel_hash.
>     (cannot leverage struct io_poll to store the indice since it's
>      already 64 Bytes)
> 
>   io_uring/cancel.c         | 14 +++++++--
>   io_uring/cancel.h         |  6 ++++
>   io_uring/fdinfo.c         |  9 ++++--
>   io_uring/io_uring.c       |  8 +++--
>   io_uring/io_uring_types.h |  2 +-
>   io_uring/poll.c           | 64 +++++++++++++++++++++------------------
>   6 files changed, 65 insertions(+), 38 deletions(-)
> 
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index 83cceb52d82d..bced5d6b9294 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
>   	if (!ret)
>   		return 0;
>   
> -	spin_lock(&ctx->completion_lock);
>   	ret = io_poll_cancel(ctx, cd);
>   	if (ret != -ENOENT)
>   		goto out;
> +	spin_lock(&ctx->completion_lock);
>   	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>   		ret = io_timeout_cancel(ctx, cd);
> -out:
>   	spin_unlock(&ctx->completion_lock);
> +out:
>   	return ret;
>   }
>   
> @@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>   	io_req_set_res(req, ret, 0);
>   	return IOU_OK;
>   }
> +
> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < size; i++) {
> +		spin_lock_init(&hash_table[i].lock);
> +		INIT_HLIST_HEAD(&hash_table[i].list);
> +	}
> +}
> diff --git a/io_uring/cancel.h b/io_uring/cancel.h
> index 4f35d8696325..b57d6706f84d 100644
> --- a/io_uring/cancel.h
> +++ b/io_uring/cancel.h
> @@ -4,3 +4,9 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>   int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
>   
>   int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);
> +
> +struct io_hash_bucket {
> +	spinlock_t		lock;
> +	struct hlist_head	list;
> +} ____cacheline_aligned_in_smp;
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index fcedde4b4b1e..f941c73f5502 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -13,6 +13,7 @@
>   #include "io_uring.h"
>   #include "sqpoll.h"
>   #include "fdinfo.h"
> +#include "cancel.h"
>   
>   #ifdef CONFIG_PROC_FS
>   static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
> @@ -157,17 +158,19 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
>   		mutex_unlock(&ctx->uring_lock);
>   
>   	seq_puts(m, "PollList:\n");
> -	spin_lock(&ctx->completion_lock);
>   	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
> -		struct hlist_head *list = &ctx->cancel_hash[i];
> +		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
>   		struct io_kiocb *req;
>   
> -		hlist_for_each_entry(req, list, hash_node)
> +		spin_lock(&hb->lock);
> +		hlist_for_each_entry(req, &hb->list, hash_node)
>   			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
>   					task_work_pending(req->task));
> +		spin_unlock(&hb->lock);
>   	}
>   
>   	seq_puts(m, "CqOverflowList:\n");
> +	spin_lock(&ctx->completion_lock);
>   	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {
>   		struct io_uring_cqe *cqe = &ocqe->cqe;
>   
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1572ebe3cff1..b67ab76b9e56 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -725,11 +725,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	if (hash_bits <= 0)
>   		hash_bits = 1;
>   	ctx->cancel_hash_bits = hash_bits;
> -	ctx->cancel_hash = kmalloc((1U << hash_bits) * sizeof(struct hlist_head),
> -					GFP_KERNEL);
> +	ctx->cancel_hash =
> +		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
> +			GFP_KERNEL);
>   	if (!ctx->cancel_hash)
>   		goto err;
> -	__hash_init(ctx->cancel_hash, 1U << hash_bits);
> +
> +	init_hash_table(ctx->cancel_hash, 1U << hash_bits);
>   
>   	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
>   	if (!ctx->dummy_ubuf)
> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
> index 7c22cf35a7e2..b67843a5f3b6 100644
> --- a/io_uring/io_uring_types.h
> +++ b/io_uring/io_uring_types.h
> @@ -230,7 +230,7 @@ struct io_ring_ctx {
>   		 * manipulate the list, hence no extra locking is needed there.
>   		 */
>   		struct io_wq_work_list	iopoll_list;
> -		struct hlist_head	*cancel_hash;
> +		struct io_hash_bucket	*cancel_hash;
>   		unsigned		cancel_hash_bits;
>   		bool			poll_multi_queue;
>   
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 0df5eca93b16..515f1727e3c6 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -19,6 +19,7 @@
>   #include "opdef.h"
>   #include "kbuf.h"
>   #include "poll.h"
> +#include "cancel.h"
>   
>   struct io_poll_update {
>   	struct file			*file;
> @@ -73,10 +74,22 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
>   static void io_poll_req_insert(struct io_kiocb *req)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> -	struct hlist_head *list;
> +	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
> +	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
>   
> -	list = &ctx->cancel_hash[hash_long(req->cqe.user_data, ctx->cancel_hash_bits)];
> -	hlist_add_head(&req->hash_node, list);
> +	spin_lock(&hb->lock);
> +	hlist_add_head(&req->hash_node, &hb->list);
> +	spin_unlock(&hb->lock);
> +}
> +
> +static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
> +{
> +	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
> +	spinlock_t *lock = &ctx->cancel_hash[index].lock;
> +
> +	spin_lock(lock);
> +	hash_del(&req->hash_node);
> +	spin_unlock(lock);
>   }
>   
>   static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
> @@ -220,8 +233,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>   	}
>   
>   	io_poll_remove_entries(req);
> +	io_poll_req_delete(req, ctx);
>   	spin_lock(&ctx->completion_lock);
> -	hash_del(&req->hash_node);
>   	req->cqe.flags = 0;
>   	__io_req_complete_post(req);
>   	io_commit_cqring(ctx);
> @@ -231,7 +244,6 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>   
>   static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   {
> -	struct io_ring_ctx *ctx = req->ctx;
>   	int ret;
>   
>   	ret = io_poll_check_events(req, locked);
> @@ -239,9 +251,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   		return;
>   
>   	io_poll_remove_entries(req);
> -	spin_lock(&ctx->completion_lock);
> -	hash_del(&req->hash_node);
> -	spin_unlock(&ctx->completion_lock);
> +	io_poll_req_delete(req, req->ctx);
>   
>   	if (!ret)
>   		io_req_task_submit(req, locked);
> @@ -435,9 +445,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   		return 0;
>   	}
>   
> -	spin_lock(&ctx->completion_lock);
>   	io_poll_req_insert(req);
> -	spin_unlock(&ctx->completion_lock);
>   
>   	if (mask && (poll->events & EPOLLET)) {
>   		/* can't multishot if failed, just queue the event we've got */
> @@ -534,32 +542,32 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
>   	bool found = false;
>   	int i;
>   
> -	spin_lock(&ctx->completion_lock);
>   	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
> -		struct hlist_head *list;
> +		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
>   
> -		list = &ctx->cancel_hash[i];
> -		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
> +		spin_lock(&hb->lock);
> +		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
>   			if (io_match_task_safe(req, tsk, cancel_all)) {
>   				hlist_del_init(&req->hash_node);
>   				io_poll_cancel_req(req);
>   				found = true;
>   			}
>   		}
> +		spin_unlock(&hb->lock);
>   	}
> -	spin_unlock(&ctx->completion_lock);
>   	return found;
>   }
>   
>   static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>   				     struct io_cancel_data *cd)
> -	__must_hold(&ctx->completion_lock)
>   {
> -	struct hlist_head *list;
>   	struct io_kiocb *req;
>   
> -	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
> -	hlist_for_each_entry(req, list, hash_node) {
> +	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
> +	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
> +
> +	spin_lock(&hb->lock);
> +	hlist_for_each_entry(req, &hb->list, hash_node) {
>   		if (cd->data != req->cqe.user_data)
>   			continue;
>   		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
> @@ -569,47 +577,48 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>   				continue;
>   			req->work.cancel_seq = cd->seq;
>   		}
> +		spin_unlock(&hb->lock);
>   		return req;
>   	}
> +	spin_unlock(&hb->lock);
>   	return NULL;
>   }
>   
>   static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
>   					  struct io_cancel_data *cd)
> -	__must_hold(&ctx->completion_lock)
>   {
>   	struct io_kiocb *req;
>   	int i;
>   
>   	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
> -		struct hlist_head *list;
> +		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
>   
> -		list = &ctx->cancel_hash[i];
> -		hlist_for_each_entry(req, list, hash_node) {
> +		spin_lock(&hb->lock);
> +		hlist_for_each_entry(req, &hb->list, hash_node) {
>   			if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
>   			    req->file != cd->file)
>   				continue;
>   			if (cd->seq == req->work.cancel_seq)
>   				continue;
>   			req->work.cancel_seq = cd->seq;
> +			spin_unlock(&hb->lock);
>   			return req;
>   		}
> +		spin_unlock(&hb->lock);
>   	}
>   	return NULL;
>   }
>   
>   static bool io_poll_disarm(struct io_kiocb *req)
> -	__must_hold(&ctx->completion_lock)
>   {
>   	if (!io_poll_get_ownership(req))
>   		return false;
>   	io_poll_remove_entries(req);
> -	hash_del(&req->hash_node);
> +	io_poll_req_delete(req, req->ctx);
>   	return true;
>   }
>   
>   int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
> -	__must_hold(&ctx->completion_lock)
>   {
>   	struct io_kiocb *req;
>   
> @@ -718,14 +727,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>   	int ret2, ret = 0;
>   	bool locked;
>   
> -	spin_lock(&ctx->completion_lock);
>   	preq = io_poll_find(ctx, true, &cd);
>   	if (!preq || !io_poll_disarm(preq)) {
> -		spin_unlock(&ctx->completion_lock);
>   		ret = preq ? -EALREADY : -ENOENT;
>   		goto out;
>   	}
> -	spin_unlock(&ctx->completion_lock);
>   
>   	if (poll_update->update_events || poll_update->update_user_data) {
>   		/* only mask one event flags, keep behavior flags */
> 
> base-commit: d8271bf021438f468dab3cd84fe5279b5bbcead8

-- 
Pavel Begunkov
