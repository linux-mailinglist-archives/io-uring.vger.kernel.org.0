Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96CA54B1C9
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243825AbiFNM5V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243191AbiFNM5U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:57:20 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626043EF09
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:57:19 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x17so11176899wrg.6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BktOVjEUjh8YCA+GrqcI7QB+m+lFBfkCm1B7IPIiPe0=;
        b=UcYO2WHLk16ZkxcmhXX6TlCqwY1f8TJOO/lhwpGBX9ThfJotrapfIZC9u1Amiomm1G
         jgth8dezIa+mh0xJGuA7I03hhciHqRdmYHSZsc7VOKEcuGLes71kV9ZrW81ZVXBcGt62
         rfyo3nC5GIxRtbMzFPqvxqLboAP8UjnNDMtB3UdzQxwjydURffPtkl8cma+blSUHAi4o
         u15Q6R2nvgobEPzs4MMTJaCVtwi/GvyqZMpbbbRfabvo1tfyC0uJBO7SbVXJxcrZ4dDe
         e2eGnVEoeeqbovRTC4qvBgEC/pehsq8XZHUlcbuakPTvQegD6gf6Y4oqmkHPkTO41spJ
         QnKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BktOVjEUjh8YCA+GrqcI7QB+m+lFBfkCm1B7IPIiPe0=;
        b=lgeqwwJ+s9/NlyfGBq7JmAeC/p3nj5sBjnW6E8GLHKQvRCN9LYhpSlXcfOjx3bDGck
         +MEms3sPBOE/PfPd8f9cYiqC4X3oRr5llFa2erm8/7iSfqgDXU6t3ezS2GfscMd2nMjP
         EU/nZoU7NntwBjzqxI51jDvvpIAnlQ6LYKYp4AWBlBSuBNXohMaXNqDArNleeGu9KocP
         y2CzftLdaLlAXYcVPgItmefhyDpy61ZyPI1Qo0RHwbJKR0auCw5aqvWsarH52gibjMzU
         gRbDZYl3IUO2shesgUXJwRdZJcvG+/dP4nu8qBklnzDRb2rCFkfn6WYtxSUqbBIhSYgt
         XHdA==
X-Gm-Message-State: AJIora8KCDYcXMaXM6CPxWWMl3LIOagdOYRb91Tfr51yE8fr2U3/RwJj
        srMc/URjJC9COCMkXEeIN+RnQSDPTBhtrA==
X-Google-Smtp-Source: AGRyM1tqWXqKxlvzMwktg4q9B/kWeG3nf8QPzaYIs10Nh+Zky4DqN0cFq/L2Lok28RaqtWqRESMC7g==
X-Received: by 2002:a05:6000:1108:b0:210:2a75:4227 with SMTP id z8-20020a056000110800b002102a754227mr4838850wrw.170.1655211437518;
        Tue, 14 Jun 2022 05:57:17 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id j20-20020adfa554000000b002100316b126sm12086821wrb.6.2022.06.14.05.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 05:57:17 -0700 (PDT)
Message-ID: <937a5109-3831-6543-dae4-355badadbfca@gmail.com>
Date:   Tue, 14 Jun 2022 13:56:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 21/25] io_uring: add IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655209709.git.asml.silence@gmail.com>
 <b8f41617e47dc5d92b240eb7feebe0d719927436.1655209709.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b8f41617e47dc5d92b240eb7feebe0d719927436.1655209709.git.asml.silence@gmail.com>
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

On 6/14/22 13:29, Pavel Begunkov wrote:
> Add a new IORING_SETUP_SINGLE_ISSUER flag and the userspace visible part
> of it, i.e. put limitations of submitters. Also, don't allow it together
> with IOPOLL as we're not going to put it to good use.

Something goes wrong after rebase, need to change this one and
will send out my tests for it later.


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/uapi/linux/io_uring.h |  5 ++++-
>   io_uring/io_uring.c           |  9 ++++++---
>   io_uring/io_uring_types.h     |  1 +
>   io_uring/tctx.c               | 25 +++++++++++++++++++++++--
>   io_uring/tctx.h               |  4 ++--
>   5 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index a41ddb8c5e1f..a3a691340d3e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -138,9 +138,12 @@ enum {
>    * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
>    */
>   #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
> -
>   #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
>   #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
> +/*
> + * Only one task is allowed to submit requests
> + */
> +#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
>   
>   enum io_uring_op {
>   	IORING_OP_NOP,
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 89696efcead4..af0bd74e78fa 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3020,6 +3020,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   	io_destroy_buffers(ctx);
>   	if (ctx->sq_creds)
>   		put_cred(ctx->sq_creds);
> +	if (ctx->submitter_task)
> +		put_task_struct(ctx->submitter_task);
>   
>   	/* there are no registered resources left, nobody uses it */
>   	if (ctx->rsrc_node)
> @@ -3615,7 +3617,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   		}
>   		ret = to_submit;
>   	} else if (to_submit) {
> -		ret = io_uring_add_tctx_node(ctx);
> +		ret = __io_uring_add_tctx_node(ctx, false);
>   		if (unlikely(ret))
>   			goto out;
>   
> @@ -3752,7 +3754,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
>   	if (fd < 0)
>   		return fd;
>   
> -	ret = io_uring_add_tctx_node(ctx);
> +	ret = __io_uring_add_tctx_node(ctx, false);
>   	if (ret) {
>   		put_unused_fd(fd);
>   		return ret;
> @@ -3972,7 +3974,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>   			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
>   			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
>   			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
> -			IORING_SETUP_SQE128 | IORING_SETUP_CQE32))
> +			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
> +			IORING_SETUP_SINGLE_ISSUER))
>   		return -EINVAL;
>   
>   	return io_uring_create(entries, &p, params);
> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
> index 0dd3ab7eec4c..faa1477bd754 100644
> --- a/io_uring/io_uring_types.h
> +++ b/io_uring/io_uring_types.h
> @@ -241,6 +241,7 @@ struct io_ring_ctx {
>   	/* Keep this last, we don't need it for the fast path */
>   
>   	struct io_restriction		restrictions;
> +	struct task_struct		*submitter_task;
>   
>   	/* slow path rsrc auxilary data, used by update/register */
>   	struct io_rsrc_node		*rsrc_backup_node;
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index 6adf659687f8..e3138a36cf39 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -81,12 +81,32 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
>   	return 0;
>   }
>   
> -int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
> +static int io_register_submitter(struct io_ring_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&ctx->uring_lock);
> +	if (!ctx->submitter_task)
> +		ctx->submitter_task = get_task_struct(current);
> +	else if (ctx->submitter_task != current)
> +		ret = -EEXIST;
> +	mutex_unlock(&ctx->uring_lock);
> +
> +	return ret;
> +}
> +
> +int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool submitter)
>   {
>   	struct io_uring_task *tctx = current->io_uring;
>   	struct io_tctx_node *node;
>   	int ret;
>   
> +	if ((ctx->flags & IORING_SETUP_SINGLE_ISSUER) && submitter) {
> +		ret = io_register_submitter(ctx);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	if (unlikely(!tctx)) {
>   		ret = io_uring_alloc_task_context(current, ctx);
>   		if (unlikely(ret))
> @@ -120,7 +140,8 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   		list_add(&node->ctx_node, &ctx->tctx_list);
>   		mutex_unlock(&ctx->uring_lock);
>   	}
> -	tctx->last = ctx;
> +	if (submitter)
> +		tctx->last = ctx;
>   	return 0;
>   }
>   
> diff --git a/io_uring/tctx.h b/io_uring/tctx.h
> index 7684713e950f..dde82ce4d8e2 100644
> --- a/io_uring/tctx.h
> +++ b/io_uring/tctx.h
> @@ -34,7 +34,7 @@ struct io_tctx_node {
>   int io_uring_alloc_task_context(struct task_struct *task,
>   				struct io_ring_ctx *ctx);
>   void io_uring_del_tctx_node(unsigned long index);
> -int __io_uring_add_tctx_node(struct io_ring_ctx *ctx);
> +int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool submitter);
>   void io_uring_clean_tctx(struct io_uring_task *tctx);
>   
>   void io_uring_unreg_ringfd(void);
> @@ -52,5 +52,5 @@ static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   
>   	if (likely(tctx && tctx->last == ctx))
>   		return 0;
> -	return __io_uring_add_tctx_node(ctx);
> +	return __io_uring_add_tctx_node(ctx, true);
>   }

-- 
Pavel Begunkov
