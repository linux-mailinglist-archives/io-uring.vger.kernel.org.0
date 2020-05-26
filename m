Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67281E30FA
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 23:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbgEZVMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 17:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388900AbgEZVMm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 17:12:42 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40041C061A0F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 14:12:42 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q9so369733pjm.2
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 14:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DIjlqd7+ltT/VOo3qWLLL2yl8xUSZyt62HR1XnVOGe0=;
        b=miLT4zzHT9BmdEDXDNwlR7MjRt0D6x8EaNYkPdepyxU38LWHQ10wE+89p3zmXdgoZu
         nwR3X/jiNzjQDA5lzmiDa7RTihenuFMt0Jy0fowrJW7j/ftgxRMKCOEo2w360CcdDB/w
         jaMmooR3jDkPe4NxBiGbUVO0o/yhMe5FIj3oRgXRO2yVQbKhqTll/Otik5eZr7op9SlC
         OH+Mdz7s5siLZxRJJdkWUmp2yHgu/POHZT45clNrujp4DuCUIxdKiMfErqtGow/jlA44
         QdMYwWqqz0cK7TOKAIX3Ri47OzycfZiW8rcITKZQd2cLVj+LQu6PQv66ETyqxRwHOgAf
         JwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DIjlqd7+ltT/VOo3qWLLL2yl8xUSZyt62HR1XnVOGe0=;
        b=GBV0UohFf8MecFIvLkmCAjqSYgc/M7t5q70v9o1RtOSSsq1mii4GxuW58QH32xVikX
         3YEuGl5j/3iZ/Wab6hbLmrpw+XKXCNpWMD3fT6zMHnrVUsQ1/OSDBFa/d0hM9SHYJFaF
         7qbxz40XmjnDaTw1LpjrQ/1aZeBi7MovpMcxydFx8nUy5WVt1P9LvM3CKFBJ3Hz7H8Pq
         gcdKE9Opxd1dYPTmtYZMDe1zKSFa7AhsjO9tFsIsi9v/R19tKITZYTxVqvoQha2iTn4i
         X33EIvz970lKMDqbVR14JTUmW1PnCzAYGK8KsOI0ct0TSYEyV9A0WU/AMwPTRdhi+B18
         PpQg==
X-Gm-Message-State: AOAM532PmxjYAAuj8XouGuwqG9sUNeBJKfKnJDWb9kOtuMKppy/roC2I
        enUcB/GGF0HErd2UtoTuQovY/w==
X-Google-Smtp-Source: ABdhPJyVgqdLBEB21Q5W6yFtM2ALexWvWnhvDfpAPCYI69WUyV3fmGF/dVQZjpZ6gyYyqAI3F4mHhg==
X-Received: by 2002:a17:902:bb96:: with SMTP id m22mr2912672pls.222.1590527561499;
        Tue, 26 May 2020 14:12:41 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:94bb:59d2:caf6:70e1? ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id q193sm378582pfq.158.2020.05.26.14.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 14:12:40 -0700 (PDT)
Subject: Re: [RFC] .flush and io_uring_cancel_files
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jann Horn <jannh@google.com>
References: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1ae26b1b-b2e7-9440-d16e-75f4c528a9c7@kernel.dk>
Date:   Tue, 26 May 2020 15:12:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/20 12:09 PM, Pavel Begunkov wrote:
> It looks like taking ->uring_lock should work like kind of grace
> period for struct files_struct and io_uring_flush(), and that would
> solve the race with "fcheck(ctx->ring_fd) == ctx->ring_file".
> 
> Can you take a look? If you like it, I'll send a proper patch
> and a bunch of cleanups on top.

Adding Jann.

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a3dbd5f40391..012af200dc72 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5557,12 +5557,11 @@ static int io_grab_files(struct io_kiocb *req)
>  	 * the fd has changed since we started down this path, and disallow
>  	 * this operation if it has.
>  	 */
> -	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
> -		list_add(&req->inflight_entry, &ctx->inflight_list);
> -		req->flags |= REQ_F_INFLIGHT;
> -		req->work.files = current->files;
> -		ret = 0;
> -	}
> +	list_add(&req->inflight_entry, &ctx->inflight_list);
> +	req->flags |= REQ_F_INFLIGHT;
> +	req->work.files = current->files;
> +	ret = 0;
> +
>  	spin_unlock_irq(&ctx->inflight_lock);
>  	rcu_read_unlock();
> 
> @@ -7479,6 +7478,10 @@ static int io_uring_release(struct inode *inode, struct
> file *file)
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				  struct files_struct *files)
>  {
> +	/* wait all submitters that can race for @files */
> +	mutex_lock(&ctx->uring_lock);
> +	mutex_unlock(&ctx->uring_lock);
> +
>  	while (!list_empty_careful(&ctx->inflight_list)) {
>  		struct io_kiocb *cancel_req = NULL, *req;
>  		DEFINE_WAIT(wait);
> 


-- 
Jens Axboe

