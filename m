Return-Path: <io-uring+bounces-3961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA04C9AE07F
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 11:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1439E1C20C6E
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 09:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE40C1A3028;
	Thu, 24 Oct 2024 09:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iZx25NEm"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3991714B0;
	Thu, 24 Oct 2024 09:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729761801; cv=none; b=ZvO8bORraDHKAeR0Gtu1ve8IelQJOkg8nohjlH2rxZRXlFtW3gmiYbM9rb1VhYIeDkGu0H114Kfo+ul0VsoC6W9pWV+8nxFG375ggt934ZHYDASX+T3RliwW2EE7DMs0n4Zu32kl3l5UnpwahB0vdjyl3dIvVb20eH83cuMJpuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729761801; c=relaxed/simple;
	bh=jTrNcLdri+3sW4LQC21Re0gXmzoWnYgbwbhiJJfYRxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tapQCpiWLVyqQ9TIa/TpgpxNyXqFZvDbOjXRH1I11y5XO1gYIbyjFfpyd3EfanQxFQ9Z/FQeJuVXzKeReWGBiT2zy1ryvufV6M39Ui/AyTMXTpM/swPZftE261t9O6TG5fGQ9utDUfvrcx6SYWm9wgHUj0ZO6mAeltpDxDiP35M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iZx25NEm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cNG1v54GZGBbvGCSwdr00JWJ070P99babx+9AJaD/EE=; b=iZx25NEmGfWGdU9TR3Z7lOIlHN
	860ZRDCDc6MYSxH7C5rCboTyY85io1hD4DTH0VXgePsuLBj85GxVdINRL9ppqAvtsgmMAUE7fEf64
	EiLE1vLnrU4rtgqQQRTS04uthFrfHrUh3o9R0IG9D3r+wbQSklLnEQ6Bw5OlCkJ121+y6yVT7R6Gw
	KMIXnizp6B2d1oEgi4CEc8K7ioDkoqgkT4clBkF9oNXaTrERX7OjPreJ0BNDBZDOgs89pEzvDOoVD
	/PO6+d+ouDQCbsKm0+tEZn1M4l3+Kgpmf7XZn2I+JBlqidrQk5y9hpIHddEvSu0I08GukpFt0fYO6
	ozhOLphA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t3u3q-0000000HRLl-3drM;
	Thu, 24 Oct 2024 09:23:18 +0000
Date: Thu, 24 Oct 2024 02:23:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Wei <dw@davidwei.uk>,
	io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v6 02/15] net: generalise net_iov chunk owners
Message-ID: <ZxoSBhC6sMEbXQi8@infradead.org>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk>
 <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 23, 2024 at 03:34:53PM +0100, Pavel Begunkov wrote:
> It doesn't care much what kind of memory it is, nor it's important
> for internals how it's imported, it's user addresses -> pages for
> user convenience sake. All the net_iov setup code is in the page pool
> core code. What it does, however, is implementing the user API, so

That's not what this series does.  It adds the new memory_provider_ops
set of hooks, with once implementation for dmabufs, and one for
io_uring zero copy.

So you are precluding zero copy RX into anything but your magic
io_uring buffers, and using an odd abstraction for that.

The right way would be to support zero copy RX into every
designated dmabuf, and make io_uring work with udmabuf or if
absolutely needed it's own kind of dmabuf.  Instead we create
a maze of incompatible abstractions here.  The use case of e.g.
doing zero copy receive into a NVMe CMB using PCIe P2P transactions
is every but made up, so this does create a problem.


