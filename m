Return-Path: <io-uring+bounces-7829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC08AA7DD0
	for <lists+io-uring@lfdr.de>; Sat,  3 May 2025 03:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBDA4986F89
	for <lists+io-uring@lfdr.de>; Sat,  3 May 2025 01:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7EE2F30;
	Sat,  3 May 2025 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gmh1bfaD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D15184F
	for <io-uring@vger.kernel.org>; Sat,  3 May 2025 01:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746234031; cv=none; b=YA69HXm/MGarzwRMSTp26cNsUQNHY4Tsbr5nZMJuy0FQ0dBsD+BW1i1FYYZ7McUUcByWF7q30AbC8XEKa6Bl+mRzvCO+SR4eXhBFv67wnJFohrsZgFwRvQRSnfjHkmySX4l+ANQtSnjBfT+1Esh8aWRjZXsFoky6R76mZWhn2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746234031; c=relaxed/simple;
	bh=A11yRfoSAXAPBviL2B4iJChHaU6OZYUImw3yMGDqKgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qM2b51lwHeWk5q65SmH7/EXLTYqfefV2UFVzQiiVbfoo2Ad8U3A7WdGl0vEIbAWJ6nxBQTADtB619R1P4GLz5+yqrlmKCmUK7MOj750Xm9EhY7n5rflVGjRbweCSG64u08hOxL3ePc2e/FWsdS6EKmHABhWdRA1uEOkUj8LZT5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gmh1bfaD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746234028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CovQiVq3j4sWSzKiLPnIcwJ7jx1eTkt2Yk/QEktGzc4=;
	b=Gmh1bfaDIJK/IdUYvT5WBUkmKy7PP2rNYqnsmsr+J8IHdIxEsVq2+bxfnv+wlrDdUMw2XS
	meZ+ma+tqvKINojIMtotizZ5g2aPOXU1aE8xq/u0GcZKeb5oNWBxtyWOVSc8KKLwbDA6lN
	+hSkGUzeZIA9oPUOUaOtFJzxOI61+yQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-ZAq4MCvcMpiiuxLj0iC3YA-1; Fri,
 02 May 2025 21:00:26 -0400
X-MC-Unique: ZAq4MCvcMpiiuxLj0iC3YA-1
X-Mimecast-MFC-AGG-ID: ZAq4MCvcMpiiuxLj0iC3YA_1746234024
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3717E1956096;
	Sat,  3 May 2025 01:00:24 +0000 (UTC)
Received: from fedora (unknown [10.72.116.4])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 282111956094;
	Sat,  3 May 2025 01:00:18 +0000 (UTC)
Date: Sat, 3 May 2025 09:00:13 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
Message-ID: <aBVqndZc-FjlHG-V@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <CADUfDZrXTzXM4tA6vRcOz1qn61he+Y6p5UsLeprbmhDVJe0gbg@mail.gmail.com>
 <aBJDClTlYV48h3P3@fedora>
 <CADUfDZoROJeDKNWOzbgEqrs_B7kU2qNWwZxfnS2TDqYxiXrY0w@mail.gmail.com>
 <aBTr5fz5KOgd9RiD@fedora>
 <CADUfDZqetfAE_s8-GDSLmYTdgrqFLv+YZ1vndg0uD38NuXW3Nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqetfAE_s8-GDSLmYTdgrqFLv+YZ1vndg0uD38NuXW3Nw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, May 02, 2025 at 02:21:05PM -0700, Caleb Sander Mateos wrote:
> On Fri, May 2, 2025 at 8:59 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Thu, May 01, 2025 at 06:31:03PM -0700, Caleb Sander Mateos wrote:
> > > On Wed, Apr 30, 2025 at 8:34 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > On Mon, Apr 28, 2025 at 05:43:12PM -0700, Caleb Sander Mateos wrote:
> > > > > On Mon, Apr 28, 2025 at 2:44 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > > > >
> > > > > > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > > > > > supporting to register/unregister bvec buffer to specified io_uring,
> > > > > > which FD is usually passed from userspace.
> > > > > >
> > > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > > ---
> > > > > >  include/linux/io_uring/cmd.h |  4 ++
> > > > > >  io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
> > > > > >  2 files changed, 67 insertions(+), 20 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > > > > index 78fa336a284b..7516fe5cd606 100644
> > > > > > --- a/include/linux/io_uring/cmd.h
> > > > > > +++ b/include/linux/io_uring/cmd.h
> > > > > > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> > > > > >
> > > > > >  struct io_buf_data {
> > > > > >         unsigned short index;
> > > > > > +       bool has_fd;
> > > > > > +       bool registered_fd;
> > > > > > +
> > > > > > +       int ring_fd;
> > > > > >         struct request *rq;
> > > > > >         void (*release)(void *);
> > > > > >  };
> > > > > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > > > > index 5f8ab130a573..701dd33fecf7 100644
> > > > > > --- a/io_uring/rsrc.c
> > > > > > +++ b/io_uring/rsrc.c
> > > > > > @@ -969,21 +969,6 @@ static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
> > > > > >         return 0;
> > > > > >  }
> > > > > >
> > > > > > -int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> > > > > > -                           struct io_buf_data *buf,
> > > > > > -                           unsigned int issue_flags)
> > > > > > -{
> > > > > > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > > > > > -       int ret;
> > > > > > -
> > > > > > -       io_ring_submit_lock(ctx, issue_flags);
> > > > > > -       ret = __io_buffer_register_bvec(ctx, buf);
> > > > > > -       io_ring_submit_unlock(ctx, issue_flags);
> > > > > > -
> > > > > > -       return ret;
> > > > > > -}
> > > > > > -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> > > > > > -
> > > > > >  static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> > > > > >                                        struct io_buf_data *buf)
> > > > > >  {
> > > > > > @@ -1006,19 +991,77 @@ static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> > > > > >         return 0;
> > > > > >  }
> > > > > >
> > > > > > -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> > > > > > -                             struct io_buf_data *buf,
> > > > > > -                             unsigned int issue_flags)
> > > > > > +static inline int do_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > > > +                                   struct io_buf_data *buf,
> > > > > > +                                   unsigned int issue_flags,
> > > > > > +                                   bool reg)
> > > > > >  {
> > > > > > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > > > > >         int ret;
> > > > > >
> > > > > >         io_ring_submit_lock(ctx, issue_flags);
> > > > > > -       ret = __io_buffer_unregister_bvec(ctx, buf);
> > > > > > +       if (reg)
> > > > > > +               ret = __io_buffer_register_bvec(ctx, buf);
> > > > > > +       else
> > > > > > +               ret = __io_buffer_unregister_bvec(ctx, buf);
> > > > >
> > > > > It feels like unifying __io_buffer_register_bvec() and
> > > > > __io_buffer_unregister_bvec() would belong better in the prior patch
> > > > > that changes their signatures.
> > > >
> > > > Can you share how to do above in previous patch?
> > >
> > > I was thinking you could define do_reg_unreg_bvec() in the previous
> > > patch. It's a logical step once you've extracted out all the
> > > differences between io_buffer_register_bvec() and
> > > io_buffer_unregister_bvec() into the helpers
> > > __io_buffer_register_bvec() and __io_buffer_unregister_bvec(). But
> > > either way is fine.
> >
> > 'has_fd' and 'ring_fd' fields isn't added yet, the defined do_reg_unreg_bvec()
> > could be quite simple, looks no big difference, I can do that...
> >
> > >
> > > >
> > > > >
> > > > > >         io_ring_submit_unlock(ctx, issue_flags);
> > > > > >
> > > > > >         return ret;
> > > > > >  }
> > > > > > +
> > > > > > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > > > +                                   struct io_buf_data *buf,
> > > > > > +                                   unsigned int issue_flags,
> > > > > > +                                   bool reg)
> > > > > > +{
> > > > > > +       struct io_ring_ctx *remote_ctx = ctx;
> > > > > > +       struct file *file = NULL;
> > > > > > +       int ret;
> > > > > > +
> > > > > > +       if (buf->has_fd) {
> > > > > > +               file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
> > > > > > +               if (IS_ERR(file))
> > > > > > +                       return PTR_ERR(file);
> > > > >
> > > > > It would be good to avoid the overhead of this lookup and
> > > > > reference-counting in the I/O path. Would it be possible to move this
> > > > > lookup to when UBLK_IO_FETCH_REQ (and UBLK_IO_COMMIT_AND_FETCH_REQ, if
> > > > > it specifies a different ring_fd) is submitted? I guess that might
> > > > > require storing an extra io_ring_ctx pointer in struct ublk_io.
> > > >
> > > > Let's start from the flexible way & simple implementation.
> > > >
> > > > Any optimization & improvement can be done as follow-up.
> > >
> > > Sure, we can start with this as-is. But I suspect the extra
> > > reference-counting here will significantly decrease the benefit of the
> > > auto-register register feature.
> >
> > The reference-counting should only be needed for registering buffer to
> > external ring, which may have been slow because of the cross-ring thing...
> 
> The current code is incrementing and decrementing the io_uring file
> reference count even if the remote_ctx == ctx, right? I agree it

Yes, but it can be changed to drop the inc/dec file reference easily since we
have a flag field.

> should definitely be possible to skip the reference count in that
> case, as this code is already running in task work context for a
> command on the io_uring.

The current 'uring_cmd' instance holds one reference of the
io_ring_ctx instance.

> It should also be possible to avoid atomic
> reference-counting in the UBLK_AUTO_BUF_REGISTERED_RING case too.

For registering buffer to external io_ring, it is hard to avoid to grag
the io_uring_ctx reference when specifying the io_uring_ctx via its FD.

> 
> >
> > Maybe we can start automatic buffer register for ubq_daemon context only,
> > meantime allow to register buffer from external io_uring by adding per-io
> > spin_lock, which may help the per-io task Uday is working on too.
> 
> I'm not sure I understand why a spinlock would be required? In Uday's
> patch set, each ublk_io still belongs to a single task. So no
> additional locking should be required.

I think it is very useful to allow to register io buffer in the
other(non-ubq_daemon) io_uring context by the offload style.

Especially the register/unregister io buffer uring_cmd is for handling
target IO, which should have been issued in same context of target io
handling.

Without one per-io spinlock, it is hard to avoid one race you mentioned:

https://lore.kernel.org/linux-block/aA2pNRkBhgKsofRP@fedora/#t

in case of bad ublk server implementation.

> 
> >
> > And the interface still allow to support automatic buffer register to
> > external io_uring since `ublk_auto_buf_reg` includes 'flags' field, we can
> > enable it in future when efficient implementation is figured out.
> 
> Sure, we can definitely start with support only for auto-registering
> the buffer with the ublk command's own io_uring. Implementing a flag
> in the future to specify a different io_uring seems like a good
> approach.

OK, I will send V2 by starting with auto-registering buffer to the ublk
uring_cmd io_uring first.


Thanks,
Ming


