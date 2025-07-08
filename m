Return-Path: <io-uring+bounces-8613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9063DAFC74B
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 11:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CDD21AA02E4
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 09:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840C02135D7;
	Tue,  8 Jul 2025 09:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UWKNWOvb"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA72AE90;
	Tue,  8 Jul 2025 09:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751967917; cv=none; b=U0ws0NvccN/8Y8Z3boVfVzondSmbcKe7RHzX1biU/BT9vxS6FN2v28wnqFpbEFjffLM3+/s9qeaGaaF603N0O0wSX5jRJ89F15Msm+sknn8dWEKMAlmbgfgBuVybRP9o+ylFzGOQsZhyvejLPDm3MRULY/9KHImb1SAoTfeczv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751967917; c=relaxed/simple;
	bh=dGcUdxYiM4ayxMycyB2LSOUC00gSDU0QfvS9fJ9kzxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JkP4ufBrUnCAl3E2Ztt2umBH5PfpMl/zyLZEWHlxoOnFzIlVU2oHYfkr0u9z1jZ8ZAaVkOko3wKg5rSYp0qDzJ0CxEs4ny6S1luJ+4tI7jh1TGd7nkOQIFDeqKoqgmL1n8QGa1cyQPF3fHXGPsdJU9TWC2LGRZpvKKEkaT7GrT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UWKNWOvb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aIbqbwBgG/lyES8ZapCr+jWLXI49EU1keL2UKBLl4ZQ=; b=UWKNWOvbW1xTiQyAkogBIy5vXY
	1kMTpJM38uJiKRySLNvCg1/KWyoRb1P010eKGu0Ne4OmVDj2enRDpDMIYiYutgg62elXC6HX5fRwp
	M1LNLNaS6wDYR9RjAnmSCamtrf8dgwjDhxgF2622TFGsWOtY8XIgCxUX7uUkeFHHe88+IJxPP1aH5
	C5UZrWlj2eHwJoWhyOzwHz2bpVaRlInzIv2GdifcrnVgCksZ0myip6UGZhhb0Tu0LW3YV/B7CjhVD
	9z4Jd2Nv/RLlugnLGApfhYL3NyOuZthIVKEvuC2NpqgIbuLqfHQrETLIoiOgkss1GF0ULYqQBX//B
	eBqoAwnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uZ4t1-00000004vIx-0KrK;
	Tue, 08 Jul 2025 09:45:15 +0000
Date: Tue, 8 Jul 2025 02:45:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>, Vishal Verma <vishal1.verma@intel.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC 00/12] io_uring dmabuf read/write support
Message-ID: <aGzoqyM06rgXIJst@infradead.org>
References: <cover.1751035820.git.asml.silence@gmail.com>
 <aGaSb5rpLD9uc1IK@infradead.org>
 <f2216c30-6540-4b1a-b798-d9a3f83547b2@gmail.com>
 <aGveLlLDcsyCBKuU@infradead.org>
 <e210595b-d01f-4405-9b5d-a486ddca49ed@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e210595b-d01f-4405-9b5d-a486ddca49ed@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 07, 2025 at 04:41:23PM +0100, Pavel Begunkov wrote:
> > I mean a reference the actual dma_buf (probably indirect through the file
> > * for it, but listen to the dma_buf experts for that and not me).
> 
> My expectation is that io_uring would pass struct dma_buf to the

io_uring isn't the only user.  We've already had one other use case
coming up for pre-load of media files in mobile very recently.  It's
also a really good interface for P2P transfers of any kind.

> file during registration, so that it can do a bunch of work upfront,
> but iterators will carry sth already pre-attached and pre dma mapped,
> probably in a file specific format hiding details for multi-device
> support, and possibly bundled with the dma-buf pointer if necessary.
> (All modulo move notify which I need to look into first).

I'd expect that the exported passed around the dma_buf, and something
that has access to it then imports it to the file.  This could be
directly forwarded to the device for the initial scrope in your series
where you only support it for block device files.

Now we have two variants:

 1) the file instance returns a cookie for the registration that the
    caller has to pass into every read/write
 2) the file instance tracks said cookie itself and matches it on
    every read/write

1) sounds faster, 2) has more sanity checking and could prevent things
from going wrong.

(all this is based on my limited dma_buf understanding, corrections
always welcome).

> > > But maybe that's fine. It's 40B -> 48B,
> > 
> > Alternatively we could the union point to a struct that has the dma buf
> > pointer and a variable length array of dma_segs. Not sure if that would
> > create a mess in the callers, though.
> 
> Iteration helpers adjust the pointer, so either it needs to store
> the pointer directly in iter or keep the current index. It could rely
> solely on offsets, but that'll be a mess with nested loops (where the
> inner one would walk some kind of sg table).

Yeah.  Maybe just keep is as a separate pointer growing the structure
and see if anyone screams.


