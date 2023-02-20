Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3008169CF96
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBTOnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjBTOnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:43:20 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2001A5EB
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:43:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5EEBE226FF;
        Mon, 20 Feb 2023 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676904197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qB5l08ii49EAiwAM4YQxyKa2kQePY+73kud/mWrsCJc=;
        b=BB2WAZTvY9yKqQNDqoEWShMEZaNcTXaAUvESOtCDx7nLjjkqBJM4iFPT0clX7NVFmkBh6a
        dW9nUnTW2mr8jqHiCoZCQEdq6Z3vD+a7KxHgncQ8HJQcgVCLZzLEDwUrlhUVKozx45k0Sn
        cmg2cAljGR20ejrW5RcVGttCbDjCQdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676904197;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qB5l08ii49EAiwAM4YQxyKa2kQePY+73kud/mWrsCJc=;
        b=24kymkpjY190jSFYZiI20Td0ZeRTUPB481AxXV4AnCdwZ9YbcWcu+Jxd8NUyU54/etNR9h
        3iuCv3/A7VkoM5Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E571C139DB;
        Mon, 20 Feb 2023 14:43:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pjeKKwSH82PHOwAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 20 Feb 2023 14:43:16 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 3/4] io_uring: cache task cancelation state in the ctx
References: <20230217155600.157041-1-axboe@kernel.dk>
        <20230217155600.157041-4-axboe@kernel.dk>
Date:   Mon, 20 Feb 2023 11:43:14 -0300
In-Reply-To: <20230217155600.157041-4-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 17 Feb 2023 08:55:59 -0700")
Message-ID: <87a618e6t9.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> It can be quite expensive for the fast paths to deference
> req->task->io_uring->in_cancel for the (very) unlikely scenario that
> we're currently undergoing cancelations.
>
> Add a ctx bit to indicate if we're currently canceling or not, so that
> the hot path may check this rather than dip into the remote task
> state.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  2 ++
>  io_uring/io_uring.c            | 44 ++++++++++++++++++++++++++++++++--
>  2 files changed, 44 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 00689c12f6ab..42d704adb9c6 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -211,6 +211,8 @@ struct io_ring_ctx {
>  		enum task_work_notify_mode	notify_method;
>  		struct io_rings			*rings;
>  		struct task_struct		*submitter_task;
> +		/* local ctx cache of task cancel state */
> +		unsigned long			in_cancel;

minor nit:

even though the real tctx value is ulong, the cache could just be a bitfield
alongside the many others in this structure. you only care if it is >0
or 0 when peeking the cache.

either way,

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>




>  		struct percpu_ref		refs;
>  	} ____cacheline_aligned_in_smp;
>  
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 64e07df034d1..0fcb532db1fc 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3192,6 +3192,46 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
>  	return percpu_counter_sum(&tctx->inflight);
>  }
>  
> +static __cold void io_uring_dec_cancel(struct io_uring_task *tctx,
> +				       struct io_sq_data *sqd)
> +{
> +	if (!atomic_dec_return(&tctx->in_cancel))
> +		return;
> +
> +	if (!sqd) {
> +		struct io_tctx_node *node;
> +		unsigned long index;
> +
> +		xa_for_each(&tctx->xa, index, node)
> +			clear_bit(0, &node->ctx->in_cancel);
> +	} else {
> +		struct io_ring_ctx *ctx;
> +
> +		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> +			clear_bit(0, &ctx->in_cancel);
> +	}
> +}
> +
> +static __cold void io_uring_inc_cancel(struct io_uring_task *tctx,
> +				       struct io_sq_data *sqd)
> +{
> +	if (atomic_inc_return(&tctx->in_cancel) != 1)
> +		return;
> +
> +	if (!sqd) {
> +		struct io_tctx_node *node;
> +		unsigned long index;
> +
> +		xa_for_each(&tctx->xa, index, node)
> +			set_bit(0, &node->ctx->in_cancel);
> +	} else {
> +		struct io_ring_ctx *ctx;
> +
> +		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> +			set_bit(0, &ctx->in_cancel);
> +	}
> +}
> +
>  /*
>   * Find any io_uring ctx that this task has registered or done IO on, and cancel
>   * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
> @@ -3210,7 +3250,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>  	if (tctx->io_wq)
>  		io_wq_exit_start(tctx->io_wq);
>  
> -	atomic_inc(&tctx->in_cancel);
> +	io_uring_inc_cancel(tctx, sqd);
>  	do {
>  		bool loop = false;
>  
> @@ -3263,7 +3303,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>  		 * We shouldn't run task_works after cancel, so just leave
>  		 * ->in_cancel set for normal exit.
>  		 */
> -		atomic_dec(&tctx->in_cancel);
> +		io_uring_dec_cancel(tctx, sqd);
>  		/* for exec all current's requests should be gone, kill tctx */
>  		__io_uring_free(current);
>  	}

-- 
Gabriel Krisman Bertazi
