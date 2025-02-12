Return-Path: <io-uring+bounces-6352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 338B6A31D4D
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 05:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DADCE166F97
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 04:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23431DF27D;
	Wed, 12 Feb 2025 04:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JD7w5qbp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991EB1DE4D5;
	Wed, 12 Feb 2025 04:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739333473; cv=none; b=iOHaPtirEoMq7CmhI1uNOW9l57DJJf0k690u9Gpq3mENvYXggEU96cp8EVAmWg5QJ0bpHzIbA2zkqWfu0Gc5yicOsLA+4hqaTd71I3T9/euOAWxMhYQb1VBI1AK3xuAK3zK3QcIzpNpBs9vFaDSOxgSsFYYBfsbr2Lhnf/Ep2CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739333473; c=relaxed/simple;
	bh=HUY9jZq6pe6s6cAP1w8mh9yTzfXKDVkS9aEHrUFESHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cj8Sgwk9VYHyP3tKp205cRq3nhxBVJTtVIHexbkctLwng8AqTbitl+s/o2eRDaa0nNJywvyZKZe8n+/hjclqVPWP/wdoDCL9g/sOconr2MGu5o1TGZ+Yd6KdynO8qE9UC6Irub2yiJs2tcTD61uc/OAWOeEMn3VGlqh0k9sOAsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JD7w5qbp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99594C4CEDF;
	Wed, 12 Feb 2025 04:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739333473;
	bh=HUY9jZq6pe6s6cAP1w8mh9yTzfXKDVkS9aEHrUFESHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JD7w5qbpTxXdFFbuA2eWtw4FBFVtQ/B+MqBkDL1+7zIzP1Ck/zbYCKSKFrVVKzT4G
	 RGHRhRDcpimrJzzXcKdAtu2VWkU0pxoFEA70TgKB2ez9AFiaEZqaW3mNDDxvF2pO2u
	 QwoPy7FajieAA9VOdrRVGQN13xw0FDJrNt19aBfEKvOAsbzbh32SAGzRnAhFJtxslu
	 FHU4tBYvyeHIRy11hhQ8b5VHXOBaz9vT29TKB9S7FwC8zO3gwZXS1RTKTnj1WCk8yM
	 hujxGqQItK3huhiZAAT81YGhWiKVbhJgytij1FJxcVvqnaBplldh/iuBQr1VEFzQsP
	 ZvzStpRpcXlaA==
Date: Tue, 11 Feb 2025 21:11:10 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 4/6] ublk: zc register/unregister bvec
Message-ID: <Z6wfXijUX_6Q3HiC@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-5-kbusch@meta.com>
 <Z6wMK5WxvS_MzLh3@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wMK5WxvS_MzLh3@fedora>

On Wed, Feb 12, 2025 at 10:49:15AM +0800, Ming Lei wrote:
> On Mon, Feb 10, 2025 at 04:56:44PM -0800, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Provide new operations for the user to request mapping an active request
> > to an io uring instance's buf_table. The user has to provide the index
> > it wants to install the buffer.
> > 
> > A reference count is taken on the request to ensure it can't be
> > completed while it is active in a ring's buf_table.
> > 
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> >  drivers/block/ublk_drv.c      | 145 +++++++++++++++++++++++++---------
> >  include/uapi/linux/ublk_cmd.h |   4 +
> >  2 files changed, 113 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > index 529085181f355..ccfda7b2c24da 100644
> > --- a/drivers/block/ublk_drv.c
> > +++ b/drivers/block/ublk_drv.c
> > @@ -51,6 +51,9 @@
> >  /* private ioctl command mirror */
> >  #define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
> >  
> > +#define UBLK_IO_REGISTER_IO_BUF		_IOC_NR(UBLK_U_IO_REGISTER_IO_BUF)
> > +#define UBLK_IO_UNREGISTER_IO_BUF	_IOC_NR(UBLK_U_IO_UNREGISTER_IO_BUF)
> 
> UBLK_IO_REGISTER_IO_BUF command may be completed, and buffer isn't used
> by RW_FIXED yet in the following cases:
> 
> - application doesn't submit any RW_FIXED consumer OP
> 
> - io_uring_enter() only issued UBLK_IO_REGISTER_IO_BUF, and the other
>   OPs can't be issued because of out of resource 
> 
> ...
> 
> Then io_uring_enter() returns, and the application is panic or killed,
> how to avoid buffer leak?

The death of the uring that registered the node tears down the table
that it's registered with, which releases its reference. All good.
 
> It need to deal with in io_uring cancel code for calling ->release() if
> the kbuffer node isn't released.

There should be no situation here where it isn't released after its use
is completed. Either the resource was gracefully unregistered or the
ring close while it was still active, but either one drops its
reference.

> UBLK_IO_UNREGISTER_IO_BUF still need to call ->release() if the node
> buffer isn't used.

Only once the last reference is dropped. Which should happen no matter
which way the node is freed.

> > +static void ublk_io_release(void *priv)
> > +{
> > +	struct request *rq = priv;
> > +	struct ublk_queue *ubq = rq->mq_hctx->driver_data;
> > +
> > +	ublk_put_req_ref(ubq, rq);
> > +}
> 
> It isn't enough to just get & put request reference here between registering
> buffer and freeing the registered node buf, because the same reference can be
> dropped from ublk_commit_completion() which is from queueing
> UBLK_IO_COMMIT_AND_FETCH_REQ, and buggy app may queue this command multiple
> times for freeing the request.
> 
> One solution is to not allow request completion until the ->release() is
> returned.

Double completions are tricky because the same request id can be reused
pretty quickly and there's no immediate way to tell if the 2nd
completion is a double or a genuine completion of the reused request.

We have rotating sequence numbers in the nvme driver to try to detect a
similar situation. So far it hasn't revealed any real bugs as far as I
know. This feels like the other side screwed up and that's their fault.

