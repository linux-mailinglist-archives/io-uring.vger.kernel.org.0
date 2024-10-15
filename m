Return-Path: <io-uring+bounces-3685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C8A99DD7B
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 07:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A91E283474
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 05:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC85166F34;
	Tue, 15 Oct 2024 05:30:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B127B3C3C;
	Tue, 15 Oct 2024 05:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728970220; cv=none; b=Yteb+GO1G9FUreSv6lX3KY8GuDE9+HYl4JSVX/luTX/4lj9nzQeORMugDZmQPI3K0Iaw5lleDdEhLw2WzfUBWRT6y7toOAi4hjzFKZZmp21o7ffOv7QKdc3fCdrPL0veTYn8WJCTKS5k4GYcBQ17SHVe2viqapwQGf422YI+QQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728970220; c=relaxed/simple;
	bh=EzU5mI03zFsx88x+566qvzOC2d73swVM+mldoP2G3lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQ7xLyNEBGi+O7JV/rDM2ZW8IxrdoYh6MbHjs5QpLd58RiuNIcBoKPwome/3Ojo7VWDymd/YVbsCMl4Gpuk4u9aszz630+UD3+TfJKteg3sj9tXTzzxeo0l0aHkqk5cgKtl7VVFKjWgzgM+C8R+KCrgmWSJL3TfLJsEIKVMiozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7BC57227AA8; Tue, 15 Oct 2024 07:30:13 +0200 (CEST)
Date: Tue, 15 Oct 2024 07:30:13 +0200
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
Message-ID: <20241015053013.GA18580@lst.de>
References: <20241010091333.GB9287@lst.de> <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local> <20241011090224.GC4039@lst.de> <5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk> <20241014062125.GA21033@lst.de> <34d3ad68068f4f87bf0a61ea8fb8f217@CAMSVWEXC02.scsc.local> <20241014074708.GA22575@lst.de> <9e3792eebf7f427db7c466374972fb99@CAMSVWEXC02.scsc.local> <20241014115052.GA32302@lst.de> <c0675721048d4b0a9a654e2e1669ad60@CAMSVWEXC02.scsc.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0675721048d4b0a9a654e2e1669ad60@CAMSVWEXC02.scsc.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 03:07:57AM +0000, Javier Gonzalez wrote:
> > On Mon, Oct 14, 2024 at 09:08:24AM +0000, Javier Gonzalez wrote:
> > > > Especially as it directly undermindes any file system work to actually make use
> > of it.
> > >
> > > I do not think it does. If a FS wants to use the temperatures, then they
> > > would be able to leverage FDP besides SCSI.
> > 
> > What do you mean with that?  This is a bit too much whitepaper vocabularly.
> > 
> > We have code in XFS that can make use of the temperature hint.  But to
> > make them work it actually needs to do real stream separation on the
> > device.  I.e. the file system consumes the temperature hints.
> 
> The device can guarantee the stream separation without knowing the temperature.

Of course.  But that's entirely not the point.

> > What space from VFS folks do you need for hints?  And why does it
> > matter?
> 
> We need space in the inode to store the hint ID.
> 
> Look, this feels like going in circles. All this gaslighting is what makes it difficult to 

I'm so fucking tired of this.  You are not even listening to my arguments
at all, even when explaing every detail to you again and again.  And then
you acuse me of "gaslighting". 

> push patches when you just do not like the feature. It is the 3rd time I propose you 
> a way forward and you simply cannot provide any specific technical feedback - in the 
> past email I posted several questions about the interface you seem to be talking 
> about and you explicitly omit that.

???

You are throwing random buzzwords and not even replying to all the
low level technical points.  If you think I missed something please
just ask again instead of this crap.

