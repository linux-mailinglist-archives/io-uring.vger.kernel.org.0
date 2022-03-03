Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD754CB9AA
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 09:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiCCI5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 03:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiCCI5f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 03:57:35 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3CB177742
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 00:56:48 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V66qy85_1646297805;
Received: from 30.226.12.33(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V66qy85_1646297805)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Mar 2022 16:56:46 +0800
Message-ID: <08e460c0-7a2f-a60e-adc3-69ce470cd07d@linux.alibaba.com>
Date:   Thu, 3 Mar 2022 16:56:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 3/3/22 13:28, Xiaoguang Wang wrote:
> IORING_REGISTER_FILES is a good feature to reduce fget/fput overhead for
> each IO we do on file, but still left one, which is io_uring_enter(2).
> In io_uring_enter(2), it still fget/fput io_ring fd. I have observed
> this overhead in some our internal oroutine implementations based on
> io_uring with low submit batch. To totally remove fget/fput overhead in
> io_uring, we may add a small struct file cache in io_uring_task and add
> a new IORING_ENTER_FIXED_FILE flag. Currently the capacity of this file
> cache is 16, wihcih I think it maybe enough, also not that this cache is
> per-thread.
>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   fs/io_uring.c                 | 127 +++++++++++++++++++++++++++++++++++++-----
>   include/linux/io_uring.h      |   5 +-
>   include/uapi/linux/io_uring.h |   9 +++
>   3 files changed, 126 insertions(+), 15 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 77b9c7e4793b..e1d4b537cb60 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -461,6 +461,8 @@ struct io_ring_ctx {
>   	};
>   };
>   
> +#define IO_RINGFD_REG_MAX 16
> +
>   struct io_uring_task {
>   	/* submission side */
>   	int			cached_refs;
> @@ -476,6 +478,7 @@ struct io_uring_task {
>   	struct io_wq_work_list	task_list;
>   	struct io_wq_work_list	prior_task_list;
>   	struct callback_head	task_work;
> +	struct file		**registered_files;
>   	bool			task_running;
>   };
>   
> @@ -8739,8 +8742,16 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
>   	if (unlikely(!tctx))
>   		return -ENOMEM;
>   
> +	tctx->registered_files = kzalloc(sizeof(struct file *) * IO_RINGFD_REG_MAX,
> +					 GFP_KERNEL);
> +	if (unlikely(!tctx->registered_files)) {
> +		kfree(tctx);
> +		return -ENOMEM;
> +	}
> +
>   	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
>   	if (unlikely(ret)) {
> +		kfree(tctx->registered_files);
>   		kfree(tctx);
>   		return ret;
>   	}
> @@ -8749,6 +8760,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
>   	if (IS_ERR(tctx->io_wq)) {
>   		ret = PTR_ERR(tctx->io_wq);
>   		percpu_counter_destroy(&tctx->inflight);
> +		kfree(tctx->registered_files);
>   		kfree(tctx);
>   		return ret;
>   	}
> @@ -9382,6 +9394,56 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
>   	return -ENXIO;
>   }
>   
> +static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool locked);
> +
> +static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_fd_reg reg;
> +	struct io_uring_task *tctx;
> +	struct file *file;
> +	int ret;
> +
> +	if (copy_from_user(&reg, arg, sizeof(struct io_uring_fd_reg)))
> +		return -EFAULT;
> +	if (reg.offset > IO_RINGFD_REG_MAX)
should be >=
> +		return -EINVAL;
> +
> +	ret = io_uring_add_tctx_node(ctx, true);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	tctx = current->io_uring;
> +	if (tctx->registered_files[reg.offset])
> +		return -EBUSY;
> +	file = fget(reg.fd);
> +	if (unlikely(!file))
> +		return -EBADF;
> +	tctx->registered_files[reg.offset] = file;
> +	return 0;
> +}
> +
> +static int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_task *tctx;
> +	__u32 offset;
> +
> +	if (!current->io_uring)
> +		return 0;
> +
> +	if (copy_from_user(&offset, arg, sizeof(__u32)))
> +		return -EFAULT;
> +	if (offset > IO_RINGFD_REG_MAX)
ditto
> +		return -EINVAL;
> +
> +	tctx = current->io_uring;
> +	if (tctx->registered_files[offset]) {
> +		fput(tctx->registered_files[offset]);
> +		tctx->registered_files[offset] = NULL;
> +	}
> +
> +	return 0;
> +}
> +
>   static void io_destroy_buffers(struct io_ring_ctx *ctx)
>   {
>   	struct io_buffer *buf;
> @@ -9790,7 +9852,7 @@ static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   	}
>   }
>   
> -static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
> +static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool locked)
>   {
>   	struct io_uring_task *tctx = current->io_uring;
>   	struct io_tctx_node *node;
> @@ -9825,9 +9887,11 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   			return ret;
>   		}
>   
> -		mutex_lock(&ctx->uring_lock);
> +		if (!locked)
> +			mutex_lock(&ctx->uring_lock);
>   		list_add(&node->ctx_node, &ctx->tctx_list);
> -		mutex_unlock(&ctx->uring_lock);
> +		if (!locked)
> +			mutex_unlock(&ctx->uring_lock);
>   	}
>   	tctx->last = ctx;
>   	return 0;
> @@ -9836,13 +9900,13 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   /*
>    * Note that this task has used io_uring. We use it for cancelation purposes.
>    */
> -static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
> +static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool locked)
>   {
>   	struct io_uring_task *tctx = current->io_uring;
>   
>   	if (likely(tctx && tctx->last == ctx))
>   		return 0;
> -	return __io_uring_add_tctx_node(ctx);
> +	return __io_uring_add_tctx_node(ctx, locked);
>   }
>   
>   /*
> @@ -9973,6 +10037,16 @@ void __io_uring_cancel(bool cancel_all)
>   	io_uring_cancel_generic(cancel_all, NULL);
>   }
>   
> +void io_uring_unreg_ringfd(struct io_uring_task *tctx)
> +{
> +	int i;
> +
> +	for (i = 0; i < IO_RINGFD_REG_MAX; i++) {
> +		if (tctx->registered_files[i])
> +			fput(tctx->registered_files[i]);
> +	}
> +}
> +
>   static void *io_uring_validate_mmap_request(struct file *file,
>   					    loff_t pgoff, size_t sz)
>   {
> @@ -10098,24 +10172,36 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   	struct io_ring_ctx *ctx;
>   	int submitted = 0;
>   	struct fd f;
> +	struct file *file;
>   	long ret;
>   
>   	io_run_task_work();
>   
>   	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
> -			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
> +			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
> +			       IORING_ENTER_FIXED_FILE)))
>   		return -EINVAL;
>   
> -	f = fdget(fd);
> -	if (unlikely(!f.file))
> -		return -EBADF;
> +	if (flags & IORING_ENTER_FIXED_FILE) {
> +		if (fd > IO_RINGFD_REG_MAX || !current->io_uring)
ditto
> +			return -EINVAL;
> +
> +		file = current->io_uring->registered_files[fd];
> +		if (unlikely(!file))
> +			return -EBADF;
> +	} else {
> +		f = fdget(fd);
> +		if (unlikely(!f.file))
> +			return -EBADF;
> +		file = f.file;
> +	}
>   
>   	ret = -EOPNOTSUPP;
> -	if (unlikely(f.file->f_op != &io_uring_fops))
> +	if (unlikely(file->f_op != &io_uring_fops))
>   		goto out_fput;
>   
>   	ret = -ENXIO;
> -	ctx = f.file->private_data;
> +	ctx = file->private_data;
>   	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
>   		goto out_fput;
>   
> @@ -10145,7 +10231,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   		}
>   		submitted = to_submit;
>   	} else if (to_submit) {
> -		ret = io_uring_add_tctx_node(ctx);
> +		ret = io_uring_add_tctx_node(ctx, false);
>   		if (unlikely(ret))
>   			goto out;
>   		mutex_lock(&ctx->uring_lock);
> @@ -10182,7 +10268,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   out:
>   	percpu_ref_put(&ctx->refs);
>   out_fput:
> -	fdput(f);
> +	if (!(flags & IORING_ENTER_FIXED_FILE))
> +		fdput(f);
>   	return submitted ? submitted : ret;
>   }
>   
> @@ -10413,7 +10500,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
>   	if (fd < 0)
>   		return fd;
>   
> -	ret = io_uring_add_tctx_node(ctx);
> +	ret = io_uring_add_tctx_node(ctx, false);
>   	if (ret) {
>   		put_unused_fd(fd);
>   		return ret;
> @@ -11134,6 +11221,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			break;
>   		ret = io_register_iowq_max_workers(ctx, arg);
>   		break;
> +	case IORING_REGISTER_IORINGFD:
> +		ret = -EINVAL;
> +		if (nr_args != 1)
> +			break;
> +		ret = io_ringfd_register(ctx, arg);
> +		break;
> +	case IORING_UNREGISTER_IORINGFD:
> +		ret = -EINVAL;
> +		if (nr_args != 1)
> +			break;
> +		ret = io_ringfd_unregister(ctx, arg);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 649a4d7c241b..5ddea83912c7 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -9,11 +9,14 @@
>   struct sock *io_uring_get_socket(struct file *file);
>   void __io_uring_cancel(bool cancel_all);
>   void __io_uring_free(struct task_struct *tsk);
> +void io_uring_unreg_ringfd(struct io_uring_task *tctx);
>   
>   static inline void io_uring_files_cancel(void)
>   {
> -	if (current->io_uring)
> +	if (current->io_uring) {
> +		io_uring_unreg_ringfd(current->io_uring);
>   		__io_uring_cancel(false);
> +	}
>   }
>   static inline void io_uring_task_cancel(void)
>   {
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 787f491f0d2a..f076a203317a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -261,6 +261,7 @@ struct io_cqring_offsets {
>   #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
>   #define IORING_ENTER_SQ_WAIT	(1U << 2)
>   #define IORING_ENTER_EXT_ARG	(1U << 3)
> +#define IORING_ENTER_FIXED_FILE	(1U << 4)
>   
>   /*
>    * Passed in for io_uring_setup(2). Copied back with updated info on success
> @@ -325,6 +326,9 @@ enum {
>   	/* set/get max number of io-wq workers */
>   	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
>   
> +	IORING_REGISTER_IORINGFD		= 20,
> +	IORING_UNREGISTER_IORINGFD		= 21,
> +
>   	/* this goes last */
>   	IORING_REGISTER_LAST
>   };
> @@ -422,4 +426,9 @@ struct io_uring_getevents_arg {
>   	__u64	ts;
>   };
>   
> +struct io_uring_fd_reg {
> +	__u32	offset;
> +	__s32	fd;
> +};
> +
>   #endif
