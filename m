Return-Path: <io-uring+bounces-7817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEF0AA768F
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 17:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C56B986C6F
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 15:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940AD25B1F6;
	Fri,  2 May 2025 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPk5rnft"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D217A2ED
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746201594; cv=none; b=MjLYZ0iT98D8puLimCnMTu/q87X91nQymhIn+9H6yXgA5E5KXaorUuB40UZJYGlfrZpwGTtnhGAhVQjVWuOHVqJlh0t+KXOLpAAokHN1llRkp6a8HK9keX5i+b1h6Esy4LcLUlmfymN112kH6d/8Dl560Dt4ft+2HtfSyN1XYt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746201594; c=relaxed/simple;
	bh=o9KjaVkCE8s/dN+8Xo5JNp5zBKgVq9U4qzL7YGsFg5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsEzKz//7GlTQyIeZOdSoFac/hwXNTH91aoc3JIXOV1XY0UOJkBpM2XDsp7BW2pPX2OSJB1W7Vlmi5alP0mR1KwhC9ptgu44BYmyyf0OADbn+NL41P3Imlt2mIlRxRl6FYTk8FVle7BPDyzOcNNmfcWIIIe+RRcQYmnh7P0qiC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPk5rnft; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746201591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UR9uUxoiLaZqiGnbLXutVD0Vko4SiDy9ag1Oik9sOw4=;
	b=WPk5rnftxzBHMUPpz2l082+QLWn6RJcpLc+wYPk2Wo4RjAwqI9ODYE4+nZD41xQfUYAOl1
	eHrwzFCa4FeFH85NiGzilzOQW1Qb2AkFBT1BytZRrRFAqKx/2Dx0Cu6hZVUn4X5iPMpgXj
	FA/tKLi7j6y+7BOqL/iFZ8L5v47zQMQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-XKA8_tz1OvK8uxcbJn5qzA-1; Fri,
 02 May 2025 11:59:46 -0400
X-MC-Unique: XKA8_tz1OvK8uxcbJn5qzA-1
X-Mimecast-MFC-AGG-ID: XKA8_tz1OvK8uxcbJn5qzA_1746201584
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12CF1180087A;
	Fri,  2 May 2025 15:59:44 +0000 (UTC)
Received: from fedora (unknown [10.72.116.6])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E4FF19560A3;
	Fri,  2 May 2025 15:59:38 +0000 (UTC)
Date: Fri, 2 May 2025 23:59:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
Message-ID: <aBTr5fz5KOgd9RiD@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <CADUfDZrXTzXM4tA6vRcOz1qn61he+Y6p5UsLeprbmhDVJe0gbg@mail.gmail.com>
 <aBJDClTlYV48h3P3@fedora>
 <CADUfDZoROJeDKNWOzbgEqrs_B7kU2qNWwZxfnS2TDqYxiXrY0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZoROJeDKNWOzbgEqrs_B7kU2qNWwZxfnS2TDqYxiXrY0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, May 01, 2025 at 06:31:03PM -0700, Caleb Sander Mateos wrote:
> On Wed, Apr 30, 2025 at 8:34 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Mon, Apr 28, 2025 at 05:43:12PM -0700, Caleb Sander Mateos wrote:
> > > On Mon, Apr 28, 2025 at 2:44 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > > > supporting to register/unregister bvec buffer to specified io_uring,
> > > > which FD is usually passed from userspace.
> > > >
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >  include/linux/io_uring/cmd.h |  4 ++
> > > >  io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
> > > >  2 files changed, 67 insertions(+), 20 deletions(-)
> > > >
> > > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > > index 78fa336a284b..7516fe5cd606 100644
> > > > --- a/include/linux/io_uring/cmd.h
> > > > +++ b/include/linux/io_uring/cmd.h
> > > > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> > > >
> > > >  struct io_buf_data {
> > > >         unsigned short index;
> > > > +       bool has_fd;
> > > > +       bool registered_fd;
> > > > +
> > > > +       int ring_fd;
> > > >         struct request *rq;
> > > >         void (*release)(void *);
> > > >  };
> > > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > > index 5f8ab130a573..701dd33fecf7 100644
> > > > --- a/io_uring/rsrc.c
> > > > +++ b/io_uring/rsrc.c
> > > > @@ -969,21 +969,6 @@ static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
> > > >         return 0;
> > > >  }
> > > >
> > > > -int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> > > > -                           struct io_buf_data *buf,
> > > > -                           unsigned int issue_flags)
> > > > -{
> > > > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > > > -       int ret;
> > > > -
> > > > -       io_ring_submit_lock(ctx, issue_flags);
> > > > -       ret = __io_buffer_register_bvec(ctx, buf);
> > > > -       io_ring_submit_unlock(ctx, issue_flags);
> > > > -
> > > > -       return ret;
> > > > -}
> > > > -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> > > > -
> > > >  static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> > > >                                        struct io_buf_data *buf)
> > > >  {
> > > > @@ -1006,19 +991,77 @@ static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
> > > >         return 0;
> > > >  }
> > > >
> > > > -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> > > > -                             struct io_buf_data *buf,
> > > > -                             unsigned int issue_flags)
> > > > +static inline int do_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > +                                   struct io_buf_data *buf,
> > > > +                                   unsigned int issue_flags,
> > > > +                                   bool reg)
> > > >  {
> > > > -       struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > > >         int ret;
> > > >
> > > >         io_ring_submit_lock(ctx, issue_flags);
> > > > -       ret = __io_buffer_unregister_bvec(ctx, buf);
> > > > +       if (reg)
> > > > +               ret = __io_buffer_register_bvec(ctx, buf);
> > > > +       else
> > > > +               ret = __io_buffer_unregister_bvec(ctx, buf);
> > >
> > > It feels like unifying __io_buffer_register_bvec() and
> > > __io_buffer_unregister_bvec() would belong better in the prior patch
> > > that changes their signatures.
> >
> > Can you share how to do above in previous patch?
> 
> I was thinking you could define do_reg_unreg_bvec() in the previous
> patch. It's a logical step once you've extracted out all the
> differences between io_buffer_register_bvec() and
> io_buffer_unregister_bvec() into the helpers
> __io_buffer_register_bvec() and __io_buffer_unregister_bvec(). But
> either way is fine.

'has_fd' and 'ring_fd' fields isn't added yet, the defined do_reg_unreg_bvec()
could be quite simple, looks no big difference, I can do that...

> 
> >
> > >
> > > >         io_ring_submit_unlock(ctx, issue_flags);
> > > >
> > > >         return ret;
> > > >  }
> > > > +
> > > > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > +                                   struct io_buf_data *buf,
> > > > +                                   unsigned int issue_flags,
> > > > +                                   bool reg)
> > > > +{
> > > > +       struct io_ring_ctx *remote_ctx = ctx;
> > > > +       struct file *file = NULL;
> > > > +       int ret;
> > > > +
> > > > +       if (buf->has_fd) {
> > > > +               file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
> > > > +               if (IS_ERR(file))
> > > > +                       return PTR_ERR(file);
> > >
> > > It would be good to avoid the overhead of this lookup and
> > > reference-counting in the I/O path. Would it be possible to move this
> > > lookup to when UBLK_IO_FETCH_REQ (and UBLK_IO_COMMIT_AND_FETCH_REQ, if
> > > it specifies a different ring_fd) is submitted? I guess that might
> > > require storing an extra io_ring_ctx pointer in struct ublk_io.
> >
> > Let's start from the flexible way & simple implementation.
> >
> > Any optimization & improvement can be done as follow-up.
> 
> Sure, we can start with this as-is. But I suspect the extra
> reference-counting here will significantly decrease the benefit of the
> auto-register register feature.

The reference-counting should only be needed for registering buffer to
external ring, which may have been slow because of the cross-ring thing...

Maybe we can start automatic buffer register for ubq_daemon context only,
meantime allow to register buffer from external io_uring by adding per-io
spin_lock, which may help the per-io task Uday is working on too.

And the interface still allow to support automatic buffer register to
external io_uring since `ublk_auto_buf_reg` includes 'flags' field, we can
enable it in future when efficient implementation is figured out.

What do you think of this approach?

> 
> >
> > Each command may register buffer to different io_uring context,
> > it can't be done in UBLK_IO_FETCH_REQ stage, because new IO with same
> > tag may register buffer to new io_uring context.
> 
> Right, if UBLK_IO_COMMIT_AND_FETCH_REQ specifies a different io_uring
> fd, then we'd have to look it up anew. But it seems likely that all
> UBLK_IO_COMMIT_AND_FETCH_REQs for a single tag will specify the same
> io_uring (certainly that's how our ublk server works). And in that
> case, the I/O could just reuse the io_uring context that was looked up
> for the prior UBLK_IO_(COMMIT_AND_)FETCH_REQ.

It is a special case, and one follow-up feature flag can help to
optimize this case only.


Thanks, 
Ming


