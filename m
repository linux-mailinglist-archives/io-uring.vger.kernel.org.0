Return-Path: <io-uring+bounces-6756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DAFDA44705
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1C0188F3D7
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4967C19ABAB;
	Tue, 25 Feb 2025 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYHHR89U"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7B9198851;
	Tue, 25 Feb 2025 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740502332; cv=none; b=mDXa7eX8/itfpcWcFs8I2SB24lQYF/EKDWfYjnbn6LzWrLwozoSf695BFEVoE+z7A25uD11675GAKlMxhZwRBn4D97strMvPT53rVccG94XSl/nEqcBp8GGFbhAy0REf3Dni++AXZaOdYN09h+zuBz/XtknGGE0IhHYSUZ+k7GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740502332; c=relaxed/simple;
	bh=IN/TbGFWavl/+97KVeHg67wgwq8NfokGyV5/dsov4kI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jq1qMym9+vYm5Kam1LRX0SIOrEpQ1fNzTIxMsOyMmQVM4k8ha08Z7y8K20adeEWh+1+5ZbXt74y9066Pu0w0TSnaD6Di4tI+xrMbs3/o0RXEx6JRPoC7vfnYO93bHiiapeQ/ptOkqVVgkB+4DVxAeUcheExQMQDS11IOdziB7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYHHR89U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1072DC4CEE8;
	Tue, 25 Feb 2025 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740502331;
	bh=IN/TbGFWavl/+97KVeHg67wgwq8NfokGyV5/dsov4kI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fYHHR89USEe3eV3NOgBZOlmLJK+NMF9yxjRmT730qWWI/9R5sW6nCHJ3Mxi0mQuU3
	 2nZc39tO3Me3+mynEKHMpWLOAVienuGGfMhA9HpDLD445FxW4A5whPjMC5oORAFQyf
	 xHHuTkDToR8bDX0LV3if/kl2xJNjAur+Wj68KJ/8a5t3SqXtr+aBUFdPz0nvper0sB
	 H6R7cRXqH7aYkFZ4wYWFiDLb4UsaJJk/WLBo9pjzZQS8LPDVk4iZF/IhloDwGQEhte
	 Dk1oousNcTk3tb+Q9Bit7YzHu3AgEx//OkszA692ZftmEcl6yljdHQXP+fJ2rb7dhv
	 E41+cBfhEyiSw==
Date: Tue, 25 Feb 2025 09:52:09 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z731OQNVyrjXtuc9@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <90747c18-01ae-4995-9505-0bd29b7f17ab@gmail.com>
 <Z73vfy0wlCxwf4hp@kbusch-mbp>
 <a5ceb705-a561-4f84-a4de-5f2e4b3e2de8@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5ceb705-a561-4f84-a4de-5f2e4b3e2de8@gmail.com>

On Tue, Feb 25, 2025 at 04:42:59PM +0000, Pavel Begunkov wrote:
> On 2/25/25 16:27, Keith Busch wrote:
> > On Tue, Feb 25, 2025 at 04:19:37PM +0000, Pavel Begunkov wrote:
> > > On 2/24/25 21:31, Keith Busch wrote:
> > > > From: Keith Busch <kbusch@kernel.org>
> > > > 
> > > > Provide new operations for the user to request mapping an active request
> > > > to an io uring instance's buf_table. The user has to provide the index
> > > > it wants to install the buffer.
> > > 
> > > Do we ever fail requests here? I don't see any result propagation.
> > > E.g. what if the ublk server fail, either being killed or just an
> > > io_uring request using the buffer failed? Looking at
> > > __ublk_complete_rq(), shouldn't someone set struct ublk_io::res?
> > 
> > If the ublk server is killed, the ublk driver timeout handler will abort
> > all incomplete requests.
> > 
> > If a backend request using this buffer fails, for example -EFAULT, then
> > the ublk server notifies the ublk driver frontend with that status in a
> > COMMIT_AND_FETCH command, and the ublk driver completes that frontend
> > request with an appropriate error status.
> 
> I see. IIUC, the API assumes that in normal circumstances you
> first unregister the buffer, and then issue another command like
> COMMIT_AND_FETCH to finally complete the ublk request. Is that it?

Yes, that's the expected good sequence. It's okay if user space does it
the other around, too: commit first, then unregister. The registration
holds a reference on the ublk request, preventing it from completing.

The backend urin gthat registered the bvec can also be a different uring
instance than the frontend that notifies the of the commit-and-fetch. In
such a setup, the commit and unregister sequence could happen
concurrently, and that's also okay.

