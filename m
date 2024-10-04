Return-Path: <io-uring+bounces-3407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D963498FD48
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 08:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A13942817B5
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 06:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6034385C5E;
	Fri,  4 Oct 2024 06:24:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F7C4DA00;
	Fri,  4 Oct 2024 06:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728023065; cv=none; b=RsM6CuMhuj/eXg8roWkxf4aBzUf8uwNNaWmM+WPkKScZbYuHuKkawqlWOAcGhESAEBInqpWHk1cFOKGg3mQH5mZHo/30hEOY6fGLGQ+P1k2mseZJYrDPJyyJAaKcYu1mTAxMaaxJJvBzN/rA7LcnsNtY4tw0D/loD9m9qzd8y9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728023065; c=relaxed/simple;
	bh=5o3T5RyacadqNdFdXd1+rCRnTJLj+4F4aL6truNMKEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZd2G5SdgXjUOVR3dMOdBk/XYCnS7zgBq2gpS3pWTbWeY9hvD7Lti6MoX6EbebtqjNGEJCPLBy2gwpWEsp5R4SbSfZ0e5QGk8zZxv5wSuMpwuTsczPd6xqy+t2gzMq+8Xga4HqAXHZTAm42auRpTBu2+81edXZPFK0L+92EvSUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 44FFD227A87; Fri,  4 Oct 2024 08:24:16 +0200 (CEST)
Date: Fri, 4 Oct 2024 08:24:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004062415.GA14876@lst.de>
References: <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org> <CGME20241003125523eucas1p272ad9afc8decfd941104a5c137662307@eucas1p2.samsung.com> <20241003125516.GC17031@lst.de> <20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 04, 2024 at 08:21:29AM +0200, Javier González wrote:
>> So I think some peoples bonuses depend on not understanding the problem
>> I fear :(
>>
>
> Please, don't.
>
> Childish comments like this delegitimize the work that a lot of people
> are doing in Linux.

It's the only very sarcastic explanation I can come up with to explain
this discussion, where people from the exactly two companies where this
might be bonus material love political discussion and drop dead when it
turns technical.

I'm probably wrong, but I've run out of other explanations.


