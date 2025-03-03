Return-Path: <io-uring+bounces-6916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27310A4CD1C
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 21:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB9043AC747
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 20:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28599230278;
	Mon,  3 Mar 2025 20:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JI2Z49xm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FAA22E3F9
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741035452; cv=none; b=lmUUoVN42ONiJl48fD6A3skRvnGk5I/qaPtJNGPPwpMTuOIzCFmNTQ68cay1xLhu/hI+ZUYlvVSeWaGprlvEH6dfz0O0V0ygM5bPJrqVmLNYDJ69xK37rnNsX4IfrkQePMMLhfn2cR88CTHJIUAZorDr2PFZSxFfRdKZ63WTNIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741035452; c=relaxed/simple;
	bh=ukzZkD+VnK4a9fcgQ9k6d/EDX8MIo+kpbp10m1ovY3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg88cRaAP9NWJkKQy43bK/iHqt/5BEuHr4yNkUu1pleVA450dlhgRp2SsZmn3MVf2GRD6O6WJnKOh2YfWsaSXq0a0LC8Sd9NUFdk/Uy5Gt0JpF6+kai3XWsJYflUUHsz/TVlEBzRlgsm/D85HhhDjii5pPSjWDo2wvTowprvRTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JI2Z49xm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E20C4CED6;
	Mon,  3 Mar 2025 20:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741035451;
	bh=ukzZkD+VnK4a9fcgQ9k6d/EDX8MIo+kpbp10m1ovY3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JI2Z49xmh8yK+hZACTW6SV3iHhn6LwM+BMki3ESljybyrK2ylXt99nWK4NQvhD/5J
	 n1OaB8B8nt81+E3csjXhLqYWVp4vCc9wLQ++GUEFNk05kqBt3B32h1nmLpEUlhnfcA
	 Rt6OjAhqr7Z6EsMTtdsiFUnUOnO2JIj8Fq25f7n1YbbzYfIo/a8TX6Pe5qAk7YRRsx
	 0Da/CUoWsCEpE6NeqjgyIwlDGa+LdE5CgC1713Cdo4iKhEEQBPMG67aXMNxzZ9f3iL
	 v4gzbtWdsJNqaeoeFjgWfnJ9j11Siq6fNWfIWjlf/al6ZZ0ZdY96QVifshFMJmF11l
	 z5TXuhfIWtJfA==
Date: Mon, 3 Mar 2025 13:57:28 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH 2/8] io_uring: add infra for importing vectored reg
 buffers
Message-ID: <Z8YXuIKio2r9OIkW@kbusch-mbp.dhcp.thefacebook.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <841b4d5b039b9db84aa1e1415a6d249ea57646f6.1741014186.git.asml.silence@gmail.com>
 <CADUfDZobvM1V38qSizh=WqAv1o5-pTOSZ+PUDMgEhgY3OVAssg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZobvM1V38qSizh=WqAv1o5-pTOSZ+PUDMgEhgY3OVAssg@mail.gmail.com>

On Mon, Mar 03, 2025 at 12:49:38PM -0800, Caleb Sander Mateos wrote:
> > +               u64 buf_end;
> > +
> > +               if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &buf_end)))
> > +                       return -EFAULT;
> > +               if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
> > +                       return -EFAULT;
> > +
> > +               total_len += iov_len;
> > +               /* by using folio address it also accounts for bvec offset */
> > +               offset = buf_addr - folio_addr;
> > +               src_bvec = imu->bvec + (offset >> imu->folio_shift);
> > +               offset &= folio_mask;
> > +
> > +               for (; iov_len; offset = 0, bvec_idx++, src_bvec++) {
> > +                       size_t seg_size = min_t(size_t, iov_len,
> > +                                               folio_size - offset);
> > +
> > +                       res_bvec[bvec_idx].bv_page = src_bvec->bv_page;
> > +                       res_bvec[bvec_idx].bv_offset = offset;
> > +                       res_bvec[bvec_idx].bv_len = seg_size;
> 
> Could just increment res_bvec to avoid the variable bvec_idx?

And utilizing bvec_set_page() to initialize looks a bit cleaner too.

