Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1C261391
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 17:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgIHPdD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 11:33:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730203AbgIHPYI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 11:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599578641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kn9hbknpyWVhQlSOafeEsxNFb47fyKdNL+eDglfupFs=;
        b=P3gVrXwfazCOFGcC0RjjOr2bdrwAZb/6JbShfW5xA6MGy0uC7rXa6Jy7LEYCfzgUBPI2iJ
        mJ5p5aJUmJ7PTJS0kFipSpKRg34VEhVI+N8VGFLovL7/Q6Dvz5k/ZFF72ffP8IdmWp+YVO
        bjhsKh1or7sTiIPE5dT9qWAjaj39FVo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-YYJc5cTwNDGlExvEGRXfEg-1; Tue, 08 Sep 2020 10:10:08 -0400
X-MC-Unique: YYJc5cTwNDGlExvEGRXfEg-1
Received: by mail-wm1-f70.google.com with SMTP id m125so4776152wmm.7
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 07:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kn9hbknpyWVhQlSOafeEsxNFb47fyKdNL+eDglfupFs=;
        b=NSYMr5lDiHT9MdQP2se/P7r05xf8rs/QJ890ZlReQyihNY9RHk+2g+KOJuMWf1oGur
         TtnSkXxtM4ZRo39u4ukqmXqyYg+gbsGDZxJIuJUiwkDraZs+uN2/oTeWwFu8AZnC9Z9l
         IoproltCdIKAUSx3+VgCmlNnVWRHYkk8AmTe78NpF5BNQtkPgN44NInVO6g73NPHLsav
         DvlZxVIwf+98uVdacGjFDpLu63w6iv1nmCJ3diPNLUCv4vqO9Gz3t50hlAO9y4SzwsxB
         pVA02rjhuckvypIGaLUCiQiJeFLe0Na2sGUL5VtvMT6y0QhrrQf+omFLPqo/KuWar1Tg
         Eg2Q==
X-Gm-Message-State: AOAM5328d/cPMX+sgE+NEun0W62CMbhI/DPjVD6nfZvgCzxhpbDMDhaY
        mpnacz0Gk+Uwm4Gv9ubLeFtJyKjzvO+YltWGtABfkJWLktOiHtFYC8exImhCLuWMjWzf4x9cFY5
        kqTKvzylecW0RyCxcXmY=
X-Received: by 2002:a5d:67d2:: with SMTP id n18mr26920277wrw.223.1599574207373;
        Tue, 08 Sep 2020 07:10:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCoZsLpCl42/yvJP59b0CJVR6x3OGhbvD44BBTGIzdJCIH1DWhXch6JnHrzE/D/eGYFzCq9A==
X-Received: by 2002:a5d:67d2:: with SMTP id n18mr26920239wrw.223.1599574207050;
        Tue, 08 Sep 2020 07:10:07 -0700 (PDT)
Received: from steredhat (host-79-53-225-185.retail.telecomitalia.it. [79.53.225.185])
        by smtp.gmail.com with ESMTPSA id y1sm34416524wru.87.2020.09.08.07.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 07:10:06 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:10:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 3/3] io_uring: allow disabling rings during the
 creation
Message-ID: <20200908141003.wsm6pclfj6tsaffr@steredhat>
References: <20200827145831.95189-1-sgarzare@redhat.com>
 <20200827145831.95189-4-sgarzare@redhat.com>
 <20200908134448.sg7evdrfn6xa67sn@steredhat>
 <045e0907-4771-0b7f-d52a-4af8197e6954@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <045e0907-4771-0b7f-d52a-4af8197e6954@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 08, 2020 at 07:57:08AM -0600, Jens Axboe wrote:
> On 9/8/20 7:44 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > 
> > On Thu, Aug 27, 2020 at 04:58:31PM +0200, Stefano Garzarella wrote:
> >> This patch adds a new IORING_SETUP_R_DISABLED flag to start the
> >> rings disabled, allowing the user to register restrictions,
> >> buffers, files, before to start processing SQEs.
> >>
> >> When IORING_SETUP_R_DISABLED is set, SQE are not processed and
> >> SQPOLL kthread is not started.
> >>
> >> The restrictions registration are allowed only when the rings
> >> are disable to prevent concurrency issue while processing SQEs.
> >>
> >> The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
> >> opcode with io_uring_register(2).
> >>
> >> Suggested-by: Jens Axboe <axboe@kernel.dk>
> >> Reviewed-by: Kees Cook <keescook@chromium.org>
> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> ---
> >> v4:
> >>  - fixed io_uring_enter() exit path when ring is disabled
> >>
> >> v3:
> >>  - enabled restrictions only when the rings start
> >>
> >> RFC v2:
> >>  - removed return value of io_sq_offload_start()
> >> ---
> >>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++++-----
> >>  include/uapi/linux/io_uring.h |  2 ++
> >>  2 files changed, 47 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index 5f62997c147b..b036f3373fbe 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -226,6 +226,7 @@ struct io_restriction {
> >>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
> >>  	u8 sqe_flags_allowed;
> >>  	u8 sqe_flags_required;
> >> +	bool registered;
> >>  };
> >>  
> >>  struct io_ring_ctx {
> >> @@ -7497,8 +7498,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
> >>  	return ret;
> >>  }
> >>  
> >> -static int io_sq_offload_start(struct io_ring_ctx *ctx,
> >> -			       struct io_uring_params *p)
> >> +static int io_sq_offload_create(struct io_ring_ctx *ctx,
> >> +				struct io_uring_params *p)
> >>  {
> >>  	int ret;
> >>  
> >> @@ -7532,7 +7533,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
> >>  			ctx->sqo_thread = NULL;
> >>  			goto err;
> >>  		}
> >> -		wake_up_process(ctx->sqo_thread);
> >>  	} else if (p->flags & IORING_SETUP_SQ_AFF) {
> >>  		/* Can't have SQ_AFF without SQPOLL */
> >>  		ret = -EINVAL;
> >> @@ -7549,6 +7549,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
> >>  	return ret;
> >>  }
> >>  
> >> +static void io_sq_offload_start(struct io_ring_ctx *ctx)
> >> +{
> >> +	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
> >> +		wake_up_process(ctx->sqo_thread);
> >> +}
> >> +
> >>  static inline void __io_unaccount_mem(struct user_struct *user,
> >>  				      unsigned long nr_pages)
> >>  {
> >> @@ -8295,6 +8301,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
> >>  	if (!percpu_ref_tryget(&ctx->refs))
> >>  		goto out_fput;
> >>  
> >> +	if (ctx->flags & IORING_SETUP_R_DISABLED)
> >> +		goto out_fput;
> >> +
> > 
> > While writing the man page paragraph, I discovered that if the rings are
> > disabled I returned ENXIO error in io_uring_enter(), coming from the previous
> > check.
> > 
> > I'm not sure it is the best one, maybe I can return EBADFD or another
> > error.
> > 
> > What do you suggest?
> 
> EBADFD seems indeed the most appropriate - the fd is valid, but not in the
> right state to do this.

Yeah, the same interpretation as mine!

Also, in io_uring_register() I'm returning EINVAL if the rings are not
disabled and the user wants to register restrictions.
Maybe also in this case I can return EBADFD.

I'll send a patch with the fixes.

Thanks,
Stefano

