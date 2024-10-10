Return-Path: <io-uring+bounces-3545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C50997B41
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 05:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6109D284261
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 03:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874684F881;
	Thu, 10 Oct 2024 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXJmC28b"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B983C3839C
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 03:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728530948; cv=none; b=jD0Zeabr4yO3wEAIdOBXRGKNh2iyG7DEoAR2jMXPyxdeTmmf2EhhJceD4snCG0a7ajsGnFG4T2L13c3Q/89dIejFOIVgfiOL/y/9X4hIGeOPdu6PmUm7px7yImWrQ/FUuLiXN3P7n/aGpIUllg6dU3e25PFHxZs8a5RPoJZjg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728530948; c=relaxed/simple;
	bh=wbKnTIdHZ/Nkf7T9fW3db0yncs3ELsxTmQkB6iNVmuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6p9nFtHMLI5HjqgQsNPOPbSw9aN1HBdI53Wi8YEESjlBdPI7sVMXAreuoR1G7mmv5hlK8odInJc5N7jiYnPKi3dMvufhjD9gUldd5nGs6NjNo04WS6rLwqOA5Qjr/GUgIp8fH8N8WMRAspYDF/E9aPVrEvq9XL+gquZCGiS0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXJmC28b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728530945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GmEXZEOcyZc/0SvFdsLbRoOtB7u4YK1Mc4GQkCkUhC4=;
	b=YXJmC28bbGzpFyNmmSXpluVNxxwpQCTaqYYMGLCisP8oFkbQ190hDME0RNsXSEGk4EaG7m
	faxrjJQNovD4X4Ucy+gc4ZLa3984ZsYYSQGSVYnYk++8u7WjF7Jc7IaRkmjcQjlfwgomoE
	DDm9/gUB5tyui967HHK6wCKYIpbyYAU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-3IBhojX7MPaIpC1onoH-Xg-1; Wed,
 09 Oct 2024 23:29:02 -0400
X-MC-Unique: 3IBhojX7MPaIpC1onoH-Xg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 466B61956080;
	Thu, 10 Oct 2024 03:29:01 +0000 (UTC)
Received: from fedora (unknown [10.72.116.47])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B5F219560AA;
	Thu, 10 Oct 2024 03:28:56 +0000 (UTC)
Date: Thu, 10 Oct 2024 11:28:46 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
Message-ID: <ZwdJ7sDuHhWT61FR@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
 <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
 <ZwJObC6mzetw4goe@fedora>
 <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Oct 09, 2024 at 04:14:33PM +0100, Pavel Begunkov wrote:
> On 10/6/24 09:46, Ming Lei wrote:
> > On Fri, Oct 04, 2024 at 04:44:54PM +0100, Pavel Begunkov wrote:
> > > On 9/12/24 11:49, Ming Lei wrote:
> > > > Allow uring command to be group leader for providing kernel buffer,
> > > > and this way can support generic device zero copy over device buffer.
> > > > 
> > > > The following patch will use the way to support zero copy for ublk.
> > > > 
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >    include/linux/io_uring/cmd.h  |  7 +++++++
> > > >    include/uapi/linux/io_uring.h |  7 ++++++-
> > > >    io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
> > > >    3 files changed, 41 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > > index 447fbfd32215..fde3a2ec7d9a 100644
> > > > --- a/include/linux/io_uring/cmd.h
> > > > +++ b/include/linux/io_uring/cmd.h
> > > > @@ -48,6 +48,8 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> > > >    void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > > >    		unsigned int issue_flags);
> > > > +int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
> > > > +		const struct io_uring_kernel_buf *grp_kbuf);
> > > >    #else
> > > >    static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > > >    			      struct iov_iter *iter, void *ioucmd)
> > > > @@ -67,6 +69,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > > >    		unsigned int issue_flags)
> > > >    {
> > > >    }
> > > > +static inline int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
> > > > +		const struct io_uring_kernel_buf *grp_kbuf)
> > > > +{
> > > > +	return -EOPNOTSUPP;
> > > > +}
> > > >    #endif
> > > >    /*
> > > > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > > > index 2af32745ebd3..11985eeac10e 100644
> > > > --- a/include/uapi/linux/io_uring.h
> > > > +++ b/include/uapi/linux/io_uring.h
> > > > @@ -271,9 +271,14 @@ enum io_uring_op {
> > > >     * sqe->uring_cmd_flags		top 8bits aren't available for userspace
> > > >     * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
> > > >     *				along with setting sqe->buf_index.
> > > > + * IORING_PROVIDE_GROUP_KBUF	this command provides group kernel buffer
> > > > + *				for member requests which can retrieve
> > > > + *				any sub-buffer with offset(sqe->addr) and
> > > > + *				len(sqe->len)
> > > 
> > > Is there a good reason it needs to be a cmd generic flag instead of
> > > ublk specific?
> > 
> > io_uring request isn't visible for drivers, so driver can't know if the
> > uring command is one group leader.
> 
> btw, does it have to be in a group at all? Sure, nobody would be
> able to consume the buffer, but otherwise should be fine.
> 
> > Another way is to add new API of io_uring_cmd_may_provide_buffer(ioucmd)
> 
> The checks can be done inside of io_uring_cmd_provide_kbuf()

Yeah.

Now the difference is just that:

- user may know it explicitly(UAPI flag) or implicitly(driver's ->cmd_op),
- if driver knows this uring_cmd is one group leader

I am fine with either way.

> 
> > so driver can check if device buffer can be provided with this uring_cmd,
> > but I prefer to the new uring_cmd flag:
> > 
> > - IORING_PROVIDE_GROUP_KBUF can provide device buffer in generic way.
> 
> Ok, could be.
> 
> > - ->prep() can fail fast in case that it isn't one group request
> 
> I don't believe that matters, a behaving user should never
> see that kind of failure.
> 
> 
> > > 1. Extra overhead for files / cmds that don't even care about the
> > > feature.
> > 
> > It is just checking ioucmd->flags in ->prep(), and basically zero cost.
> 
> It's not if we add extra code for each every feature, at
> which point it becomes a maze of such "ifs".

Yeah, I guess it can't be avoided in current uring_cmd design, which
serves for different subsystems now, and more in future.

And the situation is similar with ioctl.

> 
> > > 2. As it stands with this patch, the flag is ignored by all other
> > > cmd implementations, which might be quite confusing as an api,
> > > especially so since if we don't set that REQ_F_GROUP_KBUF memeber
> > > requests will silently try to import a buffer the "normal way",
> > 
> > The usage is same with buffer select or fixed buffer, and consumer
> > has to check the flag.
> 
> We fails requests when it's asked to use the feature but
> those are not supported, at least non-cmd requests.
> 
> > And same with IORING_URING_CMD_FIXED which is ignored by other
> > implementations except for nvme, :-)
> 
> Oh, that's bad. If you'd try to implement the flag in the
> future it might break the uapi. It might be worth to patch it
> up on the ublk side, i.e. reject the flag, + backport, and hope
> nobody tried to use them together, hmm?
> 
> > I can understand the concern, but it exits since uring cmd is born.
> > 
> > > i.e. interpret sqe->addr or such as the target buffer.
> > 
> > > 3. We can't even put some nice semantics on top since it's
> > > still cmd specific and not generic to all other io_uring
> > > requests.
> > > 
> > > I'd even think that it'd make sense to implement it as a
> > > new cmd opcode, but that's the business of the file implementing
> > > it, i.e. ublk.
> > > 
> > > >     */
> > > >    #define IORING_URING_CMD_FIXED	(1U << 0)
> > > > -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
> > > > +#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
> > > > +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_PROVIDE_GROUP_KBUF)
> > 
> > It needs one new file operation, and we shouldn't work toward
> > this way.
> 
> Not a new io_uring request, I rather meant sqe->cmd_op,
> like UBLK_U_IO_FETCH_REQ_PROVIDER_BUFFER.

`cmd_op` is supposed to be defined by subsystems, but maybe we can
reserve some for generic uring_cmd. Anyway this shouldn't be one big
deal, we can do that in future if there are more such uses.


Thanks,
Ming


