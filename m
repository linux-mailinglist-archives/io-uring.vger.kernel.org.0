Return-Path: <io-uring+bounces-3398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CADA98EFCC
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 14:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCEB2B24669
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 12:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF411991D9;
	Thu,  3 Oct 2024 12:55:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415A8199936;
	Thu,  3 Oct 2024 12:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727960149; cv=none; b=hh7iGjUe91QNSFYvao/M/uf1NFHxijC7eomReg42mMoiuhkIc91QVdBBXaausf3IadLrfoJgdBzSYUdxeBfEAB/pGxqhAPf82MtdHdeoBbXyEVN/SsupSz073b9QBp4x+/e5j68jadaEkOOG4uEX87jRnc/Twe2WLc1EaBqa0tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727960149; c=relaxed/simple;
	bh=13t2FQP0Ub/NYL4Y5bKZ5M3VdtKW/+EstcVT9OLQCMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjWgjCVayG4Dt7yeozGc9DpQGtWhLmLtsTBGe1yVkog3UHqBy5FsDKlV3SnaF42/68pjyuvq2hrcabJpobUrcKAZK+nXVMvmPARmD0LQHp8o87nJHJfOMZYKZ7IuSqxA17Eajgg7K5SyvwW7v3ha1udV+gbwuaZr1bgFTB+g0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 42C94227A88; Thu,  3 Oct 2024 14:55:45 +0200 (CEST)
Date: Thu, 3 Oct 2024 14:55:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com, Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v7 1/3] nvme: enable FDP support
Message-ID: <20241003125544.GD17031@lst.de>
References: <20240930181305.17286-1-joshi.k@samsung.com> <CGME20240930182056epcas5p33f823c00caadf9388b509bafcad86f3d@epcas5p3.samsung.com> <20240930181305.17286-2-joshi.k@samsung.com> <38daf18f-7637-4c27-9a43-67ad39dc15c0@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38daf18f-7637-4c27-9a43-67ad39dc15c0@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 02, 2024 at 11:37:11AM -0700, Bart Van Assche wrote:
> Is the description of this patch correct? The above description suggests
> that FDP information is similar in nature to SCSI data lifetime
> information. I don't think that's correct.

As you correctly point out, it is entirely incorrect.


