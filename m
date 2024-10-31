Return-Path: <io-uring+bounces-4253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB5079B72A6
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 03:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D53601C22F09
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 02:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A095246447;
	Thu, 31 Oct 2024 02:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GP3rQKve"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D75D84A39
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 02:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730343225; cv=none; b=FzYbjbDw0XYaEkG3SErDw4WCq8i+lAjSg0hTtAPzAu6mFXQJF2o14FZylCAG3I8HMU4cBAOefAHyCUIxPu2zC0NDoroPR1qBn6RHuSPTq/b0nFNl+11mVTQXgKVsR0f9LQOFEGVibKZ1yA3eqDDFfaL1oCjse9yAsFokvkFl0ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730343225; c=relaxed/simple;
	bh=q6aokFqKjHcnhGpzeCRfMyuRqwZfJGaYimFpSbJrme0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUj60VzP239ipWWCPHkRUUpDyZ06BjTiKynA1kO/3eHVg6SdKzayXeQYqlJoodln/ePfulLxJYuSYUhPTxvKZZJ9uzeNUplljO2AvF0qtEHORVvA7galVPhchQhECQ3v3VjVvA9iKnHEw2yRmLV+EJs4RVk5ERujzjR0Le3N0Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GP3rQKve; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730343221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGu1lyhks3UKXm4waSwre3Yazxs4FzW3CseVQuT845M=;
	b=GP3rQKveAvdiiWaPYQV9rSS3n4k6XgEanATqu89giUqWBgym7WsEjTO1bsBOLj3gdTFH/r
	hZKiaFRDkMJ+YOuyluPVrBbi8e9t7oiykvBoJEXeUGYJKgv1NCoWFz8+CgPeHgp1w88k15
	NgpcIThVySqmhzHxHKLA9WVw9OPs8p4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-djwUy86YOAW9ncplZMPjrg-1; Wed,
 30 Oct 2024 22:53:38 -0400
X-MC-Unique: djwUy86YOAW9ncplZMPjrg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C11F419560A7;
	Thu, 31 Oct 2024 02:53:36 +0000 (UTC)
Received: from fedora (unknown [10.72.116.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A553C19560A2;
	Thu, 31 Oct 2024 02:53:30 +0000 (UTC)
Date: Thu, 31 Oct 2024 10:53:25 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, ming.lei@redhat.com
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
Message-ID: <ZyLxJdn7bboZMAcs@fedora>
References: <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk>
 <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
 <ZyGjID-17REc9X3e@fedora>
 <ZyGx4JBPdU4VlxlZ@fedora>
 <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Oct 30, 2024 at 07:20:48AM -0600, Jens Axboe wrote:
> On 10/29/24 10:11 PM, Ming Lei wrote:
> > On Wed, Oct 30, 2024 at 11:08:16AM +0800, Ming Lei wrote:
> >> On Tue, Oct 29, 2024 at 08:43:39PM -0600, Jens Axboe wrote:
> > 
> > ...
> > 
> >>> You could avoid the OP dependency with just a flag, if you really wanted
> >>> to. But I'm not sure it makes a lot of sense. And it's a hell of a lot
> >>
> >> Yes, IO_LINK won't work for submitting multiple IOs concurrently, extra
> >> syscall makes application too complicated, and IO latency is increased.
> >>
> >>> simpler than the sqe group scheme, which I'm a bit worried about as it's
> >>> a bit complicated in how deep it needs to go in the code. This one
> >>> stands alone, so I'd strongly encourage we pursue this a bit further and
> >>> iron out the kinks. Maybe it won't work in the end, I don't know, but it
> >>> seems pretty promising and it's soooo much simpler.
> >>
> >> If buffer register and lookup are always done in ->prep(), OP dependency
> >> may be avoided.
> > 
> > Even all buffer register and lookup are done in ->prep(), OP dependency
> > still can't be avoided completely, such as:
> > 
> > 1) two local buffers for sending to two sockets
> > 
> > 2) group 1: IORING_OP_LOCAL_KBUF1 & [send(sock1), send(sock2)]  
> > 
> > 3) group 2: IORING_OP_LOCAL_KBUF2 & [send(sock1), send(sock2)]
> > 
> > group 1 and group 2 needs to be linked, but inside each group, the two
> > sends may be submitted in parallel.
> 
> That is where groups of course work, in that you can submit 2 groups and
> have each member inside each group run independently. But I do think we
> need to decouple the local buffer and group concepts entirely. For the
> first step, getting local buffers working with zero copy would be ideal,
> and then just live with the fact that group 1 needs to be submitted
> first and group 2 once the first ones are done.

IMHO, it is one _kernel_ zero copy(_performance_) feature, which often imply:

- better performance expectation
- no big change on existed application for using this feature

Application developer is less interested in sort of crippled or immature
feature, especially need big change on existed code logic(then two code paths
need to maintain), with potential performance regression.

With sqe group and REQ_F_GROUP_KBUF, application just needs lines of
code change for using the feature, and it is pretty easy to evaluate
the feature since no any extra logic change & no extra syscall/wait
introduced. The whole patchset has been mature enough, unfortunately
blocked without obvious reasons.

> 
> Once local buffers are done, we can look at doing the sqe grouping in a
> nice way. I do think it's a potentially powerful concept, but we're
> going to make a lot more progress on this issue if we carefully separate
> dependencies and get each of them done separately.

One fundamental difference between local buffer and REQ_F_GROUP_KBUF is

- local buffer has to be provided and used in ->prep()
- REQ_F_GROUP_KBUF needs to be provided in ->issue() instead of ->prep()

The only common code could be one buffer abstraction for OP to use, but
still used differently, ->prep() vs. ->issue().

So it is hard to call it decouple, especially REQ_F_GROUP_KBUF has been
simple enough, and the main change is to import it in OP code.

Local buffer is one smart idea, but I hope the following things may be
settled first:

1) is it generic enough to just allow to provide local buffer during
->prep()?

- this way actually becomes sync & nowait IO, instead AIO, and has been
  one strong constraint from UAPI viewpoint.

- Driver may need to wait until some data comes, then return & provide
the buffer with data, and local buffer can't cover this case

2) is it allowed to call ->uring_cmd() from io_uring_cmd_prep()? If not,
any idea to call into driver for leasing the kernel buffer to io_uring?

3) in OP code, how to differentiate normal userspace buffer select with
local buffer? And how does OP know if normal buffer select or local
kernel buffer should be used? Some OP may want to use normal buffer
select instead of local buffer, others may want to use local buffer.

4) arbitrary numbers of local buffer needs to be supported, since IO
often comes at batch, it shouldn't be hard to support it by adding xarray
to submission state, what do you think of this added complexity? Without
supporting arbitrary number of local buffers, performance can be just
bad, it doesn't make sense as zc viewpoint. Meantime as number of local
buffer is increased, more rsrc_node & imu allocation is introduced, this
still may degrade perf a bit.

5) io_rsrc_node becomes part of interface between io_uring and driver
for releasing the leased buffer, so extra data has to be
added to `io_rsrc_node` for driver use.

However, from above, the following can be concluded at least:

- it isn't generic enough, #1, #3
- it still need sqe group
- it is much more complicated than REQ_F_GROUP_KBUF only
- it can't be more efficient


Thanks,
Ming


