Return-Path: <io-uring+bounces-7841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1908DAAB97F
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 08:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 961051C28182
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 06:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AAE27F73F;
	Tue,  6 May 2025 04:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPy+Q0BG"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8C82BEC47
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 02:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746499574; cv=none; b=hk7IPqgsJyGR+wzUztMHi75dRAveIJDRvZ+5rRVAayec4h45zM95IVG5z4I+eY9qlxAa0hr4F7avJerG90AIyx2Ii+gdwzRaTRJ2Esg1g0dVh62/nm+YDa++aAje1T0R/xTpTY6rz43rKjhcvSQ3qZJ0sGHMQVCgU0oQHB1rt1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746499574; c=relaxed/simple;
	bh=MuBiG0/S7UIZBD5rKs0TbzCcJT2CaK2ppbhy9ywFbOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHNhGF66Tep1OKm+0nUOTIg2RG97+rBJ9P8KjM75sAsXMDH4m01F8egaJ9sh8h8NZ4hnTq2mhm/VW9g59kRi+w4HxvO7vdJprZ6yz+29fgrJAOhya1ytkxAhKFLkBVioIIhWFBmjiphPp4EjqtzF8JQw3wXQq8DBVJW/eqEyi4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPy+Q0BG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746499569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw4JE7DaO2HFUMVygjFqgHglIdpP20re07MpV/DiLWg=;
	b=UPy+Q0BGvmKMofyNsVs6rtmFiAoDktAMshh977+UrP6tWFhvtuDomxBlt/5v3hM6HqXzLn
	cVI3tXeFSoS0iaZCFim+/7UereT07CCBnbOrRNq4A2oumP1onhqQVf9XITFaWGpevelCES
	X10TSX+O9VuFjnioNNz0nL8VyV7IB0U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-rM5Jc4Q6NzWz8f_0MAVCmw-1; Mon,
 05 May 2025 22:46:04 -0400
X-MC-Unique: rM5Jc4Q6NzWz8f_0MAVCmw-1
X-Mimecast-MFC-AGG-ID: rM5Jc4Q6NzWz8f_0MAVCmw_1746499559
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C38FC19560AD;
	Tue,  6 May 2025 02:45:58 +0000 (UTC)
Received: from fedora (unknown [10.72.116.13])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4CC419560AF;
	Tue,  6 May 2025 02:45:54 +0000 (UTC)
Date: Tue, 6 May 2025 10:45:49 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
Message-ID: <aBl33aVsZ-s2-Kpx@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <CADUfDZrXTzXM4tA6vRcOz1qn61he+Y6p5UsLeprbmhDVJe0gbg@mail.gmail.com>
 <aBJDClTlYV48h3P3@fedora>
 <CADUfDZoROJeDKNWOzbgEqrs_B7kU2qNWwZxfnS2TDqYxiXrY0w@mail.gmail.com>
 <aBTr5fz5KOgd9RiD@fedora>
 <CADUfDZqetfAE_s8-GDSLmYTdgrqFLv+YZ1vndg0uD38NuXW3Nw@mail.gmail.com>
 <aBVqndZc-FjlHG-V@fedora>
 <CADUfDZoypP63aBjwUB50hZTiZ_ouN1Bt73-hHBY75xsNq9OGZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZoypP63aBjwUB50hZTiZ_ouN1Bt73-hHBY75xsNq9OGZQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Sat, May 03, 2025 at 11:55:05AM -0700, Caleb Sander Mateos wrote:
> On Fri, May 2, 2025 at 6:00 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Fri, May 02, 2025 at 02:21:05PM -0700, Caleb Sander Mateos wrote:
> > > On Fri, May 2, 2025 at 8:59 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > On Thu, May 01, 2025 at 06:31:03PM -0700, Caleb Sander Mateos wrote:
> > > > > On Wed, Apr 30, 2025 at 8:34 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Apr 28, 2025 at 05:43:12PM -0700, Caleb Sander Mateos wrote:
> > > > > > > On Mon, Apr 28, 2025 at 2:44 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > > > > > >
> > > > > > > > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > > > > > > > supporting to register/unregister bvec buffer to specified io_uring,
> > > > > > > > which FD is usually passed from userspace.
> > > > > > > >
> > > > > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > > > > ---
> > > > > > > >  include/linux/io_uring/cmd.h |  4 ++
> > > > > > > >  io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
> > > > > > > >  2 files changed, 67 insertions(+), 20 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > > > > > > index 78fa336a284b..7516fe5cd606 100644
> > > > > > > > --- a/include/linux/io_uring/cmd.h
> > > > > > > > +++ b/include/linux/io_uring/cmd.h
> > > > > > > > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> > > > > > > >
> > > > > > > >  struct io_buf_data {
> > > > > > > >         unsigned short index;
> > > > > > > > +       bool has_fd;
> > > > > > > > +       bool registered_fd;
> > > > > > > > +
> > > > > > > > +       int ring_fd;
> > > > > > > >         struct request *rq;
> > > > > > > >         void (*release)(void *);
> > > > > > > >  };
> > > > > > > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > > > > > > index 5f8ab130a573..701dd33fecf7 100644
> > > > > > > > --- a/io_uring/rsrc.c
> > > > > > > > +++ b/io_uring/rsrc.c
> > > > > > > > @@ -969,21 +969,6 @@ static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
> > > > > > > >         return 0;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> > > > > > > > -                           struct io_buf_data *buf,
> > > > > > > > -                           unsigned int issue_flags)
> > > > > > > > -{
> > > > > > > > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > > > > > > > -       int ret;
> > > > > > > > -
> > > > > > > > -       io_ring_submit_lock(ctx, issue_flags);
> > > > > > > > -       ret = __io_buffer_register_bvec(ctx, buf);
> > > > > > > > -       io_ring_submit_unlock(ctx, issue_flags);
> > > > > > > > -
> > > > > > > > -       return ret;
> > > > > > > > -}
> > > > > > > > -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> > > > > > > > -
> > > > > > > >  static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> > > > > > > >                                        struct io_buf_data *buf)
> > > > > > > >  {
> > > > > > > > @@ -1006,19 +991,77 @@ static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> > > > > > > >         return 0;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> > > > > > > > -                             struct io_buf_data *buf,
> > > > > > > > -                             unsigned int issue_flags)
> > > > > > > > +static inline int do_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > > > > > +                                   struct io_buf_data *buf,
> > > > > > > > +                                   unsigned int issue_flags,
> > > > > > > > +                                   bool reg)
> > > > > > > >  {
> > > > > > > > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > > > > > > >         int ret;
> > > > > > > >
> > > > > > > >         io_ring_submit_lock(ctx, issue_flags);
> > > > > > > > -       ret = __io_buffer_unregister_bvec(ctx, buf);
> > > > > > > > +       if (reg)
> > > > > > > > +               ret = __io_buffer_register_bvec(ctx, buf);
> > > > > > > > +       else
> > > > > > > > +               ret = __io_buffer_unregister_bvec(ctx, buf);
> > > > > > >
> > > > > > > It feels like unifying __io_buffer_register_bvec() and
> > > > > > > __io_buffer_unregister_bvec() would belong better in the prior patch
> > > > > > > that changes their signatures.
> > > > > >
> > > > > > Can you share how to do above in previous patch?
> > > > >
> > > > > I was thinking you could define do_reg_unreg_bvec() in the previous
> > > > > patch. It's a logical step once you've extracted out all the
> > > > > differences between io_buffer_register_bvec() and
> > > > > io_buffer_unregister_bvec() into the helpers
> > > > > __io_buffer_register_bvec() and __io_buffer_unregister_bvec(). But
> > > > > either way is fine.
> > > >
> > > > 'has_fd' and 'ring_fd' fields isn't added yet, the defined do_reg_unreg_bvec()
> > > > could be quite simple, looks no big difference, I can do that...
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >         io_ring_submit_unlock(ctx, issue_flags);
> > > > > > > >
> > > > > > > >         return ret;
> > > > > > > >  }
> > > > > > > > +
> > > > > > > > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > > > > > +                                   struct io_buf_data *buf,
> > > > > > > > +                                   unsigned int issue_flags,
> > > > > > > > +                                   bool reg)
> > > > > > > > +{
> > > > > > > > +       struct io_ring_ctx *remote_ctx = ctx;
> > > > > > > > +       struct file *file = NULL;
> > > > > > > > +       int ret;
> > > > > > > > +
> > > > > > > > +       if (buf->has_fd) {
> > > > > > > > +               file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
> > > > > > > > +               if (IS_ERR(file))
> > > > > > > > +                       return PTR_ERR(file);
> > > > > > >
> > > > > > > It would be good to avoid the overhead of this lookup and
> > > > > > > reference-counting in the I/O path. Would it be possible to move this
> > > > > > > lookup to when UBLK_IO_FETCH_REQ (and UBLK_IO_COMMIT_AND_FETCH_REQ, if
> > > > > > > it specifies a different ring_fd) is submitted? I guess that might
> > > > > > > require storing an extra io_ring_ctx pointer in struct ublk_io.
> > > > > >
> > > > > > Let's start from the flexible way & simple implementation.
> > > > > >
> > > > > > Any optimization & improvement can be done as follow-up.
> > > > >
> > > > > Sure, we can start with this as-is. But I suspect the extra
> > > > > reference-counting here will significantly decrease the benefit of the
> > > > > auto-register register feature.
> > > >
> > > > The reference-counting should only be needed for registering buffer to
> > > > external ring, which may have been slow because of the cross-ring thing...
> > >
> > > The current code is incrementing and decrementing the io_uring file
> > > reference count even if the remote_ctx == ctx, right? I agree it
> >
> > Yes, but it can be changed to drop the inc/dec file reference easily since we
> > have a flag field.
> >
> > > should definitely be possible to skip the reference count in that
> > > case, as this code is already running in task work context for a
> > > command on the io_uring.
> >
> > The current 'uring_cmd' instance holds one reference of the
> > io_ring_ctx instance.
> >
> > > It should also be possible to avoid atomic
> > > reference-counting in the UBLK_AUTO_BUF_REGISTERED_RING case too.
> >
> > For registering buffer to external io_ring, it is hard to avoid to grag
> > the io_uring_ctx reference when specifying the io_uring_ctx via its FD.
> 
> If the io_uring is specified by a file descriptor (not using
> UBLK_AUTO_BUF_REGISTERED_RING), I agree reference counting is
> necessary.
> But the whole point of registering ring fds is to avoid reference
> counting of the io_uring file. See how IORING_ENTER_REGISTERED_RING is
> handled in io_uring_enter(). It simply indexes
> current->io_uring->registered_rings to get the file, skipping the
> fget() and fput(). Since the auto register is running in task work
> context, it should also be able to access the task-local
> registered_rings without reference counting.

registered ring requires the io_uring is registered & used in the local
pthread, which usage is still very limited.

> 
> >
> > >
> > > >
> > > > Maybe we can start automatic buffer register for ubq_daemon context only,
> > > > meantime allow to register buffer from external io_uring by adding per-io
> > > > spin_lock, which may help the per-io task Uday is working on too.
> > >
> > > I'm not sure I understand why a spinlock would be required? In Uday's
> > > patch set, each ublk_io still belongs to a single task. So no
> > > additional locking should be required.
> >
> > I think it is very useful to allow to register io buffer in the
> > other(non-ubq_daemon) io_uring context by the offload style.
> >
> > Especially the register/unregister io buffer uring_cmd is for handling
> > target IO, which should have been issued in same context of target io
> > handling.
> >
> > Without one per-io spinlock, it is hard to avoid one race you mentioned:
> 
> I don't believe a spinlock is necessary. It should be possible to
> avoid accessing the ublk_io at all when registering the request
> buffer. __ublk_check_and_get_req() calls kref_get_unless_zero() on the
> request, which already ensures the request is owned by the ublk server

I thought the request still may be completed & recycled before calling
__ublk_check_and_get_req(). But it can be treated as one ublk server
logic bug since use-after-free doesn't exist actually.

> and prevents it from completing while its buffer is registered. This
> is analogous to how UBLK_F_USER_COPY works;
> ublk_ch_read_iter()/ublk_ch_write_iter() can be safely called from any
> thread.

OK, spinlock isn't needed.


Thanks,
Ming


