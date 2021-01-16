Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9152F8EAA
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbhAPSYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 13:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbhAPSYU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 13:24:20 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14579C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:23:40 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c124so10075781wma.5
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YtgwC47kx1X29GokbUsdjmBSf8XMrc2mfFX0CbL1k3g=;
        b=fUhfkNmffxzNMIWaeUBZ4gA7cD9OkryE7xBLD21jWkNnoCd253IaQOxDTbmWDzbrmZ
         K4Uh7zRIC/Cotg9t2VM8yMN2vkyC5p8gKWQHr0qQgpBUDXZp2hfFOUgKDU8uCwwIjjJ+
         Qo8SMWDkufwDf6+l2kO/YG3QCIydyF2VG1KsvY6pIaODH9ayutSBB5cp7hlr8GySyWle
         3MeMGE6I8XxNpAVHl7H+wFsSEHFvQugy4cnZzwo5I27LbzbFD2af7BkDZKW2BwXK8kP2
         edEcFLKmV34uV5/ZCd/OEGemJjJGMBb7Aa4kALp1A32gCR2KCFwW6Z6O4qo+xNuaam1T
         8PFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YtgwC47kx1X29GokbUsdjmBSf8XMrc2mfFX0CbL1k3g=;
        b=G2OcrMbBJZqzFXQc9GTPjuQTMWuTdzVNd2F+4FngF+meIM6W0Cub3tBhjLvOUcz/VJ
         fItyhrzUtQs2odBaa/+U99Fru2L4dDVbNZ2UxLcUW2qXXE2X0Kd0bDow3jozo4j1FDu6
         cHBjbWsgLJTvCT4N69K7/dB/8CoQ22X6yaHRF7yJwnPlvUFEtbn4m6/MZCZ8y/7PN8Re
         v4Y4Tb0A30QDQ8m5emkUdiTcdizsEIqnLxqXwFGpTdfVP8CIzq1nyg6LS3CpXOzK1j8g
         VB4w6clgS+7oPhMvjknN4sZhse67UvTr3vLWXOreOOpS+8MMsi0EoL16yJDF1JX4TbVF
         5aLg==
X-Gm-Message-State: AOAM533OHL/jDhsLwmH/EimEoNePhhdvR7s5ysv/0sXCrOfyIHMO1JqO
        hWTRlZbRzztBcAsb47zzdNPBz+uRhcs=
X-Google-Smtp-Source: ABdhPJx6NL0hWDtLJ9alpUun3IZHbRC0YY11IrOoLgUvhV71dt8x2FkOwxaNI4602h352CmTYz71Sg==
X-Received: by 2002:a1c:e2c3:: with SMTP id z186mr13933495wmg.144.1610821418487;
        Sat, 16 Jan 2021 10:23:38 -0800 (PST)
Received: from [192.168.8.126] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id j2sm19970207wrh.78.2021.01.16.10.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 10:23:37 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1610487193-21374-9-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v5 08/13] io_uring: generalize files_update functionlity
 to rsrc_update
Message-ID: <b16df789-b2e5-ae4d-232c-5090f198d68f@gmail.com>
Date:   Sat, 16 Jan 2021 18:20:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1610487193-21374-9-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/01/2021 21:33, Bijan Mottahedeh wrote:
> Generalize files_update functionality to rsrc_update in order to
> leverage it for buffers updates.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c                 | 19 ++++++++++++++-----
>  include/uapi/linux/io_uring.h |  6 +++++-
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6ebfe1f..f9f458c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5954,7 +5954,7 @@ static int io_async_cancel(struct io_kiocb *req)
>  }
>  
>  static int io_rsrc_update_prep(struct io_kiocb *req,
> -				const struct io_uring_sqe *sqe)
> +			       const struct io_uring_sqe *sqe)
>  {
>  	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
>  		return -EINVAL;
> @@ -5971,8 +5971,11 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
>  	return 0;
>  }
>  
> -static int io_files_update(struct io_kiocb *req, bool force_nonblock,
> -			   struct io_comp_state *cs)
> +static int io_rsrc_update(struct io_kiocb *req, bool force_nonblock,
> +			  struct io_comp_state *cs,
> +			  int (*update)(struct io_ring_ctx *ctx,
> +					struct io_uring_rsrc_update *up,
> +					unsigned int nr_args))

I don't like excessive use of higher order functions in C. How about
replacing it with a switch/ifs? e.g.

... /* prepare up */
mutex_lock()
if (req->opcode == FILES_UPDATE)
	update_file(); // the one that was in callback @update arg
else (req->opcode == ...)
	...
mutex_unlock();

>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_uring_rsrc_update up;
> @@ -5982,10 +5985,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
>  		return -EAGAIN;
>  
>  	up.offset = req->rsrc_update.offset;
> -	up.fds = req->rsrc_update.arg;
> +	up.rsrc = req->rsrc_update.arg;
>  
>  	mutex_lock(&ctx->uring_lock);
> -	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
> +	ret = (*update)(ctx, &up, req->rsrc_update.nr_args);
>  	mutex_unlock(&ctx->uring_lock);
>  
>  	if (ret < 0)
> @@ -5994,6 +5997,12 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
>  	return 0;
>  }
>  
> +static int io_files_update(struct io_kiocb *req, bool force_nonblock,
> +			   struct io_comp_state *cs)
> +{
> +	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_files_update);
> +}
> +
>  static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	switch (req->opcode) {
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 77de7c0..f51190b 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -288,7 +288,11 @@ enum {
>  struct io_uring_rsrc_update {
>  	__u32 offset;
>  	__u32 resv;
> -	__aligned_u64 /* __s32 * */ fds;
> +	union {
> +		__aligned_u64 /* __s32 * */ fds;
> +		__aligned_u64 /* __s32 * */ iovs;
> +		__aligned_u64 /* __s32 * */ rsrc;
> +	};
>  };
>  
>  #define io_uring_files_update	io_uring_rsrc_update
> 

-- 
Pavel Begunkov
