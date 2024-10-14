Return-Path: <io-uring+bounces-3655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E318C99C961
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 13:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2023A1C21FA2
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 11:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6C719E7F7;
	Mon, 14 Oct 2024 11:50:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFBB1684B4;
	Mon, 14 Oct 2024 11:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728906659; cv=none; b=is/mzPjRkqUCOazDsCPhYEjjbWnpF8hHcycYtd/VNQA+t2XBEhUgj9RhOmqtvZXabLGx96no0NB66vk1C9ZZons3GMi79OlOa1ZQBP9xRKNTUat7A/rLbcCSASOeOITSpFyuye5ujnOh9nTuVGtoqjOIK6W1ZrYfjSnsCZZBdvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728906659; c=relaxed/simple;
	bh=Q4e/kn/B4J8d1OxaWo7WyJ7HfcbNfBdR+3U59Cue+ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hN3VAwz0asBJm9uICwbkeX4sreJoLN6/jTgJ3nOBOcPM6f5VdentMhcLkNFnQeESjvDtxvDTSIOVmweYsWjmDo5k8Pn9g8chYCHzBIP/tZfXHpJJZis35Ac10a/tkHMgPaxB4ESN4/eBY6qiXgxwIQzJAZTjS60QfnTTwUQAhh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 885C6227AA8; Mon, 14 Oct 2024 13:50:52 +0200 (CEST)
Date: Mon, 14 Oct 2024 13:50:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
Message-ID: <20241014115052.GA32302@lst.de>
References: <CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com> <20241010070736.de32zgad4qmfohhe@ArmHalley.local> <20241010091333.GB9287@lst.de> <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local> <20241011090224.GC4039@lst.de> <5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk> <20241014062125.GA21033@lst.de> <34d3ad68068f4f87bf0a61ea8fb8f217@CAMSVWEXC02.scsc.local> <20241014074708.GA22575@lst.de> <9e3792eebf7f427db7c466374972fb99@CAMSVWEXC02.scsc.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e3792eebf7f427db7c466374972fb99@CAMSVWEXC02.scsc.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 14, 2024 at 09:08:24AM +0000, Javier Gonzalez wrote:

[can you fix your mailer please, no full quotes, and especially not
quotes of the mail headers]

> > What do you gain from that?  NVMe does not understand data temperatures,
> > so why make up that claim?  
> 
> I expressed this a couple of times in this thread. It is no problem to
> map temperatures to a protocol that does not understand the semantics.

And I've agreed every time with you.  But the important point is that we
must not do it in the driver where all context is lost.

> > Especially as it directly undermindes any file system work to actually make use of it.
> 
> I do not think it does. If a FS wants to use the temperatures, then they
> would be able to leverage FDP besides SCSI.

What do you mean with that?  This is a bit too much whitepaper vocabularly.

We have code in XFS that can make use of the temperature hint.  But to
make them work it actually needs to do real stream separation on the
device.  I.e. the file system consumes the temperature hints.


> And if we come up with a better interface later on, we can make the changes then.
> I really do not see the issue. If we were adding a temperature abstraction now, I would agree with
> You that we would need to cover the use-case you mention for FSs from the beginning, but this
> Is already here. Seems like a fair compromise to support current users.

Again, I think the temperature hints at the syscall level aren't all
bad.  There's definitively a few things I'd like to do better in hindsight,
but that's not the point.  The problem is trying to turn them into
stream separation all the way down in the driver, which is fundamentally
broken.

>   - How do we convince VFS folks to give us more space for hints at this point?

What space from VFS folks do you need for hints?  And why does it
matter?


