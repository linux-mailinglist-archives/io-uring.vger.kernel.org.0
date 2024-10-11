Return-Path: <io-uring+bounces-3589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E883999F7F
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 10:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D34DDB21154
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 08:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF38B20B211;
	Fri, 11 Oct 2024 08:59:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A1420A5E2;
	Fri, 11 Oct 2024 08:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728637151; cv=none; b=WJUmet6Z5cxMBE6C/Lo/Wlc/GinRObko13m5jegbqcXysUXCMKA3qk0eMGLd80vO+q71tn8/Q2EcUmUx+G4qpTNN7L+2yHWXk19io2tCm4b3kbZe/2T7ACH6VxL+Dj4Gs72Uy0c5S/lpiMq59mnvE6nl4m2fjd6U8wd1BBHP5jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728637151; c=relaxed/simple;
	bh=ZVTcQl479qU7T/y4VhpPLy5n3CRAWbyJUTE+jOV6E8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MV8QGGavqbYqRkFJWKw8cProlsVliYkpPiY0rA+XBsLrE4Ku4M93n5SJA1wWOyey2ULq0gzg8UFp56fhcRreswGiRze+vyca+/vfQXMUula6wrS+e4j+gqyiysmc3canGGdiY7hyolyS8werqqdpAm/iyUTCwwOk2GT0qOQ5+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBA6F227AB3; Fri, 11 Oct 2024 10:59:04 +0200 (CEST)
Date: Fri, 11 Oct 2024 10:59:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Hans Holmberg <hans@owltronix.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jack@suse.cz" <jack@suse.cz>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"bcrl@kvack.org" <bcrl@kvack.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>,
	"vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241011085904.GB4039@lst.de>
References: <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local> <CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com> <97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local> <CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com> <20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local> <CANr-nt2=Lee8B94DMPY6yDaGaBD=Lt9qdG2TzGhAwU=ddZxckg@mail.gmail.com> <CGME20241010122734eucas1p1e20a5263a4d69db81b50b8b03608fad1@eucas1p1.samsung.com> <20241010122733.bv7vxemqnxr573pz@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010122733.bv7vxemqnxr573pz@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 02:27:33PM +0200, Javier Gonzalez wrote:

[full quote snipped, it would be really helpful to only quote what you
actuall reference per the usual email rules]

>> Data placement by-file is based on that the lifetime of a file's data
>> blocks are strongly correlated. When a file is deleted, all its blocks
>> will be reclaimable at that point. This requires knowledge about the
>> data placement buckets and works really well without any hints
>> provided.
>
> But we need hints to put files together. I believe you do this already,
> as no placement protocol gives you unlimited separation.

The per-file temperature hints do a reasonable job for that.  A fully
developed version of the separate write streams submitted by Kanchan
would probably do even better, but for now the per-file hints seem
to be enough.

> Maybe you can post some patches on the parts dedicated to the VFS level
> and user-space API (syscall or uring)?

It's just using the existing temperature hints.


