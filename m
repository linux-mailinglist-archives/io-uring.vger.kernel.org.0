Return-Path: <io-uring+bounces-3412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F07009902ED
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 14:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3B871F229B8
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 12:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD8E42AB5;
	Fri,  4 Oct 2024 12:30:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF77D18E1F;
	Fri,  4 Oct 2024 12:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728045036; cv=none; b=kDAHc0VVVxZ5fqWq9NqBD5mp+SWkNHFIcu1GaYNQXOOQPwmeYVoEPq0d3IHCAND9IObjVgW6sKK/Rd20s+0pji3S3dtI/KXaVnpCB4JAsj4Vp+WzlEUSUGINvUd3Lxkru/XD596xZMHZJIQ30/Wt855LEwiSCOaTfuOOtA1SdUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728045036; c=relaxed/simple;
	bh=jUDzfy09F/zWYrKYVzLARi6Sr58rljztnaQcdgFIOzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKr++aAVoGRc1D2lWdHB0dNa3xjqcU6d/ns3YN8bb24s/ZHGqBkICqRkDqxWRXq0VSYRX7SdGfpa7G90lAl7W2mBMVT4DXlMVM6dZwcyu5HXfi/PSXeJCLppM+8nXRdDfr7pw4WWxgCO5UgVEJ5oaCVB+72mrnFiHueFc5p5QE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 225E6227A88; Fri,  4 Oct 2024 14:30:28 +0200 (CEST)
Date: Fri, 4 Oct 2024 14:30:27 +0200
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
Message-ID: <20241004123027.GA19168@lst.de>
References: <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <20241003125400.GB17031@lst.de> <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk> <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com> <20241004053121.GB14265@lst.de> <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local> <20241004062733.GB14876@lst.de> <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 04, 2024 at 08:52:33AM +0200, Javier González wrote:
> So, considerign that file system _are_ able to use temperature hints and
> actually make them work, why don't we support FDP the same way we are
> supporting zones so that people can use it in production?

Because apparently no one has tried it.  It should be possible in theory,
but for example unless you have power of 2 reclaim unit size size it
won't work very well with XFS where the AGs/RTGs must be power of two
aligned in the LBA space, except by overprovisioning the LBA space vs
the capacity actually used.

> I agree that down the road, an interface that allows hints (many more
> than 5!) is needed. And in my opinion, this interface should not have
> semintics attached to it, just a hint ID, #hints, and enough space to
> put 100s of them to support storage node deployments. But this needs to
> come from the users of the hints / zones / streams / etc,  not from
> us vendors. We do not have neither details on how they deploy these
> features at scale, nor the workloads to validate the results. Anything
> else will probably just continue polluting the storage stack with more
> interfaces that are not used and add to the problem of data placement
> fragmentation.

Please always mentioned what layer you are talking about.  At the syscall
level the temperatur hints are doing quite ok.  A full stream separation
would obviously be a lot better, as would be communicating the zone /
reclaim unit / etc size.

As an interface to a driver that doesn't natively speak temperature
hint on the other hand it doesn't work at all.

> The issue is that the first series of this patch, which is as simple as
> it gets, hit the list in May. Since then we are down paths that lead
> nowhere. So the line between real technical feedback that leads to
> a feature being merged, and technical misleading to make people be a
> busy bee becomes very thin. In the whole data placement effort, we have
> been down this path many times, unfortunately...

Well, the previous round was the first one actually trying to address the
fundamental issue after 4 month.  And then after a first round of feedback
it gets shutdown somehow out of nowhere.  As a maintainer and review that
is the kinda of contributors I have a hard time taking serious.


