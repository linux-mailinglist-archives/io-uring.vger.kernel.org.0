Return-Path: <io-uring+bounces-3482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E94996F63
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 17:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E585DB21F29
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 15:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47311E1C3B;
	Wed,  9 Oct 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHgBTrUv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954811E1C38;
	Wed,  9 Oct 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486389; cv=none; b=BKMVd3EbeRbfR8Wls9gOw2SMP1/bo+5KJAfJE7sMOsZ5VKh+zyCoWUFkMfgMIJbg4yrHy6NoJ0R/w7oGSbk1JA2dAIf2LD1qVWRnDk1MWd6UKYUtH8GoEXg72qnMI1mkTRSRcT4ouY8QR7SpMyHciBgRn7iAYDx+LVTOUMWqoA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486389; c=relaxed/simple;
	bh=GOfOzG0fD+GRAJQcUGGAR2F6juLmVMJ1gpAQWILv1vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ip8HIGSA2n6S/URgbKbkwOaWDQNJ6A9tWfTIqvOQsEG5cyMjqEDU3sh4IStbHlZDfWr2rOCbLzK/gf0StIFbQrv2qMgIAib8jc6ECKYkArQecwPwLTqC/fkXPSws6mo/VGrGy+9eWa798n4CsPzQefWdtCyEK7FSgT2tA8/A+K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHgBTrUv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E87CC4CEC5;
	Wed,  9 Oct 2024 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728486389;
	bh=GOfOzG0fD+GRAJQcUGGAR2F6juLmVMJ1gpAQWILv1vI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHgBTrUv1SJ4J1xPqWa86y8KnZRku+OSTxa1E7iRUFfjrpSn5XA3sMXPrT/3ISx2Q
	 LsvrdcVswPRIAFyxqIG7C/PYfRNYO8iQ2WyLuY3vzpyYTJB+UlZMqCzfHd/OP9mGMf
	 I2fToIWXK1w5UqrOT4KtRx8bnsg7o0bfKbabdTOIxH96Kaff/cifh/w//w1SEIlELG
	 70bscEQ9TTwSqI38JRrGuy3s9VawyMk+j8Aq5e2zoxoOTG7kLarXza1YD4otS1LrzE
	 N6z+y7zDxoQZvcNjcODDpymOYqROIB+dJwJXyfK4WhpBkwmSbaCv07J+IxtDyrRY5w
	 XCipjlUVQSNLg==
Date: Wed, 9 Oct 2024 09:06:25 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <Zwab8WDgdqwhadlE@kbusch-mbp>
References: <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com>
 <20241004053121.GB14265@lst.de>
 <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
 <20241004062733.GB14876@lst.de>
 <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
 <20241004123027.GA19168@lst.de>
 <20241007101011.boufh3tipewgvuao@ArmHalley.local>
 <20241008122535.GA29639@lst.de>
 <ZwVFTHMjrI4MaPtj@kbusch-mbp>
 <20241009092828.GA18118@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009092828.GA18118@lst.de>

On Wed, Oct 09, 2024 at 11:28:28AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 08, 2024 at 08:44:28AM -0600, Keith Busch wrote:
> > Then let's just continue with patches 1 and 2. They introduce no new
> > user or kernel APIs, and people have already reported improvements using
> > it.
> 
> They are still not any way actually exposing the FDP functionality
> in the standard though.  How is your application going to align
> anything to the reclaim unit?  Or is this another of the cases where
> as a hyperscaler you just "know" from the data sheet?

As far as I know, this is an inconsequential spec detail that is not
being considered by any applications testing this. And yet, the expected
imrpovements are still there, so I don't see a point holding this up for
that reason.

