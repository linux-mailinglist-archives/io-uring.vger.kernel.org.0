Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DCD547A13
	for <lists+io-uring@lfdr.de>; Sun, 12 Jun 2022 14:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiFLMUy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jun 2022 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiFLMUx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jun 2022 08:20:53 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10842CCAA
        for <io-uring@vger.kernel.org>; Sun, 12 Jun 2022 05:20:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso3218381wms.3
        for <io-uring@vger.kernel.org>; Sun, 12 Jun 2022 05:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yLqh14ttu3GEexrwej/Sau9oHWApZt4O4e+BqOSUESY=;
        b=EFypk2kLj+LwW15IHGXOH8d6dRHpjdZWWgDN9PgOYA+Evy/jxlXHdT6YgEAnTB2O8b
         uia+sD0DYXbqPkbVX2sFNR7IOflZSt90ZS+nsvPxwH/F98CPo91OYeKLL/JKPhb3XXNb
         yh+FPVWcRAGk9BWwCggrWAYc0b2SyvTS0gh2bhO9YjQveQOKjuM6eIxRS4XEOAIs7JoW
         JCYnjCy6+kwSms36M3bqYkZvSbmLwDWnNiX5mQ2pNZnIvXbm9BaeKY2hXN/izQ6BcSh+
         gvB7L5/1VmIE0c2wz+ooJem+4DRyOk6PbSN+Gcu2fFgfdUzewJSUct85AYHvUwFLvvZy
         WbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yLqh14ttu3GEexrwej/Sau9oHWApZt4O4e+BqOSUESY=;
        b=4Zmn3MYQB8RwxOxWVfF+HujlfCQ/HFCOO9mGiIdKPrHsPgf7eTf5F6IJd6n+qngDpF
         aLym8EK4N6calvM7YG5oFMPnrTw1tQdoVzGA+P3H0pnVV7Z+/lVb9OVCKTyttZnlatCa
         piP9ZAxq2RNAP/xGSqTNP6JTtUf+WSkDafjBvvfyg+IUq7WN9iz1cJGpz5f+7Omnlues
         LOhjgHyP0jaI1B+yPVB6si93YMbqQg7i4lW9FC1l8u+sMf+09NdA8Kn3B+dkCyhylOP2
         KAXvVNW4P9jeULmmwEcClSeg8osrDLw4Km4cvpKOSRCpWcsNte6aEpZb+b0npgiY3rGl
         9YVQ==
X-Gm-Message-State: AOAM531sZbYvL2855UytCsyTJE5bbe4MoaCXSGlbbIXchHYfXAk6LT8S
        964XPU+RlnsbcjlloGU56E0=
X-Google-Smtp-Source: ABdhPJyTene5f0Qq/y7EQugy4h2YP+NHhA3is8c10T+AboSU5Gma2gJSVAZQCNZN6fbiiaHSN7U+WQ==
X-Received: by 2002:a05:600c:1f07:b0:39c:880f:4456 with SMTP id bd7-20020a05600c1f0700b0039c880f4456mr5592378wmb.79.1655036450147;
        Sun, 12 Jun 2022 05:20:50 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h16-20020a5d6890000000b0020fe61acd09sm5391875wru.12.2022.06.12.05.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 05:20:49 -0700 (PDT)
Message-ID: <96b60078-3db2-dba0-d2bd-5a3633d0737b@gmail.com>
Date:   Sun, 12 Jun 2022 13:20:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220611103149.925423-1-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220611103149.925423-1-hao.xu@linux.dev>
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

On 6/11/22 11:31, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new io_hash_bucket structure so that each bucket in cancel_hash
> has separate spinlock. Use per entry lock for cancel_hash, this removes
> some completion lock invocation and remove contension between different
> cancel_hash entries.

I took it into my 5.20 branch, will send them to Jens
all together, thanks

https://github.com/isilence/linux/tree/io_uring/for-5.20



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
> v3->v4:
>   - address race issue in cancellation path per Pavel's comment
>   - remove the inline decorator
> 
>   io_uring/cancel.c         | 14 ++++++-
>   io_uring/cancel.h         |  6 +++
>   io_uring/fdinfo.c         |  9 +++--
>   io_uring/io_uring.c       |  8 ++--
>   io_uring/io_uring_types.h |  2 +-
>   io_uring/poll.c           | 80 ++++++++++++++++++++++++---------------
>   6 files changed, 79 insertions(+), 40 deletions(-)
> 
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index 83cceb52d82d..6f2888388a40 100644
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
> +void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < size; i++) {
> +		spin_lock_init(&hash_table[i].lock);
> +		INIT_HLIST_HEAD(&hash_table[i].list);
> +	}
> +}
> diff --git a/io_uring/cancel.h b/io_uring/cancel.h
> index 4f35d8696325..556a7dcf160e 100644
> --- a/io_uring/cancel.h
> +++ b/io_uring/cancel.h
> @@ -4,3 +4,9 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>   int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
>   
>   int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
> +void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);
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
> index 0df5eca93b16..bc93a89185f8 100644
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
> @@ -534,32 +542,31 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
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
> +	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
> +	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
>   
> -	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
> -	hlist_for_each_entry(req, list, hash_node) {
> +	spin_lock(&hb->lock);
> +	hlist_for_each_entry(req, &hb->list, hash_node) {
>   		if (cd->data != req->cqe.user_data)
>   			continue;
>   		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
> @@ -571,21 +578,21 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
>   		}
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
> @@ -594,12 +601,12 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
>   			req->work.cancel_seq = cd->seq;
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
> @@ -609,17 +616,23 @@ static bool io_poll_disarm(struct io_kiocb *req)
>   }
>   
>   int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
> -	__must_hold(&ctx->completion_lock)
>   {
>   	struct io_kiocb *req;
> +	u32 index;
> +	spinlock_t *lock;
>   
>   	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
>   		req = io_poll_file_find(ctx, cd);
>   	else
>   		req = io_poll_find(ctx, false, cd);
> -	if (!req)
> +	if (!req) {
>   		return -ENOENT;
> +	} else {
> +		index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
> +		lock = &ctx->cancel_hash[index].lock;
> +	}
>   	io_poll_cancel_req(req);
> +	spin_unlock(lock);
>   	return 0;
>   }
>   
> @@ -714,18 +727,23 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>   	struct io_poll_update *poll_update = io_kiocb_to_cmd(req);
>   	struct io_cancel_data cd = { .data = poll_update->old_user_data, };
>   	struct io_ring_ctx *ctx = req->ctx;
> +	u32 index = hash_long(cd.data, ctx->cancel_hash_bits);
> +	spinlock_t *lock = &ctx->cancel_hash[index].lock;
>   	struct io_kiocb *preq;
>   	int ret2, ret = 0;
>   	bool locked;
>   
> -	spin_lock(&ctx->completion_lock);
>   	preq = io_poll_find(ctx, true, &cd);
> -	if (!preq || !io_poll_disarm(preq)) {
> -		spin_unlock(&ctx->completion_lock);
> -		ret = preq ? -EALREADY : -ENOENT;
> +	if (!preq) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +	ret2 = io_poll_disarm(preq);
> +	spin_unlock(lock);
> +	if (!ret2) {
> +		ret = -EALREADY;
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
