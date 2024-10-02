Return-Path: <io-uring+bounces-3379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA3F98DEC3
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96A9F1F22562
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B431D0E24;
	Wed,  2 Oct 2024 15:19:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535CC1D0BB5;
	Wed,  2 Oct 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882397; cv=none; b=U9gAIflCdvVZX63WxlyKs7usnlpRMq0PQE6fMU6EYqh9g/xaX9HXv04dv0X8ky0HrurYMweGT2ESFvTR9Dv2cJECO1BoGLWMNbhlSmv40o21I5yquwGKHFmuGssxi0ICXWL9Ibp0Ioa45fanEVNOf6OlFA7xwQEsfBK3qX804DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882397; c=relaxed/simple;
	bh=TNhJ5fp2dr3urC4Z9UzCEpZvppC3NxZ3lh0UEr7ZNeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQI9zr+BZorjaryIna+LmyLzdEdM4bf+9vSp+wisTXYUC3EGUhMFAj831PxrbhtWYpPQ2LGQagHkmSH7R1lgkaSi/y0Tm3UvA0lbwkfuIkK+3DMs/17q1Jxr03BOUgHzBkuByFNY6iRlJh/U3lHZ1hSK8DXnh06wxltbCP70qPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 169C6227AB1; Wed,  2 Oct 2024 17:19:50 +0200 (CEST)
Date: Wed, 2 Oct 2024 17:19:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241002151949.GA20877@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk> <20241002075140.GB20819@lst.de> <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk> <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 02, 2024 at 09:17:35AM -0600, Keith Busch wrote:
> On Wed, Oct 02, 2024 at 05:13:44PM +0200, Christoph Hellwig wrote:
> > 
> > Well, he finally started on the right approach and gave it up after the
> > first round of feedback.  That's just a bit weird.
> 
> Nothing prevents future improvements in that direction. It just seems
> out of scope for what Kanchan is trying to enable for his customer use
> cases. This patch looks harmless.

It's not really.  Once we wire it up like this we mess up the ability
to use the feature in other ways.  Additionally the per-I/O hints are
simply broken if you want a file system in the way as last time,
and if I don't misremember you acknowledged in person last week.

