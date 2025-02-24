Return-Path: <io-uring+bounces-6707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD211A42E7D
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:01:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 690CC188EF58
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFD51F5FA;
	Mon, 24 Feb 2025 21:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFrnmIzC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859C88494;
	Mon, 24 Feb 2025 21:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740430904; cv=none; b=XBDHOh0W2f9Up5T0+79RysQ37JySno0d8UNmLS/8X+fGD7EdEQQx6CuNezYZ53gO5h06C1R1kYXuY2jrVOXcxhcka3RGZrMAr0y0qvqMeMlGx6nnWTjK+hyGPBY0p1qMCHug2zS6sFTPzpFcUVXGAEdzKkO9tOcdZOzb7LsvC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740430904; c=relaxed/simple;
	bh=D6m3waB1A6NC54+U+6VfMoiDKKCjlMEgNHFzo+7PmM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wa6IND//pjCQZGWfGJGgM1BFDGcErSG5WEKBn34P4jUBLaTytZRFXFyZ6Juon/Kl7P3uAzNIcnieEFpQGxDbZP7o/h69/aRfng1/jJ8TTpvK6YeocB9MxGCllssJ3dWUcNKXzqhKo+0vTLHDGtV7iAFRzNz6jQmMMd7VnxTJJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFrnmIzC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E62C4CED6;
	Mon, 24 Feb 2025 21:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740430902;
	bh=D6m3waB1A6NC54+U+6VfMoiDKKCjlMEgNHFzo+7PmM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oFrnmIzC349ykG200iu4FF56+hEucOSCMddKGhLSHQ5s3zC+pvF4JGcNLws4s2ssx
	 gUk5uCfUhzv6eH9CxqRczwdxMa4DTtOT9eX/GEHuf1Pqea/veET8ijEaCR4lFN+OuR
	 57oVOWV1iibvMwS+940RdrAqMqzuqkCZSJIvsVTqt98vLfB8SDKAk5NMGqxd3fP8+a
	 3UehRraP2xQ4pZEz4rCVecRBv9SvoThIaB1CPsFpWlBShG55k8s8xjQD+mHJ9GMIWt
	 +i1HaQkSsNR6ZBD0KV+6o42ugkleLRoK5OfwbZZ4bWEd/frp8TNejLGEaR/2PmoZ2X
	 +EtwgKNrHM5kw==
Date: Mon, 24 Feb 2025 14:01:40 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
Message-ID: <Z7zeNLEnZqsniK69@kbusch-mbp>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-6-kbusch@meta.com>
 <CADUfDZq5CDOZyyfjOgW_JE_A_GWLscZkbJDgQ-UKTbFC66FjKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZq5CDOZyyfjOgW_JE_A_GWLscZkbJDgQ-UKTbFC66FjKA@mail.gmail.com>

On Tue, Feb 18, 2025 at 08:22:36PM -0800, Caleb Sander Mateos wrote:
> > +struct io_alloc_cache {
> > +       void                    **entries;
> > +       unsigned int            nr_cached;
> > +       unsigned int            max_cached;
> > +       size_t                  elem_size;
> 
> Is growing this field from unsigned to size_t really necessary? It
> probably doesn't make sense to be caching allocations > 4 GB.

It used to be a size_t when I initially moved the struct to here, but
it's not anymore, so I'm out of sync. I'll fix it up.
 
> > @@ -859,10 +924,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
> >                         }
> >                         node->tag = tag;
> >                 }
> > -               data.nodes[i] = node;
> > +               table.data.nodes[i] = node;
> >         }
> > -
> > -       ctx->buf_table.data = data;
> 
> Still don't see the need to move this assignment. Is there a reason
> you prefer setting ctx->buf_table before initializing its nodes? I
> find the existing code easier to follow, where the table is moved to
> ctx->buf_table after filling it in. It's also consistent with
> io_clone_buffers().

Yes, it needs to move to earlier. The ctx buf_table needs to be set
before any allocations from io_rsrc_node_alloc() can happen.

