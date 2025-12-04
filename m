Return-Path: <io-uring+bounces-10948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 910A1CA345E
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 11:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 651E930E7AD2
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 10:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CEA330B2F;
	Thu,  4 Dec 2025 10:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gDL9yjg9"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF30296BC9;
	Thu,  4 Dec 2025 10:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845001; cv=none; b=ar1bTgq9DHK1qC16qILX583F17PwRvS8xr1Gn8QwapyQIiQzB52Sx/0STlJUSGZXytN9OYdxC0+4ndfH5hUDa9dEPzup0+NcbCqb3ABaJ2Tk+8xaiFc4gVdpzDJSG9iUaQz5XP+MzeYwOSsfCviQvfIDWePN0Iw3DAYnZL4+mSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845001; c=relaxed/simple;
	bh=GPP77VeslE1MaxJlc8kpTPR4YL6eDVPND5kyRHwKm6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kK13J71IGI7xL0+qGJ6z2oogPFGl9/aACSxQnExr36Z2nKuzCY79kioPXVDnF9VO8p/+kmefpY/qZYNYuKNC3XS1E2/VVPDJrzdLZik6whOEWsVMOCKzDqjqjLEbZE5zTVPeY+qKuI9anZP7788A1+pz+E+hnHsa0wAHe3+b0ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gDL9yjg9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iQm2kJ4t3N0jqrRweZW6C1TbB4FQZ8BUzhz52YJ0IVE=; b=gDL9yjg9ixWhRuha+zHom2Syb4
	WD1tBRPkQJEu7dCNjqfKxRofJ9Ag1cXd3r6XDqr+5Kmh3+SisGTNCXbCoD2HynVkknrtz1bHs/vOE
	xJ/OEhY5RzBYskXQrhQ14aK+3jIaJVSQiMfcjXtXsIoZZDlaEjEmk7xzhvmHTKlwgNGmUoKInHgJ+
	LnnRxa0rqlwV2RUtqj4EETWhsltqIh0FtNym3k9LJcd2lj6fKYBlo2OHEbIXIA/Z3jAcEdgAUdo4N
	+AO5EvRpvV37XV0kMjcEfw70LAn/g0Y808DO2ndDKcK3d92i98ji2jxLUxwa/D6NV+SGXFLJ8brQA
	5bCHS8Ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR6nv-00000007r6y-17Mu;
	Thu, 04 Dec 2025 10:43:19 +0000
Date: Thu, 4 Dec 2025 02:43:19 -0800
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
Subject: Re: [RFC v2 02/11] iov_iter: introduce iter type for pre-registered
 dma
Message-ID: <aTFlx1Rb-zS5vxlq@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <f57269489c4d6f670ab1f9de4d0764030d8d080c.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f57269489c4d6f670ab1f9de4d0764030d8d080c.1763725387.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Nov 23, 2025 at 10:51:22PM +0000, Pavel Begunkov wrote:
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 5b127043a151..1b22594ca35b 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -29,6 +29,7 @@ enum iter_type {
>  	ITER_FOLIOQ,
>  	ITER_XARRAY,
>  	ITER_DISCARD,
> +	ITER_DMA_TOKEN,

Please use DMABUF/dmabuf naming everywhere, this is about dmabufs and
not dma in general.

Otherwise this looks good.

