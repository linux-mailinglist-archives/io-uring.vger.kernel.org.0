Return-Path: <io-uring+bounces-10099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE81BFBBF8
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 14:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4D4EE4E2005
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 12:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA062C1589;
	Wed, 22 Oct 2025 12:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUQTGQHN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A6A2765ED;
	Wed, 22 Oct 2025 12:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761134435; cv=none; b=bfqijTuiOgQqKkk5N/TuoX8Qn5NJ03OOnJy23ZtAKuWCBh/CgMP3sAJ+ZKG6ZaBQeoyBPJQ21Nqh3i1mzIE6Ucj8TkXmiIiaEFVMa9PQFLJUKXsTE1K+QvDgYZr3TdvXSBSmwFSpaqsNSHSNGPTJE7Ltf+DuScoBLdDS4iIzYA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761134435; c=relaxed/simple;
	bh=VWiPIF2qwBAu4+cJXPOpztscrdm+U4nreWPsXfm5m4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkV150pSqcBl3ehaIo9kPUMuoBjMUmISmnqS8KjAQGkpYgrKDGlR6fUWV70Hs2dJEwzqcSq36IEHMtPCpq2r7+a5zQ2+UKN/Bmk6ejWpUWg8gSM8L4JhvoIVIpun9d+sedGSoUO9orFXJIFELA4clG2gHBUK+Iu3rpb8oYc7xfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUQTGQHN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9198C4CEE7;
	Wed, 22 Oct 2025 12:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761134434;
	bh=VWiPIF2qwBAu4+cJXPOpztscrdm+U4nreWPsXfm5m4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUQTGQHN8iIJSNTK0COz+A5qQ13te/r6TwlUvBxuwB+zELinhlbe9yJT+WhRQqzLJ
	 LIC/1sFeY4bQ8ZC8a8FN1vCyZuPOODTjyTgFo4+EeNJKlmly0ccFf0oE8sXg6jeJhw
	 xwyUmBlCjB5TaTDPe0qHfDpUBrrHkPkkmFr/IbqZDJ3BBvEal36LgvKzSkMHJw7ynC
	 E0mDOb/JRYtizuBokxBKgmgzKP1l2OoX6m77N7FybtRCnO7IGWqhcdH17An+vbvA57
	 PYlrcewNz2eyFUrMkxhelsrH12bQc5pgMIwYEcm2DZBo8XmVfOIX/LskfUtvKD7A00
	 wHgjt/HH+bBCw==
Date: Wed, 22 Oct 2025 14:00:30 +0200
From: Nathan Chancellor <nathan@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, csander@purestorage.com,
	Keith Busch <kbusch@meta.com>, Keith Busch <kbusch@kernel.org>,
	llvm@lists.linux.dev
Subject: Re: [PATCHv6] io_uring: add support for IORING_SETUP_SQE_MIXED
Message-ID: <20251022120030.GA148714@ax162>
References: <20251016180938.164566-1-kbusch@meta.com>
 <176108414866.224720.11841089098235254459.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176108414866.224720.11841089098235254459.b4-ty@kernel.dk>

On Tue, Oct 21, 2025 at 04:02:28PM -0600, Jens Axboe wrote:
> 
> On Thu, 16 Oct 2025 11:09:38 -0700, Keith Busch wrote:
> > Normal rings support 64b SQEs for posting submissions, while certain
> > features require the ring to be configured with IORING_SETUP_SQE128, as
> > they need to convey more information per submission. This, in turn,
> > makes ALL the SQEs be 128b in size. This is somewhat wasteful and
> > inefficient, particularly when only certain SQEs need to be of the
> > bigger variant.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
>       commit: 31dc41afdef21f264364288a30013b538c46152e

This needs a pretty obvious fix up as clang points out:

  io_uring/fdinfo.c:103:22: error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]
    103 |                 opcode = READ_ONCE(sqe->opcode);
        |                                    ^~~

I would have sent a formal patch but since it is at the top, I figured
it would get squashed anyways.

Cheers,
Nathan

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index d5aa64203de5..5b26b2a97e1b 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -100,8 +100,8 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		if (sq_idx > sq_mask)
 			continue;
 
-		opcode = READ_ONCE(sqe->opcode);
 		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
+		opcode = READ_ONCE(sqe->opcode);
 		if (sq_shift) {
 			sqe128 = true;
 		} else if (io_issue_defs[opcode].is_128) {

