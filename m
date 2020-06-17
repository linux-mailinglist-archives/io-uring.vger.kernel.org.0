Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3051FD4F8
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 20:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgFQS4t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 14:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgFQS4t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 14:56:49 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A181C06174E;
        Wed, 17 Jun 2020 11:56:48 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y20so3153702wmi.2;
        Wed, 17 Jun 2020 11:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pQFLPjxblqtqlwunvgrNRLdQPDN6AeZa17G9mjHuBxs=;
        b=oudWjma5N5OcnZTmUW6IfUaPbfBBVYMf8QQnWWKMlqubBKnVem+a8OipUlHi0EDYbD
         lKVZoLDSKNorcI8Gk7qHgdDohpc8taOQhoA+y0VMAxfpCcLCPDj+FaKVGUf5PYU3o5yA
         HbySKvRGXchpxRkJGlbmjkenRJ6S+YwuMalukzPgwzazJFEqoN0tgBbFStDInUdlWkgb
         xzqbAYl4jLAmBjQx2sDYbfGzfKz7IW8q/7A3PWa35ZJ4bXGa4BcYbVHyMD9xzNgcBqbv
         +dbdogt9Wa+XCAa9FMnw0FZfiZWtlWbwITB7Aa7LKwnTYgBVSGkkw/RY33yKGWrzl3eQ
         Zybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pQFLPjxblqtqlwunvgrNRLdQPDN6AeZa17G9mjHuBxs=;
        b=n+xbsXZBcZ5SgMllDM4Op+frXyruu2zMO9Jzzo1aVvc7Y21A1Y6hL7zb4UkrtULFUx
         QBqimoosiQ2Nc+yuOfuNdv7Ig8Fz81whUzeBqzmQSxnoarBE8j/674vGw41w4MXla5HS
         +evvtEF85CcHioou/CoWhlh4I9/cn8sVtdO0XdfuZnKOjk3xO8Gz6CguBvO49L8DlRT6
         +eXYFOBhgIp0rD8fPkdQogzG/Q7MN20Wt36QvIHkecOgAXD1PuO5fOuBqpvcxFT5iz/J
         4rDSVG05QlJpiUosM3EA4n67admR3YfKgfnuP/jSdD1fXoeydaUq2hovUOC3dat641Fy
         Gghg==
X-Gm-Message-State: AOAM531bZD431smNYIqVVb36lYmF1c3sk5Oa6q0oI8smjqWVTvAO2aDu
        lFu20np3zg7uyl4gHgtWO7WW/WPC0Oo=
X-Google-Smtp-Source: ABdhPJzDPN180NNTuk446Vv4wNOPDBrn40XptHbOx4tfMjvLspKVp6VGzsUcUbHKUNj5MOu2NZZ0dw==
X-Received: by 2002:a1c:4009:: with SMTP id n9mr177949wma.104.1592420207092;
        Wed, 17 Jun 2020 11:56:47 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id u3sm527635wrw.89.2020.06.17.11.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 11:56:46 -0700 (PDT)
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
 <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Message-ID: <22597d21-affb-da29-9365-d8e3b6bc4e50@gmail.com>
Date:   Wed, 17 Jun 2020 21:55:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/06/2020 20:23, Kanchan Joshi wrote:
> From: Selvakumar S <selvakuma.s1@samsung.com>
> 
> Introduce three new opcodes for zone-append -
> 
>    IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
>    IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>    IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers

I don't like the idea of creating a new set of opcodes for each new flavour.
Did you try to extend write*?

> 
> Repurpose cqe->flags to return zone-relative offset.
> 
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> ---
>  fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  8 ++++-
>  2 files changed, 77 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d8..c14c873 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -649,6 +649,10 @@ struct io_kiocb {
>  	unsigned long		fsize;
>  	u64			user_data;
>  	u32			result;
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	/* zone-relative offset for append, in bytes */
> +	u32			append_offset;
> +#endif

What is this doing here? It's related to append only.
Should be in struct io_rw or whatever.

>  	u32			sequence;
>  
>  	struct list_head	link_list;
> @@ -875,6 +879,26 @@ static const struct io_op_def io_op_defs[] = {
>  		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
> +	[IORING_OP_ZONE_APPEND] = {
> +		.needs_mm               = 1,
> +		.needs_file             = 1,
> +		.unbound_nonreg_file    = 1,
> +		.pollout		= 1,
> +	},
> +	[IORING_OP_ZONE_APPENDV] = {
> +	       .async_ctx              = 1,
> +	       .needs_mm               = 1,
> +	       .needs_file             = 1,
> +	       .hash_reg_file          = 1,
> +	       .unbound_nonreg_file    = 1,
> +	       .pollout			= 1,
> +	},
> +	[IORING_OP_ZONE_APPEND_FIXED] = {
> +	       .needs_file             = 1,
> +	       .hash_reg_file          = 1,
> +	       .unbound_nonreg_file    = 1,
> +	       .pollout			= 1,
> +	},
>  };
>  
>  static void io_wq_submit_work(struct io_wq_work **workptr);
> @@ -1285,7 +1309,16 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>  	if (likely(cqe)) {
>  		WRITE_ONCE(cqe->user_data, req->user_data);
>  		WRITE_ONCE(cqe->res, res);
> +#ifdef CONFIG_BLK_DEV_ZONED
> +		if (req->opcode == IORING_OP_ZONE_APPEND ||
> +				req->opcode == IORING_OP_ZONE_APPENDV ||

Nack, don't create special cases in common path.


> +				req->opcode == IORING_OP_ZONE_APPEND_FIXED)
> +			WRITE_ONCE(cqe->res2, req->append_offset);

Great, a function was asked to return @cflags arg, but it decides to
overwrite the field with its own stuff...

Why not pass it in @cflags?

> +		else
> +			WRITE_ONCE(cqe->flags, cflags);
> +#else
>  		WRITE_ONCE(cqe->flags, cflags);
> +#endif
>  	} else if (ctx->cq_overflow_flushed) {
>  		WRITE_ONCE(ctx->rings->cq_overflow,
>  				atomic_inc_return(&ctx->cached_cq_overflow));
> @@ -1961,6 +1994,9 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
>  static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	req->append_offset = (u32)res2;
> +#endif

Don't create #ifdef hell all over the code. Try to use a function


>  
>  	io_complete_rw_common(kiocb, res);
>  	io_put_req(req);
> @@ -1976,6 +2012,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>  	if (res != req->result)
>  		req_set_fail_links(req);
>  	req->result = res;
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	req->append_offset = (u32)res2;
> +#endif
>  	if (res != -EAGAIN)
>  		WRITE_ONCE(req->iopoll_completed, 1);
>  }
> @@ -2408,7 +2447,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  	u8 opcode;
>  
>  	opcode = req->opcode;
> -	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
> +	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED ||
> +			opcode == IORING_OP_ZONE_APPEND_FIXED) {
>  		*iovec = NULL;
>  		return io_import_fixed(req, rw, iter);
>  	}
> @@ -2417,7 +2457,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  	if (req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT))
>  		return -EINVAL;
>  
> -	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
> +	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE ||
> +			opcode == IORING_OP_ZONE_APPEND) {
>  		if (req->flags & REQ_F_BUFFER_SELECT) {
>  			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
>  			if (IS_ERR(buf)) {
> @@ -2704,6 +2745,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
>  		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
>  
>  	req->result = 0;
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	req->append_offset = 0;
> +#endif
>  	io_size = ret;
>  	if (req->flags & REQ_F_LINK_HEAD)
>  		req->result = io_size;
> @@ -2738,6 +2782,13 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
>  			__sb_writers_release(file_inode(req->file)->i_sb,
>  						SB_FREEZE_WRITE);
>  		}
> +#ifdef CONFIG_BLK_DEV_ZONED
> +		if (req->opcode == IORING_OP_ZONE_APPEND ||
> +				req->opcode == IORING_OP_ZONE_APPENDV ||
> +				req->opcode == IORING_OP_ZONE_APPEND_FIXED)
> +			kiocb->ki_flags |= IOCB_ZONE_APPEND;
> +#endif
> +
>  		kiocb->ki_flags |= IOCB_WRITE;
>  
>  		if (!force_nonblock)
> @@ -4906,6 +4957,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
>  	case IORING_OP_WRITEV:
>  	case IORING_OP_WRITE_FIXED:
>  	case IORING_OP_WRITE:
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	fallthrough;
> +	case IORING_OP_ZONE_APPEND:
> +	case IORING_OP_ZONE_APPENDV:
> +	case IORING_OP_ZONE_APPEND_FIXED:
> +#endif
>  		ret = io_write_prep(req, sqe, true);
>  		break;
>  	case IORING_OP_POLL_ADD:
> @@ -5038,6 +5095,12 @@ static void io_cleanup_req(struct io_kiocb *req)
>  	case IORING_OP_WRITEV:
>  	case IORING_OP_WRITE_FIXED:
>  	case IORING_OP_WRITE:
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	fallthrough;
> +	case IORING_OP_ZONE_APPEND:
> +	case IORING_OP_ZONE_APPENDV:
> +	case IORING_OP_ZONE_APPEND_FIXED:
> +#endif
>  		if (io->rw.iov != io->rw.fast_iov)
>  			kfree(io->rw.iov);
>  		break;
> @@ -5086,6 +5149,11 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		}
>  		ret = io_read(req, force_nonblock);
>  		break;
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	case IORING_OP_ZONE_APPEND:
> +	case IORING_OP_ZONE_APPENDV:
> +	case IORING_OP_ZONE_APPEND_FIXED:
> +#endif
>  	case IORING_OP_WRITEV:
>  	case IORING_OP_WRITE_FIXED:
>  	case IORING_OP_WRITE:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c2269..6c8e932 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -130,6 +130,9 @@ enum {
>  	IORING_OP_PROVIDE_BUFFERS,
>  	IORING_OP_REMOVE_BUFFERS,
>  	IORING_OP_TEE,
> +	IORING_OP_ZONE_APPEND,
> +	IORING_OP_ZONE_APPENDV,
> +	IORING_OP_ZONE_APPEND_FIXED,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> @@ -157,7 +160,10 @@ enum {
>  struct io_uring_cqe {
>  	__u64	user_data;	/* sqe->data submission passed back */
>  	__s32	res;		/* result code for this event */
> -	__u32	flags;
> +	union {
> +		__u32	res2; /* res2 like aio, currently used for zone-append */
> +		__u32	flags;
> +	};
>  };
>  
>  /*
> 

-- 
Pavel Begunkov
