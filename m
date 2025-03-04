Return-Path: <io-uring+bounces-6959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BCBA4F1C4
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C40BF7A3568
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 23:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70FDA259CB0;
	Tue,  4 Mar 2025 23:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r12T5CUv"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA11FF1BF;
	Tue,  4 Mar 2025 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132155; cv=none; b=AsC3sBJUc8lndCJoJCVKGXwj8G17Ao3LZrIs4ekkDc4/fS8yoAIybiyVqd0AKy2ugLhTBPScGMWgJDR4B/pNl/Qj69qClyYkknMRe3ng3GRW8rXiSw7iUxgoME7UR2Flfu8ac1RYoYLrP4PGc0mFkMqBx7xuiDx6XAO/y3hx+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132155; c=relaxed/simple;
	bh=ks/4c4sgQXSDhyHvP2NbUKCE/Ch6lf5kd37cUJOSHiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAuQZp4fPCXx6djcIapW6ylIzgnPY10M4P6LjkhsXMmUIXPO0r7Je3HSEdhRhCiX0Dm28lWIusYRHb11gBpXCTloYj1/Kd5yK/Z8LT88c9poZ+7oLNIofuxwlwBsG81rR6jxrCHgPgqTSDNxt/lTwbkN7NGt1eia1gMkzoJrqh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r12T5CUv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GnfwnItORsJ1Jvi9M7G+8hlt6pq6w6viyYuzebGi3w8=; b=r12T5CUveUF8MNsJ75xJ+v/0TS
	MWxnggAqxgi909It6OVt0Vgn0F6X23Ok7xW7LUp83v5x5jgNCvZ0uA2okU9OYV1tKcS8GHdDBRTv5
	jPIP9IR4wRyGF9a3ZUe5t8321W89OYB4roVAggSIK7KTJj8MnUURFFCsS5D3XTX96nChfyvRk6ltn
	ZbO/0d7VZ8DPyT6/gsw24NVJj8cFpJkDrMjUQoe/SWBwslOZeabLqLUn7AIUENOLMnOlH1Z04FE7g
	Yhs1gC5zaxsVCs2vTVX+mP77Uag2h05owxQhGX1BURKsAQR/Mzjz+CRmeLjK9y6smAU+PXHFk8Ucy
	rnB5/QGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpc0f-00000006YuN-2tIQ;
	Tue, 04 Mar 2025 23:49:13 +0000
Date: Tue, 4 Mar 2025 15:49:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8eReV3_yMOVOe3k@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
 <Z8eMPU7Tvduo0IVw@infradead.org>
 <876fa989-ee26-41b3-9cd4-2663343d21f7@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876fa989-ee26-41b3-9cd4-2663343d21f7@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 04:43:29PM -0700, Jens Axboe wrote:
> On 3/4/25 4:26 PM, Christoph Hellwig wrote:
> > On Tue, Mar 04, 2025 at 10:36:16AM -0700, Jens Axboe wrote:
> >> stable and actual production certainly do. Not that this should drive
> >> upstream development in any way, it's entirely unrelated to the problem
> >> at hand.
> > 
> > And that's exactly what I'm saying.  Do the right thing instead of
> > whining about backports to old kernels.
> 
> Yep we agree on that, that's obvious. What I'm objecting to is your
> delivery, which was personal rather than factual, which you should imho
> apologize for.

I thus sincerly apologize for flaming Pavel for whining about
backporting, but I'd still prefer he would have taken up that proposal
on technical grounds as I see absolutely no alternatively to
synchronously returning an error.

> And honestly pretty tiring that this needs to be said, still. Really.

An I'm really tired of folks whining about backporting instead of
staying ontopic.


