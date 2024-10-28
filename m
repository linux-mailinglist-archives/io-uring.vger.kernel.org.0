Return-Path: <io-uring+bounces-4064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BC79B2FE2
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 13:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49B0F1C24476
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 12:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2318D1DA0ED;
	Mon, 28 Oct 2024 12:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nbYSSs/T"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED81D959B;
	Mon, 28 Oct 2024 12:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730117516; cv=none; b=Evru85bNOQ4D6F/95hhJGdJjSs8ZqYHd3hldYKvOzQM3xxF9zivdpTyTqIWjPzb9bnsF5U1fdvCUCncqXF7A+WO5U84NERVMAg8o7sBnIjF0NGx3UwJN4MQsjycW/EyBN9oysorP6r8mPtvNr4NeTrHMeXEOpEMkEpiSlMdMB1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730117516; c=relaxed/simple;
	bh=T40pcA7zJ/qVaC7YSZjlKPz7uruyFhUd/a3SW0zAaTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aaKOcYMUTFE3koDg90dvL3KGERosTqG/jiDlvniL43LstyjuH72uKXO7CRvAvYnRgcFf1ZG1n28z78ta+Rt6Lw8qKbNEBa6lyhdqs0/eAnOPUi5pcf5iNQDd0R1kSCXi2bf3Z7fTiQMZ506PkijeAlCOdtLjXiPUl301wuQgFEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nbYSSs/T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GANchaQxtsQUXPkHXZjcwxb7mo3qTTIUVflFphrpMRQ=; b=nbYSSs/TLdUtkkX49MCiEy49wQ
	JhQCqc+9shj6l/rWgmHUh3vHb2TelgkWvfsR9RiPKwCbTJ9cyV3FGFLc3ToTBKOJK9g98c4rckiQX
	hRSSQ0KcerCRxh+w6FDY+2FM2FkkgMlqfZitM1S7Kzqrdl6dF3iXXi78VvTpy3i7gzKON2oNwBl/g
	bKPKa26ZTjFUTDKupOhE3BJLM1zzAGN9G7crkz4vsMfOQ01twKvtXUGBeoVWFwzAObWfEFBoM3QhG
	6aCaKdem/ibNjvj0PlV+fK3MH6K73fRd48XjwIpj++F7ehMjqiHmOqRXaPY4OkF4b5izBQAY5/IQO
	b/dE4d4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ObB-0000000AhRn-0J2V;
	Mon, 28 Oct 2024 12:11:53 +0000
Date: Mon, 28 Oct 2024 05:11:53 -0700
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
Message-ID: <Zx9_iYLVnkyE05Hh@infradead.org>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk>
 <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
 <ZxoSBhC6sMEbXQi8@infradead.org>
 <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
 <ZxpwgLRNsrTBmJEr@infradead.org>
 <de9ae678-258d-4f68-86e1-59d5eb4b70a4@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de9ae678-258d-4f68-86e1-59d5eb4b70a4@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 24, 2024 at 05:40:02PM +0100, Pavel Begunkov wrote:
> On 10/24/24 17:06, Christoph Hellwig wrote:
> > On Thu, Oct 24, 2024 at 03:23:06PM +0100, Pavel Begunkov wrote:
> > > > That's not what this series does.  It adds the new memory_provider_ops
> > > > set of hooks, with once implementation for dmabufs, and one for
> > > > io_uring zero copy.
> > > 
> > > First, it's not a _new_ abstraction over a buffer as you called it
> > > before, the abstraction (net_iov) is already merged.
> > 
> > Umm, it is a new ops vector.
> 
> I don't understand what you mean. Callback?

struct memory_provider_ops.  It's a method table or ops vetor, no
callbacks involved.

> Then please go ahead and take a look at the patchset in question
> and see how much of dmabuf handling is there comparing to pure
> networking changes. The point that it's a new set of API and lots
> of changes not related directly to dmabufs stand. dmabufs is useful
> there as an abstraction there, but it's a very long stretch saying
> that the series is all about it.

I did take a look, that's why I replied.

> > > on an existing network specific abstraction, which are not restricted to
> > > pages or anything specific in the long run, but the flow of which from
> > > net stack to user and back is controlled by io_uring. If you worry about
> > > abuse, io_uring can't even sanely initialise those buffers itself and
> > > therefore asking the page pool code to do that.
> > 
> > No, I worry about trying to io_uring for not good reason. This
> 
> It sounds that the argument is that you just don't want any
> io_uring APIs, I don't think you'd be able to help you with
> that.

No, that's complete misinterpreting what I'm saying.  Of course an
io_uring API is fine.  But tying low-level implementation details to
to is not.

> > pre-cludes in-kernel uses which would be extremly useful for
> 
> Uses of what? devmem TCP is merged, I'm not removing it,
> and the net_iov abstraction is in there, which can be potentially
> be reused by other in-kernel users if that'd even make sense.

How when you are hardcoding io uring memory registrations instead
of making them a generic dmabuf?  Which btw would also really help
with pre-registering the memry with the iommu to get good performance
in IOMMU-enabled setups.


