Return-Path: <io-uring+bounces-11162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72857CC9EF5
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 01:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 629FD301D9DA
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 00:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3268223F417;
	Thu, 18 Dec 2025 00:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="om7cFAoP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B03223EA82;
	Thu, 18 Dec 2025 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766019409; cv=none; b=DDeRTnt6QGJ+0Lpf5SjYfLfEaNMFAQXaU6tUn9arS8oZQSH6Z7aJt4Bpk13v3wrdq9NQhau0ergjg4+nwnEKkXK8QnkMwAWnoNyJlH9oZeYxYP15HWWY4rGK1SOBvgcLzR05UpQ4Jiw3DvXXJJD0qOi2RXhSVyAopns98f0ugoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766019409; c=relaxed/simple;
	bh=kmyOQ2GEiIchhKRnHP0ggwHY8wjcOoTihAEZlA6f/EQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ud7/i/c6pHRP0Y6U/bCyvfJtzFqCTmVUW5uTNUmcDFtCRmaXtejyzLloxFh3RD/bW2xEd7fOmMT7t1DG8nWq9TtBTQWD/MHgM7Z6/wAXxng/L/ROLI52MKz1ETdG7GDK863XYpcj9YJlPSWo3Dnmc0TkXK5WfqoP/DmLNpHCBSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=om7cFAoP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85F5C116B1;
	Thu, 18 Dec 2025 00:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766019408;
	bh=kmyOQ2GEiIchhKRnHP0ggwHY8wjcOoTihAEZlA6f/EQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=om7cFAoPH5MUIHCOLjtRistx6aGRa5u8bo9QJOhxHUzwHYSmKF9y5tflQdH1Cip0E
	 7sp+54lshzgfRkM3N/9+hdCNullvHdu4nl5KDjoXFwlEQ4xFLwELzl2Os5/lfGuqAH
	 pGKi+qi9MEFhi560vS3XViP6JUSLij8IwcbpRYvZgRg+TfZiCpTYQHoMbgdEmwOED1
	 cqZhDP82YJn48DhR1/j/mqh+0+yxeyRMKzp+TdcOEFTVM+MsO7qkm5APPn+nZd4e2Y
	 N+z6Zyx8woqcevgnQTz8WID8s/XQ5IRH6/nGBdo8phtzEeW/GvJT3MsGPRtdnox3t1
	 Gdixt388ud+qQ==
Date: Thu, 18 Dec 2025 08:56:43 +0800
From: Keith Busch <kbusch@kernel.org>
To: veygax <veyga@veygax.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
Message-ID: <aUNRS1Qiaiqo1scX@kbusch-mbp>
References: <20251217210316.188157-3-veyga@veygax.dev>
 <aUNLs5g3Qed4tuYs@fedora>
 <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>

On Thu, Dec 18, 2025 at 12:37:47AM +0000, veygax wrote:
> 	/*
> 	 * Add pages to bio manually.
> 	 * We use physically contiguous pages to trick blk_rq_nr_phys_segments
> 	 * into returning 1 segment.
> 	 * We use multiple bvec entries to trick the loop in io_buffer_register_bvec
> 	 * into writing out of bounds.
> 	 */
> 	for (i = 0; i < num_bvecs; i++) {
> 		struct bio_vec *bv = &bio->bi_io_vec[i];
> 		bv->bv_page = page + i;
> 		bv->bv_len = PAGE_SIZE;
> 		bv->bv_offset = 0;
> 		bio->bi_vcnt++;
> 		bio->bi_iter.bi_size += PAGE_SIZE;
> 	}

I believe you're supposed to use the bio_add_page() API rather than open
code the bvec setup.

