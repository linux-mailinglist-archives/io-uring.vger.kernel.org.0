Return-Path: <io-uring+bounces-10957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3904DCA3B9E
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 14:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 294CF3056569
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 13:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0A23370F2;
	Thu,  4 Dec 2025 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UySNlPfD"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B222E2D8396;
	Thu,  4 Dec 2025 13:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764853698; cv=none; b=eoAKt44lWKLgxKDawHLbz0MMMrspmSd219XS6EofEElK7jF4FD2H9Pw/eN9QhXYtB2pSYOsPzpufXJEG467PRM7Fd0oGTxlsxsvR4cWXjXGFuC8NNWFPLwTZfYgfmSsCOLctzrPDYcuJuGxad635R8ZOpjTSV8g860f7Gf3Et50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764853698; c=relaxed/simple;
	bh=rB989h6MSh13pP4Vgs0B4WEV9BNVjy13/RE0/6oqLRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7Bu8e4zlm+NkdP4UYvK5MjmUV5CpcjX1uqbVATYmJ4q2PPBMvf2Cf7KtHvPvVj9fOb9Q2+dcTGls/Y8NHbX7BzfTrDrpUx632mhjO9GK/T4AMNwP5KbUIsp1fkxDdYOaLolPxohykmMpLVWBs9FIa/iBqb/rtHw/D+r5YiTHpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UySNlPfD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ICX0PV1V3UJeK0rDn52UXwcxQDCvaMY3nHi8Ff8mBog=; b=UySNlPfDq60LjL7Gd30kmX3zfo
	D9Mvj9L61LQ39plfzEugc8WP+km9S45AZrwoMVhamwxf1hlRzL20LakWR0HEiqVmo9+r3vhH6JuKd
	N2oDOgUHW7L0ZMlFRTAIRriHGWARQyrOCF7sZdfKSSL+RROGRvypvrY6HDoEgBjsejmIxxTWh1dg9
	q2oXSu9PouQNh1Lq3ge7LC8er938LZLU78t4KEKZgpdizChWkb0tEBHFUtdxfRMwUWY3qNs/la5Mb
	IO9n2T1D7m8KRtyidkntyXZG+lZqefpztujrChtiC+YGlb59Hpc2Cc3UBFXOHMrAtufxtdBhp1zbx
	LWXjrkmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR949-000000081QA-0jnN;
	Thu, 04 Dec 2025 13:08:13 +0000
Date: Thu, 4 Dec 2025 05:08:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
Message-ID: <aTGHvbj2wfs33jRp@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Nov 23, 2025 at 10:51:25PM +0000, Pavel Begunkov wrote:
> +struct dma_token *blkdev_dma_map(struct file *file,
> +				 struct dma_token_params *params)

Given that this is a direct file operation instance it should be
in block/fops.c.  If we do want a generic helper below it, it
should take a struct block_device instead.  But we can probably
defer that until a user for that shows up.


