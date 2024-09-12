Return-Path: <io-uring+bounces-3157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6684F97657D
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 11:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 125CD1F277E9
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 09:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE64191499;
	Thu, 12 Sep 2024 09:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fVxw5Dlp"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE492189B8E;
	Thu, 12 Sep 2024 09:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133194; cv=none; b=QXPXojsUwdnS7Sy4OW5p08Wo9aZPINWqila8ikC/KcHos3RWaGwMN2N+I2vR9Y8pw7hVOMonKFI/7abslvFu4FbXNNr4neg2tmT4MsQvh/04/G0uMrKGWC+U3VlnjPuMxuaWAP9Vj1xCFJktiWXJVnw0bwemGPOUh/2L6uK9yEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133194; c=relaxed/simple;
	bh=khf1HhBvpU+h2z8L0zX+YklPpKmVVf/0tKV1xfSu49Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQUUEWLwO+TkjGmYwNj3odzD3DUhvmp3ubCDxJWPtfvjb7fwfV3gmlnXsatxLukVh1XVv3YwM0g4jYLjFxL+7swyZ3ilrDt1lKLNRoocdNkmq+saqvFpWIZSuvT+CN/GbaHFlKWJVsY6ccYgeDQAw55Hi4AqTILHqntayVwSm5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fVxw5Dlp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qZrcBqxMalG7OXdtjJDUEBM4nS29K+nJn6GRl07zvRc=; b=fVxw5DlpTKrFCQS7eG79Z01ue7
	ZO11jOcrKRANRWPGQYCOGFHHwAcnkTFMRnkNKSbgKd6CBzG3yERYkfQi5MWPCYcOYRz6RxJvq60WO
	Ho9gvufOuaHHji/VLTH7StzYqxWI7svnsbi5GCGrr7nGXGuPZtqzo2hLoC+BYl05OBfhEk5swapk0
	rsE8V+wz0+tLUdmc5AgVjFbQz3JV9FAuMIDyOSCKB1Mp51P/2zf0pG8/VF6iXdIdMfJuWsZyDM8gY
	+UyfbiqKo1aMxgQjZ4xszZEz1oU019LOKoD8FavkMHYA8Z9JBGuB1Bi2Wht488jDqAAp6+oeMZuxL
	qKfLOALQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sog5p-0000000CWKn-3hXZ;
	Thu, 12 Sep 2024 09:26:25 +0000
Date: Thu, 12 Sep 2024 02:26:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 8/8] block: implement async write zero pages command
Message-ID: <ZuKzwSA79NtLAMcH@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
 <Zt_9DEzoX6uxC9Q7@infradead.org>
 <d205d118-8907-4da1-8dd8-2c7c103d2754@gmail.com>
 <ZuBVy2U7Whre7EnU@infradead.org>
 <bea206da-d634-4e34-8d69-94a024721f21@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bea206da-d634-4e34-8d69-94a024721f21@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 10, 2024 at 09:10:34PM +0100, Pavel Begunkov wrote:
> If we expect any error handling from the user space at all (we do),
> it'll and have to be asynchronous, it's async commands and io_uring.
> Asking the user to reissue a command in some form is normal.

The point is that pretty much all other errors are fatal, while this
is a not supported for which we have a guaranteed to work kernel
fallback.  Kicking it off reuires a bit of work, but I'd rather have
that in one place rather than applications that work on some hardware
and not others.

> That's a shame, I agree, which is why I call it "presumably" faster,
> but that actually gives more reasons why you might want this cmd
> separately from write zeroes, considering the user might know
> its hardware and the kernel doesn't try to choose which approach
> faster.

But the kernel is the right place to make that decision, even if we
aren't very smart about it right now.  Fanning that out to every
single applications is a bad idea.

> Users who know more about hw and e.g. prefer writes with 0 page as
> per above. Users with lots of devices who care about pcie / memory
> bandwidth, there is enough of those, they might want to do
> something different like adjusting algorithms and throttling.
> Better/easier testing, though of lesser importance.
> 
> Those I made up just now on the spot, but the reporter did
> specifically ask about some way to differentiate fallbacks.

Well, an optional nofallback flag would be in line with how we do
that.  Do you have the original report to share somewhere?


