Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19455333FBD
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 14:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhCJN4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 08:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhCJN4n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 08:56:43 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E98C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=cVso1WlCNppsFMjN3mmjiU84pQGbVJPCDnM0jE/ZTu0=; b=N4PYyZ+u0ge97I36kVP4srGEVE
        m7+4h1t+6Cytc69zmKJpB/aeenfMYtlzuSP/PST+no0D3OIwQsdA4DEfJJMxt64/9T0efI66HeFnB
        DAh4ztNhHPBM1IT8JILfIJtwH7FREo73rrpdlvCLgTs+sHpDekhc9ooABbYIKYa+M4p/5r1OZLg6I
        WDt9SEN0vExGMBJKsG+BCqu/e9sdAqktL3AZThjGTzA3X9eAOAi5/VDit58yF8wBaaOkD3fZWlTB8
        oKIaNynGhM9IMEaRRugJnCLJWblZ0bmpg0FYLL+sFNnkZ0TRdKEQ0mK8tJKqXWKFJZeFgYwKXRNcO
        uXyRCfOxFvGvCB6FdL9N598x5DKTJaQu0tNmgrek5O/HasMP35/mTvkQW+4bGDjZINg76ndZRo+J1
        LP48e0R7lbQ40a1C2XwnfrTKr0oqcEHNKzwPlUP13w7Mk0BKwLrbefOHAvNkriqofDMLBZq0I5XWy
        pMwCtFlQRnQE3SQ0V8/vK7j8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lJzKH-0008Dh-EM; Wed, 10 Mar 2021 13:56:37 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 1/3] io_uring: fix invalid ctx->sq_thread_idle
Message-ID: <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
Date:   Wed, 10 Mar 2021 14:56:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Pavel,

> We have to set ctx->sq_thread_idle before adding a ring to an SQ task,
> otherwise sqd races for seeing zero and accounting it as such.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 896a7845447c..0b39c3818809 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7827,14 +7827,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>  
>  		ctx->sq_creds = get_current_cred();
>  		ctx->sq_data = sqd;
> -		io_sq_thread_park(sqd);
> -		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
> -		io_sq_thread_unpark(sqd);
> -
>  		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
>  		if (!ctx->sq_thread_idle)
>  			ctx->sq_thread_idle = HZ;
>  
> +		io_sq_thread_park(sqd);
> +		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
> +		io_sq_thread_unpark(sqd);

I wondered about the exact same change this morning, while researching
the IORING_SETUP_ATTACH_WQ behavior :-)

It still seems to me that IORING_SETUP_ATTACH_WQ changed over time.
As you introduced that flag, can you summaries it's behavior (and changes)
over time (over the releases).

I'm wondering if ctx->sq_creds is really the only thing we need to take care of.

Do we know about existing users of IORING_SETUP_ATTACH_WQ and their use case?
As mm, files and other things may differ now between sqe producer and the sq_thread.

metze
