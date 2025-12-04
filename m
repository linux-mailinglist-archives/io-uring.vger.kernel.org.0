Return-Path: <io-uring+bounces-10961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9247ACA510D
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 20:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C41E3024288
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 19:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D0234844D;
	Thu,  4 Dec 2025 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJith8/G"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE4B347FEC;
	Thu,  4 Dec 2025 19:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764875276; cv=none; b=SFeEhY4sOsYjZxRS05GrlKIh4W/PaXVu27sQpQS7vZIyFeTAVzsGZbYwnwX45moTgQM+ahYICA0czysi7ElBALa4N0Q2aVvT5ww5qPOpf5y+xsREe2ss40qGldEejcespmtrQnUuEWaBlw2XlCPmIyi6kr1nh6aBv3OSuj0iA4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764875276; c=relaxed/simple;
	bh=0T0myU9ZH1tB3I+V7V43BU4jBwzUFIVwxphPm1myBzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xdka7Oi/fVN0N52CcwUikBIkvD8FXpIK3jwST6yP3VzdXdPp+Q1LNwC4lz+h9jH+HeAzr0pCAwGQFc9iKpfju84pEMVZ0Hton7nPPcMEDhohzsZUEKgOAuykzd2aBQEK4Iconf8Mb2JC5T6oy2WElpwt8UU8xzLr5dPXO4NfWPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJith8/G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA03C116C6;
	Thu,  4 Dec 2025 19:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764875275;
	bh=0T0myU9ZH1tB3I+V7V43BU4jBwzUFIVwxphPm1myBzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rJith8/Gx4Wd98GNbJ7JgxHjEk0D7lIa7DnpsSn1yMaGQI1EqxuiciLXwN8wZjnEJ
	 qlxn4LehW7CPwkt/TTMulNZcItXi43kAMUvpYKmyfbKYiRELimMl9ItWI0kgWE/kNY
	 DfWbzXb0XWX6awag8QffycQU0ga5vSjnsYEqXVBd4zpvHQQQX3d1dxhOaC5FzIJ6Ma
	 Hy0H7EzRJg/nhYxMd5AhbzQ9AjRWFsCy3fbNeeBFBkprwe4nvjOnrPt+oWQqfVnP6K
	 TFX5BFa3hA3MJBYZfIM9zGb8IH9ErkKMEgjMl3Ts9QSjnlc/e0kR6/Uc/FgMonv2Sx
	 JSCz/VsurrB9A==
Date: Thu, 4 Dec 2025 12:07:51 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, Vishal Verma <vishal1.verma@intel.com>,
	tushar.gohad@intel.com, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 06/11] nvme-pci: add support for dmabuf reggistration
Message-ID: <aTHcB7Vm80XDMiaH@kbusch-mbp>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <9bc25f46d2116436d73140cd8e8554576de2caca.1763725388.git.asml.silence@gmail.com>
 <aTFpsl3o7IoJ_xPg@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTFpsl3o7IoJ_xPg@infradead.org>

On Thu, Dec 04, 2025 at 03:00:02AM -0800, Christoph Hellwig wrote:
> Why do you care about alignment to the controller page size?
> 
> > +	for_each_sgtable_dma_sg(sgt, sg, tmp) {
> > +		dma_addr_t dma = sg_dma_address(sg);
> > +		unsigned long sg_len = sg_dma_len(sg);
> > +
> > +		while (sg_len) {
> > +			dma_list[i++] = dma;
> > +			dma += NVME_CTRL_PAGE_SIZE;
> > +			sg_len -= NVME_CTRL_PAGE_SIZE;
> > +		}
> > +	}
> 
> Why does this build controller pages sized chunks?

I think the idea was that having fixed size entries aligned to the
device's PRP unit is that it's efficient to jump to the correct index
for any given offset. A vector of mixed sizes would require you walk the
list to find the correct starting point, which we want to avoid.

This is similar to the way io_uring registered memory is set up, though
io_uring has extra logic to use largest common contiguous segment size,
or even just one segment if it coalesces. We could probably do that too.

Anyway, that representation naturally translates to the PRP format, but
this could be done in the SGL format too.

