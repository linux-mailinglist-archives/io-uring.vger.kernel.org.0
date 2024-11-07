Return-Path: <io-uring+bounces-4521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8C59BFF3A
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 08:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9B0F1F227EF
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 07:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6430E194C6F;
	Thu,  7 Nov 2024 07:38:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E49194AD5;
	Thu,  7 Nov 2024 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730965138; cv=none; b=FLzrpBO+uw5adpDOMWhgDufv0GmKdfdh9q1TSCn4q1DE66rEVKKFVLyMyWhwHbeoscc4j/XI6SBReMLL3CdpauSgDghs8q6lycfIFbicmHmu4ACGSSUQIDVQ+KkqRKEzFMmgWUKaX7OlYSIu59gkIQhr2Br9xSdLtI4FmFRLeuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730965138; c=relaxed/simple;
	bh=XsnJrlOAE76yesIOmPpWe2zgmiLfgW5U4i7QBSegHlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=diT/l+gEX6+u6rwWNX0lNPUs3t7mu1L2EC/Nf9TC8pQvrx3Oas+TBH5MoWPRJO0fF/09HjmLp1R+Ztx0wLHb6KNmaocI5RWM859x2aogb8VmeNC86tZVkidWK3pAvGFBoE5oIaJ4qyha/DVUqwHp68kPPIHkHurJV6pRQHA10MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D0E4227AA8; Thu,  7 Nov 2024 08:38:52 +0100 (CET)
Date: Thu, 7 Nov 2024 08:38:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241107073852.GA5195@lst.de>
References: <20241106121842.5004-1-anuj20.g@samsung.com> <CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com> <20241106121842.5004-7-anuj20.g@samsung.com> <20241107055542.GA2483@lst.de> <CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 07, 2024 at 12:56:03PM +0530, Anuj gupta wrote:
> > > +/* extended capability flags */
> > > +#define EXT_CAP_PI   (1U << EXT_CAP_PI_BIT)
> >
> > This is getting into nitpicking, but is the a good reason to have that
> > enum, which is never used as a type and the values or only defined to
> > actually define the bit positions below?  That's a bit confusing to
> > me.
> 
> The enum is added to keep a check on the number of flags that can
> be added, and make sure that we don't overflow.

Umm, it is pretty clear you overflow when you do a

#define EXT_CAP_FOO   (1U << 16)

and assign it u16.  Just about every static checker will tell you
even if you don't instantly see it.  Basic testing will also show
you it won't work..

> > Also please document the ABI for EXT_CAP_PI, right now this is again
> > entirely undocumented.
> >
> 
> We are planning to document this in man/io_uring_enter.2 in the liburing
> repo, right after this series goes in. Or should it go somewhere else?

Well, it needs to go into the code actually explaining what the flag
does.  Throwing an undocumented flag into a uapi is just asking for
trouble.

> The attempt here is that if two extended capabilities are not known to
> co-exist then they can be kept in the same place. Since each extended
> capability is now a flag, we can check what combinations are valid and
> throw an error in case of incompatibility. Do you see this differently?

You only know they can't co-exist when you add them, and at that point
you can add a union.

> 
> >
> > struct io_uring_sqe_ext {
> >         /*
> >          * Reservered for please tell me what and why it is in the beginning
> >          * and not the end:
> >          */
> >         __u64   rsvd0[4];
> 
> This space is reserved for extended capabilities that might be added down
> the line. It was at the end in the earlier versions, but it is moved
> to the beginning
> now to maintain contiguity with the free space (18b) available in the first SQE,
> based on previous discussions [1].

I can't follow the argument.  But if you reserve space at the beginning
of the structure instead of the usual end you'd better add a comment
explaining it.


