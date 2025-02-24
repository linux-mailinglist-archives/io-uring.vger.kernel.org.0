Return-Path: <io-uring+bounces-6709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B77A42E95
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83DC01788CE
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D63196C7C;
	Mon, 24 Feb 2025 21:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZPFB7/g"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C0C193404;
	Mon, 24 Feb 2025 21:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740431100; cv=none; b=TPE0sbbKHf8MbD+nO6gfBJ/UG1amXVn0jIWE/Cls3E/XUfJd3RVwQ1GSr5UqMWTJjbnndx05wByhfXCUd6vjumABmOv54bQU+E2b1rYbRNFHRMUWn22/Fuh/0T6VqXdK9NSYInnXsUF6L0O2Dv3EJVqKJrGMjaas1Pao6f0miPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740431100; c=relaxed/simple;
	bh=sjih1yUELO9vGAfiR52TsYo77m5D044j2d1aO8hkPJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSc0kNYyPLVkbA3JWEqbGolxE3PLRQ7sUYS4CMQwRWW7YkVz+5okFM0Jt68VBxxT7p1cIPuf8zbJjNzXkynKUvG0IL5T8qnFMjeFxGnUtb/HYyFP7bVFxaWPf7b12gbpvPUrPhxLB/ijeO54h+uYDwXMjx+ogDjF6EHk1mDdm7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZPFB7/g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41D4C4CED6;
	Mon, 24 Feb 2025 21:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740431100;
	bh=sjih1yUELO9vGAfiR52TsYo77m5D044j2d1aO8hkPJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VZPFB7/gKXTF6yJ7vGBSMGAnTd0akerCab9urrGd95MfnJ0jZpVQrKdByUM5OPYwa
	 QacIquvHVUbrHIyvXNJklDtdagPXgq/3DPcgrsFzmYVmbmiyZBSEkgYUOsHp24pv6H
	 T+fUsTOta3ojaJaZm+yUgN1ts8KqqD/CskSzwuM+RlQ2KBdY7wfykR+aHJMzqEJjRF
	 8HTbPyVHIt8ytN7WAzovvNNRPwkXjXuh7ZTbrHTiKqGolReaECPiAbxMqtGCitlA0H
	 ai0745+rcsb8ttvhnAAk2XApARDyItJLAfbgu3451yAtm9RJBT121fbMIFG5FuPlfL
	 ZCg6Skl9vYr9Q==
Date: Mon, 24 Feb 2025 14:04:58 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
Message-ID: <Z7ze-kzDuoP_XPBx@kbusch-mbp>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-6-kbusch@meta.com>
 <d2889d14-27d2-4a64-b8d1-ff0e4af6d552@gmail.com>
 <Z7dJNx5yIneheFsd@kbusch-mbp>
 <00375984-956d-4a25-aae2-e2d72a91c62a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00375984-956d-4a25-aae2-e2d72a91c62a@gmail.com>

On Thu, Feb 20, 2025 at 04:06:21PM +0000, Pavel Begunkov wrote:
> On 2/20/25 15:24, Keith Busch wrote:
> > > > +		node = io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);
> > > 
> > > That's why node allocators shouldn't be a part of the buffer table.
> > 
> > Are you saying you want file nodes to also subscribe to the cache? The
> 
> Yes, but it might be easier for you to focus on finalising the essential
> parts, and then we can improve later.
> 
> > two tables can be resized independently of each other, we don't know how
> > many elements the cache needs to hold.
> 
> I wouldn't try to correlate table sizes with desired cache sizes,
> users can have quite different patterns like allocating a barely used
> huge table. And you care about the speed of node change, which at
> extremes is rather limited by CPU and performance and not spatiality
> of the table. And you can also reallocate it as well.

Having the cache size and lifetime match a table that it's providing
seems as simple as I can make this. This is still an optimization at the
end of the day, so it's not strictly necessary to take the last two
patches from this series to make zero copy work if you don't want to
include it from the beginning.

