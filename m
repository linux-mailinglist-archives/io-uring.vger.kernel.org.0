Return-Path: <io-uring+bounces-7789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 450C1AA4EF0
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 16:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28A127A825C
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 14:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8E725E45A;
	Wed, 30 Apr 2025 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R0nCTuj9"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6AD25EF84
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746024286; cv=none; b=Pqd2kZ5/NDKvX98YpJ0sLJ//ryMNHzJ4W+4GymNOWMhwhsNJ1NKObI/Fvc4P+8s89Zyt+HykiYm/qwN3eRT03m/+XT8LIpNeXbgcaa3ArTHg06cbsV4TPC1KsNwbaUcZdconVkyAwllOYWe2Zqvht6WFNSNkMp1uci326gq2Jz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746024286; c=relaxed/simple;
	bh=mQ1nUfr3r0AWtmrt9nX4KeiiUEY/U/ZQW81KloBmOLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIKv7HAaj8gJX3JR6lYxny7QFHFxU3vb7CwIKfqf95pDhGnxCHvugDOqGaG+SYJUHvNhSnJEqFjC5TVWXT9SCaEIaZJlVYzVOkIy12qOql/63Pgjs/xKK+2ktQy6krP6TpfWHeAVF4PtpYhuoiZE+mi+UqMiBRFmk3kvS4mFcDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R0nCTuj9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746024283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67X7e6EZg84mUYXBshhaXpQX/0XSaWfbYre1VLGYK3A=;
	b=R0nCTuj94ZlR/XwqdfnZ66/v9HwKNIY/rKJMcmqDAbz9NxHaWI1KgeHm+CQnM/TZ349Gsk
	OggvW63pLD2cWZdCmgeTkQXA2gee6wdYpsKAtRXyYpK01y2cZAhErhiqCXXHup7S/4JAXW
	N8hVPqAdI6nyv8SdF8Rck5Bj6KECs7E=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-bdODkDkmNCylVI9pdCZNRQ-1; Wed,
 30 Apr 2025 10:44:41 -0400
X-MC-Unique: bdODkDkmNCylVI9pdCZNRQ-1
X-Mimecast-MFC-AGG-ID: bdODkDkmNCylVI9pdCZNRQ_1746024279
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5239A1956086;
	Wed, 30 Apr 2025 14:44:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.59])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 221F318001D7;
	Wed, 30 Apr 2025 14:44:34 +0000 (UTC)
Date: Wed, 30 Apr 2025 22:44:29 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
Message-ID: <aBI3TfR1MBGR2K5m@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com>
 <aBAhr01KAr2qj5qi@fedora>
 <2ad7f153-9d22-43df-8b7d-3d098916c62b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ad7f153-9d22-43df-8b7d-3d098916c62b@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Apr 30, 2025 at 09:25:33AM +0100, Pavel Begunkov wrote:
> On 4/29/25 01:47, Ming Lei wrote:
> > On Mon, Apr 28, 2025 at 11:28:30AM +0100, Pavel Begunkov wrote:
> > > On 4/28/25 10:44, Ming Lei wrote:
> > > > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > > > supporting to register/unregister bvec buffer to specified io_uring,
> > > > which FD is usually passed from userspace.
> > > > 
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >    include/linux/io_uring/cmd.h |  4 ++
> > > >    io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
> > > >    2 files changed, 67 insertions(+), 20 deletions(-)
> > > > 
> > > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > > index 78fa336a284b..7516fe5cd606 100644
> > > > --- a/include/linux/io_uring/cmd.h
> > > > +++ b/include/linux/io_uring/cmd.h
> > > > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> > > ...
> > > >    	io_ring_submit_lock(ctx, issue_flags);
> > > > -	ret = __io_buffer_unregister_bvec(ctx, buf);
> > > > +	if (reg)
> > > > +		ret = __io_buffer_register_bvec(ctx, buf);
> > > > +	else
> > > > +		ret = __io_buffer_unregister_bvec(ctx, buf);
> > > >    	io_ring_submit_unlock(ctx, issue_flags);
> > > >    	return ret;
> > > >    }
> > > > +
> > > > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > > > +				    struct io_buf_data *buf,
> > > > +				    unsigned int issue_flags,
> > > > +				    bool reg)
> > > > +{
> > > > +	struct io_ring_ctx *remote_ctx = ctx;
> > > > +	struct file *file = NULL;
> > > > +	int ret;
> > > > +
> > > > +	if (buf->has_fd) {
> > > > +		file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
> > > 
> > > io_uring_register_get_file() accesses task private data and the request
> > > doesn't control from which task it's executed. IOW, you can't use the
> > > helper here. It can be iowq or sqpoll, but either way nothing is
> > > promised.
> > 
> > Good catch!
> > 
> > Actually ublk uring_cmd is guaranteed to be issued from user context.
> > 
> > We can enhance it by failing buffer register:
> > 
> > 	if ((current->flags & PF_KTHREAD) || (issue_flags & IO_URING_F_IOWQ))
> > 		return -EACCESS;
> 
> Can it somehow check that current matches the desired task? That's exactly
> the condition where it can go wrong, and that's much better than listing all
> corner cases that might change.
> 
> Just to avoid confusion, it's not guaranteed by io_uring it'll be run from
> the "right" task. If that changes in the future, either the ublk uapi should
> be mandating the user to fall back to something else like regular fds, or
> ublk will need to handle it somehow.

ublk does track the task context, and I will enhance the check for
registered ring fd in ublk driver side, and make sure that it won't be
used if the task context isn't ubq_daemon context.

If task context doesn't match, the uring command can be completed and ublk
server gets notified for handling the failure, such as, by sending register io buffer
command.

> 
> > > > +		if (IS_ERR(file))
> > > > +			return PTR_ERR(file);
> > > > +		remote_ctx = file->private_data;
> > > > +		if (!remote_ctx)
> > > > +			return -EINVAL;
> > > 
> > > nit: this check is not needed.
> > 
> > OK.
> > 
> > > 
> > > > +	}
> > > > +
> > > > +	if (remote_ctx == ctx) {
> > > > +		do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
> > > > +	} else {
> > > > +		if (!(issue_flags & IO_URING_F_UNLOCKED))
> > > > +			mutex_unlock(&ctx->uring_lock);
> > > 
> > > We shouldn't be dropping the lock in random helpers, for example
> > > it'd be pretty nasty suspending a submission loop with a submission
> > > from another task.
> > > 
> > > You can try lock first, if fails it'll need a fresh context via
> > > iowq to be task-work'ed into the ring. see msg_ring.c for how
> > > it's done for files.
> > 
> > Looks trylock is better, will take this approach by returning -EAGAIN,
> > and let ublk driver retry.
> 
> Is there a reliable fall back path for the userspace? Hammering the
> same thing until it succeeds in never a good option.

It is the simplest way to retry until it succeeds.

But we can improve it by retrying several times, if it still can't succeed,
complete the uring command and let ublk server send register buffer
command for registering the buffer manually.


thanks,
Ming


