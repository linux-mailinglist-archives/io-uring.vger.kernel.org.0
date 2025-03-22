Return-Path: <io-uring+bounces-7190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2624EA6C81E
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 08:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FA1817CEB1
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 07:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C7B189F3B;
	Sat, 22 Mar 2025 07:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hribvX4l"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B791D78F5D
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 07:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742629361; cv=none; b=eCm2gD9XmZA5xY8XLC8QYYNcPwP/vXIYNWS+Psc4opBOzwy8Lmvgct+JOqucU6ENhsSdOUVZjbdIdCb3KlfZM6ppDzAoqGpMNo+lSGrefx51oLkM2PQ3m7CXVl7RZVDG2pACK+5kTRkIRZzMHE/TMXU81mxfzNnhdx+qEEQ3K38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742629361; c=relaxed/simple;
	bh=MCdKmMKBoyyUMRKRf7hO+90afl2SCZ5ynOJsDkhJ9mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyzw/EmJcSG3u6SE5I2uSEwELHtzfwGuoePRSCk1C6XwdJSBXiuFbpvflC+trK6IAKn/tDvUkBwS85rIJZY5HLcukSsmHxuX0UTFkl50Gj8M2YfZj7tG0Vx8gZcEUtYZGD0hbYuGeZHgYi4D1szyHd4ukj46Qu8u7eZh1P7bv6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hribvX4l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742629358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eSfN4adD6Yy/dTw2Fx1VYIssqdlx2Rs6iAavKyg5Vos=;
	b=hribvX4lZn54yHDVV3tkLe6vPPxtmmm5T2q2+fLys8SCY0sMNZGM/hv2hvqm6AS+UEtkCG
	oVPDNbv18brXHUJsvGSh0iSkERDCW+2kep62WdERUrXCMVBI/lUy1VW5GujBQcoQiTkJee
	l8/Qd6sYUjo6X496e1EjzCjv9nmBjFE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-7JhKs1JWPs2MMRscdvmx2Q-1; Sat,
 22 Mar 2025 03:42:34 -0400
X-MC-Unique: 7JhKs1JWPs2MMRscdvmx2Q-1
X-Mimecast-MFC-AGG-ID: 7JhKs1JWPs2MMRscdvmx2Q_1742629353
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 491C6180882E;
	Sat, 22 Mar 2025 07:42:33 +0000 (UTC)
Received: from fedora (unknown [10.72.120.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B375230001A1;
	Sat, 22 Mar 2025 07:42:25 +0000 (UTC)
Date: Sat, 22 Mar 2025 15:42:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 0/3] Consistently look up fixed buffers before going async
Message-ID: <Z95p25fOUY6X7lbX@fedora>
References: <20250321184819.3847386-1-csander@purestorage.com>
 <5588f0fe-c7dc-457f-853a-8687bddd2d36@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5588f0fe-c7dc-457f-853a-8687bddd2d36@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Mar 21, 2025 at 08:24:43PM +0000, Pavel Begunkov wrote:
> On 3/21/25 18:48, Caleb Sander Mateos wrote:
> > To use ublk zero copy, an application submits a sequence of io_uring
> > operations:
> > (1) Register a ublk request's buffer into the fixed buffer table
> > (2) Use the fixed buffer in some I/O operation
> > (3) Unregister the buffer from the fixed buffer table
> > 
> > The ordering of these operations is critical; if the fixed buffer lookup
> > occurs before the register or after the unregister operation, the I/O
> > will fail with EFAULT or even corrupt a different ublk request's buffer.
> > It is possible to guarantee the correct order by linking the operations,
> > but that adds overhead and doesn't allow multiple I/O operations to
> > execute in parallel using the same ublk request's buffer. Ideally, the
> > application could just submit the register, I/O, and unregister SQEs in
> > the desired order without links and io_uring would ensure the ordering.
> > This mostly works, leveraging the fact that each io_uring SQE is prepped
> > and issued non-blocking in order (barring link, drain, and force-async
> > flags). But it requires the fixed buffer lookup to occur during the
> > initial non-blocking issue.
> 
> In other words, leveraging internal details that is not a part
> of the uapi, should never be relied upon by the user and is fragile.
> Any drain request or IOSQE_ASYNC and it'll break, or for any reason
> why it might be desirable to change the behaviour in the future.
> 
> Sorry, but no, we absolutely can't have that, it'll be an absolute
> nightmare to maintain as basically every request scheduling decision
> now becomes a part of the uapi.
> 
> There is an api to order requests, if you want to order them you
> either have to use that or do it in user space. In your particular
> case you can try to opportunistically issue them without ordering
> by making sure the reg buffer slot is not reused in the meantime
> and handling request failures.

I agree, the order should be provided from UAPI/syscall level.

SQE group does address this order issue, and now it can work with
fixed buffer registering OP together.

If no one objects, I will post out the patch for review.


Thanks, 
Ming


