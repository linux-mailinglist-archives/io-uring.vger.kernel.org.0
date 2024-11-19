Return-Path: <io-uring+bounces-4850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2C59D30A9
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 23:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FA6DB22218
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 22:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8106B1C1F0B;
	Tue, 19 Nov 2024 22:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQMYYfAv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E231876;
	Tue, 19 Nov 2024 22:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732056559; cv=none; b=VU1M55dvlu6Jysx118sauTa30wEylzE8DuPk3/B1OnfmNOCZ4Lz5LKX7AcxbVs0bMGS8+AY35sW+vRxTJ9QiSIqPrbw28EqdevfSm1bobCI2E5A16wZC8nZOdMvy/CjPYlJUVwgehXYiGj09FJghy/YW5vvNHEQ7wbQScyTJ1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732056559; c=relaxed/simple;
	bh=da9J+92L3X12EP6GZGUAqszUOKZLRzsWW/faOD90Lhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isUmP7n4pQaxsvnu6aCxS0SA5ryia+mbz0yCFjKt9dGO9WpiQ65jIRYYYa26zm/KEOTRfTrwg6RUzWOZSexk3ewoXAnHwSIua2kEs0ADzMR26bVU04UK8XWEEdi0TZ0Lvi1PXY1hz2yspghvazEjn370eWKhch9WIup40BuyzlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQMYYfAv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD82DC4CECF;
	Tue, 19 Nov 2024 22:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732056557;
	bh=da9J+92L3X12EP6GZGUAqszUOKZLRzsWW/faOD90Lhk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EQMYYfAvgBdeCX3/hPmuzjpTYLWV6cZlwiM+NkrUuDw11qmQJVftoDRGF+8WiAuPd
	 2MUbbSjfZ3JkSEYD02t6VkNyS4o0+G0Iu69z+h4Fb/R/QEme9n6tOqLymU6OJmIL1L
	 2EcOjQvM+6By+fq6prjX3SGHshpSCT86qrBmwr73sg1eFcCSlKYc2PARlcko3AssaE
	 XQQtkxykStWspXRy7UmNUb/UzQNL5U5hC9/5IA+8m48JjiokbdJ4XTn8+93yLpXTkk
	 5hSXLYvEdIzftE6p37qgfiAQXeYTSBysScW8nhxW6VpH3nvLeMizLivSCA3bwus0E7
	 qOptCU2Po2Cww==
Date: Tue, 19 Nov 2024 15:49:14 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>, Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 14/15] nvme: enable FDP support
Message-ID: <Zz0V6qv3oyKV_Kzp@kbusch-mbp.dhcp.thefacebook.com>
References: <20241119121632.1225556-1-hch@lst.de>
 <20241119121632.1225556-15-hch@lst.de>
 <ZzzWQFyq0Sv7cuHb@kbusch-mbp>
 <20241119182427.GA20997@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119182427.GA20997@lst.de>

On Tue, Nov 19, 2024 at 07:24:27PM +0100, Christoph Hellwig wrote:
> On Tue, Nov 19, 2024 at 11:17:36AM -0700, Keith Busch wrote:
> > > +	if (le32_to_cpu(configs[result.fdpcidx].nrg) > 1) {
> > > +		dev_warn(ns->ctrl->device, "FDP NRG > 1 not supported\n");
> > 
> > Why not support multiple reclaim groups?
> 
> Can you come up with a sane API for that? 

Haven't really thought about it. If it's there, it's probably useful for
RU's that are not "Persistently Isolated". But let's not worry about it
now, we can just say you don't get to use write streams for these.

> And can you find devices in
> the wild that actually support it?

I haven't come across any, no.

But more about the return codes for pretty much all the errors here.
They'll prevent the namespace from being visible, but I think you just
want to set the limits to disable write streams instead. Otherwise it'd
be a regression since namespaces configured this way are currently
usable.

