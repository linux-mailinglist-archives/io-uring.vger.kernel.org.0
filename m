Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA13855C2D2
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 14:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbiF0Hrz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 03:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiF0Hry (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 03:47:54 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80BD6153
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 00:47:52 -0700 (PDT)
Message-ID: <70e38e6d-35f3-f140-9551-63e4e434bf18@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656316071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L1TJ0Ud6OW8kiKEtScuYVizmv1X9erbHTqgCEKKFtqA=;
        b=iqqgOmApcW87qLo4x05dW2YoW0PboC8gl2suodRmWhM3YNj6UETDIelEctiHdWm51LJ+kn
        CJEEmQSgq/JAG5QnUs5Q8ORtTPsJBo8yAu+hEZoSgMFPMU4W6mMg/xy13ElNqwwwl+YSXw
        GaMApY4RedvIbVIE3NIoCOvHgoVflLw=
Date:   Mon, 27 Jun 2022 15:47:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next] io_uring: let to set a range for file slot
 allocation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/25/22 18:55, Pavel Begunkov wrote:
>  From recently io_uring provides an option to allocate a file index for
> operation registering fixed files. However, it's utterly unusable with
> mixed approaches when for a part of files the userspace knows better
> where to place it, as it may race and users don't have any sane way to
> pick a slot and hoping it will not be taken.

Exactly, with high frequency of index allocation from like multishot
accept, it's easy that user-pick requests fails.
By the way, just curious, I can't recall a reason that users pick a slot
rather than letting kernel do the decision, is there any? So I guess
users may use all the indexes as 'file slot allocation' range. Correct
me if I miss something.


> 
> Let the userspace to register a range of fixed file slots in which the
> auto-allocation happens. The use case is splittting the fixed table in
> two parts, where on of them is used for auto-allocation and another for
> slot-specified operations.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Some quick tests:
> https://github.com/isilence/liburing/tree/range-file-alloc
> 
>   include/linux/io_uring_types.h |  3 +++
>   include/uapi/linux/io_uring.h  | 13 +++++++++++++
>   io_uring/filetable.c           | 24 ++++++++++++++++++++----
>   io_uring/filetable.h           | 20 +++++++++++++++++---
>   io_uring/io_uring.c            |  6 ++++++
>   io_uring/rsrc.c                |  2 ++
>   6 files changed, 61 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 918165a20053..1054b8b1ad69 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -233,6 +233,9 @@ struct io_ring_ctx {
>   
>   	unsigned long		check_cq;
>   
> +	unsigned int		file_alloc_start;
> +	unsigned int		file_alloc_end;
> +
>   	struct {
>   		/*
>   		 * We cache a range of free CQEs we can use, once exhausted it
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 09e7c3b13d2d..84dd240e7147 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -429,6 +429,9 @@ enum {
>   	/* sync cancelation API */
>   	IORING_REGISTER_SYNC_CANCEL		= 24,
>   
> +	/* register a range of fixed file slots for automatic slot allocation */
> +	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
> +
>   	/* this goes last */
>   	IORING_REGISTER_LAST
>   };
> @@ -575,4 +578,14 @@ struct io_uring_sync_cancel_reg {
>   	__u64				pad[4];
>   };
>   
> +/*
> + * Argument for IORING_REGISTER_FILE_ALLOC_RANGE
> + * The range is specified as [off, off + len)
> + */
> +struct io_uring_file_index_range {
> +	__u32	off;
> +	__u32	len;
> +	__u64	resv;
> +};
> +
>   #endif
> diff --git a/io_uring/filetable.c b/io_uring/filetable.c
> index 534e1a3c625d..5d2207654e0e 100644
> --- a/io_uring/filetable.c
> +++ b/io_uring/filetable.c
> @@ -16,7 +16,7 @@
>   static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>   {
>   	struct io_file_table *table = &ctx->file_table;
> -	unsigned long nr = ctx->nr_user_files;
> +	unsigned long nr = ctx->file_alloc_end;
>   	int ret;
>   
>   	do {
> @@ -24,11 +24,10 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>   		if (ret != nr)
>   			return ret;
>   
> -		if (!table->alloc_hint)
> +		if (table->alloc_hint == ctx->file_alloc_start)
>   			break;
> -
>   		nr = table->alloc_hint;
> -		table->alloc_hint = 0;
> +		table->alloc_hint = ctx->file_alloc_start;

should we use io_reset_alloc_hint() ?

>   	} while (1);
>   
>   	return -ENFILE;
> @@ -139,3 +138,20 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
>   		fput(file);
>   	return ret;
>   }
> +
> +int io_register_file_alloc_range(struct io_ring_ctx *ctx,
> +				 struct io_uring_file_index_range __user *arg)
> +{
> +	struct io_uring_file_index_range range;
> +	u32 end;
> +
> +	if (copy_from_user(&range, arg, sizeof(range)))
> +		return -EFAULT;
> +	if (check_add_overflow(range.off, range.len, &end))
> +		return -EOVERFLOW;
> +	if (range.resv || end > ctx->nr_user_files)
> +		return -EINVAL;
> +
> +	io_file_table_set_alloc_range(ctx, range.off, range.len);
> +	return 0;
> +}
> diff --git a/io_uring/filetable.h b/io_uring/filetable.h
> index fb5a274c08ff..acd5e6463733 100644
> --- a/io_uring/filetable.h
> +++ b/io_uring/filetable.h
> @@ -3,9 +3,7 @@
>   #define IOU_FILE_TABLE_H
>   
>   #include <linux/file.h>
> -
> -struct io_ring_ctx;
> -struct io_kiocb;
> +#include <linux/io_uring_types.h>
>   
>   /*
>    * FFS_SCM is only available on 64-bit archs, for 32-bit we just define it as 0
> @@ -30,6 +28,9 @@ void io_free_file_tables(struct io_file_table *table);
>   int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
>   			struct file *file, unsigned int file_slot);
>   
> +int io_register_file_alloc_range(struct io_ring_ctx *ctx,
> +				 struct io_uring_file_index_range __user *arg);
> +
>   unsigned int io_file_get_flags(struct file *file);
>   
>   static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
> @@ -68,4 +69,17 @@ static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
>   	file_slot->file_ptr = file_ptr;
>   }
>   
> +static inline void io_reset_alloc_hint(struct io_ring_ctx *ctx)
> +{
> +	ctx->file_table.alloc_hint = ctx->file_alloc_start;
> +}
> +
> +static inline void io_file_table_set_alloc_range(struct io_ring_ctx *ctx,
> +						 unsigned off, unsigned len)
> +{
> +	ctx->file_alloc_start = off;
> +	ctx->file_alloc_end = off + len;
> +	io_reset_alloc_hint(ctx);
> +}
> +
>   #endif
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 45538b3c3a76..8ab17e2325bc 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3877,6 +3877,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			break;
>   		ret = io_sync_cancel(ctx, arg);
>   		break;
> +	case IORING_REGISTER_FILE_ALLOC_RANGE:
> +		ret = -EINVAL;
> +		if (!arg || nr_args)
> +			break;
> +		ret = io_register_file_alloc_range(ctx, arg);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 3a2a5ef263f0..edca7c750f99 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1009,6 +1009,8 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   		io_file_bitmap_set(&ctx->file_table, i);
>   	}
>   
> +	/* default it to the whole table */
> +	io_file_table_set_alloc_range(ctx, 0, ctx->nr_user_files);
>   	io_rsrc_node_switch(ctx, NULL);
>   	return 0;
>   fail:

