Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C072E0442
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 03:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgLVCLj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 21:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLVCLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 21:11:39 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B0AC0613D3;
        Mon, 21 Dec 2020 18:10:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id q4so6621257plr.7;
        Mon, 21 Dec 2020 18:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FnuJh32XFVzCBtjJsd69Wal/1kF9mCCotS7zGoIN7ok=;
        b=N9ghEEVKHllFEe1CMmaby1iettrwekp0TafKAcgMhCEwU//30jJq/WXdDU1fkb+v4u
         Sm03GJzhSZgsr/7oqXdhVa7XOtP3cddsDuiVa33XbhvLc2xORCNFLQYR2m8A2cj9m++G
         Ipku3OFeNrhBwfl/H91UeXmTxY5GfRI8O2EldtrrdhzYqVvilDnNsnyuI055IZM/BodE
         EQ2U/tSpn5S9i5eo5pdzf5NeTgzB/HNS6guypjy7yDylpIOh8dYNWtKM7bliuVVFVGJt
         HvpgiEdwQHb2s09CZhK6lQgbNRpIGqLBm5/iBF+UCSbG4gLtg/s7GZjOa8JsXLcyuTLb
         t7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FnuJh32XFVzCBtjJsd69Wal/1kF9mCCotS7zGoIN7ok=;
        b=ugkb/f/BDHXACkQmyySP8a3t40pIF1ypitDHekQEvA7KnyYoRVtRr+aDV1capArXuH
         aC+9W5pauHctJS5p+Zs8wGiD2wGCYsGQBiET2HwN9Gz6vh+u02A5gPdZxN/TBEq3Hyol
         6tuTprmdz0Pv1yCjReJ6yWFrcW+kcLExQ1Bo6tpoG3efN9y1FgeyewZv6PZbvTgzogj7
         sHOXz8AkCkCPWHKrlPfPhezWUy0dbSP5abJ4gBd1RMjxbvSrJbgxa/e3IaWaBGvKRldE
         /MCvYkQtAbKCUFyB9V++FvJUXt8IcbiOBW0Qbjkp0QAw/Zfi7pyrtQTESpnWVOE48rQR
         pnOw==
X-Gm-Message-State: AOAM532Mp+KWjTS2NolIJV87smivhuTUUIR5zwIOe7J634UmkBPXqmmu
        MSxL2HMrUpJPdmXRre8h3/t4RC/MLxeeiry7
X-Google-Smtp-Source: ABdhPJwVZ7qyxc6Fy+VsDmXTzyQkrA98vbthOxfIYjkAC7ijO0mw8AbpFH9MMnBoJOoTIPmAalCvcQ==
X-Received: by 2002:a17:902:8503:b029:dc:44f:62d8 with SMTP id bj3-20020a1709028503b02900dc044f62d8mr18757093plb.34.1608603058647;
        Mon, 21 Dec 2020 18:10:58 -0800 (PST)
Received: from gmail.com (c-73-241-149-213.hsd1.ca.comcast.net. [73.241.149.213])
        by smtp.gmail.com with ESMTPSA id u1sm16660566pjr.51.2020.12.21.18.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 18:10:58 -0800 (PST)
Date:   Mon, 21 Dec 2020 21:10:43 -0500
From:   Noah Goldstein <goldstein.w.n@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     noah <goldstein.n@wustl.edu>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: io_uring.c: Add skip option for __io_sqe_files_update
Message-ID: <20201222021043.GA139782@gmail.com>
References: <20201220065025.116516-1-goldstein.w.n@gmail.com>
 <0cdf2aac-6364-742d-debb-cfd58b4c6f2b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cdf2aac-6364-742d-debb-cfd58b4c6f2b@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Dec 20, 2020 at 03:18:05PM +0000, Pavel Begunkov wrote:
> On 20/12/2020 06:50, noah wrote:> From: noah <goldstein.n@wustl.edu>
> > 
> > This patch makes it so that specify a file descriptor value of -2 will
> > skip updating the corresponding fixed file index.
> > 
> > This will allow for users to reduce the number of syscalls necessary
> > to update a sparse file range when using the fixed file option.
> 
> Answering the github thread -- it's indeed a simple change, I had it the
> same day you posted the issue. See below it's a bit cleaner. However, I
> want to first review "io_uring: buffer registration enhancements", and
> if it's good, for easier merging/etc I'd rather prefer to let it go
> first (even if partially).
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 941fe9b64fd9..b3ae9d5da17e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7847,9 +7847,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  	if (IS_ERR(ref_node))
>  		return PTR_ERR(ref_node);
>  
> -	done = 0;
>  	fds = u64_to_user_ptr(up->fds);
> -	while (nr_args) {
> +	for (done = 0; done < nr_args; done++) {
>  		struct fixed_file_table *table;
>  		unsigned index;
>  
> @@ -7858,7 +7857,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  			err = -EFAULT;
>  			break;
>  		}
> -		i = array_index_nospec(up->offset, ctx->nr_user_files);
> +		if (fd == IORING_REGISTER_FILES_SKIP)
> +			continue;
> +
> +		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
>  		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>  		index = i & IORING_FILE_TABLE_MASK;
>  		if (table->files[index]) {
> @@ -7896,9 +7898,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				break;
>  			}
>  		}
> -		nr_args--;
> -		done++;
> -		up->offset++;
>  	}
>  
>  	if (needs_switch) {
> 
> -- 
> Pavel Begunkov
Ah. Got it.
