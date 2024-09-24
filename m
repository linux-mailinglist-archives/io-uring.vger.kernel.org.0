Return-Path: <io-uring+bounces-3284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D57984263
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AD66281DDC
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE24154C0F;
	Tue, 24 Sep 2024 09:40:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC6215382E;
	Tue, 24 Sep 2024 09:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170846; cv=none; b=FUA1pT5ZWP094nniRYp8c2jK3SZ9dDdZgPkFDTxpHBWI8SkbJ9ynumw1LPvoXvhyX6nZnUIB1BmvceOUlCynxIL7wq1fpIJO+nxSNUShTwhGRRztGPlbJo2YFzplvj1oUI3nJ3+yoy4XFdBVkm7alU5gRoWHxv0xdCWC0L0/OMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170846; c=relaxed/simple;
	bh=vg6OpjeFxM5OIf4FA6Ag2bkEiDOmYd5fylwKFav+R04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnM3Hq6Xb5aBfiSlGdLYqUTlqtalIaqoh/mG9HORbgqXyW1BVYL5jh1HBO8f08FAvJMr8NGToZCMEWzgG/VUJULTfgFGJf69MUGIpWJULyht+G1l62w9sgxx2+AlZASxWrNbIIHuh6LmoMChU5j5nj5K0FHFxyuOo43BAUev7oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C249D227A8E; Tue, 24 Sep 2024 11:40:40 +0200 (CEST)
Date: Tue, 24 Sep 2024 11:40:40 +0200
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
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v6 3/3] io_uring: enable per-io hinting capability
Message-ID: <20240924094040.GB27855@lst.de>
References: <20240924092457.7846-1-joshi.k@samsung.com> <CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com> <20240924092457.7846-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924092457.7846-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Per-I/O hints really can't work for file system interfaes.  They
will have to be a clear opt in to support for regular files.

I'll do a more detailed review when I'm back next week.


