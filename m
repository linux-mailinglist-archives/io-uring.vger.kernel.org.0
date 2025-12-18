Return-Path: <io-uring+bounces-11211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87621CCB395
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4764300794B
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942201D86FF;
	Thu, 18 Dec 2025 09:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YzklQRHT"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397B32E8E16;
	Thu, 18 Dec 2025 09:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050738; cv=none; b=I+UH2IYMgd94JMgnIQZpjqWU8UyEL+L3F4QS2pJ9u0J6rzjbA7CGrwRb/bolg/HAQ54s+c//Ld/C41xK2RC5Gfl4TMzECMj/wloKgG6lS+C4Cx7pSUjQl1Y/iVn0480r3svvowHMmH1LnS0iuqa9xrmY2BSJYR9zv6X7VJPnyMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050738; c=relaxed/simple;
	bh=w75zZlJvMZAL3Ahznrh2HPBKCvGY6SwE6HYC4OZ/m/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFwRhNGDCBgNkOjGrvdNvcu9aXAx4rhHCZyiOsf6BEgbD7AcvS4Hqy+Z27vrQl/5PQdf3u1mcyMcTrZ5I39Nei9KnQDoC8jCcZaOSxql3/IGULNRUxX9V+MFgMvkTAwGUphDfzCZlGsHqHdiWZWw/MDKsTNYJe5OqYVjO5S1On8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YzklQRHT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Zx6Nb2DtC321NBtNMWjmqbfzgZP0zfMswFguelvxTr0=; b=YzklQRHTZCE0MKQ/ayaLmxoyEB
	Qq40ox68eCZQkUiN968bPVIOXZOCOCYzEzYO0tdNZAi9YRnXcpuiv+AMRQBTBaPYATXvc9bGoCoiq
	vAt9zmHyBPYms9zxNL0+Q8o01smDIiBb0H2rtXQ91/WmMh5nXqZQcOmUwbKMjshXza0Z8WSJmK86g
	NhlZVupA89g3MCT8UIrIqEr3ReaCUps6dfp2goJAM9bmno/6RPZSmQAIyrQN82Y4xkilYY9EAX1sZ
	rGZtuuX5r/2hBN4iZ8RTEhC/c12o52xhtGnAd+73Tq2BSnH8G48IUT+ueO1wRlx3VWKPzg/GB5KiG
	xQjn+/OA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWATH-00000008ADG-2vx8;
	Thu, 18 Dec 2025 09:38:55 +0000
Date: Thu, 18 Dec 2025 01:38:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH 2/3] block: don't initialize bi_vcnt for cloned bio in
 bio_iov_bvec_set()
Message-ID: <aUPLr_cUd9nmvoI0@infradead.org>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
 <20251218093146.1218279-3-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218093146.1218279-3-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 18, 2025 at 05:31:43PM +0800, Ming Lei wrote:
> For a cloned bio, bi_vcnt should not be initialized since the bio_vec
> array is shared and owned by the original bio.

Maybe, maybe not.  What is the rational for that "should" ?


