Return-Path: <io-uring+bounces-3645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB69099BFF0
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 08:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F3411C22906
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 06:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F02D224D6;
	Mon, 14 Oct 2024 06:21:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A222318;
	Mon, 14 Oct 2024 06:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728886892; cv=none; b=hkWy/KDkNkXS27L3qRamhVLtaNjFTF78NsRJAJM6OUh6/cEkaxC9Iil0eSNl+TLsD4V/QttYnurZ26YIpJ317zcEwRJDVDk0Ct1r79OfF0KanYPCtUNXr3+YWDXWARKH/y1SmFpquMw3vkFG7EmdE/T9ijD9fUG8K+rdqH2ND3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728886892; c=relaxed/simple;
	bh=XlVQ876lzP2pq2V5GPmofZOqtihlvPmVEph6MLv92dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKs3e3ykID6rMjVGnKeomb4MbMI5a4Ft2YwC+ah6/7RrRLVEC+J6OKb0vQeg7ACDgy9QcTtwlisCkwrRRTyrFkeTvF7jqBgKE9yi0G1HeNetTM2/CL2iXuXi3tA5lfXg/lz/mJS12X9/skEkTl8Ag8zwIKD4mlD7XBWEUGdHol8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DA246227AAC; Mon, 14 Oct 2024 08:21:25 +0200 (CEST)
Date: Mon, 14 Oct 2024 08:21:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241014062125.GA21033@lst.de>
References: <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp> <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp> <CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com> <20241010070736.de32zgad4qmfohhe@ArmHalley.local> <20241010091333.GB9287@lst.de> <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local> <20241011090224.GC4039@lst.de> <5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 11, 2024 at 11:08:26AM -0600, Jens Axboe wrote:
> 
> I think that last argument is a straw man - for any kind of interface
> like this, we've ALWAYS just had the rule that any per-whatever
> overrides the generic setting.

And exactly that is the problem.  For file systems we can't support
that sanely.  So IFF you absolutely want the per-I/O hints we need
an opt in by the file operations.  I've said that at least twice
in this discussion before, but as everyone likes to have political
discussions instead of technical ones no one replied to that.


