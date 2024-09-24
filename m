Return-Path: <io-uring+bounces-3283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35422984260
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 660FE1C22937
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFD4156678;
	Tue, 24 Sep 2024 09:39:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC9515533F;
	Tue, 24 Sep 2024 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170779; cv=none; b=t+khdGgptVS0FszJ1ERtviI3EpI77llHQ6Qh+tb8lG+wCWOjc36lqReJBJ6+ynUXW73huhNVbsEOaPTYEdXAk/7tn74HgX7WtnHaX70rqPCVZFdck5MWNsFRGgRMXds3rcpTJN2ct7ccte/rkRNebcJ4tmh8pAdLYrzTMghmqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170779; c=relaxed/simple;
	bh=Xy+pnPfQ/fhfJR+VgmfMDTLtUy97yynqQ22gOZGMIlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8imHCrQ0xXUwRESTlPNUA1yGhsSHfFGycZFqvsVqXG3aVGOdR+xgtRYPDBtXQqqLxK1atFQ43Ty3EfDLuKLXWl1HkkY6IIoVT/vTPB9lAhX6PQYq2kUYl34NNG1uYSvQsNgPJ1FMLvBqEU6F6WF/ipyzjvfOXOnPOLmbYkgBz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 083ED227AB4; Tue, 24 Sep 2024 11:39:31 +0200 (CEST)
Date: Tue, 24 Sep 2024 11:39:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v6 1/3] nvme: enable FDP support
Message-ID: <20240924093930.GA27855@lst.de>
References: <20240924092457.7846-1-joshi.k@samsung.com> <CGME20240924093250epcas5p39259624b9ebabdef15081ea9bd663d41@epcas5p3.samsung.com> <20240924092457.7846-2-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240924092457.7846-2-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

As far as I can tell this regresseѕ back to before when you tried
to actually make forward progress and is the same as the old version
again :(

For that:

Nacked-by: Christoph Hellwig <hch@lst.de>


