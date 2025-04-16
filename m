Return-Path: <io-uring+bounces-7498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFD1A90CB7
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 230E93B205D
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51A2226183;
	Wed, 16 Apr 2025 20:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwJK+QyK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF7B224B1C;
	Wed, 16 Apr 2025 20:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744833808; cv=none; b=et/jmnndkX+GOlb1ExFZwfYPbZDteVYaf2aBYslgAQdey7Xh/+n7w1XQedTzhNaVyu7STzz0vjgVlgSLcbAfxaGVL08Plxsa+hA76M/en3R30AEDOv4V6seGMOW4OGTCMu2Y48unmm3JBQhLjRI7HUqBmziJD+B5yZ/IsuXFghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744833808; c=relaxed/simple;
	bh=fGqkcwr2dXvnDfIlOByvQ400SmA1KGq1IVJ7csYSysU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6PW+JwyntSSZo5L8VQ54GrM47rYkxownEwu2yqpFY+yphOfy5j2DQ1EDyx78Kn7Yhk81TLT+446Sh06mzu3+AFwx34y96+C0u1+wbUyVR9lTPolURjtXfMTeKmFrgJJi7Zp3r/tfwgw24ewb1QDDyu+MVLebRnkgwXHo2ejVv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwJK+QyK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831B2C4CEE2;
	Wed, 16 Apr 2025 20:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744833808;
	bh=fGqkcwr2dXvnDfIlOByvQ400SmA1KGq1IVJ7csYSysU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nwJK+QyKA1kfcwEPWqDzFZs+JzAJZn9b2J9iTB4OmXi3Hs5ZBlDEee/az/2gFt1zV
	 gqiSlpPEWetawekMrq/rrAajiyjo19ZOi+z6mx+KW/23x5AQBAr+NRWdRoBy7rg4QM
	 Z8asJSALHM9saC289hnlGEPrzd4Yt6Cm3HuaAqQKeD8/ernNavL69HZtSxx+l/L0Xp
	 fNhf+TukO5juxjWDYXN91PmKwlRA2c3aAdWQVoEz9Q/sMkRnN6VbnT8gXKMb/Ckj4I
	 vDS/52WaeWgKo6jxItwO3FzMeD7mXr/MITYR4Jux2JmdIRcs/kJty5ql4Q3VYNMtKQ
	 9PcINU05LSFOA==
Date: Wed, 16 Apr 2025 14:03:25 -0600
From: Keith Busch <kbusch@kernel.org>
To: Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
Message-ID: <aAANDZUvjPckRik4@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>

On Thu, Apr 17, 2025 at 01:27:55AM +0530, Nitesh Shetty wrote:
> > +       /*
> > +        * Offset trimmed front segments too, if any, now trim the tail.
> > +        * For is_kbuf we'll iterate them as they may be different sizes,
> > +        * otherwise we can just do straight up math.
> > +        */
> > +       if (len + offset < imu->len) {
> > +               bvec = iter->bvec;
> > +               if (imu->is_kbuf) {
> > +                       while (len > bvec->bv_len) {
> > +                               len -= bvec->bv_len;
> > +                               bvec++;
> > +                       }
> > +                       iter->nr_segs = bvec - iter->bvec;
> > +               } else {
> > +                       size_t vec_len;
> > +
> > +                       vec_len = bvec->bv_offset + iter->iov_offset +
> > +                                       iter->count + ((1UL << folio_shift) - 1);
> > +                       iter->nr_segs = vec_len >> folio_shift;
> > +               }
> > +       }
> >         return 0;
> >  }
> This might not be needed for is_kbuf , as they already update nr_seg
> inside iov_iter_advance.

iov_iter_advance only handles the front segs. We still need something
for any trailing segments that are not part of this mapping request.

