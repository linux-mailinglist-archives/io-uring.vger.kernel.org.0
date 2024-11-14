Return-Path: <io-uring+bounces-4679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FAB9C82EE
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 07:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 535B1284D39
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 06:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C853F16EB76;
	Thu, 14 Nov 2024 06:07:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E23913635B;
	Thu, 14 Nov 2024 06:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731564437; cv=none; b=Ash7snriTXwgtVsnz5OfmeqzMIF8AM32Sk9vA+LTQ8+jNEnHSAM2YTlxmyXrv6l7it7gM4wU+C1IDKi54W9ABxdGEKtomFKZD6ZT3UuRwhNl3cTjPix1xOQWHL7wGRFJ0G0rKj1jqQpOYyoJ1mEKWxJvnGPATwcqMMQZOP7Gt3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731564437; c=relaxed/simple;
	bh=7ehHj18QLSUfM1dlngq4SJzlV/nF2C1eTDT+/MCr50s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ia6GubiBvk2R1k0ag65m032C5NfVj+tm010cuHK6i6m1b/LPXhak5AhVCrnvB873U+MjJ+ioeZ05tyTkLoIbZBIJpH+XRkkmFzl7k2NVJLnUye9ag3oXEXfWNOAvNCa0kWQjgtaIktEcU8mtcDCKQYu6KlhzAmv7W93SH9QKfJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2357668C7B; Thu, 14 Nov 2024 07:07:11 +0100 (CET)
Date: Thu, 14 Nov 2024 07:07:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Pierre Labat <plabat@micron.com>,
	Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20241114060710.GA11169@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com> <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com> <20241111102914.GA27870@lst.de> <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com> <20241112133439.GA4164@lst.de> <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com> <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com> <20241113044736.GA20212@lst.de> <ZzU7bZokkTN2s8qr@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzU7bZokkTN2s8qr@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 10:51:09AM +1100, Dave Chinner wrote:
> Specifically to this "stream hint" discussion: go look at the XFS
> filestreams allocator.

Those are rally two different things - file streams is about how to
locate data into a single hardware write streams.  SCSI/NVMe streams
including streams 2.0 (FDP) that this thread is about is about telling
the hardware about these streams, and also about allowing the file
systems (or other user of the storage) to  pack into the actual
underlying hardware boundaries that matter for deleting/overwriting
this data.

Funnily enough Hans and I were just recently brainstorming on how to
tie both together for the zoned xfs work.

> SGI wrote an entirely new allocator for XFS whose only purpose in
> life is to automatically separate individual streams of user data
> into physically separate regions of LBA space.

One of the interesting quirks of streams/FDP is that they they operate
on (semi-)physical data placement that is completely decoupled from LBA
space.  So if a file system or application really wants to track LBA
vs physical allocations separately it gives them a way to do that.
I don't really know what the advantage of having to track both is, but
people smarted than me might have good uses for it.


