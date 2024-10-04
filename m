Return-Path: <io-uring+bounces-3408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB2C298FD4F
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 08:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47B04B222F8
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 06:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9A56F305;
	Fri,  4 Oct 2024 06:27:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A2739FEB;
	Fri,  4 Oct 2024 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728023262; cv=none; b=nmqETn10xyruo1MJRJ0SBTCJkuDI1D+zJ3qPFkW5vl9TiuRL6Sx3uuhfiENJ4Dk0gjrndDv0qbG9IFuL88FjuhhKrxalRw2DbzUjOs5YarIhpnawPLjyw3gVkK6q2vnO1vpGXcdYNhqkzglNf6cgwDr9YpvIjqzyssd0D4DMFP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728023262; c=relaxed/simple;
	bh=rqozs4HW6OYSXLAUVOBTDFuUNhs8rZVJzE5B+05LPGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S72/k8qcFhguYVbM4KfKnHDJBK+uRaxAegXK4Z/okiKmHAAenNlCQoog7tD+m2e8EEk52lp6fRClVZGDHe099OZhl3EiEt6sRdK9l/IRf+ER0ntppT2OfMdJJn2YjTZuZie6UYd5pPe0nRHCutIBAa1/uGuVNihEv3Aq883A0gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F1B57227A87; Fri,  4 Oct 2024 08:27:33 +0200 (CEST)
Date: Fri, 4 Oct 2024 08:27:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004062733.GB14876@lst.de>
References: <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <20241003125400.GB17031@lst.de> <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk> <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com> <20241004053121.GB14265@lst.de> <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 04, 2024 at 08:18:11AM +0200, Javier González wrote:
>> And for anyone who followed the previous discussions of the patches
>> none of this should been new, each point has been made at least three
>> times before.
>
> Looking at the work you and Hans have been doing on XFS, it seems you
> have been successful at mapping the semantics of the temperature to
> zones (which has no semantics, just as FDP).
>
>    What is the difference between the mapping in zones and for FDP?

Probably not much, except for all the pitfalls in the FDP not quite hint
not madatory design.

> The whole point is using an existing interface to cover the use-case of
> people wanting hints in block.

And that's fine.  And that point all the way back for month is that
doing a complete dumb mapping in the driver for that is fundamentally
wrong.  Kanchan's previous series did about 50% of the work to get
it rid, but then everyone dropped dead and played politics.


