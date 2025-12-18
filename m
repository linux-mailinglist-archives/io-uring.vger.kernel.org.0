Return-Path: <io-uring+bounces-11210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD79CCB33E
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E6D1B300B923
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AD73328E7;
	Thu, 18 Dec 2025 09:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gGj3xOQw"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B45E3321D1;
	Thu, 18 Dec 2025 09:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050662; cv=none; b=FwkDWE0AkdmD+Gg62vHwKbsHlWeOrLTRs7cBoKbQ3GX61U08ktGJzYHZLQabvHoBxxyktg6ic6SiUY7WRTbpZpbGojxPymX1mHWp7yugdUmut70tU8k6sfRQzfMbBTy7QYG7rBVwQLnesOw498un9RvlNdjwP0PQoa7jy63tumg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050662; c=relaxed/simple;
	bh=vWJ4cdmrkvI4ieVrRawR1MELGR9c1Vn5pY4VhVW6VHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekfep9lAUp7b9M4PIG1sXlzbbRkxClUKuNalUGpe6fgvTibSrmOmxekDsWNRacgsnKtFtl4/yI7MsYnoQy2IcFtBlHzAaE2s8B+Q/2Xx3F4TTfCXApCOuyXrYemZCwjMc1e+RXLZbzKkWM2OEWeK5fQd7dclcKtStNu3tNgsPHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gGj3xOQw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=418ItCLm0WIHrajf4kTh9NyZoEJJBs0Wd/JaxwLOaGs=; b=gGj3xOQwkoW028tJruEM5PBuPy
	kizyDSTtj0E5RixCAa1w4GvWnYbehXkjc0k5pl/dDy0ksicUBzewL7eWzScDhZ1ZY5InAMXbhI+Vz
	roexj5q1+83MGxoZhw9eaaqISnv8PkVuW+3FM6nrEKeYcDYsetGnjQc7J9mtP7CgyQOG3KJx0FlYO
	gg4oP6xEbv8ae8sJz1KjrEz955itlWyfguAP48vvArMh+VXRi4cqYx2PMQ+vq9uUupy0citqNaeJL
	uNI++xOSxC3gN0iOqoWakYGH7jUGJHlFf+7CGoyYgnVzLTmCIN95S+Aw/3oeoY0NwsBpENBn5Y2yH
	1r2gnCaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWAS1-000000089zN-3szg;
	Thu, 18 Dec 2025 09:37:37 +0000
Date: Thu, 18 Dec 2025 01:37:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH 1/3] block: fix bio_may_need_split() by using bvec
 iterator way
Message-ID: <aUPLYcAx2dh-DvuP@infradead.org>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
 <20251218093146.1218279-2-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218093146.1218279-2-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 18, 2025 at 05:31:42PM +0800, Ming Lei wrote:
> ->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
> passed to bio_may_need_split().
> 
> So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
> checking with help from bio size and bvec->len.
> 
> Meantime retrieving the 1st bvec via __bvec_iter_bvec().

That totally misses the point.  The ->bi_vcnt is a fast and lose
check to see if we need the fairly expensive iterators to do the
real check.


