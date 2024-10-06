Return-Path: <io-uring+bounces-3434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F53991D5A
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 10:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F016A1C20CB2
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 08:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85FF165F19;
	Sun,  6 Oct 2024 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rfs/xqW3"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42C5150990
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728204413; cv=none; b=VjSreRpc6QeQKsBnTXgQ2J0fBgEbccDwf4xfO4w8pbjgxqa4CLPbGIwh65HwqdeI4KozUDlXx+uj9najxtKnKYSXQqwAON5rw6yZuWAN2PlHXvaXis+F1tWEDgSSJ8C6pZgo2m67EoR1VHRVswvfeMkqyeO0XsjVfyU+BrK6XA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728204413; c=relaxed/simple;
	bh=uqfW9rXM7GrTBsQ3Q0S4AcJ1WSBxMnqaCCf0GV9ftO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mS7e7DzgfprVzesVr3qUC65wklm3TwU5T+zamd8f3i0lf9IK89sVW826IDirkcRzEuO/I4/EjVKHV0pzFfO6RqmxfMp/gh8hS3n+TEjJ4AhWYqLGgECQI5iw3nDN6Zi6eeMKWg+gQOSNKZ4Kri5juM0h/meFhKlwkgDj8QBV2Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rfs/xqW3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728204410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPZEDzzPn8i4/QTMQcUT212dbnR5LHqzOBSy1TzKWOY=;
	b=Rfs/xqW3nzuV4U/2t4VoAONeXHOHb4z1BjWtdIjMgrfZwf89PQJgP6Wp/2MLW6Hwl2FP7H
	CfOOzvR/esflldq9P3UIaYQSMQa5WobaqIQ1gr6coOq9FPZUWCly4ZD9ijOKl9QD1tgTOA
	dnB20fbhmtmnnf6BNPDH3mSMXkZWtCs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-zGLFebcFPmm6-XbHhO86Xg-1; Sun,
 06 Oct 2024 04:46:47 -0400
X-MC-Unique: zGLFebcFPmm6-XbHhO86Xg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73C5E19772C6;
	Sun,  6 Oct 2024 08:46:46 +0000 (UTC)
Received: from fedora (unknown [10.72.116.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 223EE3000198;
	Sun,  6 Oct 2024 08:46:41 +0000 (UTC)
Date: Sun, 6 Oct 2024 16:46:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
Message-ID: <ZwJObC6mzetw4goe@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
 <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 04, 2024 at 04:44:54PM +0100, Pavel Begunkov wrote:
> On 9/12/24 11:49, Ming Lei wrote:
> > Allow uring command to be group leader for providing kernel buffer,
> > and this way can support generic device zero copy over device buffer.
> > 
> > The following patch will use the way to support zero copy for ublk.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/io_uring/cmd.h  |  7 +++++++
> >   include/uapi/linux/io_uring.h |  7 ++++++-
> >   io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
> >   3 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > index 447fbfd32215..fde3a2ec7d9a 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -48,6 +48,8 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> >   void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> >   		unsigned int issue_flags);
> > +int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
> > +		const struct io_uring_kernel_buf *grp_kbuf);
> >   #else
> >   static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> >   			      struct iov_iter *iter, void *ioucmd)
> > @@ -67,6 +69,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> >   		unsigned int issue_flags)
> >   {
> >   }
> > +static inline int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
> > +		const struct io_uring_kernel_buf *grp_kbuf)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> >   #endif
> >   /*
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 2af32745ebd3..11985eeac10e 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -271,9 +271,14 @@ enum io_uring_op {
> >    * sqe->uring_cmd_flags		top 8bits aren't available for userspace
> >    * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
> >    *				along with setting sqe->buf_index.
> > + * IORING_PROVIDE_GROUP_KBUF	this command provides group kernel buffer
> > + *				for member requests which can retrieve
> > + *				any sub-buffer with offset(sqe->addr) and
> > + *				len(sqe->len)
> 
> Is there a good reason it needs to be a cmd generic flag instead of
> ublk specific?

io_uring request isn't visible for drivers, so driver can't know if the
uring command is one group leader.

Another way is to add new API of io_uring_cmd_may_provide_buffer(ioucmd)
so driver can check if device buffer can be provided with this uring_cmd,
but I prefer to the new uring_cmd flag:

- IORING_PROVIDE_GROUP_KBUF can provide device buffer in generic way.
- ->prep() can fail fast in case that it isn't one group request

> 
> 1. Extra overhead for files / cmds that don't even care about the
> feature.

It is just checking ioucmd->flags in ->prep(), and basically zero cost.

> 
> 2. As it stands with this patch, the flag is ignored by all other
> cmd implementations, which might be quite confusing as an api,
> especially so since if we don't set that REQ_F_GROUP_KBUF memeber
> requests will silently try to import a buffer the "normal way",

The usage is same with buffer select or fixed buffer, and consumer
has to check the flag.

And same with IORING_URING_CMD_FIXED which is ignored by other
implementations except for nvme, :-)

I can understand the concern, but it exits since uring cmd is born.

> i.e. interpret sqe->addr or such as the target buffer.

> 3. We can't even put some nice semantics on top since it's
> still cmd specific and not generic to all other io_uring
> requests.
> 
> I'd even think that it'd make sense to implement it as a
> new cmd opcode, but that's the business of the file implementing
> it, i.e. ublk.
> 
> >    */
> >   #define IORING_URING_CMD_FIXED	(1U << 0)
> > -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
> > +#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
> > +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_PROVIDE_GROUP_KBUF)

It needs one new file operation, and we shouldn't work toward
this way.



Thanks,
Ming


