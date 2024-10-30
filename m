Return-Path: <io-uring+bounces-4208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE269B66AD
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 15:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 677EF1C214DF
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D4143173;
	Wed, 30 Oct 2024 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OTLoqjE1"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB401F427D;
	Wed, 30 Oct 2024 14:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730300277; cv=none; b=dbHkslTiAgf7WT0W5XftOeQGHOLVFqSHjMwM2QEemqHZZzc+Hy+VhovyeAEiSEEatdoRsCt9dGdwFn0LK0B+RTr5Npco2s4XrSSAs3aROimUvznxAg2f9/9xIXM7XXwR5MkPLqCv/yQsoSbFGbxslFsohyNuA4tsQEBxeGsQvMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730300277; c=relaxed/simple;
	bh=mefuM4t1ECqbl3fiXwjneiO0N0zCuMcAR7sLOr/5iEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYlAtRxYJq30NVk0ozr6/9tkZPtDUHXd3ePaYErdcB/k7G0aRkE5QKRny3RkLMRHSY/hRrbjCvBcK2ZQaQK60lcvsi2EwqIWR4aRBsuwkFqkL8hb/gx+2wGgPKSJk7864VrAFP0V4rKKIB5B28mKcCpQPVhi1iF+sF+4HhXKw5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OTLoqjE1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EOhe37wzhw7xzeIak4/ImqmXuzFb2P7wAz173iN/p4U=; b=OTLoqjE1CZqI8ShDmv6JW4Ktxv
	hMRcPCrHHuu3B0qZfUNGiu9RW+3TpKco6Fmrg5szaBTrgFlqAQHcM4mWnn2QfL7M8uXM8F9Zhw4dB
	SkugKclQ8gBVH2xCldCkVnlZIsbRBC9Rt5+Md/5MwEGL28yyG6znlZuObJdb3QATdExFcwJTedoeS
	U3AJjnwNVpfZufyQ1NYkXFQmGtcN5WuSt741wtZvdZxtjWqJ/9KjRcwyUWrxbgBSuPwU0mRTGCORi
	CkH50ekY9Ok5BwMMHY8Fc4mLDvSyGgkjsqHZdrbRnyQ2qUvzown8yZzFMp+yI8lTIwiRDhfkjmyEI
	25loAEPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t6A8v-00000000kGb-1hC0;
	Wed, 30 Oct 2024 14:57:53 +0000
Date: Wed, 30 Oct 2024 07:57:53 -0700
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
Message-ID: <ZyJJcfQ-ldDtsfLN@infradead.org>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk>
 <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
 <ZxoSBhC6sMEbXQi8@infradead.org>
 <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
 <ZxpwgLRNsrTBmJEr@infradead.org>
 <de9ae678-258d-4f68-86e1-59d5eb4b70a4@gmail.com>
 <Zx9_iYLVnkyE05Hh@infradead.org>
 <9a14e132-6a13-4077-973d-b1eca417e563@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a14e132-6a13-4077-973d-b1eca417e563@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 29, 2024 at 04:35:16PM +0000, Pavel Begunkov wrote:
> I see, the reply is about your phrase about additional memory
> abstractions:
> 
> "... don't really need to build memory buffer abstraction over
> memory buffer abstraction."

Yes, over the exsting memory buffer abstraction (dma_buf).

> If you mean internals, making up a dmabuf that has never existed in the
> picture in the first place is not cleaner or easier in any way. If that
> changes, e.g. there is more code to reuse in the future, we can unify it
> then.

I'm not sure what "making up" means here, they are all made up :)

> > with pre-registering the memry with the iommu to get good performance
> > in IOMMU-enabled setups.
> 
> The page pool already does that just like it handles the normal
> path without providers.

In which case is basically is a dma-buf.  If you'd expose it as such
we could actually use to communicate between subsystems in the
kernel.


