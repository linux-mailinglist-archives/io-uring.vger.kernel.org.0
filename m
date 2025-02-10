Return-Path: <io-uring+bounces-6336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0ECA2F0E5
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2025 16:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 979DD18848F0
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2025 15:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB6D23C38A;
	Mon, 10 Feb 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVqRb4rp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36802136E21;
	Mon, 10 Feb 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739199917; cv=none; b=VdYbyFSBFSjM8Qt0P9Iy3nidHZX3FhzEwCbJMTJMiIy8VdFc2nEKgJOn3FO1FzPWu48VDsD1Fsl5by++wIZl2Vr5LN7zGGE4BLHP2dGT+54UAb+Xb3z5IFMSray1o1Lma7iycgQa+Fjx3oszYZPg1GxyvvpDpWahy0tQoYD4s5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739199917; c=relaxed/simple;
	bh=6pwpcOmnQ+m/cF7eNK960CBBNxK4Uui1P8jZME+h4uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0WhHJlY14VI09pjx0f4/tXqz3rdVwGKPXF48d2+eytwuU7m6fbhJ0FV6lzr7qTF2YirL+8fv6Wb81MAejcSa7YhMlFv04lgiCONZA60yyfi6TiZa/m1n7jhdAhXLLwSBlFnKGFEAvf3onQnLU02xstNJJWhxHQaMbHlt5Ma0LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVqRb4rp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71129C4CED1;
	Mon, 10 Feb 2025 15:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739199916;
	bh=6pwpcOmnQ+m/cF7eNK960CBBNxK4Uui1P8jZME+h4uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qVqRb4rpeBANWlsGBPmijGeccYLw9MA6hPh/Jhzqq9FvQibQaXR6FwBL4ndxdBU/y
	 576KcC9tArG89+nOo4wN90n9cvxWJk2fnFxg8qLz/nFE98oDKVV2jTfMkDx44KG6Yq
	 R84DnABxa4nrF0KC9Rl3V8IiVBnHAT0+bTFXQF+fGcf0fdZEAPvoSgEHDF57wZz9yW
	 kvp+SWWq7NKE9YclmPGwQg1736SsRCK81Ue3phSTUZkUr27VMgrRQ/+Lc6hhb9iLNz
	 Rfcom0I9s4WKyOWdMXT56C5EZTOVoKMURLLNImRUhb3iAHSWrwK79xkjDpz6Ygvqsc
	 Id0GXQwfZfMmw==
Date: Mon, 10 Feb 2025 08:05:14 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com
Subject: Re: [PATCH 3/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z6oVqsG5Mp-PjAwz@kbusch-mbp>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-4-kbusch@meta.com>
 <Z6oJXIsBMMkCpW_3@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6oJXIsBMMkCpW_3@fedora>

On Mon, Feb 10, 2025 at 10:12:44PM +0800, Ming Lei wrote:
> On Mon, Feb 03, 2025 at 07:45:14AM -0800, Keith Busch wrote:
> > +	rq_for_each_bvec(bv, rq, rq_iter) {
> > +		get_page(bv.bv_page);
> > +		node->buf->bvec[i].bv_page = bv.bv_page;
> > +		node->buf->bvec[i].bv_len = bv.bv_len;
> > +		node->buf->bvec[i].bv_offset = bv.bv_offset;
> > +		i++;
> 
> In this patchset, ublk request buffer may cross uring OPs, so it is inevitable
> for buggy application to complete IO command & ublk request before
> io_uring read/write OP using the buffer/page is completed .

The buggy app would have to both complete the requests and unregister
the fixed buffer (the registration takes a reference, too) while having
backend requests in flight using that registered buffer. That could
happen, which is why the page references are elevated. It should contain
the fallout of the buggy application to the application's memory.

But if this is really a scenario that we must prevent from happening,
then I think the indirect callback is really the best option. It's not a
big deal, I just wanted to try to avoid it.

