Return-Path: <io-uring+bounces-1096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D072387E90C
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 12:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E7632828B8
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 11:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90855374FE;
	Mon, 18 Mar 2024 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQeWKvYk"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F59364DA
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710763187; cv=none; b=mcPfIWdgiKLUe/ZipLtYq/+oPz4IOo7cHDdd4YCgle0AansjlZzoDtAZiKegdQo4f1jD0TitfXhKBAJ/5xP2ktN/oef464LHCjkbEPShX4zeHGP8HK4Ohhf4KSERCvvaeypFWQrUf37UReKyYzkbps+RDM62DrhL1toecUvtrbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710763187; c=relaxed/simple;
	bh=h5vAQKw9xAoeeoV4ibELgkwYu3pGNUDsQF4DyNboEfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2nRJl2QZKuTvWboQQsPunhwFbDrcbWbUmQiXfyWGbGuzG3SvOOA03IWD5eiK7GVg8VgJ00uxPGQWqcU/NxGrumlNen2DKmtnO9997BVMqSr5mfoOoapUq6OvboUNHPRcH7CIXC1dj2bF4KlJJXD7DcbYGyXu6Ivs0KcpmwgXiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQeWKvYk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710763184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0APy/jjMITjgNsF6VuS2jEmHbNTpvbU6W1e1/+F4zs=;
	b=PQeWKvYk4AGeHXZcxk1HxoiMPJHE2pelCnXcw+OT4afx0a+9dSMxPXIuHGwBQSlH+d+LBF
	GhD9MDZ06hx0NNBD7ikxdE6VxhEMMNPS1URei1G1k4TVHvc73McJliafRZA5rfcXmAyCwW
	wM6KZCyxbrTja/h5PKSz8K3CI0vXfOI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-8WFpLqVLOjC-DfLZXhQ8Gw-1; Mon,
 18 Mar 2024 07:59:43 -0400
X-MC-Unique: 8WFpLqVLOjC-DfLZXhQ8Gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C08C1C2CDE2;
	Mon, 18 Mar 2024 11:59:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5B6840C6DB3;
	Mon, 18 Mar 2024 11:59:39 +0000 (UTC)
Date: Mon, 18 Mar 2024 19:59:15 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 03/14] io_uring/cmd: make io_uring_cmd_done irq safe
Message-ID: <Zfgsk8mND0cah3DP@fedora>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <faeec0d1e7c740a582f51f80626f61c745ed9a52.1710720150.git.asml.silence@gmail.com>
 <Zff25z0fPGBPfJs1@fedora>
 <4c6a5b55-2833-4ef7-a514-577fe61160dd@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6a5b55-2833-4ef7-a514-577fe61160dd@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Mon, Mar 18, 2024 at 11:50:32AM +0000, Pavel Begunkov wrote:
> On 3/18/24 08:10, Ming Lei wrote:
> > On Mon, Mar 18, 2024 at 12:41:48AM +0000, Pavel Begunkov wrote:
> > > io_uring_cmd_done() is called from the irq context and is considered to
> > > be irq safe, however that's not the case if the driver requires
> > > cancellations because io_uring_cmd_del_cancelable() could try to take
> > > the uring_lock mutex.
> > > 
> > > Clean up the confusion, by deferring cancellation handling to
> > > locked task_work if we came into io_uring_cmd_done() from iowq
> > > or other IO_URING_F_UNLOCKED path.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >   io_uring/uring_cmd.c | 24 +++++++++++++++++-------
> > >   1 file changed, 17 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > index ec38a8d4836d..9590081feb2d 100644
> > > --- a/io_uring/uring_cmd.c
> > > +++ b/io_uring/uring_cmd.c
> > > @@ -14,19 +14,18 @@
> > >   #include "rsrc.h"on   #include "uring_cmd.h"
> > > -static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
> > > -		unsigned int issue_flags)
> > > +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
> > >   {
> > >   	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> > >   	struct io_ring_ctx *ctx = req->ctx;
> > > +	lockdep_assert_held(&ctx->uring_lock);
> > > +
> > >   	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
> > >   		return;
> > >   	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
> > > -	io_ring_submit_lock(ctx, issue_flags);
> > >   	hlist_del(&req->hash_node);
> > > -	io_ring_submit_unlock(ctx, issue_flags);
> > >   }
> > >   /*
> > > @@ -44,6 +43,9 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > >   	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> > >   	struct io_ring_ctx *ctx = req->ctx;
> > > +	if (WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL))
> > > +		return;
> > > +
> > 
> > This way limits cancelable command can't be used in iopoll context, and
> > it isn't reasonable, and supporting iopoll has been in ublk todo list,
> > especially single ring context is shared for both command and normal IO.
> 
> That's something that can be solved when it's needed, and hence the
> warning so it's not missed. That would need del_cancelable on the
> ->iopoll side, but depends on the "leaving in cancel queue"
> problem resolution.

The current code is actually working with iopoll, so adding the warning
can be one regression. Maybe someone has been using ublk with iopoll.


Thanks,
Ming


