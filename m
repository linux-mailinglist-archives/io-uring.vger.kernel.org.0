Return-Path: <io-uring+bounces-9317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF2FB38BC7
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 23:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6EB91B23A33
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 21:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0C530F815;
	Wed, 27 Aug 2025 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGK+ORyI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F14D30F811;
	Wed, 27 Aug 2025 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756331966; cv=none; b=Lbl778AqcJGgcBqGXTFLLmGyUUL+rnF3wk1dyUXJHQ16cvMor5xq7jRJJfat3W/454LdT3RFwb4T/hHbTy9I7oLEbq00xdn/PYGnJVttqFOyVtdir21/bwU/2jkoCHU0s3/ChbYsnIaRDRSHMRd/l3WBJQiBRXy2p75wTrZZuPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756331966; c=relaxed/simple;
	bh=hspNPxc7tVYSEf6hBQu45yJ72aWyCwXogpkdVNoorsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MtTn/bBlQMGFzAkYsFBz57UW3Emm/k6zrT+itu4nyfGXzbJX9yEaHbuVHZxb083dKV0L8QbJVuNUdkNfRJWhOc5/H41tNOzTyjY5QVxUDK/qffHDRKkX4Lhradx3eAzHLrLelT1YDcYNGK4a5owSa3TCN0ty/JgHWr65ytOBU1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGK+ORyI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A6AC4CEEB;
	Wed, 27 Aug 2025 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756331966;
	bh=hspNPxc7tVYSEf6hBQu45yJ72aWyCwXogpkdVNoorsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGK+ORyIjCeJ9UOmgDhBBRR7RUHH+ArslmbX2BMuqKGFvZcgF6ZgI18AbC7YOU5n+
	 9hYJYJCKPG4snhDnInHNblk1kMbHLf0ohDrFuhNSa88+kQth5daFoppGXXcjNpE3/B
	 oLCGjLyxHKw3aG+z2QA+rRM/Juo8/+UG4GJMz3z/rqnMkTaNkBSI0nvPVyxrIGt+zP
	 q2jU5V6hUTdSuYHxK+x3zlSv4/+pPoVRs306n10OBQk1WwOszONJOrYtksHkw61tsM
	 CpPzkwKfky88pB3cGUgplO6a8BQ3WmjiB7j+PMblYTjFi3Y3XYrjub7rl5EvVAsQ//
	 WhuGoIVNacpCA==
Date: Wed, 27 Aug 2025 15:59:23 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Qingyue Zhang <chunzhennn@qq.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, Suoxing Zhang <aftern00n@qq.com>
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
Message-ID: <aK9_u9ZK9NgKiBkE@kbusch-mbp>
References: <20250827114339.367080-1-chunzhennn@qq.com>
 <tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com>
 <fcfd5324-9918-4613-94b0-c27fb8398375@kernel.dk>
 <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>

On Wed, Aug 27, 2025 at 03:45:28PM -0600, Jens Axboe wrote:
> > +		buf_len = READ_ONCE(buf->len);
> > +		this_len = min_t(int, len, buf_len);
> > +		buf_len -= this_len;
> > +		if (buf_len) {
> >  			buf->addr += this_len;
> > +			buf->len = buf_len;
> >  			return false;
> >  		}
> > +		buf->len = 0;

Purely for symmetry, assigning buf->len ought to be a WRITE_ONCE.

