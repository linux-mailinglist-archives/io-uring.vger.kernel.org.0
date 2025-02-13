Return-Path: <io-uring+bounces-6401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DABA334FD
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 02:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B51A9188B0F6
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 01:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528481372;
	Thu, 13 Feb 2025 01:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7lwd7uk"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90220126C05
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 01:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739411561; cv=none; b=F4ylPgIEJD2UD3DIe1G0ePTxwYI1wD/SIa/imuf38OdwpVeQ4gBGNyErdvqFAcLoJ3R4YayDIu0cs25NypTa0bep1aKTGPls/BXEfchLMii41ci34aLQKU4rya9zJ4UJSalCrqfi6srT0mM6r5+HuuONTl7oABJcXoYB8oKpuP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739411561; c=relaxed/simple;
	bh=AeGapwkhvPvPhgYEa6rrgGRPmtorswQb7GglQAbQWAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUAuouTVaH5SbW/d3lIkEWi8LBZfrR32sokROmVnmSY4pbZ2/sysAGe9ifvKZjsQTBb9bBsK0Imr7inLWQHMwO0lDUS+NRxLVex+pHSF5G5W7ZSCHbGBWic/nOLz3Dz1QBXyXg5y6maaxWbJPn21G1Dx5ms1SOg1Wc9UusDodRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7lwd7uk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739411558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ePuqci4m5ViNOkBFwnEGnbQCT7x5ZRRGM+8649zXR44=;
	b=Q7lwd7ukgl/KPUMqK+jsAzg+kIleA9SqLMdIhtiVlL0+jsfBBrNkcv8u0RT8rh1WjhDJYk
	D84AiBgBqkR5badYL4ji47sLDOx9wkK3pY8ARR9GsXbfeMxeQsQQ94xe9Dw38dT5n5YeJK
	RKNjD3YUsQ6T6au3kmCrFKgM6DAwJx4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-PRlBzJZaPz6Yj9RQGCQQXg-1; Wed,
 12 Feb 2025 20:52:32 -0500
X-MC-Unique: PRlBzJZaPz6Yj9RQGCQQXg-1
X-Mimecast-MFC-AGG-ID: PRlBzJZaPz6Yj9RQGCQQXg_1739411551
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA98B1800875;
	Thu, 13 Feb 2025 01:52:30 +0000 (UTC)
Received: from fedora (unknown [10.72.120.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33453180034D;
	Thu, 13 Feb 2025 01:52:24 +0000 (UTC)
Date: Thu, 13 Feb 2025 09:52:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com
Subject: Re: [PATCHv2 0/6] ublk zero-copy support
Message-ID: <Z61QU-qxgYhFGQwl@fedora>
References: <20250211005646.222452-1-kbusch@meta.com>
 <Z6wHjGFcFCLMnUez@fedora>
 <Z6y-M7cby-ZAoLzY@kbusch-mbp>
 <7c2c2668-4f23-41d9-9cdf-c8ddd1f13f7c@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c2c2668-4f23-41d9-9cdf-c8ddd1f13f7c@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 12, 2025 at 04:06:58PM +0000, Pavel Begunkov wrote:
> On 2/12/25 15:28, Keith Busch wrote:
> > On Wed, Feb 12, 2025 at 10:29:32AM +0800, Ming Lei wrote:
> > > It is explained in the following links:
> > > 
> > > https://lore.kernel.org/linux-block/b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com/
> > > 
> > > - node kbuffer is registered in ublk uring_cmd's ->issue(), but lookup
> > >    in RW_FIXED OP's ->prep(), and ->prep() is always called before calling
> > >    ->issue() when the two are submitted in same io_uring_enter(), so you
> > >    need to move io_rsrc_node_lookup() & buffer importing from RW_FIXED's ->prep()
> > >    to ->issue() first.
> > 
> > I don't think that's accurate, at least in practice. In a normal flow,
> > we'll have this sequence:
> > 
> >   io_submit_sqes
> >     io_submit_sqe (uring_cmd ublk register)
> >       io_init_req
> >         ->prep()
> >       io_queue_sqe
> >         ->issue()
> >     io_submit_sqe (read/write_fixed)
> >       io_init_req
> >         ->prep()
> >       io_queue_sqe
> >        ->issue()
> > 
> > The first SQE is handled in its entirety before even looking at the
> > subsequent SQE. Since the register is first, then the read/write_fixed's
> > prep will have a valid index. Testing this patch series appears to show
> > this reliably works.
> 
> Ming describes how it works for links. This one is indeed how
> non links are normally executed. Though I'd repeat it's an
> implementation detail and not a part of the uapi. Interestingly,
> Keith, you sent some patches changing the ordering here quite a
> while ago, just as an example of how it can change.

My fault, I should have provided the link or async background.

> 
> 
> > > - secondly, ->issue() order is only respected by IO_LINK, and io_uring
> > >    can't provide such guarantee without using IO_LINK:
> > > 
> > >    Pavel explained it in the following link:
> > > 
> > >    https://lore.kernel.org/linux-block/68256da6-bb13-4498-a0e0-dce88bb32242@gmail.com/
> > > 
> > >    There are also other examples, such as, register buffer stays in one
> > >    link chain, and the consumer OP isn't in this chain, the consumer OP
> > >    can still be issued before issuing register_buffer.
> > 
> > Yep, I got that. Linking is just something I was hoping to avoid. I
> > understand there are conditions that can break the normal flow I'm
> > relying on regarding  the ordering. This hasn't appeared to be a problem
> > in practice, but I agree this needs to be handled.

LINK/ASYNC needs to be supported, and sometimes they are useful.

- IO_LINK is the only way for respecting IO order

  io_uring only supports non-link or link all in one batch

- ASYNC sometimes can avoid to call two ->issue() unnecessarily if you
  know that the OP can't be dealt with async way in advance, maybe not
  one problem for ublk uring_cmd, but it is helpful for some FS write
  (un-allocated write)


Thanks,
Ming


