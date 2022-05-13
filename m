Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301C6525AE2
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 06:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbiEMEhu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 00:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiEMEht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 00:37:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F72B56C00
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 21:37:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 137so6452810pgb.5
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 21:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=Dxyh9MW1a4DrJTQvJJSD2jbmaQ7eNI13jy2jYSGmZqI=;
        b=QNrnsIQbX0weIh6A4aTOx+QWnVTRecR/NKQ8u0955CmR0rZtSawM+V/DO/4IEUzeV0
         fkYv8Bu8uzbFP1pMoKhZgxLALvCusktYcFdy6Yv/qQIL2WwNreewoVNZvQntBwWNRBLs
         SdyQ/nNPKYDNHhG7hus7o0taVqAdbuCP1e5YGShQeER6ZxCyoyyxhHNUF6/Gx4Fwwmk5
         OAOMM1l94lvZcH/B/Z0JDZMIZzIL15LiZLoYFpvF197cWhPRHa7tw7impRGp06wSW5st
         K20jkeDXvWh9n94rHKmc3STIIa9xIxopO7jj2g5GJC6xQ1TxtHt2OuTwmL7rymzX9BtB
         qUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Dxyh9MW1a4DrJTQvJJSD2jbmaQ7eNI13jy2jYSGmZqI=;
        b=CezA3UDV/PXLDd56mt61i1uO9WqHQ/hj74/WQKP492Li8H/nxvo4v0/aLEPI1gUBdN
         ZaCZKD0iUrHRImtdjVpMCs5fUUpsCmKGtXzjskhj0g6mBdTCg0QLbGgofaiPHs9EBMit
         xOwNMJbQEgJpsR6DDO3WslV6XUVcniLxk2v6bWbsJUOCf0ZiAGrpPNLw/PCZ8otgYAOa
         SWjKhoQvm+5B8ss9lrJ5qdtFnZ20tNcMLLcNvST4CENgY+b7NiJi0zZzG8ZfoXRaTjG6
         UNlwzBp+tg8j4sVb0i3TVSZnaChIG/5634TzJT7vURWVHyJE1n6IsSW/kFeDJLuJx6NS
         3u5w==
X-Gm-Message-State: AOAM531IIls0OtoryXzwcA+v/MHxtASF1mO/wdWdOsj1etZWoZWguEKq
        yvPtQVUPOu5115Pi8onK7GfFkQBW22w=
X-Google-Smtp-Source: ABdhPJxFvO7XnNNvo/tQ7OJFQtC2kaXzS7LwAvQw2aeP9CQDanCZjZZEpMYeT2fvMKAHOVgT96Fazw==
X-Received: by 2002:a63:220e:0:b0:3c6:d818:19ff with SMTP id i14-20020a63220e000000b003c6d81819ffmr2393224pgi.486.1652416666925;
        Thu, 12 May 2022 21:37:46 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902e80700b0015e8d4eb207sm761945plg.81.2022.05.12.21.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 21:37:46 -0700 (PDT)
Message-ID: <d9a5da57-ae34-b137-3ef8-fe6d6b16359a@gmail.com>
Date:   Fri, 13 May 2022 12:38:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
From:   Hao Xu <haoxu.linux@gmail.com>
Subject: Re: [PATCH 3/6] io_uring: allow allocated fixed files for
 openat/openat2
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-4-axboe@kernel.dk>
In-Reply-To: <20220509155055.72735-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 下午11:50, Jens Axboe 写道:
> If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
> then that's a hint to allocate a fixed file descriptor rather than have
> one be passed in directly.
> 
> This can be useful for having io_uring manage the direct descriptor space.
> 
> Normal open direct requests will complete with 0 for success, and < 0
> in case of error. If io_uring is asked to allocated the direct descriptor,
> then the direct descriptor is returned in case of success.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 32 +++++++++++++++++++++++++++++---
>   include/uapi/linux/io_uring.h |  9 +++++++++
>   2 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8c40411a7e78..ef999d0e09de 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4697,7 +4697,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	return __io_openat_prep(req, sqe);
>   }
>   
> -static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
> +static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>   {
>   	struct io_file_table *table = &ctx->file_table;
>   	unsigned long nr = ctx->nr_user_files;
> @@ -4722,6 +4722,32 @@ static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
>   	return -ENFILE;
>   }
>   
> +static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
> +			       struct file *file, unsigned int file_slot)
> +{
> +	int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int ret;
> +
> +	if (alloc_slot) {
> +		io_ring_submit_lock(ctx, issue_flags);
> +		file_slot = io_file_bitmap_get(ctx);
> +		if (unlikely(file_slot < 0)) {
> +			io_ring_submit_unlock(ctx, issue_flags);
> +			return file_slot;
> +		}
> +	}
> +
> +	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
> +	if (alloc_slot) {
> +		io_ring_submit_unlock(ctx, issue_flags);
> +		if (!ret)
> +			return file_slot;

Sorry, I missed onething, looks like this should be file_slot+1, as this
is returned to the userspace. I refer to the previous open/accept direct
feature, they see the file_index from userspace as number counted from
one, so it'd better to keep it consistent.

Regards,
Hao

> +	}
> +
> +	return ret;
> +}
> +
>   static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct open_flags op;
> @@ -4777,8 +4803,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
>   	if (!fixed)
>   		fd_install(ret, file);
>   	else
> -		ret = io_install_fixed_file(req, file, issue_flags,
> -					    req->open.file_slot - 1);
> +		ret = io_fixed_fd_install(req, issue_flags, file,
> +						req->open.file_slot);
>   err:
>   	putname(req->open.filename);
>   	req->flags &= ~REQ_F_NEED_CLEANUP;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 06621a278cb6..b7f02a55032a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -63,6 +63,15 @@ struct io_uring_sqe {
>   	__u64	__pad2[2];
>   };
>   
> +/*
> + * If sqe->file_index is set to this for opcodes that instantiate a new
> + * direct descriptor (like openat/openat2/accept), then io_uring will allocate
> + * an available direct descriptor instead of having the application pass one
> + * in. The picked direct descriptor will be returned in cqe->res, or -ENFILE
> + * if the space is full.
> + */
> +#define IORING_FILE_INDEX_ALLOC		(~0U)
> +
>   enum {
>   	IOSQE_FIXED_FILE_BIT,
>   	IOSQE_IO_DRAIN_BIT,

