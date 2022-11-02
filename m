Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86596161A3
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 12:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiKBLVc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 07:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKBLVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 07:21:31 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9C1120A0
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 04:21:30 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id y16so24015196wrt.12
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 04:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0UyCoU1s0RtnVHYqQ2GDxHKz3+s7CDJTR0mhXHfjDOk=;
        b=dzUkYKhvxmKhTUYBv7qut22TP1idONIenHPJFO7cIh3sc1E1FFunkwGitMIAcuPKe2
         KJ83Kktxmpx+V2StXQV8HeIvbEhqwPKnfoQ5oVJHkeOwSaaD/atAORBRmoVF6S9k6UXL
         srGNIzPsi4kgWG4ktHkUeAXSCH7yvqD+MGGiDQidbddGX42Ow0UHBEUvatjIYw0od5z9
         2jlCugynEUbg112z2l9z/eX9nZl4P0vtUHf04zltVeUyhnLFHACAalUfj2PJWzw8Gwp8
         VFwkgUaR7vrp6Ph9XzK6bVsi+5xFH2IxQmV9+ZJyPL6s2sffzsGfk5MMYfBygVGasIIk
         222A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0UyCoU1s0RtnVHYqQ2GDxHKz3+s7CDJTR0mhXHfjDOk=;
        b=5UTleHDoxAEqZUcj5zkgd9Ujhip/O0SkQvcA7IemzIBM3rNKzvDrxDojoSsxkLqLyr
         jqFN0Ri8tybft+gDjVwiLttyQnZS25b5GxSjQR0kI7GDLAgxp8j+bI2hPynrYXN4RN4J
         pEBIwN7kfqP08yDZNrUOY1tLvXlCqR7emxaPJyFq1z6tE6VjBIQXWcrZVA3e+hOReb6S
         cSTN6FuwoC6FZ+mvN4vleOmxsXbripoTt9QhXKOL9U+4sSDEciYaZbbel2cxNPb1qcxC
         8NlYnh+T+4QhNZRHXLKYNLPlazT8S3YtvXjvyxeJ+NvC2OLAEUziunYFcKau8WmP1T/5
         kx6g==
X-Gm-Message-State: ACrzQf1yJouWwX0bLtOf3k4fgEYxuLyI3vbV0zPogbWannApCcOMuyuQ
        UVvEZuY7bykB5I5lAVw6RAprFouqMH4=
X-Google-Smtp-Source: AMsMyM5Gp3Q7xLMOZKrWWShtt1QodiKFH+T+QQYUTGRbBkgmXyiA82WZYrrBY7IuIBHGL7WbkjqB/Q==
X-Received: by 2002:a5d:50cf:0:b0:236:86df:257f with SMTP id f15-20020a5d50cf000000b0023686df257fmr14825585wrt.374.1667388088711;
        Wed, 02 Nov 2022 04:21:28 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2739])
        by smtp.gmail.com with ESMTPSA id t24-20020a7bc3d8000000b003b4935f04a4sm1764883wmj.5.2022.11.02.04.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 04:21:28 -0700 (PDT)
Message-ID: <5234ce36-b8d9-edbd-302b-58ceeb896c7d@gmail.com>
Date:   Wed, 2 Nov 2022 11:20:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next 01/12] io_uring: infrastructure for retargeting
 rsrc nodes
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-2-dylany@meta.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221031134126.82928-2-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 13:41, Dylan Yudaken wrote:
> rsrc node cleanup can be indefinitely delayed when there are long lived
> requests. For example if a file is located in the same rsrc node as a long
> lived socket with multishot poll, then even if unregistering the file it
> will not be closed while the poll request is still active.
> 
> Introduce a timer when rsrc node is switched, so that periodically we can
> retarget these long lived requests to the newest nodes. That will allow
> the old nodes to be cleaned up, freeing resources.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>   include/linux/io_uring_types.h |  2 +
>   io_uring/io_uring.c            |  1 +
>   io_uring/opdef.h               |  1 +
>   io_uring/rsrc.c                | 92 ++++++++++++++++++++++++++++++++++
>   io_uring/rsrc.h                |  1 +
>   5 files changed, 97 insertions(+)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index f5b687a787a3..1d4eff4e632c 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -327,6 +327,8 @@ struct io_ring_ctx {
>   	struct llist_head		rsrc_put_llist;
>   	struct list_head		rsrc_ref_list;
>   	spinlock_t			rsrc_ref_lock;
> +	struct delayed_work		rsrc_retarget_work;
> +	bool				rsrc_retarget_scheduled;
>   
>   	struct list_head		io_buffers_pages;
>   
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6cc16e39b27f..ea2260359c56 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -320,6 +320,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	spin_lock_init(&ctx->rsrc_ref_lock);
>   	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
>   	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
> +	INIT_DELAYED_WORK(&ctx->rsrc_retarget_work, io_rsrc_retarget_work);
>   	init_llist_head(&ctx->rsrc_put_llist);
>   	init_llist_head(&ctx->work_llist);
>   	INIT_LIST_HEAD(&ctx->tctx_list);
> diff --git a/io_uring/opdef.h b/io_uring/opdef.h
> index 3efe06d25473..1b72b14cb5ab 100644
> --- a/io_uring/opdef.h
> +++ b/io_uring/opdef.h
> @@ -37,6 +37,7 @@ struct io_op_def {
>   	int (*prep_async)(struct io_kiocb *);
>   	void (*cleanup)(struct io_kiocb *);
>   	void (*fail)(struct io_kiocb *);
> +	bool (*can_retarget_rsrc)(struct io_kiocb *);

side note: need to be split at some moment into 2 tables depending
on hotness, we want better caching for ->issue and ->prep

>   };
>   
>   extern const struct io_op_def io_op_defs[];
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 55d4ab96fb92..106210e0d5d5 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -15,6 +15,7 @@
>   #include "io_uring.h"
>   #include "openclose.h"
>   #include "rsrc.h"
> +#include "opdef.h"
>   
>   struct io_rsrc_update {
>   	struct file			*file;
> @@ -204,6 +205,95 @@ void io_rsrc_put_work(struct work_struct *work)
>   	}
>   }
>   
> +
> +static unsigned int io_rsrc_retarget_req(struct io_ring_ctx *ctx,
> +					 struct io_kiocb *req)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	if (!req->rsrc_node ||
> +	     req->rsrc_node == ctx->rsrc_node)
> +		return 0;
> +	if (!io_op_defs[req->opcode].can_retarget_rsrc)
> +		return 0;
> +	if (!(*io_op_defs[req->opcode].can_retarget_rsrc)(req))
> +		return 0;

nit, there should be no need to deref fptr.

if (!io_op_defs[req->opcode].can_retarget_rsrc(req)) ...

> +
> +	io_rsrc_put_node(req->rsrc_node, 1);
> +	req->rsrc_node = ctx->rsrc_node;
> +	return 1;
> +}
> +
> +static unsigned int io_rsrc_retarget_table(struct io_ring_ctx *ctx,
> +				   struct io_hash_table *table)
> +{
> +	unsigned int nr_buckets = 1U << table->hash_bits;
> +	unsigned int refs = 0;
> +	struct io_kiocb *req;
> +	int i;
> +
> +	for (i = 0; i < nr_buckets; i++) {
> +		struct io_hash_bucket *hb = &table->hbs[i];
> +
> +		spin_lock(&hb->lock);
> +		hlist_for_each_entry(req, &hb->list, hash_node)
> +			refs += io_rsrc_retarget_req(ctx, req);
> +		spin_unlock(&hb->lock);
> +	}
> +	return refs;
> +}
> +
> +static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	percpu_ref_get(&ctx->refs);
> +	mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, 60 * HZ);
> +	ctx->rsrc_retarget_scheduled = true;
> +}
> +
> +static void __io_rsrc_retarget_work(struct io_ring_ctx *ctx)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	struct io_rsrc_node *node;
> +	unsigned int refs;
> +	bool any_waiting;
> +
> +	if (!ctx->rsrc_node)
> +		return;
> +
> +	spin_lock_irq(&ctx->rsrc_ref_lock);
> +	any_waiting = false;
> +	list_for_each_entry(node, &ctx->rsrc_ref_list, node) {
> +		if (!node->done) {
> +			any_waiting = true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irq(&ctx->rsrc_ref_lock);
> +
> +	if (!any_waiting)
> +		return;
> +
> +	refs = io_rsrc_retarget_table(ctx, &ctx->cancel_table);
> +	refs += io_rsrc_retarget_table(ctx, &ctx->cancel_table_locked);
> +
> +	ctx->rsrc_cached_refs -= refs;
> +	while (unlikely(ctx->rsrc_cached_refs < 0))
> +		io_rsrc_refs_refill(ctx);

We can charge ->rsrc_cached_refs after setting up nodes in prep / submission
without underflowing the actual refs because we know that the requests are
not yet submitted and so won't consume refs. This one looks more troublesome


> +}
> +
> +void io_rsrc_retarget_work(struct work_struct *work)
> +{
> +	struct io_ring_ctx *ctx;
> +
> +	ctx = container_of(work, struct io_ring_ctx, rsrc_retarget_work.work);
> +
> +	mutex_lock(&ctx->uring_lock);
> +	ctx->rsrc_retarget_scheduled = false;
> +	__io_rsrc_retarget_work(ctx);
> +	mutex_unlock(&ctx->uring_lock);
> +	percpu_ref_put(&ctx->refs);
> +}
> +
>   void io_wait_rsrc_data(struct io_rsrc_data *data)
>   {
>   	if (data && !atomic_dec_and_test(&data->refs))
> @@ -285,6 +375,8 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
>   		atomic_inc(&data_to_kill->refs);
>   		percpu_ref_kill(&rsrc_node->refs);
>   		ctx->rsrc_node = NULL;
> +		if (!ctx->rsrc_retarget_scheduled)
> +			io_rsrc_retarget_schedule(ctx);
>   	}
>   
>   	if (!ctx->rsrc_node) {
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 81445a477622..2b94df8fd9e8 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -54,6 +54,7 @@ struct io_mapped_ubuf {
>   };
>   
>   void io_rsrc_put_work(struct work_struct *work);
> +void io_rsrc_retarget_work(struct work_struct *work);
>   void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
>   void io_wait_rsrc_data(struct io_rsrc_data *data);
>   void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);

-- 
Pavel Begunkov
