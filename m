Return-Path: <io-uring+bounces-7768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CC3A9FE91
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 817B1189F63B
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0653D561;
	Tue, 29 Apr 2025 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BwGuPXtr"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB3C184E
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887682; cv=none; b=JI3oSWHdIR4C3UWhe03SqK9nStBtqgAegkUQzyAj2NTJzXuOrLYxF3X99sqZY7cepdbHCmCczvUmevYppRD4PxCp+ylKxMkxfJNaXD+H+waMCNmDEDiVdKK6oFr3RH9nREPvX1ZvZHGQa1F2IHWXYdc1Qpd+bwt4chXLoePQ1f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887682; c=relaxed/simple;
	bh=t1DQLE8dSNi+GWL/fzjgxlxd5l0RoYYMxlCxV7Hxhr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvXA+oU148IhDONGspq7luBolhdUkFFIvHVRgvEdXh7qd0DnwWo/8FewZUjd2gtL4nvozhSUkiIu3LB2bhcNTFj7IGf6LFaAO7BUsBJF2yjdue7Wt6DYX9S/8PubgBiAKxYX3RfrO+kMSEMT4jHHDyK35BUsmMkzhpqUwswcpWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BwGuPXtr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745887678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+VqWWCiV5NuLVBveYZvEqyUNB76/UuHJEbLtYimF1CY=;
	b=BwGuPXtr8G0DaOlDpCGl3bASBST57YW653BCTe8+ZofvT5dd1DnzGxyeb/Yqo6sZQ4zjHG
	H2Nnw7siWiA7UORfULltPw5ix3ahIqzS6eappQl4w6EuSoZYyGgxtX79i/9UGdVPl5XQRu
	f/CN/2mWWHPgyzuYlXklkSIFLwUso1o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-awnAyD0vM0KxwrZoa-xG5g-1; Mon,
 28 Apr 2025 20:47:57 -0400
X-MC-Unique: awnAyD0vM0KxwrZoa-xG5g-1
X-Mimecast-MFC-AGG-ID: awnAyD0vM0KxwrZoa-xG5g_1745887675
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4697A1800360;
	Tue, 29 Apr 2025 00:47:55 +0000 (UTC)
Received: from fedora (unknown [10.72.116.57])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C51430001A2;
	Tue, 29 Apr 2025 00:47:48 +0000 (UTC)
Date: Tue, 29 Apr 2025 08:47:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
Message-ID: <aBAhr01KAr2qj5qi@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Apr 28, 2025 at 11:28:30AM +0100, Pavel Begunkov wrote:
> On 4/28/25 10:44, Ming Lei wrote:
> > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > supporting to register/unregister bvec buffer to specified io_uring,
> > which FD is usually passed from userspace.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/io_uring/cmd.h |  4 ++
> >   io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
> >   2 files changed, 67 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > index 78fa336a284b..7516fe5cd606 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> ...
> >   	io_ring_submit_lock(ctx, issue_flags);
> > -	ret = __io_buffer_unregister_bvec(ctx, buf);
> > +	if (reg)
> > +		ret = __io_buffer_register_bvec(ctx, buf);
> > +	else
> > +		ret = __io_buffer_unregister_bvec(ctx, buf);
> >   	io_ring_submit_unlock(ctx, issue_flags);
> >   	return ret;
> >   }
> > +
> > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > +				    struct io_buf_data *buf,
> > +				    unsigned int issue_flags,
> > +				    bool reg)
> > +{
> > +	struct io_ring_ctx *remote_ctx = ctx;
> > +	struct file *file = NULL;
> > +	int ret;
> > +
> > +	if (buf->has_fd) {
> > +		file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
> 
> io_uring_register_get_file() accesses task private data and the request
> doesn't control from which task it's executed. IOW, you can't use the
> helper here. It can be iowq or sqpoll, but either way nothing is
> promised.

Good catch!

Actually ublk uring_cmd is guaranteed to be issued from user context.

We can enhance it by failing buffer register:

	if ((current->flags & PF_KTHREAD) || (issue_flags & IO_URING_F_IOWQ))
		return -EACCESS;

> 
> > +		if (IS_ERR(file))
> > +			return PTR_ERR(file);
> > +		remote_ctx = file->private_data;
> > +		if (!remote_ctx)
> > +			return -EINVAL;
> 
> nit: this check is not needed.

OK.

> 
> > +	}
> > +
> > +	if (remote_ctx == ctx) {
> > +		do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
> > +	} else {
> > +		if (!(issue_flags & IO_URING_F_UNLOCKED))
> > +			mutex_unlock(&ctx->uring_lock);
> 
> We shouldn't be dropping the lock in random helpers, for example
> it'd be pretty nasty suspending a submission loop with a submission
> from another task.
> 
> You can try lock first, if fails it'll need a fresh context via
> iowq to be task-work'ed into the ring. see msg_ring.c for how
> it's done for files.

Looks trylock is better, will take this approach by returning -EAGAIN,
and let ublk driver retry.


Thanks, 
Ming


