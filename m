Return-Path: <io-uring+bounces-10105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EE605BFC59B
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7F1C85085CF
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691AA347BD1;
	Wed, 22 Oct 2025 13:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8dIP4JU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414F2346E79;
	Wed, 22 Oct 2025 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761141190; cv=none; b=U5DCUTzaH4KM6xyPA20DiXShcgXNruLLapI5eJ7k7A3jgK3XgJXYfsdkJz0ecz+KeWuCekmzocKETonTU6p48QYbY4E10FbMYBM5Pu6iKtCv4IOnqKM3tWvBwXRMprAVXJt8Ev1qqOQRKaFeLUZEG5MktpWeED26jSZkEuaXPTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761141190; c=relaxed/simple;
	bh=uE40fVZIwpQY/Qon1EaOUs/WD5WZRxO+6qhfgBZiel4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOQZINWcs45KLV+kQ/XLnAKyQFUsJgqvgqBVKqZKjyUge6MPJMOz2f9OKRqBXYr9z4wHmi5TPgrSOyIrSq3PiDH4iZCA2XohlrJ/JwZBg12WR3VF/A4WkFnM/vSTuqzT/1iF7ANDFlB60q59RiVvGRYR1CwdlusNDLAIyCs26kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8dIP4JU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC98C4CEE7;
	Wed, 22 Oct 2025 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761141189;
	bh=uE40fVZIwpQY/Qon1EaOUs/WD5WZRxO+6qhfgBZiel4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8dIP4JU9CBm8/lDHQnXzs2b+FvjAS7lLoXERfx+cY+ZiwXgSOiGN8mJ/jnxbnkqf
	 2dsD853VyUZTKSXs9Lp1GR/QNKsqldpoc9J21FDk6XfrBzhmKgxFBfcurVW77jKnqe
	 j/H/gqF6Nyc1+vYaJX+/NnymUL0dfrmWT11LI7DX8eVui11e48qEXTvkvVFsH2WyxC
	 iUjKPRzrH+9ConnJqZfjEwZ8c1vQXep/+XJI0IwDHlv3kq5mXtcLlerQ0ad1H62sSH
	 58A7eWodVqxgbsQ5RhBAE3JPHy2lWIUYKR2evUdWLgk2+ofa6MdPmknhEA36koPBa1
	 1eS6baLllZeeQ==
Date: Wed, 22 Oct 2025 07:53:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Nathan Chancellor <nathan@kernel.org>, io-uring@vger.kernel.org,
	csander@purestorage.com, Keith Busch <kbusch@meta.com>,
	llvm@lists.linux.dev
Subject: Re: [PATCHv6] io_uring: add support for IORING_SETUP_SQE_MIXED
Message-ID: <aPjhwxTf0wAw_eaW@kbusch-mbp>
References: <20251016180938.164566-1-kbusch@meta.com>
 <176108414866.224720.11841089098235254459.b4-ty@kernel.dk>
 <20251022120030.GA148714@ax162>
 <4ea25979-4fc2-4db7-8656-6c262af2cbee@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ea25979-4fc2-4db7-8656-6c262af2cbee@kernel.dk>

On Wed, Oct 22, 2025 at 07:34:22AM -0600, Jens Axboe wrote:
> On 10/22/25 6:00 AM, Nathan Chancellor wrote:
> > On Tue, Oct 21, 2025 at 04:02:28PM -0600, Jens Axboe wrote:
> >>
> >> On Thu, 16 Oct 2025 11:09:38 -0700, Keith Busch wrote:
> >>> Normal rings support 64b SQEs for posting submissions, while certain
> >>> features require the ring to be configured with IORING_SETUP_SQE128, as
> >>> they need to convey more information per submission. This, in turn,
> >>> makes ALL the SQEs be 128b in size. This is somewhat wasteful and
> >>> inefficient, particularly when only certain SQEs need to be of the
> >>> bigger variant.
> >>>
> >>> [...]
> >>
> >> Applied, thanks!
> >>
> >> [1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
> >>       commit: 31dc41afdef21f264364288a30013b538c46152e
> > 
> > This needs a pretty obvious fix up as clang points out:
> > 
> >   io_uring/fdinfo.c:103:22: error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]
> >     103 |                 opcode = READ_ONCE(sqe->opcode);
> >         |                                    ^~~
> > 
> > I would have sent a formal patch but since it is at the top, I figured
> > it would get squashed anyways.
> 
> Indeed - I'll fold this in. Keith, can you add an fdinfo test case for
> mixed as well?

Thanks, and will do. Any quick hints on how to ensure fdinfo finds some
entries to report? I assume I can just put some entries on the queue,
but don't call io_uring_enter.

