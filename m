Return-Path: <io-uring+bounces-3397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A52F798EFC6
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 14:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E865282513
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 12:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D48197A65;
	Thu,  3 Oct 2024 12:55:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B1E19538A;
	Thu,  3 Oct 2024 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727960121; cv=none; b=j3JjVRaNVWE8jyDGFP2e+LRUC4GHX6H/YMRCDeIhJomcmjn09nAZ7l8sMtBggFVUWiXT7Sr3zP9/NNATA97IAGHaaITLq4r92xlBo3SWFrnYBzWe5lt0jLOan7Z1NvBtN7nK1LzmpqVL1LB1WCCgsuSHAhytn/chpzobIOu95ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727960121; c=relaxed/simple;
	bh=6hzi9MSmMRtaNkgY/cQBbPd9wRHWXB1Cma/oZYxAwu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbttc7vcXeIRwR3x1Tx6iRQV4979LWXxxMnHcB3CEot2AjGo96kBLgx/9Ec9oVg9iTRLGBhuV1CPz09hpRaJIYCaSBR1X4wspxM+gjhzU6mP4R8XKoBWfqfG0CR5D0KdZHyui6llnLoDHZnlI21q9N7cCGE4hBjP3diZE6MDICg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BBB5E227A88; Thu,  3 Oct 2024 14:55:16 +0200 (CEST)
Date: Thu, 3 Oct 2024 14:55:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	hare@suse.de, sagi@grimberg.me, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241003125516.GC17031@lst.de>
References: <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk> <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 02, 2024 at 11:34:47AM -0700, Bart Van Assche wrote:
> Isn't FDP about communicating much more than only this information to
> the block device, e.g. information about reclaim units? Although I'm
> personally not interested in FDP, my colleagues were involved in the
> standardization of FDP.

Yes, it is.  And when I explained how to properly export this kind of
information can be implemented on top of the version Kanchan sent everyone
suddenly stopped diskussion technical points and went either silent or
all political.

So I think some peoples bonuses depend on not understanding the problem
I fear :(


