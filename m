Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD7C23409F
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 09:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbgGaH6X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 03:58:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731684AbgGaH6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 03:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596182300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=84tLlFhyX5yQ5ssNIgVXDIYFq1uCyZ1N5Ve3Yue5jsc=;
        b=Q0j3G3jxMKoBkfMkavmHRBzYqmpf2WMuosKfzBthIoKJX8QU9+D6uMVoX8XcDpo2EO0L0d
        X10GOpFsALCgNBcBEa+ffKnvSNlNhUbKL3CwxYRWsUthi92vEEfHKu0l5fYM8y6XW0Tncw
        kmw+FPdu4fUejosJ0OK11zsXjHR+3tE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-OEc1kFGmO4WWujQ-XhZfow-1; Fri, 31 Jul 2020 03:58:18 -0400
X-MC-Unique: OEc1kFGmO4WWujQ-XhZfow-1
Received: by mail-wr1-f69.google.com with SMTP id t3so7809522wrr.5
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 00:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84tLlFhyX5yQ5ssNIgVXDIYFq1uCyZ1N5Ve3Yue5jsc=;
        b=sWrm2GO/CaxtWgqipjM+Ln673o06FpQWsWAWQX7EzUzCeyb9EuHEyBVVugFpvlf3n5
         pARNw+N6uLnCep19SgpKjqz/ptWYQVVJyb/V5AfJj1jtowNFxuvdOXYy8W6c+iWNl0f+
         c6adQcHVdFDnrRSElfwkjSMlzS/QgzXbfoOFzYdlygRD46YfcyiTUb+Mblf22o7jtkgQ
         uVTDqkSySVWW9kOk9nnXUi1aD4e7e3dWntMx5LG+CPea9Xxv/6EPneAsefe10ueGyAIL
         ZPx6ns4hbh4whF7H0k6SlgZRh6pj3JHM7CtnMLgcBx+xy2wgbOPScS/yZsLa36oy++7u
         XO+w==
X-Gm-Message-State: AOAM531VIa1ca571QGHYaJrmM8cMNJttse5bxhmsRVyTNnr8tB+vk2T8
        dsR74KjHRRbbC1IN93Bz8NNUkqsPhPq07TR8uofqqDM3YBnl0ckL3prfJursWP/PH6+ZZzvjyJz
        CnIGD3z92L9aJe7M+Xww=
X-Received: by 2002:a5d:6646:: with SMTP id f6mr2322297wrw.155.1596182297356;
        Fri, 31 Jul 2020 00:58:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg3vxSVrk32ILOZGXQoal40vZ/kQMjl/7R1XUZZ0f//VcKOhzCU6FvM9FdTHXSwSs8UzvHCw==
X-Received: by 2002:a5d:6646:: with SMTP id f6mr2322282wrw.155.1596182297060;
        Fri, 31 Jul 2020 00:58:17 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id b139sm13367476wmd.19.2020.07.31.00.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 00:58:16 -0700 (PDT)
Date:   Fri, 31 Jul 2020 09:58:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: don't touch 'ctx' after installing file
 descriptor
Message-ID: <20200731075813.wi4cyjmz7cql6mry@steredhat>
References: <5c2ac23d-3801-c06f-8bf6-4096fef88113@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c2ac23d-3801-c06f-8bf6-4096fef88113@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 30, 2020 at 01:47:52PM -0600, Jens Axboe wrote:
> As soon as we install the file descriptor, we have to assume that it
> can get arbitrarily closed. We currently account memory (and note that
> we did) after installing the ring fd, which means that it could be a
> potential use-after-free condition if the fd is closed right after
> being installed, but before we fiddle with the ctx.
> 
> In fact, syzbot reported this exact scenario:
> 
> BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
> BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
> BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
> Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145
> 
> CPU: 0 PID: 18145 Comm: syz-executor.5 Not tainted 5.8.0-rc7-next-20200729-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>  io_account_mem fs/io_uring.c:7397 [inline]
>  io_uring_create fs/io_uring.c:8369 [inline]
>  io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45c429
> Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f8f121d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000000008540 RCX: 000000000045c429
> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000196
> RBP: 000000000078bf38 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
> R13: 00007fff86698cff R14: 00007f8f121d19c0 R15: 000000000078bf0c
> 
> Move the accounting of the ring used locked memory before we get and
> install the ring file descriptor.

Maybe we can add:
Fixes: 309758254ea6 ("io_uring: report pinned memory usage")

The patch LGTM:
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

> 
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fabf0b692384..33702f3b5af8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8329,6 +8329,15 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		ret = -EFAULT;
>  		goto err;
>  	}
> +
> +	/*
> +	 * Account memory _before_ installing the file descriptor. Once
> +	 * the descriptor is installed, it can get closed at any time.
> +	 */
> +	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
> +		       ACCT_LOCKED);
> +	ctx->limit_mem = limit_mem;
> +
>  	/*
>  	 * Install ring fd as the very last thing, so we don't risk someone
>  	 * having closed it before we finish setup
> @@ -8338,9 +8347,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		goto err;
>  
>  	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
> -	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
> -		       ACCT_LOCKED);
> -	ctx->limit_mem = limit_mem;
>  	return ret;
>  err:
>  	io_ring_ctx_wait_and_kill(ctx);
> 
> -- 
> Jens Axboe
> 

