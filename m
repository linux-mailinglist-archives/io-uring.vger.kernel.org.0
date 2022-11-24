Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012DE637D75
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKXQFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiKXQFj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:05:39 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721C15BB19
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:05:38 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id cl5so3072958wrb.9
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3RsCd0y3JXIWpBBsgPE4Mq6m8ajfxKQAwJ9NPVzGKKY=;
        b=lUA/g/9lfHyHn75QEqbAglkuQR/pm6ypTeapF0DhzB0WFZN5tssI8HAGOxTXanW78k
         h7Y2ommBmM+zVKAsigSsfxxwVs3q12fRVZlDXTOVzcZR5rHDS2dWYr94ApdxXu25J4+W
         qnQCYNzkDIPeUxYi6WVV3KmnEqyZRE+dQqn7Ibt/9x1lpzM2ppedUbKZ36IDa9pYiDif
         a9l/p6K34+ysPv0LfojpDlz3H2zygaf5rcTb7dF789K1YAkg/t+Rt/OeSn/Wgr6e8Kw9
         7ZR5NKnIfh82YOiK83wgHwbTceg0grwYiDYAGnnLggzXjR9StZdq5fysX1KsAxT8UPEx
         eO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3RsCd0y3JXIWpBBsgPE4Mq6m8ajfxKQAwJ9NPVzGKKY=;
        b=Y/fqCdy3hYC9pAr6x3By1MO0Z4hG0tkTPChhFj5aSBwjOILN2+sCl+/ZDiJlFvbQj6
         oUZTXUXEaMoo6/Rh0/au90wDfD2LhU7PvD9lobfkH3pZV+FJqp/6ub9Lxlvi0yOz8vAi
         yxe3NFzi5mKj6zLTpMF4ZzE8ZYVdk293HmLLUmi72p0xNPMqic+uX9po1rH+AKWwP2vL
         Tjll+p+xqIVQ4IRNjMRufGIJUkywtsL6cWFMZH6wuSdcY9fjTIPHsuOvWCp29zzR1Rak
         NRGBCQOOyAIg7ISM1gCtqhLsH7CHVfnfTADMcv1rqkOFBx1kYWFDSAKxmFXtSNGwxnfU
         Rohw==
X-Gm-Message-State: ANoB5plNB5mVpuRPJRSPf47nxA19PTAv/zvYFPxaGm33pByzhTaUfu1Z
        x/uB6ijmzuv9eE7fD66+qhY=
X-Google-Smtp-Source: AA0mqf5k0ZnsUMeSDVnszsa/fFNV+cPtGPKLjKiSMM+Xiq04nIPKxwyZSFCbAd8PKzsXmGS7cAEj8w==
X-Received: by 2002:a5d:526b:0:b0:242:380:c10e with SMTP id l11-20020a5d526b000000b002420380c10emr295387wrc.132.1669305936860;
        Thu, 24 Nov 2022 08:05:36 -0800 (PST)
Received: from [192.168.8.100] (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id cc18-20020a5d5c12000000b002238ea5750csm2078727wrb.72.2022.11.24.08.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 08:05:36 -0800 (PST)
Message-ID: <5a490cb1-bf73-fddf-fd7b-8ee3f0c21b42@gmail.com>
Date:   Thu, 24 Nov 2022 16:04:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-next v3 4/9] io_uring: allow defer completion for aux
 posted cqes
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221124093559.3780686-1-dylany@meta.com>
 <20221124093559.3780686-5-dylany@meta.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221124093559.3780686-5-dylany@meta.com>
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

On 11/24/22 09:35, Dylan Yudaken wrote:
> Multishot ops cannot use the compl_reqs list as the request must stay in
> the poll list, but that means they need to run each completion without
> benefiting from batching.
> 
> Here introduce batching infrastructure for only small (ie 16 byte)
> CQEs. This restriction is ok because there are no use cases posting 32
> byte CQEs.
> 
> In the ring keep a batch of up to 16 posted results, and flush in the same
> way as compl_reqs.
> 
> 16 was chosen through experimentation on a microbenchmark ([1]), as well
> as trying not to increase the size of the ring too much. This increases
> the size to 1472 bytes from 1216.

It might be cleaner to defer io_cqring_ev_posted() instead of caching
cqes and spinlocking is not a big problem, because we can globally
get rid of them.


> [1]: https://github.com/DylanZA/liburing/commit/9ac66b36bcf4477bfafeff1c5f107896b7ae31cf
> Run with $ make -j && ./benchmark/reg.b -s 1 -t 2000 -r 10
> Gives results:
> baseline	8309 k/s
> 8		18807 k/s
> 16		19338 k/s
> 32		20134 k/s
> 
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>   include/linux/io_uring_types.h |  2 ++
>   io_uring/io_uring.c            | 27 ++++++++++++++++++++++++---
>   2 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index f5b687a787a3..accdfecee953 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -174,7 +174,9 @@ struct io_submit_state {
>   	bool			plug_started;
>   	bool			need_plug;
>   	unsigned short		submit_nr;
> +	unsigned int		cqes_count;
>   	struct blk_plug		plug;
> +	struct io_uring_cqe	cqes[16];
>   };
>   
>   struct io_ev_fd {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cbd271b6188a..53b61b5cde80 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -167,7 +167,8 @@ EXPORT_SYMBOL(io_uring_get_socket);
>   
>   static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
>   {
> -	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
> +	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
> +	    ctx->submit_state.cqes_count)
>   		__io_submit_flush_completions(ctx);
>   }
>   
> @@ -802,6 +803,21 @@ bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
>   	return false;
>   }
>   
> +static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	struct io_submit_state *state = &ctx->submit_state;
> +	unsigned int i;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +	for (i = 0; i < state->cqes_count; i++) {
> +		struct io_uring_cqe *cqe = &state->cqes[i];
> +
> +		io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags, true);
> +	}
> +	state->cqes_count = 0;
> +}
> +
>   bool io_post_aux_cqe(struct io_ring_ctx *ctx,
>   		     u64 user_data, s32 res, u32 cflags,
>   		     bool allow_overflow)
> @@ -1325,6 +1341,9 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	struct io_submit_state *state = &ctx->submit_state;
>   
>   	io_cq_lock(ctx);
> +	/* must come first to preserve CQE ordering in failure cases */
> +	if (state->cqes_count)
> +		__io_flush_post_cqes(ctx);
>   	wq_list_for_each(node, prev, &state->compl_reqs) {
>   		struct io_kiocb *req = container_of(node, struct io_kiocb,
>   					    comp_list);
> @@ -1334,8 +1353,10 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	}
>   	io_cq_unlock_post(ctx);
>   
> -	io_free_batch_list(ctx, state->compl_reqs.first);
> -	INIT_WQ_LIST(&state->compl_reqs);
> +	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
> +		io_free_batch_list(ctx, state->compl_reqs.first);
> +		INIT_WQ_LIST(&state->compl_reqs);
> +	}
>   }
>   
>   /*

-- 
Pavel Begunkov
