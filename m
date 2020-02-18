Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4FC162621
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 13:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBRMbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 07:31:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21739 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726415AbgBRMbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 07:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582029102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8SlpuMhxEkNsVu++R0qzZ0u0OpROVAfPhZWy1e0dEb8=;
        b=XL43B7bDMn51gH0CwqITMVmLNiACR49wbQu0qf4d3cFPQtNiTM6fK0dq0iGieNqDi7FtkH
        sR5yLR8VRB/aRzTzWfbPapDmHuqnOsokNX8OvdPkEdwMf8eQBgyV4/i1vlXKnfRfZ4Eh06
        YfTWDzDh4K8D6IItCYAnbpFUGQzy1RU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-d-uIMBF3Ox6fS34_QSVTTg-1; Tue, 18 Feb 2020 07:31:40 -0500
X-MC-Unique: d-uIMBF3Ox6fS34_QSVTTg-1
Received: by mail-wm1-f71.google.com with SMTP id b8so821191wmj.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 04:31:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8SlpuMhxEkNsVu++R0qzZ0u0OpROVAfPhZWy1e0dEb8=;
        b=hpiUjLlCHXhzTv9eBMmRGxmkeMdh4GouIfO62S9iKJ8HjS8k/1zy8vGWDiRi+C7f1h
         3jk2v5M2wuGgqGcINxaWT4TRQw5Ah3e2q7pneahZJ443so2FhNiZmw3BunUK8GXB7s3S
         J55zW9vEkg6orPP23XqqtxugoxzYybKTljWFcqilUSFyHe7M5e5XzsTsiDy5l3xKVCaK
         fxMCaQCuXl4Q2utPFkW2Fr+4aSVLV6VKSAK7m5lvvpGtiohmMrApMYZeU7qcZnBeY/8R
         zpIGL3OQbr9e8iMQFuDbIyLc2lSc5a/rR5R9WHXShVUukVDN3NvTIJQbR4nKVN9bVu6j
         NZIw==
X-Gm-Message-State: APjAAAXV/ad+6idibXlmDyVgk3ZvHIeWtdICFh+o6GbZzPgmBM9D8r31
        47mbzER99ynnPyTFeMPnUee5Dv1y62UcfOZuzsKM3/lIvESOvq2OAO0HlOjSzMDwZCJGmXwM3jv
        Ju9/LvjJrLSNFc6hfQh0=
X-Received: by 2002:a5d:6151:: with SMTP id y17mr28368353wrt.110.1582029098848;
        Tue, 18 Feb 2020 04:31:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqyX7L8WQTkUFJv9QhdUj6RJA4xdxAXKjDQbK3r6resoWQuxm7d2+WUtLLTRQZ1zvQ/gtSV0vQ==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr28368330wrt.110.1582029098553;
        Tue, 18 Feb 2020 04:31:38 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id b16sm3283514wmj.39.2020.02.18.04.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 04:31:37 -0800 (PST)
Date:   Tue, 18 Feb 2020 13:31:35 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] io_uring: remove unnecessary NULL checks
Message-ID: <20200218123135.5iihagj3lkwx4h52@steredhat>
References: <20200217143945.ua4lawkg22ggfihr@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217143945.ua4lawkg22ggfihr@kili.mountain>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 17, 2020 at 05:39:45PM +0300, Dan Carpenter wrote:
> The "kmsg" pointer can't be NULL and we have already dereferenced it so
> a check here would be useless.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 72bc378edebc..e9f339453ddb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3065,7 +3065,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			if (req->io)
>  				return -EAGAIN;
>  			if (io_alloc_async_ctx(req)) {
> -				if (kmsg && kmsg->iov != kmsg->fast_iov)
> +				if (kmsg->iov != kmsg->fast_iov)
>  					kfree(kmsg->iov);
>  				return -ENOMEM;
>  			}
> @@ -3219,7 +3219,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			if (req->io)
>  				return -EAGAIN;
>  			if (io_alloc_async_ctx(req)) {
> -				if (kmsg && kmsg->iov != kmsg->fast_iov)
> +				if (kmsg->iov != kmsg->fast_iov)
>  					kfree(kmsg->iov);
>  				return -ENOMEM;
>  			}

Make sense.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

