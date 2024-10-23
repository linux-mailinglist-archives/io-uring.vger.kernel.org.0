Return-Path: <io-uring+bounces-3938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A19F9AC016
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 09:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD6A81F21D92
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 07:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C680F15350B;
	Wed, 23 Oct 2024 07:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sg/k6Sfu"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E9213DB9F;
	Wed, 23 Oct 2024 07:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668040; cv=none; b=SFBOTjF0rpzgZHK9bx8EY7IUGVOz7exmz9H8AbzNOUWR0B1LRdW2rAosBKVrb6MUjtlX5arWUjy/Maq+9m1kSLa9MDvAeG9bXno1WX91UJff58QNhUP6WywwKPbanYu20Lc/VzJE64tRYzORpPpvzkm+xhxEHLgKsjYLn7uW9GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668040; c=relaxed/simple;
	bh=EYSCT3GpLwpgWQjmPjVqWCwYz6V61945ajYy0Xe+6iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcUbm3iZJetno49wTtBX+PCYUK+0tdN6ywaVZWfWpoS2cmvDkpMGw42YXFLDsZMFGjCJKxjIV54qr2D36VnILIT6V/OJRVdOhjaIu9Gvo0W+RJIpDfiE0+KKv7+T4DIjAnZo+XjL2qh9IlH6ZqYLmq/aVlVRaOj1FQ7T7R4FISM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sg/k6Sfu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w+90h7H5AVOlUGCT6jpiVo75HoG20ZQ36MbBIWzDKCk=; b=sg/k6Sfu33Iw5/CiNpoYqkyf4X
	ElBBSIB+U1NJ6KBwX7CC1QLsj5/W7jRqgkVLS/Q1t55vyPeXoDDFWS8o6/u7JhoeDWfyv34O0lhQj
	NtSUWkELXMp3MDvKLwNwpQtsB85FtrY2ZsBiXxWGnjvrddxbNyryGmNOy5H3tYl3+U4EkspGvnqe9
	+ukocsux5Q+eNjr3i0AEtuBcufLP0hheAujRayp+4/YL9wtVn+h05KQ3rYQsvBnRkSJJCchy8W8Gs
	mRgTASenNL3AI7px863NvEkEOGfQgoYHm4P+ArsmPt1xZ+0/48UzWn1h2Ek//qM33/l7ceMPCS37s
	vllZB6xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t3Vfa-0000000DMaT-0Hry;
	Wed, 23 Oct 2024 07:20:38 +0000
Date: Wed, 23 Oct 2024 00:20:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
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
Message-ID: <ZxijxiqNGONin3IY@infradead.org>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016185252.3746190-3-dw@davidwei.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 16, 2024 at 11:52:39AM -0700, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
> which serves as a useful abstraction to share data and provide a
> context. However, it's too devmem specific, and we want to reuse it for
> other memory providers, and for that we need to decouple net_iov from
> devmem. Make net_iov to point to a new base structure called
> net_iov_area, which dmabuf_genpool_chunk_owner extends.

We've been there before.  Instead of reinventing your own memory
provider please enhance dmabufs for your use case.  We don't really
need to build memory buffer abstraction over memory buffer abstraction.

