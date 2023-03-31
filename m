Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BA56D220F
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjCaOJm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 10:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjCaOJl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 10:09:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591B01E73F;
        Fri, 31 Mar 2023 07:09:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DEDC21FD7C;
        Fri, 31 Mar 2023 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680271774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNZ94o/MZbKL9G0QQj9aIoZ+VfTlCGmKP5S0MBE57OA=;
        b=EmbrFBr4HpWgMMI2YmJCxOMOaBnmJw45SOZKjPttuASA/igdkaW9Hmqp3gy7NGbdoEUDDd
        +lCjWE2EvlrAWvUqdyqzI3+vMJtZdgdVDD+t7nzrPqiuXdpNK2ALqUBXl2hvLm7qfFRG/n
        9b+s00dGhtfHbr1PX+YKXYDuT8MXbl0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680271774;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNZ94o/MZbKL9G0QQj9aIoZ+VfTlCGmKP5S0MBE57OA=;
        b=98OycAMMB7IHnPkxOLCqJH4lN66ZwBU/EBZ2fTULo+1yPYh5fkdQW/kiuLQ30MXKvDX8ak
        X+P+as1Gi1B1H9Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F101134F7;
        Fri, 31 Mar 2023 14:09:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gsqyDp7pJmQUXwAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 31 Mar 2023 14:09:34 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
References: <cover.1680187408.git.asml.silence@gmail.com>
        <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
Date:   Fri, 31 Mar 2023 11:09:32 -0300
In-Reply-To: <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Thu, 30 Mar 2023 15:53:28 +0100")
Message-ID: <87cz4p1083.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> Add allocation cache for struct io_rsrc_node, it's always allocated and
> put under ->uring_lock, so it doesn't need any extra synchronisation
> around caches.

Hi Pavel,

I'm curious if you considered using kmem_cache instead of the custom
cache for this case?  I'm wondering if this provokes visible difference in
performance in your benchmark.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  1 +
>  io_uring/io_uring.c            | 11 +++++++++--
>  io_uring/rsrc.c                | 23 +++++++++++++++--------
>  io_uring/rsrc.h                |  5 ++++-
>  4 files changed, 29 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 47496059e13a..5d772e36e7fc 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -332,6 +332,7 @@ struct io_ring_ctx {
>  
>  	/* protected by ->uring_lock */
>  	struct list_head		rsrc_ref_list;
> +	struct io_alloc_cache		rsrc_node_cache;
>  
>  	struct list_head		io_buffers_pages;
>  
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8c3886a4ca96..beedaf403284 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -310,6 +310,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  	INIT_LIST_HEAD(&ctx->sqd_list);
>  	INIT_LIST_HEAD(&ctx->cq_overflow_list);
>  	INIT_LIST_HEAD(&ctx->io_buffers_cache);
> +	io_alloc_cache_init(&ctx->rsrc_node_cache, sizeof(struct io_rsrc_node));
>  	io_alloc_cache_init(&ctx->apoll_cache, sizeof(struct async_poll));
>  	io_alloc_cache_init(&ctx->netmsg_cache, sizeof(struct io_async_msghdr));
>  	init_completion(&ctx->ref_comp);
> @@ -2791,6 +2792,11 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
>  	mutex_unlock(&ctx->uring_lock);
>  }
>  
> +void io_rsrc_node_cache_free(struct io_cache_entry *entry)
> +{
> +	kfree(container_of(entry, struct io_rsrc_node, cache));
> +}
> +
>  static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  {
>  	io_sq_thread_finish(ctx);
> @@ -2816,9 +2822,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  
>  	/* there are no registered resources left, nobody uses it */
>  	if (ctx->rsrc_node)
> -		io_rsrc_node_destroy(ctx->rsrc_node);
> +		io_rsrc_node_destroy(ctx, ctx->rsrc_node);
>  	if (ctx->rsrc_backup_node)
> -		io_rsrc_node_destroy(ctx->rsrc_backup_node);
> +		io_rsrc_node_destroy(ctx, ctx->rsrc_backup_node);
>  
>  	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
>  
> @@ -2830,6 +2836,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  #endif
>  	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
>  
> +	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
>  	if (ctx->mm_account) {
>  		mmdrop(ctx->mm_account);
>  		ctx->mm_account = NULL;
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 0f4e245dee1b..345631091d80 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -164,7 +164,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
>  		kfree(prsrc);
>  	}
>  
> -	io_rsrc_node_destroy(ref_node);
> +	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
>  	if (atomic_dec_and_test(&rsrc_data->refs))
>  		complete(&rsrc_data->done);
>  }
> @@ -175,9 +175,10 @@ void io_wait_rsrc_data(struct io_rsrc_data *data)
>  		wait_for_completion(&data->done);
>  }
>  
> -void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
> +void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>  {
> -	kfree(ref_node);
> +	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache))
> +		kfree(node);
>  }
>  
>  void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
> @@ -198,13 +199,19 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
>  	}
>  }
>  
> -static struct io_rsrc_node *io_rsrc_node_alloc(void)
> +static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
>  {
>  	struct io_rsrc_node *ref_node;
> +	struct io_cache_entry *entry;
>  
> -	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
> -	if (!ref_node)
> -		return NULL;
> +	entry = io_alloc_cache_get(&ctx->rsrc_node_cache);
> +	if (entry) {
> +		ref_node = container_of(entry, struct io_rsrc_node, cache);
> +	} else {
> +		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
> +		if (!ref_node)
> +			return NULL;
> +	}
>  
>  	ref_node->refs = 1;
>  	INIT_LIST_HEAD(&ref_node->node);
> @@ -243,7 +250,7 @@ int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
>  {
>  	if (ctx->rsrc_backup_node)
>  		return 0;
> -	ctx->rsrc_backup_node = io_rsrc_node_alloc();
> +	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
>  	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
>  }
>  
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 17293ab90f64..d1555eaae81a 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -4,6 +4,8 @@
>  
>  #include <net/af_unix.h>
>  
> +#include "alloc_cache.h"
> +
>  #define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
>  #define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
>  #define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
> @@ -37,6 +39,7 @@ struct io_rsrc_data {
>  };
>  
>  struct io_rsrc_node {
> +	struct io_cache_entry		cache;
>  	int refs;
>  	struct list_head		node;
>  	struct io_rsrc_data		*rsrc_data;
> @@ -65,7 +68,7 @@ void io_rsrc_put_tw(struct callback_head *cb);
>  void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
>  void io_rsrc_put_work(struct work_struct *work);
>  void io_wait_rsrc_data(struct io_rsrc_data *data);
> -void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
> +void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
>  int io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
>  int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
>  			  struct io_rsrc_node *node, void *rsrc);

-- 
Gabriel Krisman Bertazi
