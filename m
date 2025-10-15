Return-Path: <io-uring+bounces-10016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70571BDC189
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 04:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE09919A254A
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 02:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE6525C80D;
	Wed, 15 Oct 2025 02:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRound0H"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93101DED64
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 02:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760493824; cv=none; b=ouryk7KLQv+m6SB0obKBALT/VR5qAJjHbfHdiSdmeQgcpWR7x/Uz75tDZs+qFrweBbeNVWaV5MPnTgw5TfQaTp6GzOBoHRTa3FKVOcw935oTC3+3NBWx/HU4lman8uKYpPtuEoiUlavM+Um9vkdQGeDve8zpSccZrDoHmFKikz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760493824; c=relaxed/simple;
	bh=WTfHS5ONjD4Am0B5JphGlfHfJ7bShXGA9hdpGZcODNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ei28x7kmApImspFxwl5MvoWJlaA4CgefqHVQNkmQXlKoHt5DlWdjfS5Gt62XiPZ4+JX3UNuC9XhIPk9PlPe1ckBLQRU/Quedc5TGMEakCL8rTdFf35F4B0i4kOtuPlq42vO75BdwtZHNRcbpUxHqK1ZAxf1nSrhNfjsf0FNrow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRound0H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B15BC4CEE7;
	Wed, 15 Oct 2025 02:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760493824;
	bh=WTfHS5ONjD4Am0B5JphGlfHfJ7bShXGA9hdpGZcODNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DRound0HM4YyuqHMBopjE5kZjovdIUFOtojI5o30l3G7dxbqKxLUJqzwPrm7yq5dA
	 /fo2JkTygBMzB7V/Vqj+vQdTN4ZZQiBJLzemUKtP6NoY1Dc02ehuBaXNM3HQEGVYq3
	 xeCqL76i/629AXvpt4mfh3nB+xsA7D+lBP5Lo6oSZQ+f3iMNuFHVvvgbmGyS6rU1AI
	 W4Pg8291pzBomTWdiM9ymSWoEHlx8ZNKN7BvIO98pvlWfuBCncSjyVANR4LRY8wZYM
	 To6vgV1WXguMvdiPF11ltJT+36vpSFtG5As8jsLeY7udecw+hZQA5HZcE+++FeItTJ
	 lUwZFi3naPDwQ==
Date: Tue, 14 Oct 2025 20:03:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	axboe@kernel.dk
Subject: Re: [PATCHv5 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Message-ID: <aO8A_nGt9D0bVnPt@kbusch-mbp>
References: <20251013180011.134131-1-kbusch@meta.com>
 <20251013180011.134131-3-kbusch@meta.com>
 <CADUfDZqe7+M9dqxVxUmMo31S1EGVmOhwqfKGLJfR45Yb_BT+Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqe7+M9dqxVxUmMo31S1EGVmOhwqfKGLJfR45Yb_BT+Fg@mail.gmail.com>

On Tue, Oct 14, 2025 at 03:33:19PM -0700, Caleb Sander Mateos wrote:
> On Mon, Oct 13, 2025 at 11:00 AM Keith Busch <kbusch@meta.com> wrote:
> > +               /*
> > +                * A 128b op on a non-128b SQ requires mixed SQE support as
> > +                * well as 2 contiguous entries.
> > +                */
> > +               if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
> > +                   !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
> > +                       return io_init_fail_req(req, -EINVAL);
> > +               /*
> > +                * A 128b operation on a mixed SQ uses two entries, so we have
> > +                * to increment the head and decrement what's left.
> > +                */
> > +               ctx->cached_sq_head++;
> > +               (*left)--;
> 
> Hmm, io_submit_sqes() calls io_get_task_refs() at the start to
> decrement cached_refs by the number of SQEs (counting 128-byte SQEs
> twice) but io_put_task() only increments it once for each completed
> request (counting 128-byte SQEs once). Does that mean there's a
> refcount leak? Perhaps io_submit_sqes() or this block needs to
> increment cached_refs to account for each 128-byte SQE?

It looks like you're right. I think the increment option is the easiest
way to deal with it, just adding this line into the above:

+ 	current->io_uring->cached_refs++;

I'm going to take a moment to figure out a good way to test this because
I don't think I'm hitting any problem with the admittedly simple tests
I've offered to liburing, so I may be missing something.

