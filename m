Return-Path: <io-uring+bounces-3106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 732829739C0
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6D8EB258DD
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046F0188CB1;
	Tue, 10 Sep 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yXWuVvzp"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1AB18FC67;
	Tue, 10 Sep 2024 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725978062; cv=none; b=fvvNtseHZJK7x6dKaipEWEkbzI9zeW9Mh8xZlaBh651NZnhbVr/jY/smS8gP7WQZon/ztLpORtR5/7bXXsQU+GDuH9/7ZkJ/0PCHR4ofoLxDEZ1j77h72X4dXb6OCI8zvxhEZ21oU1VgzLZvUy0gZwpddZkF4SD0x9sJbE5+jhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725978062; c=relaxed/simple;
	bh=t0zfhUCzFbQpQ2vWvHz1DzfYXJoS1tC6CBScO8aept0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGQWD9KZJUAkGXp4dKHh5fRC7xotDfsMn/4ZRmWamTn+mDE9xJ8q25KSno8HlJ8eLkgeJln2B1rhe1/dCA1fG5ql10xCLLrjsLAJd0z+3P02x5V96wI/sOjSrHWTpnakx0oAeNds0Dmw/RSb0ag36oqjJHfz2z9qnq44H1nO18s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yXWuVvzp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SQ27hHAn9LKNNpp23rFT1O9ivXHn5Hr9ICtgjyHmaxI=; b=yXWuVvzp4E5G7rZtyhPonNsJzN
	teBE57AVqWoRuO/UsYMqNbQ+xfVl8lDgaH8zz5d5K/a8QAxHM+dTgszMHdYXF/H8h/ILvZ7FrmqoQ
	bk/kUyp7hcooZ+H0XSeR0dQas8xSBYEY25TZ8jzlMLAJYxb8W2DgpjDiGIfQzMQuYa8kVrpBUTfJJ
	eO3ISs5OJjCPQi0603wr21fzqsmQkUC+y1f6NDc6RlsooTTsCEBjkl/JVsDQtQvJCq1Y0VVF/e+DQ
	83J0/4zgG6LKGem72HO3TW8oQbw8u9AqnT9lK4c1SWvvDMo32UHvHYwhxs3Fyk3bvqVQn0ACVpaDl
	2a88HINg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1so1jn-00000005r8k-2FDr;
	Tue, 10 Sep 2024 14:20:59 +0000
Date: Tue, 10 Sep 2024 07:20:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 8/8] block: implement async write zero pages command
Message-ID: <ZuBVy2U7Whre7EnU@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
 <Zt_9DEzoX6uxC9Q7@infradead.org>
 <d205d118-8907-4da1-8dd8-2c7c103d2754@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d205d118-8907-4da1-8dd8-2c7c103d2754@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 10, 2024 at 01:17:48PM +0100, Pavel Begunkov wrote:
> > > Add a command that writes the zero page to the drive. Apart from passing
> > > the zero page instead of actual data it uses the normal write path and
> > > doesn't do any further acceleration, nor it requires any special
> > > hardware support. The indended use is to have a fallback when
> > > BLOCK_URING_CMD_WRITE_ZEROES is not supported.
> > 
> > That's just a horrible API.  The user should not have to care if the
> > kernel is using different kinds of implementations.
> 
> It's rather not a good api when instead of issuing a presumably low
> overhead fast command the user expects sending a good bunch of actual
> writes with different performance characteristics.

The normal use case (at least the ones I've been involved with) are
simply zero these blocks or the entire device, and please do it as
good as you can.  Needing asynchronous error handling in userspace
for that is extremely counter productive.

> In my experience,
> such fallbacks cause more pain when a more explicit approach is
> possible. And let me note that it's already exposed via fallocate, even
> though in a bit different way.

Do you mean the FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE case in
blkdev_fallocate?  As far as I can tell this is actually a really bad
example, as even a hardware offloaded write zeroes can and often does
write physical zeroes to the media, and does so from a firmware path
that is often slower than the kernel loop.

But you have an actual use case where you want to send a write zeroes
command but never a loop of writes, it would be good to document that
and add a flag for it.  And if we don't have that case it would still
be good to have a reserved flags field to add it later if needed.

Btw, do you have API documentation (e.g. in the form of a man page)
for these new calls somewhere?


