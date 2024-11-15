Return-Path: <io-uring+bounces-4725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 139E39CF31D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA933B645F3
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192C31CEE9F;
	Fri, 15 Nov 2024 16:54:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5981BC069;
	Fri, 15 Nov 2024 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689643; cv=none; b=TumnVHPonYDAE0yHFC6kw7//Yx2r7+UeOLDWfJTBS0x1kTGzZMpv+qDY8JdsfwxoxASHa4iy8/gejPSkD0dhG5+nneBQk+ESE022agxxvAxU+BR1izm+bYNFKVL53+XtKZwAUe83WgEKZEULVZuG7FSJ5pfyZlsodRNg44TkT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689643; c=relaxed/simple;
	bh=yDXkpXU6/IAPVs2ZLps/GO7tZ5rNTL5loe+l0zKWTb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7Oo+wN38CVw/Mav1bXRmEaRGUA97Sy4vQcrv9NHtT+qdr3agJ1a+3Z50eM3M8AfJSXqsYWybjF4uGJX9B92KPPgCRdzENP82xthzplq2Gm/jHhDPowlGxmCjBl7mYvq+r7iRw5Q9uS645HKhrCl2t4IItDC9GXk1ay4FxybUwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8B41D67373; Fri, 15 Nov 2024 17:53:49 +0100 (CET)
Date: Fri, 15 Nov 2024 17:53:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	Pierre Labat <plabat@micron.com>,
	Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi
 streams
Message-ID: <20241115165348.GA22628@lst.de>
References: <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com> <20241111102914.GA27870@lst.de> <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com> <20241112133439.GA4164@lst.de> <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com> <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com> <20241113044736.GA20212@lst.de> <ZzU7bZokkTN2s8qr@dread.disaster.area> <20241114060710.GA11169@lst.de> <Zzd2lfQURP70dAxu@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzd2lfQURP70dAxu@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 15, 2024 at 09:28:05AM -0700, Keith Busch wrote:
> SSDs operates that way. FDP just reports more stuff because that's what
> people kept asking for. But it doesn't require you fundamentally change
> how you acces it. You've singled out FDP to force a sequential write
> requirement that that requires unique support from every filesystem
> despite the feature not needing that.

No I haven't.  If you think so you are fundamentally misunderstanding
what I'm saying.

> We have demonstrated 40% reduction in write amplifcation from doing the
> most simplist possible thing that doesn't require any filesystem or
> kernel-user ABI changes at all. You might think that's not significant
> enough to let people realize those gains without more invasive block
> stack changes, but you may not buying NAND in bulk if that's the case.

And as iterared multiple times you are doing that by bypassing the
file system layer in a forceful way that breaks all abstractions and
makes your feature unavailabe for file systems.

I've also thrown your a nugget by first explaining and then even writing
protype code to show how you get what you want while using the proper
abstractions.  But instead of a picking up on that you just whine like
this.  Either spend a little bit of effort to actually get the interface
right or just shut up.

