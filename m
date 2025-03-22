Return-Path: <io-uring+bounces-7211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D019A6CD55
	for <lists+io-uring@lfdr.de>; Sun, 23 Mar 2025 00:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CAEA1623F3
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 23:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962171AA786;
	Sat, 22 Mar 2025 23:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="df+RIv3y"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56CD171C9
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742687912; cv=none; b=Plgf4B80J95iOPmlp0fkfmm/d8gY1bm5mCKlelzzt0B09yFUwAN/2HiG9pQeWF8POMNxaRTrx7tDWsKKXxNTPfpulzGr1MWFbzIf11pi4doYNfUQvy8yDhxoVP8LSywhxzYH82nH5mLcqslJQWU7yoOIKzghg00t29LGDG3Et90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742687912; c=relaxed/simple;
	bh=hRzHv2iX1WP4gvaCVnHphvn13etT0cu6ibK065HfU5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kq4V4I2l6rM1bHpAEeCRKf/n0h5hv909rYJ+8ZmGY7XCYONkCGJxtRqdRQhN4LFFOrcFxrx7XQtN5NxCYk9Eliz1GWzLP/pBQ4diiahfvC0EypwrUzFdTjbp6tGYK1csyIzAFLe2ulIpS/Woj/FuBlZryaycq7MNRYte16awf8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=df+RIv3y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742687909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ZecM8tV0ujYPqG0iDu1rpHOw+Nrl+IJi4PGwToY4TU=;
	b=df+RIv3yxmp4hx02Om78lJKZlcLhnKI2RMAaP8MWzaXLyyD/cbQ2qe7j6EFYHA2KysTTpR
	5BTEcjDZLQU1j873DXCFoxJ74GeXbHiEp+H4B9itNB5JujhbtXAJCWxYJzfJ/BB2Fr8uge
	d/7l7lsH+qb/pZAbuXwKGfntsWN0+QM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-B1HabR5_PfOTO5PWnmV_bg-1; Sat,
 22 Mar 2025 19:58:19 -0400
X-MC-Unique: B1HabR5_PfOTO5PWnmV_bg-1
X-Mimecast-MFC-AGG-ID: B1HabR5_PfOTO5PWnmV_bg_1742687898
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3044180049D;
	Sat, 22 Mar 2025 23:58:17 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC6F730001A2;
	Sat, 22 Mar 2025 23:58:12 +0000 (UTC)
Date: Sun, 23 Mar 2025 07:58:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
Message-ID: <Z99OjrbmfBQxC3kt@fedora>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com>
 <Z97ALTDd-s0-uT7O@fedora>
 <Z9741KU2Fz7J0NSq@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9741KU2Fz7J0NSq@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sat, Mar 22, 2025 at 11:52:20AM -0600, Keith Busch wrote:
> On Sat, Mar 22, 2025 at 09:50:37PM +0800, Ming Lei wrote:
> > On Sat, Mar 22, 2025 at 12:02:02PM +0000, Pavel Begunkov wrote:
> > > On 3/22/25 07:56, Ming Lei wrote:
> > > > So far fixed kernel buffer is only used for FS read/write, in which
> > > > the remained bytes need to be zeroed in case of short read, otherwise
> > > > kernel data may be leaked to userspace.
> > > 
> > > Can you remind me, how that can happen? Normally, IIUC, you register
> > > a request filled with user pages, so no kernel data there. Is it some
> > > bounce buffers?
> > 
> > For direct io, it is filled with user pages, but it can be buffered IO,
> > and the page can be mapped to userspace.
> 
> I may missing something here because that doesn't sound specific to
> kernel registered bvecs. Is page cache memory not already zeroed out to
> protect against short reads?

Not sure if mm/fs will do that for short read.

At least some drivers do zero data for short read, such as loop,
erofs_fileio_ki_complete(), null_blk...

> 
> I can easily wire up a flakey device that won't fill the requested
> memory. What do I need to do to observe this data leak?

You can observe non-zero data in this way.

Wrt. zero copy, the device need to be trusted, that is why both USER_COPY
and ZERO_COPY features can't be available for unprivileged mode.

Thinking of further, this patch isn't needed because ublk driver does
handle short READ by requeuing request.


Thanks,
Ming


