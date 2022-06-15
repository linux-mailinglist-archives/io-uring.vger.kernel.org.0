Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD3154C4E8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 11:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343756AbiFOJmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 05:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243260AbiFOJmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 05:42:12 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9063ED17
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 02:42:11 -0700 (PDT)
Message-ID: <40197f84-35e3-4e37-fe73-3c7f4c21d513@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655286129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMHZ5mKGNISuDqc9lZA1yW24W1DL0prBq14Ki65hun8=;
        b=je9FyEQWHoHQ+q96G8g0kNDZw5G5tSQgZsXmaQGc/nDGeBdfiYtaaKwH7RjFvdotX0rsjM
        hvOGR3o7fHuaTYh+4z5u2ibEc28QnhA+E74a7937w42vOs588eqOejA9WYuceggMrYqK5e
        io72NxRo8a3Ev8+brYegvRp/0RUSbVo=
Date:   Wed, 15 Jun 2022 17:41:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 21/25] io_uring: add
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 22:37, Pavel Begunkov wrote:
> Add a new IORING_SETUP_SINGLE_ISSUER flag and the userspace visible part
> of it, i.e. put limitations of submitters. Also, don't allow it together
> with IOPOLL as we're not going to put it to good use.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/uapi/linux/io_uring.h |  5 ++++-
>   io_uring/io_uring.c           |  7 +++++--
>   io_uring/io_uring_types.h     |  1 +
>   io_uring/tctx.c               | 27 ++++++++++++++++++++++++---
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
> index 15d209f334eb..4b90439808e3 100644
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
> index aba0f8cd6f49..f6d0ad25f377 100644
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
> index 6adf659687f8..012be261dc50 100644
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

Seems we don't need this uring_lock:
When we create a ring, we setup ctx->submitter_task before uring fd is
installed so at that time nobody else can enter this code.
when we enter this code later in io_uring_enter, we just read it.

