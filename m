Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA321D156
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 10:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgGMIHh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 04:07:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54440 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725818AbgGMIHh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 04:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594627655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=thokzV2lTPzLARMZ2GmJNDEymlOB144wptcD2yJ3eYo=;
        b=WfTETJ9mmiGoPzp5fY6EjMT6v4m4ofuuhepGWck5HL8qAR18CI4jTqgOr1BwZW6A933ZfR
        sIge1ch2xVtKffy1M3QPQVrZk9UCJwdBS/oQ4Jyy/KtgDoB+OkN+LyV2m/RzHf7YFZgxsT
        HHv3enir/net/0A5qCnA2tZGolC2b0Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-LkM69WlWP56z_pAwCRyOrw-1; Mon, 13 Jul 2020 04:07:34 -0400
X-MC-Unique: LkM69WlWP56z_pAwCRyOrw-1
Received: by mail-wm1-f72.google.com with SMTP id z74so12452719wmc.4
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 01:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=thokzV2lTPzLARMZ2GmJNDEymlOB144wptcD2yJ3eYo=;
        b=RgUWspcNh5xsj3kE0K+LEm9w0kRDXYGHjSckGgFzWe+B9nhffsvAaPTRm57w2RGqpM
         LMPpRR+21bNKgNZOmIH1DX58l4kPwzm1dO634YRdTj/UZFMSd7ZxP51gxnXixBJGqDXP
         BgguC2HrN9hjL+NZR/Wb1cLIpBn8IkHQIKek0ePXbI+ruDj8sRnnzweEDq2IVGcjoLLn
         JipZXi6UYunjhzCNUptbjEKPjffEoE4QzTJj6hSEiAs5WxVD8gBh+43CO6VfxKZXqKLD
         SgczhWEVls6/NoPjNujIRtgw1p4F/yZH0cDKR6U0Q9qMKO/K0JIhxMKRQbsK+h9mNa3m
         pEUA==
X-Gm-Message-State: AOAM533lJpt0kHOCXDKft1dNnWET18uinBxVDmJrj268nsb2yJGyWCrE
        gcQdcRnIC+WUGNyWKMwEjtYfgQOBWa7znn7QvEIEM65N7UMtG0/hqLZnsu+HOoE8i9nK/3BRzOy
        eHGZlWPJpRwWf2n6e2O0=
X-Received: by 2002:adf:9051:: with SMTP id h75mr84159388wrh.152.1594627652975;
        Mon, 13 Jul 2020 01:07:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6ugR4SJYyS+JyXgFpzVLUdQEd9gIqid8od/rTaiAEg/puVly9toFCtHHU1aU3hfbT+UQRmQ==
X-Received: by 2002:adf:9051:: with SMTP id h75mr84159371wrh.152.1594627652750;
        Mon, 13 Jul 2020 01:07:32 -0700 (PDT)
Received: from steredhat (host-79-49-203-52.retail.telecomitalia.it. [79.49.203.52])
        by smtp.gmail.com with ESMTPSA id w16sm26837072wrg.95.2020.07.13.01.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:07:32 -0700 (PDT)
Date:   Mon, 13 Jul 2020 10:07:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RFC 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
Message-ID: <20200713080729.gttt3ymk7aqumle4@steredhat>
References: <20200710141945.129329-1-sgarzare@redhat.com>
 <20200710141945.129329-3-sgarzare@redhat.com>
 <f39fe84d-1353-1066-c7fc-770054f7129e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39fe84d-1353-1066-c7fc-770054f7129e@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 11:52:48AM -0600, Jens Axboe wrote:
> On 7/10/20 8:19 AM, Stefano Garzarella wrote:
> > The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode
> > permanently installs a feature whitelist on an io_ring_ctx.
> > The io_ring_ctx can then be passed to untrusted code with the
> > knowledge that only operations present in the whitelist can be
> > executed.
> > 
> > The whitelist approach ensures that new features added to io_uring
> > do not accidentally become available when an existing application
> > is launched on a newer kernel version.
> 
> Keeping with the trend of the times, you should probably use 'allowlist'
> here instead of 'whitelist'.

Sure, it is better!

> > 
> > Currently is it possible to restrict sqe opcodes and register
> > opcodes. It is also possible to allow only fixed files.
> > 
> > IOURING_REGISTER_RESTRICTIONS can only be made once. Afterwards
> > it is not possible to change restrictions anymore.
> > This prevents untrusted code from removing restrictions.
> 
> A few comments below.
> 
> > @@ -337,6 +344,7 @@ struct io_ring_ctx {
> >  	struct llist_head		file_put_llist;
> >  
> >  	struct work_struct		exit_work;
> > +	struct io_restriction		restrictions;
> >  };
> >  
> >  /*
> 
> Since very few will use this feature, was going to suggest that we make
> it dynamically allocated. But it's just 32 bytes, currently, so probably
> not worth the effort...
> 

Yeah, I'm not sure it will grow in the future, so I'm tempted to leave it
as it is, but I can easily change it if you prefer.

> > @@ -5491,6 +5499,11 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
> >  	if (unlikely(!fixed && io_async_submit(req->ctx)))
> >  		return -EBADF;
> >  
> > +	if (unlikely(!fixed && req->ctx->restrictions.enabled &&
> > +		     test_bit(IORING_RESTRICTION_FIXED_FILES_ONLY,
> > +			      req->ctx->restrictions.restriction_op)))
> > +		return -EACCES;
> > +
> >  	return io_file_get(state, req, fd, &req->file, fixed);
> >  }
> 
> This one hurts, though. I don't want any extra overhead from the
> feature, and you're digging deep in ctx here to figure out of we need to
> check.
> 
> Generally, all the checking needs to be out-of-line, and it needs to
> base the decision on whether to check something or not on a cache hot
> piece of data. So I'd suggest to turn all of these into some flag.
> ctx->flags generally mirrors setup flags, so probably just add a:
> 
> 	unsigned int restrictions : 1;
> 
> after eventfd_async : 1 in io_ring_ctx. That's free, plenty of room
> there and that cacheline is already pulled in for reading.
> 

Thanks for the clear explanation!

I left a TODO comment near the 'enabled' field to look for something better,
and what you're suggesting is what I was looking for :-)

I'll change it!

Thanks,
Stefano

