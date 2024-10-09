Return-Path: <io-uring+bounces-3474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE36F996553
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 11:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88967B22720
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 09:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E798C18A948;
	Wed,  9 Oct 2024 09:28:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2618B465;
	Wed,  9 Oct 2024 09:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466116; cv=none; b=k25v6krebsqN0msLvqiiNYxzQ16lldyKLFeIpAOXMYCuvqmuW7aSHq3KvQ2cMzu7y2iGb4DoqEfrkP2cQKwqkZDW0L6vH4Mj/EKrNU9zkfL5/pQr8VNqXwXKrp2ALSwST4/SPdBuWMZ7fqI/dxOrCxq9vM5OfAre+/A4+JGAgsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466116; c=relaxed/simple;
	bh=59B6D4eY1sw8iViJUckmsksPUvkarjEJKHHC0dKMbsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETZIAvw53AkR5cox3RYLvPIruCEPW8NFcGMB6HuIymL1BSI+kb1FZ/gXtnBp2SWF3wBmMf4tm/QhMzF9j6y3DU8XIvh+70TjrduME0ipv9wCey/989j8Q1DR7UZMhnt5xC85qpwxye57likp4QBX5Hk9yUf0ldgCvPpPz35hdCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6B9C2227A8E; Wed,  9 Oct 2024 11:28:28 +0200 (CEST)
Date: Wed, 9 Oct 2024 11:28:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
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
Message-ID: <20241009092828.GA18118@lst.de>
References: <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk> <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com> <20241004053121.GB14265@lst.de> <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local> <20241004062733.GB14876@lst.de> <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwVFTHMjrI4MaPtj@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 08, 2024 at 08:44:28AM -0600, Keith Busch wrote:
> Then let's just continue with patches 1 and 2. They introduce no new
> user or kernel APIs, and people have already reported improvements using
> it.

They are still not any way actually exposing the FDP functionality
in the standard though.  How is your application going to align
anything to the reclaim unit?  Or is this another of the cases where
as a hyperscaler you just "know" from the data sheet?

But also given that the submitter completely disappeared and refuses
to even discuss his patches I thing they are simply abandonware at
this point anyway.

