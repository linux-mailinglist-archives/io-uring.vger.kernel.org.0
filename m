Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C6616A3B2
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 11:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgBXKQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 05:16:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgBXKQW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 05:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582539381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hPf/yXWC/PiGfjXcPUU3BSfiGE9Nl86MyJqNGBc9zOA=;
        b=iU/kaxq3MevMi2QoUmCxVjqe2su4gF4JkykBe202byy4TCffYhMYH4mbFsNK476l6OCTKC
        OEbLHTu0HBd543GK6upO7I65g1TpsPejVnao9wEwH6EiRkFXShdNJz9jERfSDp+cKKUOZp
        DXkZkli/IBPpkaHfftX2nww36vg2Avg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-6tqKtUBfMbSChFa5EnVjbg-1; Mon, 24 Feb 2020 05:16:18 -0500
X-MC-Unique: 6tqKtUBfMbSChFa5EnVjbg-1
Received: by mail-wm1-f72.google.com with SMTP id p2so2235023wma.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 02:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hPf/yXWC/PiGfjXcPUU3BSfiGE9Nl86MyJqNGBc9zOA=;
        b=bShtnD3QVo4mXBCzKIxLfUhnjyfFTjB28sSg8BpkqvtDsbMQ2sL/3Gpmwdn1eGhNuh
         LZZ3NCoMd2MtkXuSWfK9hiVZoQFO/ZW4SVupyknzkdpcsYh/+L1s1Eqb6j57qD6JCHTc
         wxzt5+8oIvfKHXwHYwIyDnDItuCHf8kkDB3qUPzrWFsDJ6VIWbkaCQbKlb8fmbqiJR78
         z0GT86xyPHQln64xejnD1oNh90Fb6cw50T74yT+CMbhA1Atf21q4SMlgIJU87qsO2Mys
         ANbyX+86sP1QPXcBjYBdrBZQyIS0MCSwALI8meMvoDCfkS3eg0EX7wLTAtMdKyTLInui
         8uaA==
X-Gm-Message-State: APjAAAV/4A2p2pxl0Pbo7bxQOdlnBhtfblJetCRBb2JKdWv/l9NRAd4r
        szTAh/ppqfFPHs/1Xm+e5NIvyV2ta200s+tVy42N/Bs9CwY4bUo3vFbL8hLU8FE2ZFUQhwJK4eD
        LQZ4CSDfMWsy+hwHji0w=
X-Received: by 2002:adf:fd0e:: with SMTP id e14mr65075643wrr.127.1582539377518;
        Mon, 24 Feb 2020 02:16:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzq75ZBbiYJBqXZFf3WHPu0AbaOStO3vsqhakZe5N3S1JHJ0dImuKw60zRTqP8RJRfhpwBzNQ==
X-Received: by 2002:adf:fd0e:: with SMTP id e14mr65075621wrr.127.1582539377250;
        Mon, 24 Feb 2020 02:16:17 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id a5sm17644194wmb.37.2020.02.24.02.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 02:16:16 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:16:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: fix personality idr leak
Message-ID: <20200224101614.rycnfdvcrhthlkct@steredhat>
References: <a77e7987-0b1b-a01a-bd31-264c1179816c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a77e7987-0b1b-a01a-bd31-264c1179816c@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Feb 23, 2020 at 02:17:36PM -0700, Jens Axboe wrote:
> We somehow never free the idr, even though we init it for every ctx.
> Free it when the rest of the ring data is freed.
> 
> Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7d0be264527d..d961945cb332 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6339,6 +6339,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  	io_sqe_buffer_unregister(ctx);
>  	io_sqe_files_unregister(ctx);
>  	io_eventfd_unregister(ctx);
> +	idr_destroy(&ctx->personality_idr);
>  
>  #if defined(CONFIG_UNIX)
>  	if (ctx->ring_sock) {
> 
> -- 
> Jens Axboe
> 

