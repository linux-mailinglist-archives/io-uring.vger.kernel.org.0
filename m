Return-Path: <io-uring+bounces-3590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 360D2999FAB
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 11:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A834AB236A1
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 09:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0608B20C48C;
	Fri, 11 Oct 2024 09:02:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E14020C47F;
	Fri, 11 Oct 2024 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728637351; cv=none; b=WnShwATvRCYZPEmYk/fPOhC6xkgUs04/IGrlcRfeVmzh2VGZlBCVkgNC67x518qqld2N9/0Z2OQmmTq+sL1VThiCjgZgu2rHVVxeDmc8c1+Cwc7rhZysEE963GNjS5Gs0qnJx0ow7iTooiSY6+W8G11iqL3qZVphcGXkQhUe/Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728637351; c=relaxed/simple;
	bh=jBKYDl6lY8ktEq1As5u3jLOH+rvvtdOO0sTGYsKY/6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvf9MyOxLm+MMM2J8ok07AcKGCMnJAs7CJiLj5VyLh1L0VX8b1wiTnC5x3XoqO2xthClEiitYgrCs6nlGTypXY/zipH6EgeTsbK1JspO49yttZN/ITyAFXAVO2g25EFlZPOY/x5ToREAowLjlSZ9BJyEto29UbzCTkPvU8oA18M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD211227AB3; Fri, 11 Oct 2024 11:02:24 +0200 (CEST)
Date: Fri, 11 Oct 2024 11:02:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20241011090224.GC4039@lst.de>
References: <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp> <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp> <CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com> <20241010070736.de32zgad4qmfohhe@ArmHalley.local> <20241010091333.GB9287@lst.de> <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 01:59:14PM +0200, Javier González wrote:
>> As mentioned probably close to a dozen times over this thread and it's
>> predecessors:  Keeping the per-file I/O hint API and mapping that to
>> FDP is fine.  Exposing the overly-simplistic hints to the NVMe driver
>> through the entire I/O stack and locking us into that is not.
>
> I don't understand the "locking us into that" part.

The patches as submitted do the two following two things:

 1) interpret the simple temperature hints to map to FDP reclaim handles
 2) add a new interface to set the temperature hints per I/O

and also rely on an annoying existing implementation detail where the I/O
hints set on random files get automatically propagated to the block
device without file system involvement.

This means we can't easily make the nvme driver actually use smarter
hints that expose the actual FDP capabilities without breaking users
that relied on the existing behavior, especially the per-I/O hints that
counteract any kind of file system based data placement.


