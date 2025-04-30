Return-Path: <io-uring+bounces-7791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9924CAA505F
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 17:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6934B9E4336
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 15:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09180248F53;
	Wed, 30 Apr 2025 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLq3bODW"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2AE21D3E9
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027290; cv=none; b=uCbD1LLEZXWefs4EL8+4Z62TCebAvAmhKcgm1b/dG5AoK3wSrgi0gJymZZ2h1mTJrXyJfAnQesuPsBBXarFseUtq6hEi1WBoiMECD0bvBGU73iA1jeKi9FELavwei8J3XDsEnuj3EE3lXByldqPG/obGMRPq6ZxBJgQPN98QOZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027290; c=relaxed/simple;
	bh=I6m4j3NsUsif6x/EEw5cgPfF2cJfVl/7fP3o5SnSgm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+ZfgED1svVkSxEIb6E9U6VOXY89VmwsWZh1K27ECtnDjJiU3S8m/xoVvBEywbjqIne6AwWOoToqgwcck0U/ywRry52Z07oFT5i36V/GlhDbeoNNzP6hF/HpY0PDKZJqIMUJQCXdzv7OxMw16PHK1dufs3aTGAFSIheqhmb5yF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KLq3bODW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746027288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SiKfEPZGCcVJIA5jCRE2xKSSWGX2ebUDK8pMQjrVMvY=;
	b=KLq3bODW5E+bufxPBeYf253ON9v9tuWEjPdse8wOuQdw57XuYwzPR//c2KYVIXDJOqwiIt
	15Cr+rma39gvWA4CQqQT3jUWJUIhIMHmPXFObA2mcwsNCtEiGOaZnVAyegcRdnOIHxA5F8
	iwEUykU9SuUIGsn6xUcoQNyX867KpxI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-9imub77-PGyN4r0nqPNFDQ-1; Wed,
 30 Apr 2025 11:34:44 -0400
X-MC-Unique: 9imub77-PGyN4r0nqPNFDQ-1
X-Mimecast-MFC-AGG-ID: 9imub77-PGyN4r0nqPNFDQ_1746027283
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 882F91800ECB;
	Wed, 30 Apr 2025 15:34:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.59])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58A3B19560A3;
	Wed, 30 Apr 2025 15:34:38 +0000 (UTC)
Date: Wed, 30 Apr 2025 23:34:34 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
Message-ID: <aBJDClTlYV48h3P3@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <CADUfDZrXTzXM4tA6vRcOz1qn61he+Y6p5UsLeprbmhDVJe0gbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrXTzXM4tA6vRcOz1qn61he+Y6p5UsLeprbmhDVJe0gbg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Apr 28, 2025 at 05:43:12PM -0700, Caleb Sander Mateos wrote:
> On Mon, Apr 28, 2025 at 2:44 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > supporting to register/unregister bvec buffer to specified io_uring,
> > which FD is usually passed from userspace.
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  include/linux/io_uring/cmd.h |  4 ++
> >  io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
> >  2 files changed, 67 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > index 78fa336a284b..7516fe5cd606 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> >
> >  struct io_buf_data {
> >         unsigned short index;
> > +       bool has_fd;
> > +       bool registered_fd;
> > +
> > +       int ring_fd;
> >         struct request *rq;
> >         void (*release)(void *);
> >  };
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 5f8ab130a573..701dd33fecf7 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -969,21 +969,6 @@ static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
> >         return 0;
> >  }
> >
> > -int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> > -                           struct io_buf_data *buf,
> > -                           unsigned int issue_flags)
> > -{
> > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > -       int ret;
> > -
> > -       io_ring_submit_lock(ctx, issue_flags);
> > -       ret = __io_buffer_register_bvec(ctx, buf);
> > -       io_ring_submit_unlock(ctx, issue_flags);
> > -
> > -       return ret;
> > -}
> > -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> > -
> >  static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> >                                        struct io_buf_data *buf)
> >  {
> > @@ -1006,19 +991,77 @@ static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> >         return 0;
> >  }
> >
> > -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> > -                             struct io_buf_data *buf,
> > -                             unsigned int issue_flags)
> > +static inline int do_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > +                                   struct io_buf_data *buf,
> > +                                   unsigned int issue_flags,
> > +                                   bool reg)
> >  {
> > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> >         int ret;
> >
> >         io_ring_submit_lock(ctx, issue_flags);
> > -       ret = __io_buffer_unregister_bvec(ctx, buf);
> > +       if (reg)
> > +               ret = __io_buffer_register_bvec(ctx, buf);
> > +       else
> > +               ret = __io_buffer_unregister_bvec(ctx, buf);
> 
> It feels like unifying __io_buffer_register_bvec() and
> __io_buffer_unregister_bvec() would belong better in the prior patch
> that changes their signatures.

Can you share how to do above in previous patch?

> 
> >         io_ring_submit_unlock(ctx, issue_flags);
> >
> >         return ret;
> >  }
> > +
> > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > +                                   struct io_buf_data *buf,
> > +                                   unsigned int issue_flags,
> > +                                   bool reg)
> > +{
> > +       struct io_ring_ctx *remote_ctx = ctx;
> > +       struct file *file = NULL;
> > +       int ret;
> > +
> > +       if (buf->has_fd) {
> > +               file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
> > +               if (IS_ERR(file))
> > +                       return PTR_ERR(file);
> 
> It would be good to avoid the overhead of this lookup and
> reference-counting in the I/O path. Would it be possible to move this
> lookup to when UBLK_IO_FETCH_REQ (and UBLK_IO_COMMIT_AND_FETCH_REQ, if
> it specifies a different ring_fd) is submitted? I guess that might
> require storing an extra io_ring_ctx pointer in struct ublk_io.

Let's start from the flexible way & simple implementation.

Any optimization & improvement can be done as follow-up.

Each command may register buffer to different io_uring context,
it can't be done in UBLK_IO_FETCH_REQ stage, because new IO with same
tag may register buffer to new io_uring context.

But it can be optimized in future for one specific use case with feature
flag.

> 
> > +               remote_ctx = file->private_data;
> > +               if (!remote_ctx)
> > +                       return -EINVAL;
> > +       }
> > +
> > +       if (remote_ctx == ctx) {
> > +               do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
> > +       } else {
> > +               if (!(issue_flags & IO_URING_F_UNLOCKED))
> > +                       mutex_unlock(&ctx->uring_lock);
> > +
> > +               do_reg_unreg_bvec(remote_ctx, buf, IO_URING_F_UNLOCKED, reg);
> > +
> > +               if (!(issue_flags & IO_URING_F_UNLOCKED))
> > +                       mutex_lock(&ctx->uring_lock);
> > +       }
> > +
> > +       if (file)
> > +               fput(file);
> > +
> > +       return ret;
> > +}
> > +
> > +int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> > +                           struct io_buf_data *buf,
> > +                           unsigned int issue_flags)
> 
> If buf->has_fd is set, this struct io_uring_cmd *cmd is unused. Could
> you define separate functions that take a struct io_uring_cmd * vs. a
> ring_fd?

The ring_fd may point to the same io_uring context with 'io_uring_cmd',
we need this information for dealing with io_uring context lock.


Thanks, 
Ming


