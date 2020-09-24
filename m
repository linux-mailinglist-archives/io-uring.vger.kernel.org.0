Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52E9276E2C
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 12:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgIXKHQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 06:07:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727325AbgIXKHQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 06:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600942035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4iT/+LmTQkYz1dVybGRkqzSRFikZmjo7e6yd4w7JahI=;
        b=c3uYQYHVpROSfYeAS3a7gHUAg5q2aHrLUeUs5IilgKiSIBsGBaNa+uIz0ITHtxEje8sTOj
        6Sjd44YO+dcKdqNngvC7ewGAdwFQ9dy6eZ+BCArxgVI3WhFXUiqNtgMqSZMUPzupkBvhrh
        CtrtUnlpdQwuY0ZkDWYpnqV0/VzcGT8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-0EmJsjcKNWWpSy0jki3iLw-1; Thu, 24 Sep 2020 06:04:28 -0400
X-MC-Unique: 0EmJsjcKNWWpSy0jki3iLw-1
Received: by mail-wr1-f72.google.com with SMTP id 33so1046587wre.0
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 03:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4iT/+LmTQkYz1dVybGRkqzSRFikZmjo7e6yd4w7JahI=;
        b=g4yfJFEFmBQWxO/Pru8Zd7V1pyhzFpndhXqMO2UZ0O0v1wxiPy2jCaZTYLS4vMVh7F
         nUZdR4HU1/6VxIYZTWEKSJIc9+NchNFh6jkyIVn4xH4MuG7FWKs09RfiGnmROHYEAhWO
         4E837Un2WbzbTScmY0HIo7Zr3dKQiMBhCOETD31++/tTD3AbIvrKk2msocuMFJkFsJdm
         mjn+cb7E0Pq079f/3lkbquVzcsjmxXx/zudXea47iPEg9SGUd/QNUkAXF+eI073aF2Wc
         JMrAiyXmRPcI8f4VumjP4ki1TYbMdcq3ed/9Tn5nHMtZBHJNEV7URkLCJyKXWfl9XzXP
         6EwQ==
X-Gm-Message-State: AOAM531sLPpJ9VydzrzLQWbv4YQRUFruo4WdeECFp0LwIB56DBoVIzYn
        DLtUC6LyRtFmPaEdaZhH50YJi3HKcqmFe9clhRrbTxXHnmdszHJIomp/ElnAh4byRgBI4meIwIO
        iHsels2DsA3DwkhuK4OA=
X-Received: by 2002:a1c:3505:: with SMTP id c5mr4131447wma.65.1600941866710;
        Thu, 24 Sep 2020 03:04:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4DzvvN2YwQ6KtvvDMCnKA4GxXXQOU7dZsfNIy0PVg9H21tlk1WVUkwuf5qI94NBq6wLIIMg==
X-Received: by 2002:a1c:3505:: with SMTP id c5mr4131420wma.65.1600941866485;
        Thu, 24 Sep 2020 03:04:26 -0700 (PDT)
Received: from steredhat (host-80-116-189-193.retail.telecomitalia.it. [80.116.189.193])
        by smtp.gmail.com with ESMTPSA id i14sm3077099wro.96.2020.09.24.03.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 03:04:25 -0700 (PDT)
Date:   Thu, 24 Sep 2020 12:04:22 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH RESEND] io_uring: show sqthread pid and cpu in fdinfo
Message-ID: <20200924100422.owe7enrnhh5d2axz@steredhat>
References: <1600916124-19563-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600916124-19563-1-git-send-email-joseph.qi@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 24, 2020 at 10:55:24AM +0800, Joseph Qi wrote:
> In most cases we'll specify IORING_SETUP_SQPOLL and run multiple
> io_uring instances in a host. Since all sqthreads are named
> "io_uring-sq", it's hard to distinguish the relations between
> application process and its io_uring sqthread.
> With this patch, application can get its corresponding sqthread pid
> and cpu through show_fdinfo.
> Steps:
> 1. Get io_uring fd first.
> $ ls -l /proc/<pid>/fd | grep -w io_uring
> 2. Then get io_uring instance related info, including corresponding
> sqthread pid and cpu.
> $ cat /proc/<pid>/fdinfo/<io_uring_fd>
> 
> pos:	0
> flags:	02000002
> mnt_id:	13
> SqThread:	6929
> SqThreadCpu:	2
> UserFiles:	1
>     0: testfile
> UserBufs:	0
> PollList:
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/io_uring.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8b426aa..9c8b3b3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8415,6 +8415,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  	int i;
>  
>  	mutex_lock(&ctx->uring_lock);
> +	seq_printf(m, "SqThread:\t%d\n", (ctx->flags & IORING_SETUP_SQPOLL) ?
> +					 task_pid_nr(ctx->sqo_thread) : -1);

What about 'SqThreadPID'?

> +	seq_printf(m, "SqThreadCpu:\t%d\n", (ctx->flags & IORING_SETUP_SQPOLL) ?
> +					    task_cpu(ctx->sqo_thread) : -1);
>  	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
>  	for (i = 0; i < ctx->nr_user_files; i++) {
>  		struct fixed_file_table *table;
> -- 
> 1.8.3.1
> 

With or without that changed, it looks good to me:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

