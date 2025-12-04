Return-Path: <io-uring+bounces-10949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC68CA350F
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 11:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00D1030BAFE3
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 10:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAEA3331A75;
	Thu,  4 Dec 2025 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K2BRFBOF"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909CF336EC2;
	Thu,  4 Dec 2025 10:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845022; cv=none; b=HgaZfHxXSBdrfDQzGEBPcvul+q2/UkVQGKnLDHHvYzoHnYh718t5rh7HAd2NPSDFiyCDcTqqSVVos+5vXlSfyUaPPxQmNEsZU0OHWl4CUx4FM9/eLIBdc1n9bZhVBiIgeLcuPMLWD2iVWsyOVjHHpvVAY0UetasWM3Irg9eCX1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845022; c=relaxed/simple;
	bh=V4hLJV0WcNI6t1NJfjDFxE+aIHxg9AgO9PhOiOrPwTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hm2NPAL3kBvr5uTlM0WEsvb2ozpTNn5ExHW6hGAR5YSgJVP2P0c58T7KDN5ywp2NCh21OahcW/wHHVz2DgOgw+0Y0mLAgD2FbjpmdmacXVqX+6oxS4vNfmSosV+7oESp4eSETr4WWwlu/5kuX79Mr87npnYwJAVKqmHlAIMuA50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K2BRFBOF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=idCFnFrcUwTtb74aqgqX3OChCwMLLJI8Rgwiu4DAog0=; b=K2BRFBOF4STdM5n71oCxHURkyJ
	KtQjMWn/9TxNZyOFUCMJBMwk3YmSdz8sGr+lYeSmkGXR0go6CosvKBKWBtrFF+y7PywB4wFtfw9gI
	8t3liVGA3mJSStBbxB1LQFnNmbO8rgpnNH2w8AGTzful7ozAXRhheILgv/kvDdhPnz0XRpoVnumit
	OHmSdfbx5Ym5V/8zbG+f/LYgLM7L/8IIWHjmzSmj1DUXkbnespHZPfRkczHxO8Suz4zOnPwGeAdrR
	md7tOKdS+pWrdfhmvvfRKaPQjEVTnsEkYl3LMhkWU+q72FuaE96F3N6SVnZfr6TiYrfLssncAkq0y
	Gsip+55A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR6oF-00000007rBA-2kX4;
	Thu, 04 Dec 2025 10:43:39 +0000
Date: Thu, 4 Dec 2025 02:43:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 03/11] block: move around bio flagging helpers
Message-ID: <aTFl290ou0_RIT6-@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <6cb3193d3249ab5ca54e8aecbfc24086db09b753.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cb3193d3249ab5ca54e8aecbfc24086db09b753.1763725387.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Nov 23, 2025 at 10:51:23PM +0000, Pavel Begunkov wrote:
> We'll need bio_flagged() earlier in bio.h in the next patch, move it
> together with all related helpers, and mark the bio_flagged()'s bio
> argument as const.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Maybe ask Jens to queue it up ASAP to get it out of the way?


