Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAF7520D0C
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 06:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbiEJEr4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 00:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiEJErz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 00:47:55 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5F8293B61
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 21:43:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x23so13952484pff.9
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 21:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=AAUL/u+t3pLrTGdfOe/NmvrwS3L9y7gauFcNAmvJjSc=;
        b=XqIbiigHHG1poOebGqJQBRW13TB9FLsSy8XE/3NJBlIAYhdAFBBgeHeWO3BAHtVsDw
         kASOnHIAqPAYVEj6lxidOWPdVDr/uS3Mn9qFCS+WlgCB1h3qO5qELvOTqKwZ87iRnKIv
         71IsElMhDF/sszpAqCK/eNPoWJv3UEoMvjdLFRTNufYvp8b0fnFp3G8IxH1j9eGLDiNw
         WWv3H5L0ACUAI5A9wAmqQycU+Mh+F6IN8/ZpMRMaDgvqoK5Vr2btcZr6++mOvDXg/AF5
         nWZB2EMXQ6bqkipEySTxOsDmPDlR9vV5cI++BSCrAM8E35sfhFoPupiSTjo85YInJzOE
         GM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AAUL/u+t3pLrTGdfOe/NmvrwS3L9y7gauFcNAmvJjSc=;
        b=kT5pshVhWNRgx5aGTDwogJRIuU/ZodiCVZ4l+x4yhApfBVf2iPxkkbf5Le8dpsSecg
         E6XVG36q9XWVFXaE5nmF33T4hbqjDpE2zMc08WhfZCz5JER2BditZOX16jU+ysdxbgeM
         PhSZvfoBmC+On71+lNP3SGKi+4F/uzkGrid0VAkUukFy9N3pkpdf+dfMd/7taA4ICzOF
         wazxQ7Z6vL/7H7QHO4mN/P8x4Q/f/ViGXHXZ+baQX4wMsyoZv65+z18mt5PpjR4Pex5K
         dJHvZq6N+ZwSL3aAk3uJSWMlIS+AMC/Zdlv17RTKqgN2ILOMGqQpKbfYFR6v6ravWVfe
         HJTQ==
X-Gm-Message-State: AOAM533rTYj/3xrcIpQeq+TdOrG/e4jLqDtBjgdOuNhI9I2u0C1sRlYB
        5CjPA5rzkv91dXbnlzqLR+k=
X-Google-Smtp-Source: ABdhPJwzvs47vczixn/SfeUoR+msxPIUK0hv8oqE7VQv+/YNjcdfchOgMCEZ/72lzfv005/6xTFzyg==
X-Received: by 2002:a63:82c7:0:b0:398:2d6d:848a with SMTP id w190-20020a6382c7000000b003982d6d848amr14313092pgd.343.1652157838603;
        Mon, 09 May 2022 21:43:58 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a788800b001dbe11be891sm630325pjk.44.2022.05.09.21.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 21:43:58 -0700 (PDT)
Message-ID: <7bd84712-bff8-be4f-f4d2-8403678d8495@gmail.com>
Date:   Tue, 10 May 2022 12:44:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 6/6] io_uring: add flag for allocating a fully sparse
 direct descriptor space
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-7-axboe@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <20220509155055.72735-7-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 下午11:50, Jens Axboe 写道:
> Currently to setup a fully sparse descriptor space upfront, the app needs
> to alloate an array of the full size and memset it to -1 and then pass
> that in. Make this a bit easier by allowing a flag that simply does
> this internally rather than needing to copy each slot separately.
> 
> This works with IORING_REGISTER_FILES2 as the flag is set in struct
> io_uring_rsrc_register, and is only allow when the type is
> IORING_RSRC_FILE as this doesn't make sense for registered buffers.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 15 ++++++++++++---
>   include/uapi/linux/io_uring.h |  8 +++++++-
>   2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 644f57a46c5f..fe67fe939fac 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9107,12 +9107,12 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
>   		struct io_fixed_file *file_slot;
>   
> -		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
> +		if (fds && copy_from_user(&fd, &fds[i], sizeof(fd))) {
>   			ret = -EFAULT;
>   			goto fail;
>   		}
>   		/* allow sparse sets */
> -		if (fd == -1) {
> +		if (!fds || fd == -1) {
>   			ret = -EINVAL;
>   			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
>   				goto fail;
> @@ -11755,14 +11755,20 @@ static __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
>   	memset(&rr, 0, sizeof(rr));
>   	if (copy_from_user(&rr, arg, size))
>   		return -EFAULT;
> -	if (!rr.nr || rr.resv || rr.resv2)
> +	if (!rr.nr || rr.resv2)
> +		return -EINVAL;
> +	if (rr.flags & ~IORING_RSRC_REGISTER_SPARSE)
>   		return -EINVAL;
>   
>   	switch (type) {
>   	case IORING_RSRC_FILE:
> +		if (rr.flags & IORING_RSRC_REGISTER_SPARSE && rr.data)
> +			break;
>   		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
>   					     rr.nr, u64_to_user_ptr(rr.tags));
>   	case IORING_RSRC_BUFFER:
> +		if (rr.flags & IORING_RSRC_REGISTER_SPARSE)
> +			break;
>   		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
>   					       rr.nr, u64_to_user_ptr(rr.tags));
>   	}
> @@ -11931,6 +11937,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   		ret = io_sqe_buffers_unregister(ctx);
>   		break;
>   	case IORING_REGISTER_FILES:
> +		ret = -EFAULT;
> +		if (!arg)
> +			break;
>   		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
>   		break;
>   	case IORING_UNREGISTER_FILES:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b7f02a55032a..d09cf7c0d1fe 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -396,9 +396,15 @@ struct io_uring_files_update {
>   	__aligned_u64 /* __s32 * */ fds;
>   };
>   
> +/*
> + * Register a fully sparse file sparse, rather than pass in an array of all

                                     ^space

> + * -1 file descriptors.
> + */
> +#define IORING_RSRC_REGISTER_SPARSE	(1U << 0)
> +
>   struct io_uring_rsrc_register {
>   	__u32 nr;
> -	__u32 resv;
> +	__u32 flags;
>   	__u64 resv2;
>   	__aligned_u64 data;
>   	__aligned_u64 tags;

This looks promising, we may eliminate cqes for open/accept_direct reqs.

feel free to add,
Reviewed-by: Hao Xu <howeyxu@tencent.com>


