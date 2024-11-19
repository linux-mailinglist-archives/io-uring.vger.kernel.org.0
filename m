Return-Path: <io-uring+bounces-4811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0D69D20A0
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 08:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853491F22810
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 07:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B34147C71;
	Tue, 19 Nov 2024 07:16:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A738F64;
	Tue, 19 Nov 2024 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732000571; cv=none; b=q0qF6OpDa2sHCkFfHBif4HmKCpHS+hnlBBaTXkETC+AX1C3Z//wGTsg5nxI87EehjcSqMRJDaMrGy0Z6tCeJViXc9Z8ID4gbjMneQqbEYTtqiloRS2BWTdqxpCNFcxMXV9Ri9a8oFVKCm3NHKXs+yiBdu2a5ezCxym+1IZAxjhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732000571; c=relaxed/simple;
	bh=o5W93ZRZuJpOngPEOATz+fJ6TPQNm96QPnduvIAonxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcezQk5porm5rd34NyfZFjQQS786N4fNtAoffAmqMrLCpv2McvNrzbOyJH9gd7vr+CTibYfC2/bb8MPos4pZ/i3Ud0+5FDJmAlbOh6+nVLW9RVr5n5OyfgWgD2JvMpS8i50j/eZG6BlejaSVfUg0eKUIrd2oJFL6/yQHXzLaTUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAAF068D49; Tue, 19 Nov 2024 08:15:56 +0100 (CET)
Date: Tue, 19 Nov 2024 08:15:56 +0100
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
Message-ID: <20241119071556.GA8417@lst.de>
References: <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com> <20241112133439.GA4164@lst.de> <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com> <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com> <20241113044736.GA20212@lst.de> <ZzU7bZokkTN2s8qr@dread.disaster.area> <20241114060710.GA11169@lst.de> <Zzd2lfQURP70dAxu@kbusch-mbp> <20241115165348.GA22628@lst.de> <ZzvPpD5O8wJzeHth@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzvPpD5O8wJzeHth@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 18, 2024 at 04:37:08PM -0700, Keith Busch wrote:
> We have an API that has existed for 10+ years. You are gatekeeping that
> interface by declaring NVMe's FDP is not allowed to use it. Do I have
> that wrong? You initially blocked this because you didn't like how the
> spec committe worked. Now you've shifted to trying to pretend FDP
> devices require explicit filesystem handholding that was explicely NOT
> part of that protocol.

I'm not fucking gate keeping anything, I'm really tired of this claim
with absolutely no facts backing it up.

> > And as iterared multiple times you are doing that by bypassing the
> > file system layer in a forceful way that breaks all abstractions and
> > makes your feature unavailabe for file systems.
> 
> Your filesystem layering breaks the abstraction and capabilities the
> drives are providing. You're doing more harm than good trying to game
> how the media works here.

How so?

> > I've also thrown your a nugget by first explaining and then even writing
> > protype code to show how you get what you want while using the proper
> > abstractions.  
> 
> Oh, the untested prototype that wasn't posted to any mailing list for
> a serious review? The one that forces FDP to subscribe to the zoned
> interface only for XFS, despite these devices being squarly in the
> "conventional" SSD catagory and absolutely NOT zone devices? Despite I
> have other users using other filesystems successfuly using the existing
> interfaces that your prototype doesn't do a thing for? Yah, thanks...

What zoned interface to FDP?

The exposed interface is to:

 a) pick a write stream
 b) expose the size of the reclaim unit

not done yet, but needed for good operation:

 c) expose how much capacity in a reclaim unit has been written

This is about as good as it gets to map the FDP (and to a lesser extent
streams) interface to an abstract block layer API.  If you have a better
suggestion to actually expose these capabilities I'm all ears.

Now _my_ preferred use of that interface is a write out of place,
map LBA regions to physical reclaim blocks file system.  On the hand
hand because it actually fits the file system I'm writing, on the other
hand because industry experience has shown that this is a very good
fit to flash storage (even without any explicit placement).  If you
think that's all wrong that fine, despite claims to the contrary from
you absolutely nothing in the interface forced you to do that.

You can roll the dice for your LBA allocations and write them using
a secure random number generator.  The interface allows for all of that,
but I doubt your results will all that great.  Not my business.

> I appreciate you put the time into getting your thoughts into actual
> code and it does look very valuable for ACTUAL ZONE block devices. But
> it seems to have missed the entire point of what this hardware feature
> does. If you're doing low level media garbage collection with FDP and
> tracking fake media write pointers, then you're doing it wrong. Please
> use Open Channel and ZNS SSDs if you want that interface and stop
> gatekeeping the EXISTING interface that has proven value in production
> software today.

Hey, feel free to come up with a better design.  The whole point of a
proper block layer design is that you actually can do that!

> > But instead of a picking up on that you just whine like
> > this.  Either spend a little bit of effort to actually get the interface
> > right or just shut up.
> 
> Why the fuck should I make an effort to do improve your pet project that
> I don't have a customer for? They want to use the interface that was
> created 10 years ago, exactly for the reason it was created, and no one
> wants to introduce the risks of an untested and unproven major and
> invasive filesystem and block stack change in the kernel in the near
> term!

Because you apparently want an interface to FDP in the block layer.  And
if you want that you need to stop bypassing the file systems as pointed
out not just by me but also at least one other file system maintainer
and the maintainer of the most used block subsystem.  I've thrown you
some bones how that can be done while doing everything else you did
before (at least assuming you get the fs side past the fs maintainers),
but the only thanks for that is bullshit attacks at a personal level.

