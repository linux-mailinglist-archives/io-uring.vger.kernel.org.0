Return-Path: <io-uring+bounces-11244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F6DCD4675
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 00:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C03613005BA9
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 23:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC9B261B92;
	Sun, 21 Dec 2025 23:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0li5F6c"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA8F246770;
	Sun, 21 Dec 2025 23:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766359777; cv=none; b=omiqMQWSw8J/mjjJvW+uAVxj6mOTWAr+RnuDx76iOoyyTBHr616vooNWwlGhnHlPWzApZE9k+06sS5w94kejoE3Qi1KCr2d0kIXoWYphqO1yoBh4M5vW7aw8ogWFNl3dj8mRCBkW63rSCk3s5pcNfPD95JIC4n/pGCBLhwPrm4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766359777; c=relaxed/simple;
	bh=t8HijVQv3B8zyuPMxhi4KJFXULFcp8yK+aMFo1c1tdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLjCESHyS81TrXHXiKRqkKfvHyLd901jwCVJIYAlAesP/Mh+MEgHbSgETmKib0cmVCO5nkurhi/Kd5gpSuygiH9T40vcGh2k6hjDr5XhcM1JZhPXObM7MqCd5qKFCbT8EEcxQGIrU+RwpEm+ARB4c9GzR50v2zkwABHovBeo85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0li5F6c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6967C4CEFB;
	Sun, 21 Dec 2025 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766359776;
	bh=t8HijVQv3B8zyuPMxhi4KJFXULFcp8yK+aMFo1c1tdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c0li5F6c7+eRoDeppoux5RFLGWbleHXhxtThyYJFSlBkAqwf7yz15ZwKN4VWDgytw
	 uxPoyIGLvMpdsBzoE/EnZB0Bglq/hTYc+f6tNGA2SI2qAC8LZ5BS5IHCFy9iSoBodq
	 OrWpq9ARrdZHZV96o20vfW9u+KE01uhs039QJshFzhJI/6oWTGGXCde5RZfsFrcaC/
	 3v+ICdAYxH7blXDnzDrFExehT1EJ/kWvcbNoOeSZhtvOYnYyz7yWHnBbWHLcfFfPtu
	 o/SqoME20M39WOo8b/3rslVpye+t5f4wAcrrZeHdeVzNgrnlWjyt2MzKTa2r0qMYoS
	 SV6YEe1Gma2kA==
Date: Mon, 22 Dec 2025 07:29:31 +0800
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: veygax <veyga@veygax.dev>, Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
Message-ID: <aUiC2615oUTgF_PT@kbusch-mbp>
References: <20251217210316.188157-3-veyga@veygax.dev>
 <aUNLs5g3Qed4tuYs@fedora>
 <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
 <aUNRS1Qiaiqo1scX@kbusch-mbp>
 <aUTjxJEDYYfOT_QG@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUTjxJEDYYfOT_QG@infradead.org>

On Thu, Dec 18, 2025 at 09:33:56PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 18, 2025 at 08:56:43AM +0800, Keith Busch wrote:
> > On Thu, Dec 18, 2025 at 12:37:47AM +0000, veygax wrote:
> > > 	/*
> > > 	 * Add pages to bio manually.
> > > 	 * We use physically contiguous pages to trick blk_rq_nr_phys_segments
> > > 	 * into returning 1 segment.
> > > 	 * We use multiple bvec entries to trick the loop in io_buffer_register_bvec
> > > 	 * into writing out of bounds.
> > > 	 */
> > > 	for (i = 0; i < num_bvecs; i++) {
> > > 		struct bio_vec *bv = &bio->bi_io_vec[i];
> > > 		bv->bv_page = page + i;
> > > 		bv->bv_len = PAGE_SIZE;
> > > 		bv->bv_offset = 0;
> > > 		bio->bi_vcnt++;
> > > 		bio->bi_iter.bi_size += PAGE_SIZE;
> > > 	}
> > 
> > I believe you're supposed to use the bio_add_page() API rather than open
> > code the bvec setup.
> 
> The above is simply an open coded version of doing repeated
> __bio_add_page calls.  Which would be rather suboptimal, but perfectly
> valid.

Yeah, there's nothing stopping someone from using it that way, but a
quick survey of __bio_add_page() users appear to be special cases that
allocate a single vector bio, so its existing use is a short-cut that
bio_add_page() will inevitiably reach anyway. Did you intend for it to
be called directly for multiple vector uses too? It is suboptimal as you
said, so it still feels like a misuse if someone did that.

