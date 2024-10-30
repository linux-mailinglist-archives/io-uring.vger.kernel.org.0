Return-Path: <io-uring+bounces-4218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D42ED9B6A29
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88AC81F21869
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C80C2185B6;
	Wed, 30 Oct 2024 16:57:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18327217451;
	Wed, 30 Oct 2024 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307438; cv=none; b=qINNnf+/zwK8Ks/FR387AGXdyI65dY1GPhI2M6xFKIGwK4mOdsnCRhCBsJtO3+QutQduwL5hCMstlW/UfBST052dsIo3r/9jple6PMO4r6XCHDHWel9a3HMk4jyrF4Jo1mc0iSnamIU8oL2YwlgnBxlRpwJRjEbm+1ZRTT7OKv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307438; c=relaxed/simple;
	bh=PmY58ufbxZt52Fj6QFq92qEjPRlv3+mg9qay8fcYwio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pau9pWEp5CiJesy6UXXu5BN1uzjGoHfRcnk+ml4LOY1lWdxvP449Dn7fPYURAPLEoEDg3Ve6gXrowspXI9z+z/bONxlxseZ5A0LmGuBt8931Q9i0j1KTztHjqc/f2yh7TlmLqAMTUPd7z3OopAoMMsXiSB4r8cqeFHEgcSuxE+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A309227A8E; Wed, 30 Oct 2024 17:57:09 +0100 (CET)
Date: Wed, 30 Oct 2024 17:57:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241030165708.GA11009@lst.de>
References: <20241029153702.GA27545@lst.de> <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de> <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de> <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de> <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com> <20241030155052.GA4984@lst.de> <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 10:42:59AM -0600, Keith Busch wrote:
> On Wed, Oct 30, 2024 at 04:50:52PM +0100, Christoph Hellwig wrote:
> > On Wed, Oct 30, 2024 at 09:48:39AM -0600, Keith Busch wrote:
> > > What??? You said to map the temperature hints to a write stream. The
> > > driver offers that here. But you specifically don't want that? I'm so
> > > confused.
> > 
> > In bdev/fops.c (or file systems if they want to do that) not down in the
> > driver forced down everyones throat.  Which was the whole point of the
> > discussion that we're running in circles here.
> 
> That makes no sense. A change completely isolated to a driver isn't
> forcing anything on anyone. It's the upper layers that's forcing this
> down, whether the driver uses it or not: the hints are already getting
> to the driver, but the driver currently doesn't use it.

And once it uses by default, taking it away will have someone scream
regresion, because we're not taking it away form that super special
use case.

> Here's something recent from rocksdb developers running ycsb worklada
> benchmark. The filesystem used is XFS.

Thanks for finally putting something up.

> It sets temperature hints for different SST levels, which already
> happens today. The last data point made some minor changes with
> level-to-hint mapping.

Do you have a pointer to the changes?

> Without FDP:
> 
> WAF:        2.72
> IOPS:       1465
> READ LAT:   2681us
> UPDATE LAT: 3115us
> 
> With FDP (rocksdb unmodified):
> 
> WAF:        2.26
> IOPS:       1473
> READ LAT:   2415us
> UPDATE LAT: 2807us
> 
> With FDP (with some minor rocksdb changes):
> 
> WAF:        1.67
> IOPS:       1547
> READ LAT:   1978us
> UPDATE LAT: 2267us

Compared to the Numbers Hans presented at Plumbers for the Zoned XFS code,
which should work just fine with FDP IFF we exposed real write streams,
which roughly double read nad wirte IOPS and reduce the WAF to almost
1 this doesn't look too spectacular to be honest, but it sure it something.

I just wish we could get the real infraѕtructure instead of some band
aid, which makes it really hard to expose the real thing because now
it's been taken up and directly wired to a UAPI.
one

