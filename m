Return-Path: <io-uring+bounces-3466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 140E3995227
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 16:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D66B286846
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 14:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF371DFDA4;
	Tue,  8 Oct 2024 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7lrx/3E"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7221D8DFB;
	Tue,  8 Oct 2024 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728398673; cv=none; b=Vj2t3/XD2eM2PmI7onPxMPLj5wGJ7UNfKsu9xCWfSPf8uhLq/oEUvAJuVCewZRUbkOmQIwIGb3nRL9bwvS/+BeJa49++wit+94IHf6wwLjb8R/bccB5bT65YHYj2ATBZsk0zFfSaB2HfexplG5htQP89SJqSi8crWXeWv+QmB0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728398673; c=relaxed/simple;
	bh=2r9KIBLL1cXgHzsof+Mzxlou0eXLychanxOKsDI3Vd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suJJrF2d/SVktFujCdqDVzHoP4wvf46ofO/ei0T/kCWBfhjZryNOXfw0ajquu7TGqZLw56YmU/Dw1aCdFWjbFav+niiVtmiOHjrtsCxAusb8Gsi6in+DDCHEsG4fvi/s1Kdk15Xrugfqtx8mcoYU57JlJMRB53RdjOdYXXmJsIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7lrx/3E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBBDC4CEC7;
	Tue,  8 Oct 2024 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728398672;
	bh=2r9KIBLL1cXgHzsof+Mzxlou0eXLychanxOKsDI3Vd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T7lrx/3EXHxD5qGecNBPZyiltAIxvOthAw23EzR8+WCK20equjsTRP01hX6d0yJZe
	 +lCbO3N2b6N2rPy4uApYGLvbc0a7dSj5P+HKyEpluOg5RbeRjra1pvCwLgLSsJTOkf
	 QUkrjTnusD3AtnS6p542x05JmpzFHhGyftkzX1SovS+Ooqd9rDya9WVOw5ktixC+7W
	 OeDKwd/ZPmfdo82F/3RhCzgITXnXT2iXFPw644evbv1soENfOTupnQxenfAbStRf6O
	 XhApI494qeYFBOcGv5BTfgr7wZq9X4IjgXisT7w9xlfiQSKtyRXRmrKMDSWjNeSQiA
	 6eLnoFAguPyWA==
Date: Tue, 8 Oct 2024 08:44:28 -0600
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
Message-ID: <ZwVFTHMjrI4MaPtj@kbusch-mbp>
References: <20241003125400.GB17031@lst.de>
 <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
 <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com>
 <20241004053121.GB14265@lst.de>
 <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
 <20241004062733.GB14876@lst.de>
 <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
 <20241004123027.GA19168@lst.de>
 <20241007101011.boufh3tipewgvuao@ArmHalley.local>
 <20241008122535.GA29639@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241008122535.GA29639@lst.de>

On Tue, Oct 08, 2024 at 02:25:35PM +0200, Christoph Hellwig wrote:
> On Mon, Oct 07, 2024 at 12:10:11PM +0200, Javier González wrote:
> > In summary, what we are asking for is to take the patches that cover the
> > current use-case, and work together on what might be needed for better
> > FS support.
> 
> And I really do not think it is a good idea.  For one it actually
> works against the stated intent of the FDP spec.  Second extending
> the hints to per per-I/O in the io_uring patch is actively breaking
> the nice per-file I/O hint abstraction we have right now, and is
> really unsuitable when actually used on a file and not just a block
> device.  And if you are only on a block device I think passthrough
> of some form is still the far better option, despite the problems
> with it mentioned by Keith.

Then let's just continue with patches 1 and 2. They introduce no new
user or kernel APIs, and people have already reported improvements using
it. Further, it is just a hint, it doesn't lock the kernel into anything
that may hinder future inovations and enhancements. So let's unblock
users and refocus *our* time to something more productive, please?

And to be honest, the per-io hints for generic read/write use is only
valuable for my users if metadata is also exposed to userspace. I know
Javier's team is working on that in parallel, so per-io hints are a
lower priority for me until that part settles.

