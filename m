Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E140B017
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhINOBn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhINOBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:01:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED27C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:00:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 9so20040529edx.11
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wNgM8islrn1/yGFRuU1yw4o6wK7Hjj5bbVrPfWYhwoE=;
        b=iljNlRSdUqledI44qcfZboGcvpaZrpjl/lOl3qB8u00Xl3tLdEBaaskofs3q7ez3ad
         onT9rbtsYFvp0uqBTiixFG6LBwUbokM8ZaTGbjvRvzEfCOtGFQt5yarPeQwgjH3QVVwU
         VmA23J65iTMiz2JqZPJuB4+8Y6DuLO4Ydc06xOYj5syWsSANQPn6jKwvz5HjRGhd65bZ
         T3noQoOcNnfuvR8BpMjBiU88inoyFswCiGeILWx+O3GsGacGDYpxkSEsd+nFbWR/aZzB
         VhulZ7XDISIwWH57Nn9gNHA4/iIAY6/A6+sLyxYHBzI/fCXs+6XIDvKWi1/LkJf8YJWJ
         qOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wNgM8islrn1/yGFRuU1yw4o6wK7Hjj5bbVrPfWYhwoE=;
        b=WN/JN1MA+y9akT2RZzBFNs7Kd2A4rTJ0FfTOHFZqpky5fPTS/mCOATjJYBqkoNLDZY
         l2RxryAkJgVzvJCI/3B8zUHVXlFRzawYEseg1aDtV0u54l3kj9quHUlPmqn1YGic4yTG
         zy4w5anX9Mt+v5CUEETNYSS3dfADyl74iuuqBhu4ErLB4zBZmHy1Y+NIevnmKHQB7ANj
         3yO/8jJjPYHFWilbcJLwABHyvDJcF5WwjURRvnVgbR1FspnzqAq7s7ZiBmwjRfp+mPgY
         I7zk35RA2hLFUDUgZxrMvCjyyrc1D8sQ9F4CqQUVs607gufh4IsrzaYxaOx7doORfJrx
         IC2Q==
X-Gm-Message-State: AOAM53233YcOzEpG9ppO3dIlWY5Yyz9e5MEW4myk70rv6bemUPogOVZq
        iN+8884hJjbLx/CZKhi2hpjBBEIn5Tw=
X-Google-Smtp-Source: ABdhPJyLGpaUYY21v3H9OLsC5ufb2CX+1tkzoONbhK8LmFDSfeR0rN4MdWgFilWqAdi8uMC82DoTXQ==
X-Received: by 2002:a05:6402:40e:: with SMTP id q14mr17685235edv.11.1631628020820;
        Tue, 14 Sep 2021 07:00:20 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id hz15sm4979498ejc.119.2021.09.14.07.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:00:20 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: auto-removal for direct open/accept
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
Message-ID: <5bb07a0f-c7ea-be32-01e8-9610a905c735@gmail.com>
Date:   Tue, 14 Sep 2021 14:59:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 2:37 PM, Pavel Begunkov wrote:
> It might be inconvenient that direct open/accept deviates from the
> update semantics and fails if the slot is taken instead of removing a
> file sitting there. Implement the auto-removal.
> 
> Note that removal might need to allocate and so may fail. However, if an
> empty slot is specified, it's guaraneed to not fail on the fd
> installation side. It's needed for users that can't tolerate spuriously
> closed files, e.g. accepts where the other end doesn't expect it.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 59 +++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 41 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a864a94364c6..29bca3a1ddeb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c

[...]
>  static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>  				 unsigned int issue_flags, u32 slot_index)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool needs_switch = false;
>  	struct io_fixed_file *file_slot;
>  	int ret = -EBADF;
>  
> @@ -8304,12 +8321,31 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>  	ret = -EINVAL;
>  	if (slot_index >= ctx->nr_user_files)
>  		goto err;
> +	/*
> +	 * Ignore error, ->rsrc_backup_node is not needed if the slot is empty,
> +	 * and we'd rather not drop the file.
> +	 */
> +	io_rsrc_node_switch_start(ctx);

Can be made easier, will resend shortly

-- 
Pavel Begunkov
