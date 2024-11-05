Return-Path: <io-uring+bounces-4450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D33339BC3F2
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 04:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 896791F21C66
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 03:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5030F183CC9;
	Tue,  5 Nov 2024 03:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gTpiKzCW"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557594D9FE
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 03:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730777878; cv=none; b=i8JjQmXGChqung/JNNQnE9NZT7tz12Xlpi/VR3l66f8VfnuqsK2ykOQcp9fEdv7ddqwI1LiQZ649Kr+ORejGYEmcAaLBP1m/NePyAeO6YVAfZQCAR/KRrvKA0Ldbxej/goAZSVPqUwUd+eVAFukvN5lmq3G334pQcPkj/4heZro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730777878; c=relaxed/simple;
	bh=SiqRW3+HPP5ywhZu2n4PJpYDHEvVCGjp4q52XH9Tur4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXj2SfTy9RG4fveyZkbOKDg2At0ZmHeDqKXkW0GNzVNgi9UMYY35QT7jpq8En3IyJFcd14C/+FEwmiIDP0VMoAIx2U0JxPYTUNpoXf8IEb8nV1CurCtIp7j469fs9smX7Ug2YiSYk+rroptygzUiH2jVSz9jdoPxelJyrjXVeqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gTpiKzCW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730777875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2doew4i/v+ovW5yTz8iEOTPX6Na+iF+P1BpXnU3FKvA=;
	b=gTpiKzCWU8SEILtEc7eXDi0AqYF1r3gqKRn2REkY8UFOeFBE/P/V+D9A6692KKqWJ8O64g
	a4DLacUyPI8Q2raID3fjQbuNfZtgH4FPl2cfmkjQuRtlbH+3HQaWZXHACDkVj/Q5Z8FYKv
	Q7Q2tvV/t7vHhnN3egi+HVHjhLkTU50=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-3rC_49HuPWijHDCZcH_Hvw-1; Mon,
 04 Nov 2024 22:37:54 -0500
X-MC-Unique: 3rC_49HuPWijHDCZcH_Hvw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ABF2195608C;
	Tue,  5 Nov 2024 03:37:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 801E219560AA;
	Tue,  5 Nov 2024 03:37:47 +0000 (UTC)
Date: Tue, 5 Nov 2024 11:37:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZymTBm0wGV8UsdRk@fedora>
References: <ZyQpH8ttWAhS9C5G@fedora>
 <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com>
 <ZygSWB08t1PPyPyv@fedora>
 <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com>
 <ZyghmwcI1U4WizyX@fedora>
 <74d8d323-789c-4b4d-8ce6-ada6a567b552@gmail.com>
 <ZyjHQN9VITpOlyPA@fedora>
 <8fc4d419-5d16-4f58-ae66-8267edaff6ef@gmail.com>
 <ZyjNq92M8qhJFEKm@fedora>
 <0e4d8bda-459c-41f0-af8d-30c9d81bfb80@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e4d8bda-459c-41f0-af8d-30c9d81bfb80@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Nov 04, 2024 at 04:38:08PM +0000, Pavel Begunkov wrote:
> On 11/4/24 13:35, Ming Lei wrote:
> > On Mon, Nov 04, 2024 at 01:24:09PM +0000, Pavel Begunkov wrote:
> ...
> > > > > > > any private data, then the buffer should've already been initialised by
> > > > > > > the time it was lease. Initialised is in the sense that it contains no
> > > > > > 
> > > > > > For block IO the practice is to zero the remainder after short read, please
> > > > > > see example of loop, lo_complete_rq() & lo_read_simple().
> > > > > 
> > > > > It's more important for me to understand what it tries to fix, whether
> > > > > we can leak kernel data without the patch, and whether it can be exploited
> > > > > even with the change. We can then decide if it's nicer to zero or not.
> > > > > 
> > > > > I can also ask it in a different way, can you tell is there some security
> > > > > concern if there is no zeroing? And if so, can you describe what's the exact
> > > > > way it can be triggered?
> > > > 
> > > > Firstly the zeroing follows loop's handling for short read
> > > 
> > > > Secondly, if the remainder part of one page cache buffer isn't zeroed, it might
> > > > be leaked to userspace via another read() or mmap() on same page.
> > > 
> > > What kind of data this leaked buffer can contain? Is it uninitialised
> > > kernel memory like a freshly kmalloc'ed chunk would have? Or is it private
> > > data of some user process?
> > 
> > Yes, the page may be uninitialized, and might contain random kernel data.
> 
> I see now, the user is obviously untrusted, but you're saying the ublk
> server user space is trusted enough to see that kind of kernel data.

ublk server isn't allowed to read from uninitialized page too, that
is why `dir` field is added to `io_uring_kernel_buf`. For READ IO, the
buffer is write-only, and I will extend io_mapped_ubuf to cover it as
suggested by Jens.

> Sounds like a security concern, is there a precedent allowing such?

User emulated storages are in same situation, such as virtio-blk, in virtio_queue_rq(),
virtblk_add_req() is called to add the READ request's sglist to virt-queue, then
wakeup qemu for handling read IO, qemu will retrieve guest sg list from
virt-queue and make sure DATA is filled to the sg buffer.

Another example is null_blk without memback, which does nop for any READ IO. 

> Is it what ublk normally does even without this zero copy proposal?

Without zero copy, userspace provides one IO buffer for each io command, and
ublk server read data to this IO buffer first, then notify ublk driver via
uring_cmd for completing the read IO, and ublk driver will copy data from
the ublk server IO buffer to the original READ request buffer.


Thanks,
Ming


