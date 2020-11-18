Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB62B8571
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 21:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgKRUUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 15:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKRUUi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 15:20:38 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED0C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 12:20:38 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 10so4285121wml.2
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 12:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PlhF07bA5giHbkB1sOwALjrL/WQzdEmpoAbbCL0l3/c=;
        b=R5nqDW6tpdYUjJdBlI9m1RNXT1tMKWzR2JbBdTCQhL5jDmSigpYPs5gXI1hqAdxiAW
         VX9RmG9ZMfYIT36TXNu78OW1OT0K4PN2qBuQF8DgyHf19i9rPmZP43gBkG+wiR95vQmh
         zf/YjwW5D23IKhS0LTH7/TE6liQij0QGOjCCCi84PVFeifjWY99Et6wbKsPmcSifWzRn
         900JetDWI7SLN9m2hcGZ7PtS5lQ7vDRbxwWmRqUbMmul+BOcI2xIs6Z510n1EnujADHG
         wahNybwvn3og0BVqV8n2mFvACZkmLD+66eYnuDJfiopYaMhDWG5DSM+9A/y1l/Wln1Mh
         I4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PlhF07bA5giHbkB1sOwALjrL/WQzdEmpoAbbCL0l3/c=;
        b=IZhTwiGd05L5qkShHs4WuMCfLrIkUdPHLnTBdov4nHEoGLYZMLJzvrGFw85AD9jeAP
         An37d9mPdqsEE6R4VuQN9+j3jrZRaGNuu+4gev2y1ZmEgfmNRi1w67DFfUn51LaD0t7t
         76VKlSo/T5dslBSy0hKvAI7l1YM2HumOU8Bbkeln18e4V3sncmA9IZVJcBb95IsJAYZ8
         6xZ7DQGWLglf+Z5R4Wr7/rNW0qz9y96lIlMFWws4rTQ/TJAPnAx70OqyIhY117wEtSCB
         /91PJ1H4fsm1Xk9Y4lKjc8LtAo2FAVnbeVRc9SS84g8hTI5FHgpoZaI60nY2jcZNZh5H
         oMqQ==
X-Gm-Message-State: AOAM5339r86o4z6dgGHt3s7ngRYJJILgL68i2UJX/gp4bEMCN4KjoeYZ
        GD9yZ+xN5V9VuyCJuRADCjHhfPAXV0xhNg==
X-Google-Smtp-Source: ABdhPJx4RrAwTLrje3A+BBFHGIiPKNaYH16PGPS/0MWZdB2pOX8p3AYnJJJMrRVux02xDrh9NZ1d0A==
X-Received: by 2002:a1c:a548:: with SMTP id o69mr819511wme.23.1605730836376;
        Wed, 18 Nov 2020 12:20:36 -0800 (PST)
Received: from [192.168.1.144] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id t15sm5159382wmn.19.2020.11.18.12.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 12:20:35 -0800 (PST)
Subject: Re: [PATCH 6/8] io_uring: support buffer registration updates
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-7-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7d9e5065-0cad-2ef1-be6b-0067116c67bf@gmail.com>
Date:   Wed, 18 Nov 2020 20:17:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1605222042-44558-7-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/11/2020 23:00, Bijan Mottahedeh wrote:
> Introduce IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE,
> consistent with file registration update.

I'd prefer to not add a new opcode for each new resource. Can we have
only IORING_OP_RESOURCE_UPDATE and multiplex inside? Even better if you
could fit all into IORING_OP_FILES_UPDATE and then

#define IORING_OP_RESOURCE_UPDATE IORING_OP_FILES_UPDATE

Jens, what do you think?

> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c                 | 139 +++++++++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/io_uring.h |   8 +--
>  2 files changed, 140 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 71f6d5c..6020fd2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1006,6 +1006,9 @@ struct io_op_def {
>  		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
>  						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
>  	},
> +	[IORING_OP_BUFFERS_UPDATE] = {
> +		.work_flags		= IO_WQ_WORK_MM,
> +	},
>  };
>  
>  enum io_mem_account {
> @@ -1025,6 +1028,9 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_rsrc_update *ip,
>  				 unsigned nr_args);
> +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
> +				   struct io_uring_rsrc_update *up,
> +				   unsigned nr_args);
>  static void __io_clean_op(struct io_kiocb *req);
>  static struct file *io_file_get(struct io_submit_state *state,
>  				struct io_kiocb *req, int fd, bool fixed);
> @@ -5939,6 +5945,19 @@ static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
>  	percpu_ref_exit(&ref_node->refs);
>  	kfree(ref_node);
>  }
> +
> +static int io_buffers_update_prep(struct io_kiocb *req,
> +				  const struct io_uring_sqe *sqe)
> +{
> +	return io_rsrc_update_prep(req, sqe);
> +}
> +
> +static int io_buffers_update(struct io_kiocb *req, bool force_nonblock,
> +			     struct io_comp_state *cs)
> +{
> +	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_buffers_update);
> +}
> +
>  static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	switch (req->opcode) {
> @@ -6010,11 +6029,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_renameat_prep(req, sqe);
>  	case IORING_OP_UNLINKAT:
>  		return io_unlinkat_prep(req, sqe);
> +	case IORING_OP_BUFFERS_UPDATE:
> +		return io_buffers_update_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
>  			req->opcode);
> -	return-EINVAL;
> +	return -EINVAL;
>  }
>  
>  static int io_req_defer_prep(struct io_kiocb *req,
> @@ -6268,6 +6289,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
>  	case IORING_OP_UNLINKAT:
>  		ret = io_unlinkat(req, force_nonblock);
>  		break;
> +	case IORING_OP_BUFFERS_UPDATE:
> +		ret = io_buffers_update(req, force_nonblock, cs);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -8224,6 +8248,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
>  	if (imu->acct_pages)
>  		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
>  	kvfree(imu->bvec);
> +	imu->bvec = NULL;
>  	imu->nr_bvecs = 0;
>  }
>  
> @@ -8441,6 +8466,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>  		if (pret > 0)
>  			unpin_user_pages(pages, pret);
>  		kvfree(imu->bvec);
> +		imu->bvec = NULL;
>  		goto done;
>  	}
>  
> @@ -8602,6 +8628,8 @@ static void io_buf_data_ref_zero(struct percpu_ref *ref)
>  static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
>  {
>  	io_buffer_unmap(ctx, prsrc->buf);
> +	kvfree(prsrc->buf);
> +	prsrc->buf = NULL;
>  }
>  
>  static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
> @@ -8684,6 +8712,111 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  	return 0;
>  }
>  
> +static inline int io_queue_buffer_removal(struct fixed_rsrc_data *data,
> +					  struct io_mapped_ubuf *imu)
> +{
> +	return io_queue_rsrc_removal(data, (void *)imu);
> +}
> +
> +static void destroy_fixed_buf_ref_node(struct fixed_rsrc_ref_node *ref_node)
> +{
> +	destroy_fixed_rsrc_ref_node(ref_node);
> +}
> +
> +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
> +				   struct io_uring_rsrc_update *up,
> +				   unsigned nr_args)
> +{
> +	struct fixed_rsrc_data *data = ctx->buf_data;
> +	struct fixed_rsrc_ref_node *ref_node;
> +	struct io_mapped_ubuf *imu;
> +	struct iovec iov;
> +	struct iovec __user *iovs;
> +	struct page *last_hpage = NULL;
> +	__u32 done;
> +	int i, err;
> +	bool needs_switch = false;
> +
> +	if (check_add_overflow(up->offset, nr_args, &done))
> +		return -EOVERFLOW;
> +	if (done > ctx->nr_user_bufs)
> +		return -EINVAL;
> +
> +	ref_node = alloc_fixed_buf_ref_node(ctx);
> +	if (IS_ERR(ref_node))
> +		return PTR_ERR(ref_node);
> +
> +	done = 0;
> +	iovs = u64_to_user_ptr(up->iovs);
> +	while (nr_args) {
> +		struct fixed_rsrc_table *table;
> +		unsigned index;
> +
> +		err = 0;
> +		if (copy_from_user(&iov, &iovs[done], sizeof(iov))) {
> +			err = -EFAULT;
> +			break;
> +		}
> +		i = array_index_nospec(up->offset, ctx->nr_user_bufs);
> +		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
> +		index = i & IORING_BUF_TABLE_MASK;
> +		imu = &table->bufs[index];
> +		if (table->bufs[index].ubuf) {
> +			struct io_mapped_ubuf *dup;
> +			dup = kmemdup(imu, sizeof(*imu), GFP_KERNEL);
> +			if (!dup) {
> +				err = -ENOMEM;
> +				break;
> +			}
> +			err = io_queue_buffer_removal(data, dup);
> +			if (err)
> +				break;
> +			memset(imu, 0, sizeof(*imu));
> +			needs_switch = true;
> +		}
> +		if (!io_buffer_validate(&iov)) {
> +			err = io_sqe_buffer_register(ctx, &iov, imu,
> +						     &last_hpage);
> +			if (err) {
> +				memset(imu, 0, sizeof(*imu));
> +				break;
> +			}
> +		}
> +		nr_args--;
> +		done++;
> +		up->offset++;
> +	}
> +
> +	if (needs_switch) {
> +		percpu_ref_kill(&data->node->refs);
> +		spin_lock(&data->lock);
> +		list_add(&ref_node->node, &data->ref_list);
> +		data->node = ref_node;
> +		spin_unlock(&data->lock);
> +		percpu_ref_get(&ctx->buf_data->refs);
> +	} else
> +		destroy_fixed_buf_ref_node(ref_node);
> +
> +	return done ? done : err;
> +}
> +
> +static int io_sqe_buffers_update(struct io_ring_ctx *ctx, void __user *arg,
> +				 unsigned nr_args)
> +{
> +	struct io_uring_rsrc_update up;
> +
> +	if (!ctx->buf_data)
> +		return -ENXIO;
> +	if (!nr_args)
> +		return -EINVAL;
> +	if (copy_from_user(&up, arg, sizeof(up)))
> +		return -EFAULT;
> +	if (up.resv)
> +		return -EINVAL;
> +
> +	return __io_sqe_buffers_update(ctx, &up, nr_args);
> +}
> +
>  static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
>  {
>  	__s32 __user *fds = arg;
> @@ -9961,6 +10094,7 @@ static bool io_register_op_must_quiesce(int op)
>  	switch (op) {
>  	case IORING_UNREGISTER_FILES:
>  	case IORING_REGISTER_FILES_UPDATE:
> +	case IORING_REGISTER_BUFFERS_UPDATE:
>  	case IORING_REGISTER_PROBE:
>  	case IORING_REGISTER_PERSONALITY:
>  	case IORING_UNREGISTER_PERSONALITY:
> @@ -10036,6 +10170,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_sqe_buffers_unregister(ctx);
>  		break;
> +	case IORING_REGISTER_BUFFERS_UPDATE:
> +		ret = io_sqe_buffers_update(ctx, arg, nr_args);
> +		break;
>  	case IORING_REGISTER_FILES:
>  		ret = io_sqe_files_register(ctx, arg, nr_args);
>  		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 87f0f56..17682b5 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -137,6 +137,7 @@ enum {
>  	IORING_OP_SHUTDOWN,
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
> +	IORING_OP_BUFFERS_UPDATE,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> @@ -279,17 +280,12 @@ enum {
>  	IORING_UNREGISTER_PERSONALITY		= 10,
>  	IORING_REGISTER_RESTRICTIONS		= 11,
>  	IORING_REGISTER_ENABLE_RINGS		= 12,
> +	IORING_REGISTER_BUFFERS_UPDATE		= 13,
>  
>  	/* this goes last */
>  	IORING_REGISTER_LAST
>  };
>  
> -struct io_uring_files_update {
> -	__u32 offset;
> -	__u32 resv;
> -	__aligned_u64 /* __s32 * */ fds;
> -};
> -
>  struct io_uring_rsrc_update {
>  	__u32 offset;
>  	__u32 resv;
> 

-- 
Pavel Begunkov
