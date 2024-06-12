Return-Path: <io-uring+bounces-2167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C719047FF
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 02:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0877D1F23A66
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 00:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E37F391;
	Wed, 12 Jun 2024 00:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYCgJk9q"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D9764A
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 00:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718151744; cv=none; b=q/0UMpyxaM5uqi0FNaokDx9ooeIe3sl/ilnMt8xSbKXdMhdtQz63m8I3s0pb7tmqIL4DjflEz9ts+r4hgBeGfNxEgOVvdDgXvEHHJXef8j72fNdQHE9fUY4rWLBTs//RGjNn1mNGJ8joz22OwX1SjPkImjjIAF0Ps3P2sINnG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718151744; c=relaxed/simple;
	bh=1Oq7uWzOB/CtxkFvi7Oy9/x/1BoA9be4KYMj+KbSSXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMJQsjbBfx4Q3UiUDLVHF4457aRCOspHFJSqPInhGt3KfgbZMQs3yYbSx+ter5Y1oGB7aQFHIyrM210uxiaRutDBa3+qgUgJFrGMILKzvt/z4fwW0LkFTW5V/s588zEtz2LAlXYJuRdHgplqC1AlKfR1hsKcboeyuKsG8YfTxUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYCgJk9q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718151741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6m/s1j7JfiLAgujrqTYh/6UpGWIiGaquf8IHHLxyec=;
	b=CYCgJk9qub/jUnpqTl5ux6dXS5GVYYQzczjLm+Q637oXhZqN46gLJVmO4ihFzPMVFL48Xv
	Fav6ByZTmcOp/0h5viX7JOoBflC98OHNXiIqkbbxSCp7Gs4OpheZ5n+W+dQsEwFks72b7G
	cvQFeSP0v/CBCHJ0KkM5qqXMHWeUk04=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-iA2LVOBhN92gy0ZiGUnbtQ-1; Tue,
 11 Jun 2024 20:22:18 -0400
X-MC-Unique: iA2LVOBhN92gy0ZiGUnbtQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D107219560AB;
	Wed, 12 Jun 2024 00:22:16 +0000 (UTC)
Received: from fedora (unknown [10.72.112.75])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2D6C19560AD;
	Wed, 12 Jun 2024 00:22:12 +0000 (UTC)
Date: Wed, 12 Jun 2024 08:22:07 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V3 7/9] io_uring: support providing sqe group buffer
Message-ID: <ZmjqL+2JqBUSB5vZ@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-8-ming.lei@redhat.com>
 <ae3941f8-36a4-42fc-aaf8-027fe2de2d4d@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae3941f8-36a4-42fc-aaf8-027fe2de2d4d@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Jun 10, 2024 at 03:00:23AM +0100, Pavel Begunkov wrote:
> On 5/11/24 01:12, Ming Lei wrote:
> > SQE group with REQ_F_SQE_GROUP_DEP introduces one new mechanism to share
> > resource among one group of requests, and all member requests can consume
> > the resource provided by group lead efficiently in parallel.
> > 
> > This patch uses the added sqe group feature REQ_F_SQE_GROUP_DEP to share
> > kernel buffer in sqe group:
> > 
> > - the group lead provides kernel buffer to member requests
> > 
> > - member requests use the provided buffer to do FS or network IO, or more
> > operations in future
> > 
> > - this kernel buffer is returned back after member requests use it up
> > 
> > This way looks a bit similar with kernel's pipe/splice, but there are some
> > important differences:
> > 
> > - splice is for transferring data between two FDs via pipe, and fd_out can
> > only read data from pipe; this feature can borrow buffer from group lead to
> > members, so member request can write data to this buffer if the provided
> > buffer is allowed to write to.
> > 
> > - splice implements data transfer by moving pages between subsystem and
> > pipe, that means page ownership is transferred, and this way is one of the
> > most complicated thing of splice; this patch supports scenarios in which
> > the buffer can't be transferred, and buffer is only borrowed to member
> > requests, and is returned back after member requests consume the provided
> > buffer, so buffer lifetime is simplified a lot. Especially the buffer is
> > guaranteed to be returned back.
> > 
> > - splice can't run in async way basically
> > 
> > It can help to implement generic zero copy between device and related
> > operations, such as ublk, fuse, vdpa, even network receive or whatever.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/io_uring_types.h | 33 +++++++++++++++++++
> >   io_uring/io_uring.c            | 10 +++++-
> >   io_uring/io_uring.h            |  5 +++
> >   io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
> >   io_uring/kbuf.h                | 13 ++++++++
> >   io_uring/net.c                 | 31 +++++++++++++++++-
> >   io_uring/opdef.c               |  5 +++
> >   io_uring/opdef.h               |  2 ++
> >   io_uring/rw.c                  | 20 +++++++++++-
> >   9 files changed, 176 insertions(+), 3 deletions(-)
> > 
> ...
> > diff --git a/io_uring/net.c b/io_uring/net.c
> > index 070dea9a4eda..83fd5879082e 100644
> > --- a/io_uring/net.c
> > +++ b/io_uring/net.c
> > @@ -79,6 +79,13 @@ struct io_sr_msg {
> ...
> >   retry_bundle:
> >   	if (io_do_buffer_select(req)) {
> >   		struct buf_sel_arg arg = {
> > @@ -1132,6 +1148,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
> >   		if (unlikely(ret))
> >   			goto out_free;
> >   		sr->buf = NULL;
> > +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> > +		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
> > +				sr->len, ITER_DEST, &kmsg->msg.msg_iter);
> > +		if (unlikely(ret))
> > +			goto out_free;
> >   	}
> >   	kmsg->msg.msg_inq = -1;
> > @@ -1334,6 +1355,14 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
> >   		if (unlikely(ret))
> >   			return ret;
> >   		kmsg->msg.sg_from_iter = io_sg_from_iter;
> > +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> > +		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> > +
> > +		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
> > +				sr->len, ITER_SOURCE, &kmsg->msg.msg_iter);
> > +		if (unlikely(ret))
> > +			return ret;
> > +		kmsg->msg.sg_from_iter = io_sg_from_iter;
> 
> Not looking here too deeply I'm pretty sure it's buggy.
> The buffer can only be reused once the notification
> CQE completes, and there is nothing in regards to it.

OK. It isn't triggered in ublk-nbd because the buffer is still valid
until the peer reply is received, when the notification is definitely
ready.

I will remove send zc support in the enablement series, and it can
be added in future without much difficulty.


Thanks,
Ming


