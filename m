Return-Path: <io-uring+bounces-3588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C3B999F6D
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 10:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C565CB20D0F
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 08:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A5419413B;
	Fri, 11 Oct 2024 08:56:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FB20A5E2;
	Fri, 11 Oct 2024 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728636999; cv=none; b=q6r6AARwAuHdg8pWhkf+3G1uJO/5VT8HAhJt11FpP5nroY+qzXwDZJyjzv1C0ysbSRyze1g/95egvi9jQkTUe+WS4p4NdNPHcIXc4oWLBt+JcMfYhsWXFv3sGzcIBE9MR1gRStB/7ZF/V970gmlY1yxgxc6srT28imNN4nl9hJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728636999; c=relaxed/simple;
	bh=3aK2GFXaB51o5dyRuGxLEUmOb2CRwQ0mXANQpLb2hNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/UEBIg7KepTQrm17lWOuwsa4ZFtmS/yWHXpyRJYbSxlV60PaZ0PhZ71nLFBgQ87IDNr4wx+haMXYrneexvPBUxHtgjgyM0KgTjMvQbf5f2BMkeviyKnwvvWyiKeII53pIvv8E+Tp+rQRs9Ln8U4p/UNjoItiR9Nlc5dMcwjO3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1AE1227AB3; Fri, 11 Oct 2024 10:56:31 +0200 (CEST)
Date: Fri, 11 Oct 2024 10:56:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans@owltronix.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jack@suse.cz" <jack@suse.cz>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"bcrl@kvack.org" <bcrl@kvack.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>,
	"vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241011085631.GA4039@lst.de>
References: <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com> <97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local> <CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com> <20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local> <CGME20241010092019eucas1p157b87b63e91cd2294df4a8f8e2de4cdf@eucas1p1.samsung.com> <20241010092010.GC9287@lst.de> <20241010122232.r2omntepzkmtmx7p@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010122232.r2omntepzkmtmx7p@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 02:22:32PM +0200, Javier Gonzalez wrote:
> Passthru is great for prototyping and getting insights on end-to-end
> applicability. We see though that it is difficult to get a full solution
> based on it, unless people implement a use-space layer tailored to their
> use-case (e.g., a version SPDK's bdev). After the POC phase, most folks
> that can use passthru prefer to move to block - with a validated
> use-case it should be easier to get things upstream.
>
> This is exactly where we are now.

That's a lot of marketing babble :)    What exact thing is missing
from the passthrough interface when using say spdx over io_uring?

> If you saw the comments from Christian on the inode space, there are a
> few plumbing challenges. Do you have any patches we could look at?

I'm not sure what you refer to here.


