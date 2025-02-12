Return-Path: <io-uring+bounces-6353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E3CA32209
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 10:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F9C18891A3
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 09:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224F5205ADD;
	Wed, 12 Feb 2025 09:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DH3q57ac"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E30205E1C
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 09:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739352296; cv=none; b=pW0pHTWft/gIq/bmhFDFS83u1nhzZ1DjFiKwK1N8m+YUoHZ/l1jw4cQADIufBMm2YiS+hvQbx0IQL0qMD9/HUSpMKw7L+hleewDX9/YAZ/PrEpDzNeaSLogeyMk5C/C24hkFkOqplTo+pqEcOwhcNxNH8Tdw9Xto6swoJ7gtHD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739352296; c=relaxed/simple;
	bh=GCOhmjqh6jc6SmwlT3AIKdtngTBk1T5OV3BHdpRLGbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEeRQIMUorFYbPniDlmq5faxQu6NQn+53+MrzYjqaGYYIT/zrHPbRN6J6fpt6b5ogC/EpjDjWbNf4/Wqa/Ul3EjPIJRlNAL6jSBYp42AL0uyU/UUMYHwvlNybt9UAZzs1wWQSinJmSwL8Wts193zHA+BAgDdilCZ4BkMYkmvgvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DH3q57ac; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739352293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SYJ9orynFCdaDzZq+D4S9a2qhPf5BpjIKAJMG6yIzLE=;
	b=DH3q57acN+O19GCVmKrOt/IWTHTGGuvCeL4A5W5RqaIRzgEj0XA8v3N05GBik3DWU5IV+P
	4cUFRjEatDzGQ676uo3RwpOVurT+q4atQTqr/0tZhXXlAn8pE4pkmlHbE0Lv2fe/vdKHJd
	tbsyX2lxiY+yUoOP9aEnU3C+58nQTEA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-TcePJH9HPQiXt_SKY9plUw-1; Wed,
 12 Feb 2025 04:24:48 -0500
X-MC-Unique: TcePJH9HPQiXt_SKY9plUw-1
X-Mimecast-MFC-AGG-ID: TcePJH9HPQiXt_SKY9plUw_1739352285
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A26561955E94;
	Wed, 12 Feb 2025 09:24:45 +0000 (UTC)
Received: from fedora (unknown [10.72.116.60])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BE40195608D;
	Wed, 12 Feb 2025 09:24:39 +0000 (UTC)
Date: Wed, 12 Feb 2025 17:24:34 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 4/6] ublk: zc register/unregister bvec
Message-ID: <Z6xo0mhJDRa0eaxv@fedora>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-5-kbusch@meta.com>
 <Z6wMK5WxvS_MzLh3@fedora>
 <Z6wfXijUX_6Q3HiC@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wfXijUX_6Q3HiC@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Feb 11, 2025 at 09:11:10PM -0700, Keith Busch wrote:
> On Wed, Feb 12, 2025 at 10:49:15AM +0800, Ming Lei wrote:
> > On Mon, Feb 10, 2025 at 04:56:44PM -0800, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > Provide new operations for the user to request mapping an active request
> > > to an io uring instance's buf_table. The user has to provide the index
> > > it wants to install the buffer.
> > > 
> > > A reference count is taken on the request to ensure it can't be
> > > completed while it is active in a ring's buf_table.
> > > 
> > > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > > ---
> > >  drivers/block/ublk_drv.c      | 145 +++++++++++++++++++++++++---------
> > >  include/uapi/linux/ublk_cmd.h |   4 +
> > >  2 files changed, 113 insertions(+), 36 deletions(-)
> > > 
> > > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > > index 529085181f355..ccfda7b2c24da 100644
> > > --- a/drivers/block/ublk_drv.c
> > > +++ b/drivers/block/ublk_drv.c
> > > @@ -51,6 +51,9 @@
> > >  /* private ioctl command mirror */
> > >  #define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
> > >  
> > > +#define UBLK_IO_REGISTER_IO_BUF		_IOC_NR(UBLK_U_IO_REGISTER_IO_BUF)
> > > +#define UBLK_IO_UNREGISTER_IO_BUF	_IOC_NR(UBLK_U_IO_UNREGISTER_IO_BUF)
> > 
> > UBLK_IO_REGISTER_IO_BUF command may be completed, and buffer isn't used
> > by RW_FIXED yet in the following cases:
> > 
> > - application doesn't submit any RW_FIXED consumer OP
> > 
> > - io_uring_enter() only issued UBLK_IO_REGISTER_IO_BUF, and the other
> >   OPs can't be issued because of out of resource 
> > 
> > ...
> > 
> > Then io_uring_enter() returns, and the application is panic or killed,
> > how to avoid buffer leak?
> 
> The death of the uring that registered the node tears down the table
> that it's registered with, which releases its reference. All good.

OK, looks I miss the point.

io_sqe_buffers_unregister() is called from io_ring_ctx_free(), when the
registered buffer can be released.

However, it still may cause use-after-free on this request which has
been failed from io_uring_try_cancel_uring_cmd(), and please see the
following code path:

io_uring_try_cancel_requests
	io_uring_try_cancel_uring_cmd
		ublk_uring_cmd_cancel_fn
			ublk_abort_requests
				ublk_abort_queue
					__ublk_fail_req
						ublk_put_req_ref

The above race needs to be covered.

>  
> > It need to deal with in io_uring cancel code for calling ->release() if
> > the kbuffer node isn't released.
> 
> There should be no situation here where it isn't released after its use
> is completed. Either the resource was gracefully unregistered or the
> ring close while it was still active, but either one drops its
> reference.
> 
> > UBLK_IO_UNREGISTER_IO_BUF still need to call ->release() if the node
> > buffer isn't used.
> 
> Only once the last reference is dropped. Which should happen no matter
> which way the node is freed.
> 
> > > +static void ublk_io_release(void *priv)
> > > +{
> > > +	struct request *rq = priv;
> > > +	struct ublk_queue *ubq = rq->mq_hctx->driver_data;
> > > +
> > > +	ublk_put_req_ref(ubq, rq);
> > > +}
> > 
> > It isn't enough to just get & put request reference here between registering
> > buffer and freeing the registered node buf, because the same reference can be
> > dropped from ublk_commit_completion() which is from queueing
> > UBLK_IO_COMMIT_AND_FETCH_REQ, and buggy app may queue this command multiple
> > times for freeing the request.
> > 
> > One solution is to not allow request completion until the ->release() is
> > returned.
> 
> Double completions are tricky because the same request id can be reused
> pretty quickly and there's no immediate way to tell if the 2nd
> completion is a double or a genuine completion of the reused request.
> 
> We have rotating sequence numbers in the nvme driver to try to detect a
> similar situation. So far it hasn't revealed any real bugs as far as I
> know. This feels like the other side screwed up and that's their fault.

Not same with nvme, in which nvme controller won't run DMA on this buffer
after the 1st completion.

The ublk request buffer has been leased to io_uring for running read_fixed/write_fixed,
meantime it is freed and reused by kernel for other purpose.

As I mentioned, it can be solved by not allowing to complete the IO
command if the buffer is leased to io_uring.


Thanks,
Ming


