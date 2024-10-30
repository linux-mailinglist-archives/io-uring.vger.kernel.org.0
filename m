Return-Path: <io-uring+bounces-4214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 755C09B696D
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 208501F227C4
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 16:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426AC215007;
	Wed, 30 Oct 2024 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7CnMtXJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0885F213150;
	Wed, 30 Oct 2024 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730306584; cv=none; b=rup9yGL8Ca+VpG/ZtZJLj3PyfeNHFGZrGT3H/ayaVt7bb81mii8mRA4kH2LuASpsogIjpoW+8hMBBdF9w7Gi/ROp2eASE9jH9FtqdoipRi6eCYdObME1mJ9dIkINKNNzAYUm9q9tYaBxOsxD7AyUXheNN3lOXPw6Zn7jI9rMEvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730306584; c=relaxed/simple;
	bh=1/0dSTf4yF624Y/P59xZdCMBVZftwYRQ9Iep0UZhrRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xj06YAnGaOxCMdh+svz3t5ADHA59LvjYbLJuv93C/RoKXkNJ68cfhrznwBGGcu44XnSOB35JDzRquvW3pqoAwprBP1TaC4DgC6vy1nnVjEb9r+v+FIesGlj9NO8NWYGx1QrJ3SREKsHTJ40o8aAmfam2JHJc8ncrxDl0tgy0d8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r7CnMtXJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3BBC4CECE;
	Wed, 30 Oct 2024 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730306582;
	bh=1/0dSTf4yF624Y/P59xZdCMBVZftwYRQ9Iep0UZhrRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r7CnMtXJfg2XLopB7x6q6w/5J3eSeCRzh/JZL9VoA35bCquYGOAVG5jWkAnGrICOY
	 if+jiAhMTec1qdXOp6MhI1zuJOxJMlzM1zTfX0xF/9tAE2hO+sweXnXojynSxYWzZS
	 wDQKbWZI0CNQtEl4kujHFm++/2ynpKrD2aQ4CXwenL8sWP8j4HdXwrbQ6BsWZMMbBh
	 4aos8zVS/b2cJ1/T/iTut+hAG02y6JSty0iLhTiRODcKqeXwQWz147rEpbQvb0T0Q4
	 SHj+SgE0YRXOc4KjPdFRUuRayLBW68UKSM07cUh+btmCCm6RF5JVb/Vi/U2mIyQ2XY
	 Y5cfovAZjagTA==
Date: Wed, 30 Oct 2024 10:42:59 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
References: <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
 <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
 <20241030155052.GA4984@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030155052.GA4984@lst.de>

On Wed, Oct 30, 2024 at 04:50:52PM +0100, Christoph Hellwig wrote:
> On Wed, Oct 30, 2024 at 09:48:39AM -0600, Keith Busch wrote:
> > What??? You said to map the temperature hints to a write stream. The
> > driver offers that here. But you specifically don't want that? I'm so
> > confused.
> 
> In bdev/fops.c (or file systems if they want to do that) not down in the
> driver forced down everyones throat.  Which was the whole point of the
> discussion that we're running in circles here.

That makes no sense. A change completely isolated to a driver isn't
forcing anything on anyone. It's the upper layers that's forcing this
down, whether the driver uses it or not: the hints are already getting
to the driver, but the driver currently doesn't use it. Finding a way to
use them is not some force to be demonized...

> > > with no way to make actually useful use of the stream separation.
> > 
> > Have you tried it? The people who actually do easily demonstrate it is
> > in fact very useful.
> 
> While I've read the claim multiple times, I've not actually seen any
> numbers.

Here's something recent from rocksdb developers running ycsb worklada
benchmark. The filesystem used is XFS.

It sets temperature hints for different SST levels, which already
happens today. The last data point made some minor changes with
level-to-hint mapping.

Without FDP:

WAF:        2.72
IOPS:       1465
READ LAT:   2681us
UPDATE LAT: 3115us

With FDP (rocksdb unmodified):

WAF:        2.26
IOPS:       1473
READ LAT:   2415us
UPDATE LAT: 2807us

With FDP (with some minor rocksdb changes):

WAF:        1.67
IOPS:       1547
READ LAT:   1978us
UPDATE LAT: 2267us

