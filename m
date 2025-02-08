Return-Path: <io-uring+bounces-6329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B94AA2D880
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 21:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05EF916627A
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 20:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB00E243941;
	Sat,  8 Feb 2025 20:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GuNuW+6O"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80329243940;
	Sat,  8 Feb 2025 20:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739045630; cv=none; b=KUGenhyxtW8HOAKHXjFN8fjXgK4CjQENyjCcttB9P0Kge8OtbQm6zV/VRjvXLxk3BNreFmL0gPriGGKQS8wpVclsgos//bmquEfCRYnncg9MwYaKJo2y/E5Ic82K4gkR+9q8l/+SweoawVOwOgb8z+rY57S//PdN7LSVJ7gSERM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739045630; c=relaxed/simple;
	bh=47SPMhrRE00boTtS4jLE7OHrulcxoPCh+GEMjSvogko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXdgY9TvRmnu7Yg4TXgTnsTEWcnbq6tGqdluYmtO3qpZgwEf9lCNYDIFIw4uSKWCxe3E68t8+E855llFlZZZCEkKZXPFNdXRLQ19nsL5IbAuqhSw/zRV1jreCKdE1FkExWvZeAWuARomd/GJb1nDirQjCIoPgZJ8CDXrscyVZys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GuNuW+6O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF0BC4CED6;
	Sat,  8 Feb 2025 20:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739045629;
	bh=47SPMhrRE00boTtS4jLE7OHrulcxoPCh+GEMjSvogko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GuNuW+6OjMFPCmRsjqHd+IM3Los51kJSUF0DKc+z97tcOchwzazDidSVanZXDbgyk
	 m0ll8oRaupwPcFvI1zbUb9gOD73M2b7V8vV7WXKc3vTBttl0iyNjIdZo2R6LEC01kT
	 8V81J/7As6D3wPVwprnZ4a2a6Z1OGypepItzc8G331WDyNQcTH3Gah+JRN5ZtV0Wez
	 szDERh2zcXazvWzJtYLBzAcntJpUmx9eCGOn8jdOgdNVLc0DCxMKVsl6Wn0GN8viYl
	 6kItvM0npTfWePPk0fwSCiKhm04rIP2YsWIL0QrubmBxo4IAjUGUsDYpl4icxDTv7S
	 0SoEFAI36oIMw==
Date: Sat, 8 Feb 2025 13:13:47 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@meta.com>,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	axboe@kernel.dk, Bernd Schubert <bernd@bsbernd.com>
Subject: Re: [PATCH 0/6] ublk zero-copy support
Message-ID: <Z6e6-w_L4GZwKuN8@kbusch-mbp>
References: <20250203154517.937623-1-kbusch@meta.com>
 <Z6WDVdYxxQT4Trj8@fedora>
 <Z6YTfi29FcSQ1cSe@kbusch-mbp>
 <Z6bvSXKF9ESwJ61r@fedora>
 <b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com>

On Sat, Feb 08, 2025 at 02:16:15PM +0000, Pavel Begunkov wrote:
> On 2/8/25 05:44, Ming Lei wrote:
> > On Fri, Feb 07, 2025 at 07:06:54AM -0700, Keith Busch wrote:
> > > On Fri, Feb 07, 2025 at 11:51:49AM +0800, Ming Lei wrote:
> > > > On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
> > > > > 
> > > > > The previous version from Ming can be viewed here:
> > > > > 
> > > > >    https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
> > > > > 
> > > > > Based on the feedback from that thread, the desired io_uring interfaces
> > > > > needed to be simpler, and the kernel registered resources need to behave
> > > > > more similiar to user registered buffers.
> > > > > 
> > > > > This series introduces a new resource node type, KBUF, which, like the
> > > > > BUFFER resource, needs to be installed into an io_uring buf_node table
> > > > > in order for the user to access it in a fixed buffer command. The
> > > > > new io_uring kernel API provides a way for a user to register a struct
> > > > > request's bvec to a specific index, and a way to unregister it.
> > > > > 
> > > > > When the ublk server receives notification of a new command, it must
> > > > > first select an index and register the zero copy buffer. It may use that
> > > > > index for any number of fixed buffer commands, then it must unregister
> > > > > the index when it's done. This can all be done in a single io_uring_enter
> > > > > if desired, or it can be split into multiple enters if needed.
> > > > 
> > > > I suspect it may not be done in single io_uring_enter() because there
> > > > is strict dependency among the three OPs(register buffer, read/write,
> > > > unregister buffer).
> > > 
> > > The registration is synchronous. io_uring completes the SQE entirely
> > > before it even looks at the read command in the next SQE.
> > 
> > Can you explain a bit "synchronous" here?
> 
> I'd believe synchronous here means "executed during submission from
> the submit syscall path". And I agree that we can't rely on that.
> That's an implementation detail and io_uring doesn't promise that,

The commands are processed in order under the ctx's uring_lock. What are
you thinking you might do to make this happen in any different order?

