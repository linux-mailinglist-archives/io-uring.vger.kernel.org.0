Return-Path: <io-uring+bounces-7200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CA0A6CA66
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 14:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AD7C188A861
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 13:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE931F8EEE;
	Sat, 22 Mar 2025 13:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UnQZl43B"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761D1E9907
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742651457; cv=none; b=A8mQFBUSy9U3QB0QBVvYhMEcPCERVY1+BGqlULTtTcNrntE52Qvoywh1b395g1BCc7PJ5MsDN1aHJKzC0O4rMmB256lWqB5HOxN1yyzjKHgroc+DGZQH9urLxdPRPHj+Qnu0aJDJXIlV/jcnIaFcTO3DBa12YNn6PAGqjV7fBrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742651457; c=relaxed/simple;
	bh=SL42mpQxWpOVoD8q9XJf5kFxnrFiZayq4czxIFAw4zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndENVQ7gMOefBNLiukBe8YzQ3Nf/2HcLNaXKodTy5e5GKidMo0YdgENaLqekTf5lqjVdRTYUFcVpeAzQMDz/gAU93FQ3qeV62P+Ld5/iEHz1WRPuGZ8UOh0bjA3B8Eyd7TtBfxSF1u4geOHCf5s7G7FvmQk5sDwwQZwX66wpCVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UnQZl43B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742651452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=05614ULnI1KQttOcKLmxexxB7yhTuSQdYOQtOKcUV98=;
	b=UnQZl43B2NOmPkp/iULWYs8YhB39P2JrcycztyTxp+mWgMLnYT296hMOUvhUJxu2GVPrNF
	nP0nm7BgtKAgkUxjpeCtAoDNQ8FalZrfFUUkUSR6C4xZOtHmS6ZGFJh6MflaazejDrt3aG
	z4TVxXCrMOQK0pRP71jal0tqqckjR4k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-WHXNd8CoMxuFA-kx8RWunA-1; Sat,
 22 Mar 2025 09:50:49 -0400
X-MC-Unique: WHXNd8CoMxuFA-kx8RWunA-1
X-Mimecast-MFC-AGG-ID: WHXNd8CoMxuFA-kx8RWunA_1742651448
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0DE918004A9;
	Sat, 22 Mar 2025 13:50:47 +0000 (UTC)
Received: from fedora (unknown [10.72.120.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49099195609D;
	Sat, 22 Mar 2025 13:50:42 +0000 (UTC)
Date: Sat, 22 Mar 2025 21:50:37 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
Message-ID: <Z97ALTDd-s0-uT7O@fedora>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Sat, Mar 22, 2025 at 12:02:02PM +0000, Pavel Begunkov wrote:
> On 3/22/25 07:56, Ming Lei wrote:
> > So far fixed kernel buffer is only used for FS read/write, in which
> > the remained bytes need to be zeroed in case of short read, otherwise
> > kernel data may be leaked to userspace.
> 
> Can you remind me, how that can happen? Normally, IIUC, you register
> a request filled with user pages, so no kernel data there. Is it some
> bounce buffers?

For direct io, it is filled with user pages, but it can be buffered IO,
and the page can be mapped to userspace.

> 
> > Add two helpers for fixing this issue, meantime replace one check
> > with io_use_fixed_kbuf().
> > 
> > Cc: Caleb Sander Mateos <csander@purestorage.com>
> > Cc: Keith Busch <kbusch@kernel.org>
> > Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> ...
> > +/* zero remained bytes of kernel buffer for avoiding to leak data */
> > +static inline void io_req_zero_remained(struct io_kiocb *req,
> > +					struct iov_iter *iter)
> > +{
> > +	size_t left = iov_iter_count(iter);
> > +
> > +	if (left > 0 && iov_iter_rw(iter) == READ)
> > +		iov_iter_zero(left, iter);
> > +}
> > +
> >   #endif
> > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > index 039e063f7091..67dc1a6710c9 100644
> > --- a/io_uring/rw.c
> > +++ b/io_uring/rw.c
> > @@ -541,6 +541,12 @@ static void __io_complete_rw_common(struct io_kiocb *req, long res)
> >   	} else {
> >   		req_set_fail(req);
> >   		req->cqe.res = res;
> > +
> > +		if (io_use_fixed_kbuf(req)) {
> > +			struct io_async_rw *io = req->async_data;
> > +
> > +			io_req_zero_remained(req, &io->iter);
> > +		}
> 
> I think it can be exploited. It's called from ->ki_complete, i.e.
> io_complete_rw, so make the request size enough, if you're stuck
> copying in [soft]irq for too long.

Short read seldom happens, so how it can be exploited? And the request size
can't be too big in this(ublk) use case.

Thanks,
Ming


