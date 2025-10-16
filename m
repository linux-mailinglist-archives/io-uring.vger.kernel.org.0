Return-Path: <io-uring+bounces-10040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF9EBE4FD6
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 20:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6A21A67D13
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 18:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E718E223DD1;
	Thu, 16 Oct 2025 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgaIXE+8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D91223DC1
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638011; cv=none; b=tNRzJrykHf4gwMvsY2hJYct7do7MwCqnkimC0hEnHI4TGIald9L2ej4TJ8d7MpvbnDa56KGUMJFTgk1fzWpoboDtqBX99sf4baZNjCMeL3PPgosCyQuN/8dHF8n98GJyvchIAPozpFloMCsetMVrJBwXAqbXWJdlwJRb3NFCfAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638011; c=relaxed/simple;
	bh=hQxU+9+ACC8h+5XcC7XLvEiZWPDTvgyHPKm/8PPTNJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfgPNbiVGuweJlWuMHyrBN3M0ZEjubCvUiG5nubJUYlpY/vMmodqFfimYkQMoVq0vcWXsIbxGdZsfAuytSw+1dZlrZnx0iOR9/BhwHOrST/2vbsDtAYMM1NKByc0ZFaRNXtpWshRs03mQgPTDVGXGfG7EPWGkrP3v06N8wJrrGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgaIXE+8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE13C4CEF1;
	Thu, 16 Oct 2025 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760638011;
	bh=hQxU+9+ACC8h+5XcC7XLvEiZWPDTvgyHPKm/8PPTNJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sgaIXE+8STT5pepcsS60Tt5hXRPemrcG0o1w6ymoHQT9IB5rGVQyUOA+X6N901IRK
	 OkpegKOqOQeHL3JbR2vc+Z1eeF624UVgT2//4t+LwE/MV+FTiBiK5XWqAYrhUkKBpo
	 +ycp+ZNuK8xSt9b8rq+JW47Qep1yYlHixkS+nJDwDFd/+8ywXHUx0u7qNMsKzd9M5c
	 GWXepbIcpo5c4olbToWaqTGL5il9/l108PeEEm/ljOdA2CQFLKNYQYqoCmbfD3Cqpu
	 dRzYBvQY8LNP0Xy2kGnpZotIjSJ+XMc2YruEl9GjiEOdk71sQYYTDBgh63iTFVEhFh
	 Y401n5p16caVQ==
Date: Thu, 16 Oct 2025 12:06:48 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	axboe@kernel.dk
Subject: Re: [PATCHv5 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Message-ID: <aPE0OLRyzN9FuQni@kbusch-mbp>
References: <20251013180011.134131-1-kbusch@meta.com>
 <20251013180011.134131-3-kbusch@meta.com>
 <CADUfDZqe7+M9dqxVxUmMo31S1EGVmOhwqfKGLJfR45Yb_BT+Fg@mail.gmail.com>
 <aO8A_nGt9D0bVnPt@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aO8A_nGt9D0bVnPt@kbusch-mbp>

On Tue, Oct 14, 2025 at 08:03:42PM -0600, Keith Busch wrote:
> On Tue, Oct 14, 2025 at 03:33:19PM -0700, Caleb Sander Mateos wrote:
> > On Mon, Oct 13, 2025 at 11:00 AM Keith Busch <kbusch@meta.com> wrote:
> > > +               /*
> > > +                * A 128b op on a non-128b SQ requires mixed SQE support as
> > > +                * well as 2 contiguous entries.
> > > +                */
> > > +               if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
> > > +                   !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
> > > +                       return io_init_fail_req(req, -EINVAL);
> > > +               /*
> > > +                * A 128b operation on a mixed SQ uses two entries, so we have
> > > +                * to increment the head and decrement what's left.
> > > +                */
> > > +               ctx->cached_sq_head++;
> > > +               (*left)--;
> > 
> > Hmm, io_submit_sqes() calls io_get_task_refs() at the start to
> > decrement cached_refs by the number of SQEs (counting 128-byte SQEs
> > twice) but io_put_task() only increments it once for each completed
> > request (counting 128-byte SQEs once). Does that mean there's a
> > refcount leak? Perhaps io_submit_sqes() or this block needs to
> > increment cached_refs to account for each 128-byte SQE?
> 
> It looks like you're right. I think the increment option is the easiest
> way to deal with it, just adding this line into the above:
> 
> + 	current->io_uring->cached_refs++;
> 
> I'm going to take a moment to figure out a good way to test this because
> I don't think I'm hitting any problem with the admittedly simple tests
> I've offered to liburing, so I may be missing something.

So the tests were in fact causing missing putting some usage references,
but I'm not sure how to check for such leakage. Everything ends up
clearing up once the ring closes, and there's no other visibility into
the refcount from user space. I had to add some trace_printks just to
verify it. The increment above gets everything back to normal, at least,
so will send a new version with that in.

