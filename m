Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03832426DC
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 10:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgHLIjt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 04:39:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbgHLIjs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 04:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597221587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+8/jEqsattVoOuPzDbRK8Jiq92tGSdjogZHzTdBrvco=;
        b=cEQyJNPcWk0/RY77Wk/LrBCy41bXdKKSpewxSSD3YFhkQ6dQ+Pq5Jnxh32e9MQMQKFSEz2
        iQvlz6eXzH260ZfZlkgYe8w7Q/pB7j8X4e/Rfje1Mzwm9IuYXYI8KGo+OifJFZFP7ZVSV/
        IDpGCLXctZZRihfkjTxDBIgpalOrLYM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-BDh7tkw7MV-IEt6C_Ktu4g-1; Wed, 12 Aug 2020 04:39:45 -0400
X-MC-Unique: BDh7tkw7MV-IEt6C_Ktu4g-1
Received: by mail-wr1-f71.google.com with SMTP id b13so625316wrq.19
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 01:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+8/jEqsattVoOuPzDbRK8Jiq92tGSdjogZHzTdBrvco=;
        b=LFEmq448D9MjLSJ0To67Pu+EuUBWQxPWiF8XSyX4mnHYcmTF+xapN9xXhCnOg4sR0L
         /KTmJldW1EmZVq/RyWvFwmFd+tv9wc7pDPfdxlxSWYLNsV1ILdASqsUX8OmRswPwpnt2
         yiMrbCIoFmOPmRSryS54zstyw456Y8agJZaL9NGYyQ66rthk7LWY6hO+jS9UmFGT91Fx
         k4Gbl38O1hqY6ATQHpcKv9Vvo0fqXy9/EFXclX5qdBoU8JRnA1vLXQu4TRyZE963c4yz
         f3BekiYB1i5Lq7SlDKFugSdKWNEh6/8LvSkXWm+0W9a93lFVwYkWf1mcfbMXp29SHqDp
         gY1w==
X-Gm-Message-State: AOAM533ARvOEnhbXS3lhynxpqETtXY3k2KnNM7SuVJS6NjLki0bhVnkB
        oBjxYdsqxpLEvKVh0uML8IjlagtYUxcYcUaynYFehZzIlrv+z9PzeHC3rjyHR+gQT50B6Rzi4EW
        2k8cFzLiIB1pDwWCtZpc=
X-Received: by 2002:a5d:440e:: with SMTP id z14mr32061472wrq.422.1597221583989;
        Wed, 12 Aug 2020 01:39:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJZ6J6nb6z7W4evskT0iDZpi4wQiAQGbrikhMaLxp0rIcKcPRnb2QNhGLYyHBskvpGurvp4w==
X-Received: by 2002:a5d:440e:: with SMTP id z14mr32061459wrq.422.1597221583778;
        Wed, 12 Aug 2020 01:39:43 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id 65sm3239919wre.6.2020.08.12.01.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 01:39:43 -0700 (PDT)
Date:   Wed, 12 Aug 2020 10:39:37 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: fail poll arm on queue proc failure
Message-ID: <20200812083937.m5zmmnnavfdlqlrv@steredhat>
References: <6d9ed36f-c55a-9907-179d-3b1b82b56e90@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d9ed36f-c55a-9907-179d-3b1b82b56e90@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 11, 2020 at 09:52:55AM -0600, Jens Axboe wrote:
> Check the ipt.error value, it must have been either cleared to zero or
> set to another error than the default -EINVAL if we don't go through the
> waitqueue proc addition. Just give up on poll at that point and return
> failure, this will fallback to async work.
> 
> io_poll_add() doesn't suffer from this failure case, as it returns the
> error value directly.
> 
> Cc: stable@vger.kernel.org # v5.7+
> Reported-by: syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

LGTM:
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Stefano

> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 99582cf5106b..8a2afd8c33c9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4883,7 +4883,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  
>  	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>  					io_async_wake);
> -	if (ret) {
> +	if (ret || ipt.error) {
>  		io_poll_remove_double(req, apoll->double_poll);
>  		spin_unlock_irq(&ctx->completion_lock);
>  		kfree(apoll->double_poll);
> -- 
> Jens Axboe
> 

