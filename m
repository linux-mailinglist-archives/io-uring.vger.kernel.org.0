Return-Path: <io-uring+bounces-4913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA3F9D481F
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 08:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A05B9B2247F
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 07:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D20B12BF02;
	Thu, 21 Nov 2024 07:17:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E1230986;
	Thu, 21 Nov 2024 07:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732173477; cv=none; b=Px1Fzw7R/aM2dcBU4Q2VuKEXIUCA0zUgxk8O3PH15KObhk20j7L67NuHW0lRDrSW4p6vmqqGNjTsCCnYUrMEyU/xtlsPqnAFW5WW3QnRh5F6rZ9vhAXm1PZu/fuOWVh9+Xoo/NsBYTxuTT0wLCHT/1rQOIwGrSFWb4Ds2ku/LXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732173477; c=relaxed/simple;
	bh=MZBJOVF8zI5nrwFBupqg2PfYY7lz872zAFhUIdCxBf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=glLkKCi01X8mgT6rRu5ECpDZ+28v0i5te3Z7VK/tPRNR6VbjeKB9EYwB78PMyVSDeo4sUIgbmILV67lRFZ2baxjt/HB3yD1iYM4Hm7CH264z8YFVI86Zqo7AxFyBHLlbJCoa1Wcz31FiaG9H95FRbFhaYEo3H/dT10AZOv8l2w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E2F668AFE; Thu, 21 Nov 2024 08:17:49 +0100 (CET)
Date: Thu, 21 Nov 2024 08:17:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
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
Message-ID: <20241121071748.GA22859@lst.de>
References: <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com> <20241113044736.GA20212@lst.de> <ZzU7bZokkTN2s8qr@dread.disaster.area> <20241114060710.GA11169@lst.de> <Zzd2lfQURP70dAxu@kbusch-mbp> <20241115165348.GA22628@lst.de> <ZzvPpD5O8wJzeHth@kbusch-mbp> <20241119071556.GA8417@lst.de> <20241120172158.GP9425@frogsfrogsfrogs> <Zz4mQGrlKMiPa8NH@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz4mQGrlKMiPa8NH@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 20, 2024 at 11:11:12AM -0700, Keith Busch wrote:
> Various applications were written to that interface and showed initial
> promise, but production quality hardware never materialized.

FYI, production grade NVMe streams hardware did materialize and is still
is shipped and used by multiple storage OEMS.  Like most things in
enterprise storage you're unlikely to see it outside the firmware builds
for those few customers that actually require and QAed it.

> Some of
> these applications are still setting the write hints today, and the
> filesystems are all passing through the block stack, but there's just
> currently no nvme driver listening on the other side.

The only source available application we could fine that is using these
hints is rocksb, which got the fcntl interface wrong so that it did not
have a chance to actually work until Hans fixed it recently.  Once he
fixed it, it shows great results when using file system based hinting,
although it still needs tuning to align it's internal file size to
the hardware reclaim unit size, i.e. it either needs behind the scenes
knowledge or an improved interface to be properly optimized.

> The meaning assigned to an FDP stream is whatever the user wants it to
> mean. It's not strictly a lifetime hint, but that is certainly a valid
> way to use them. The contract on the device's side is that writes to
> one stream won't create media interfere or contention with writes to
> other streams. This is the same as nvme's original streams, which for
> some reason did not carry any of this controversy.

Maybe people realized how badly that works outside a few very special
purpose uses?

I've said it before, but if you really do want to bypass the file
systems (and there's very good reasons for that for some workloads),
bypass it entirely.  Don't try to micro-manage the layer below the
file system from the application without any chance for the file system
to even be in the known.

The entire discussion also seems to treat file systems as simple
containers for blocks that are static.  While that is roughly true
for a lot of older file system designs, once you implement things
like snapshots, data checksums, data journalling or in general
flash friendly metadata write patterns that is very wrong, and
the file systems will want to be able to separate write streams
independently of the pure application write streams.

