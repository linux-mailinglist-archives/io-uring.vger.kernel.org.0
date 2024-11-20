Return-Path: <io-uring+bounces-4880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 836549D410E
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 18:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44057283A18
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 17:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B866C19F487;
	Wed, 20 Nov 2024 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sE65TP9K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CEF18660C;
	Wed, 20 Nov 2024 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732123319; cv=none; b=Nos6dEb4/dsc0fStPKUyTP9JuurCJLH5sWJX6/LxUocP2BefU9n26KB3UIa/0RRuiidBFRa5znfTz/T2D14A8P7/2Fc7HNJT4MjJtAhO32nTfGb89xGwTp2L48r50XWlmE6uGIQgTN10vZNam6xwFqcrH+oBKtqtbX5OkdTbw/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732123319; c=relaxed/simple;
	bh=CisfSRwRyV6xFZ3ffdwsTnIX1RRva6lDeE+IMHthU4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kO8IpYjPnPHdUu9N8LtKMZG9pzOZoeCQ/P/C4ST97aZVehjfOvx3hs5rAtq3U5kbuXxgQc0vBaCeKYkakwLQF1zvqnuGlIO9uuJ7yPLmBuhDK/IcdvJTmuHouPbbdUqwnTbdPEpLFGz7RmbTGbFSS0Z+x1vh/GgoffHOKH4FXbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sE65TP9K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F38C4CECD;
	Wed, 20 Nov 2024 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732123319;
	bh=CisfSRwRyV6xFZ3ffdwsTnIX1RRva6lDeE+IMHthU4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sE65TP9KzC8lXttvgkpoIk9DNxl1R2joWsQ7jx/5EK7tz62NWmAncc74wClnU3+3R
	 T6lXP3F+QOCisA9Wmv8dm8+DA3ENCx9Zcol1PT8t6NylX1KkPCfonL/ASJvvK9uyG7
	 9mKakZmdRF+z7jc3znDFSzqWNoLYKDac2BA8WpzoRQuqBBjZvRHWQW7m74bfA+pahM
	 hcAsA6UKgIt9Hm82jry43p/etNn6VHtI1KrtQxFevd+YeX6ULZtwdgmL38sc8dkUnX
	 SgXNzDzumat2Ayo8TZKsMjjUoEOICUI6nj47zq5ZR31xIB/DobapduwFXd7+GC4rzV
	 OXvqswLeXON6Q==
Date: Wed, 20 Nov 2024 09:21:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Dave Chinner <david@fromorbit.com>,
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
Message-ID: <20241120172158.GP9425@frogsfrogsfrogs>
References: <20241112133439.GA4164@lst.de>
 <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
 <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
 <20241113044736.GA20212@lst.de>
 <ZzU7bZokkTN2s8qr@dread.disaster.area>
 <20241114060710.GA11169@lst.de>
 <Zzd2lfQURP70dAxu@kbusch-mbp>
 <20241115165348.GA22628@lst.de>
 <ZzvPpD5O8wJzeHth@kbusch-mbp>
 <20241119071556.GA8417@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119071556.GA8417@lst.de>

On Tue, Nov 19, 2024 at 08:15:56AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 18, 2024 at 04:37:08PM -0700, Keith Busch wrote:
> > We have an API that has existed for 10+ years. You are gatekeeping that
> > interface by declaring NVMe's FDP is not allowed to use it. Do I have
> > that wrong? You initially blocked this because you didn't like how the
> > spec committe worked. Now you've shifted to trying to pretend FDP
> > devices require explicit filesystem handholding that was explicely NOT
> > part of that protocol.
> 
> I'm not fucking gate keeping anything, I'm really tired of this claim
> with absolutely no facts backing it up.
> 
> > > And as iterared multiple times you are doing that by bypassing the
> > > file system layer in a forceful way that breaks all abstractions and
> > > makes your feature unavailabe for file systems.
> > 
> > Your filesystem layering breaks the abstraction and capabilities the
> > drives are providing. You're doing more harm than good trying to game
> > how the media works here.
> 
> How so?
> 
> > > I've also thrown your a nugget by first explaining and then even writing
> > > protype code to show how you get what you want while using the proper
> > > abstractions.  
> > 
> > Oh, the untested prototype that wasn't posted to any mailing list for
> > a serious review? The one that forces FDP to subscribe to the zoned
> > interface only for XFS, despite these devices being squarly in the
> > "conventional" SSD catagory and absolutely NOT zone devices? Despite I
> > have other users using other filesystems successfuly using the existing
> > interfaces that your prototype doesn't do a thing for? Yah, thanks...
> 
> What zoned interface to FDP?
> 
> The exposed interface is to:
> 
>  a) pick a write stream

How do filesystem users pick a write stream?  I get a pretty strong
sense that you're aiming to provide the ability for application software
to group together a bunch of (potentially arbitrary) files in a cohort.
Then (maybe?) you can say "This cohort of files are all expected to have
data blocks related to each other in some fashion, so put them together
so that the storage doesn't have to work so hard".

Part of my comprehension problem here (and probably why few fs people
commented on this thread) is that I have no idea what FDP is, or what
the write lifetime hints in scsi were/are, or what the current "hinting"
scheme is.

Is this what we're arguing about?

enum rw_hint {
	WRITE_LIFE_NOT_SET	= RWH_WRITE_LIFE_NOT_SET,
	WRITE_LIFE_NONE		= RWH_WRITE_LIFE_NONE,
	WRITE_LIFE_SHORT	= RWH_WRITE_LIFE_SHORT,
	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
} __packed;

(What happens if you have two disjoint sets of files, both of which are
MEDIUM, but they shouldn't be intertwined?)

Or are these new fdp hint things an overload of the existing write hint
fields in the iocb/inode/bio?  With a totally different meaning from
anticipated lifetime of the data blocks?

If Christoph is going where I think he's going with xfs, then maybe the
idea here is to map allocation groups on the realtime volume (i.e.
rtgroups) to a zone (or a flash channel?), along with the ability for
user programs to say "allocations to this cohort of files should all
come from the same rtgroup".

But.  The cohort associations exist entirely in the filesystem, so the
filesystem gets to figure out the association between rtgroup and
whatever scsi/nvme/fdp/whatever hints it sends the hardware.  The
mappings will all be to the same LBA space, but that's the filesystem's
quirk, not necessarily a signal to the storage.

Writes within a cohort will target a single rtgroup until it fills up,
at which point we pick another rtgroup and start filling that.
Eventually something comes along to gc the surviving allocations in the
old rtgroups.  (Aside: the xfs filestreams thing that Dave mentioned
upthread does something kind of like this, except that user programs
cannot convey cohort associations to the filesystem.)

AFAICT the cohort associations are a file property, which the filesystem
can persist in whatever way it wants -- e.g. (ab)using the u32 xfs
project id.  Is there any use using a different cohort id for a specific
IO?  I don't think there are any.

I suppose if your application wants to talk directly to a block device
then I could see why you'd want to be able to send write hints or fdp
placement whatevers directly to the storage, but I don't think that's
the majority of application programs.  Or to put it another way -- you
can plumb in a blockdev-only direct interface to the storage hints, but
us filesystem folks will design whatever makes the most sense for us,
and will not probably not provide direct access to those hints.  After
all, the whole point of xfs is to virtualize a block device.

<shrug> Just my ignorant 2c.  Did that help, or did I just pour gasoline
on a flamewar?

--D

>  b) expose the size of the reclaim unit
> 
> not done yet, but needed for good operation:
> 
>  c) expose how much capacity in a reclaim unit has been written
> 
> This is about as good as it gets to map the FDP (and to a lesser extent
> streams) interface to an abstract block layer API.  If you have a better
> suggestion to actually expose these capabilities I'm all ears.
> 
> Now _my_ preferred use of that interface is a write out of place,
> map LBA regions to physical reclaim blocks file system.  On the hand
> hand because it actually fits the file system I'm writing, on the other
> hand because industry experience has shown that this is a very good
> fit to flash storage (even without any explicit placement).  If you
> think that's all wrong that fine, despite claims to the contrary from
> you absolutely nothing in the interface forced you to do that.
> 
> You can roll the dice for your LBA allocations and write them using
> a secure random number generator.  The interface allows for all of that,
> but I doubt your results will all that great.  Not my business.
> 
> > I appreciate you put the time into getting your thoughts into actual
> > code and it does look very valuable for ACTUAL ZONE block devices. But
> > it seems to have missed the entire point of what this hardware feature
> > does. If you're doing low level media garbage collection with FDP and
> > tracking fake media write pointers, then you're doing it wrong. Please
> > use Open Channel and ZNS SSDs if you want that interface and stop
> > gatekeeping the EXISTING interface that has proven value in production
> > software today.
> 
> Hey, feel free to come up with a better design.  The whole point of a
> proper block layer design is that you actually can do that!
> 
> > > But instead of a picking up on that you just whine like
> > > this.  Either spend a little bit of effort to actually get the interface
> > > right or just shut up.
> > 
> > Why the fuck should I make an effort to do improve your pet project that
> > I don't have a customer for? They want to use the interface that was
> > created 10 years ago, exactly for the reason it was created, and no one
> > wants to introduce the risks of an untested and unproven major and
> > invasive filesystem and block stack change in the kernel in the near
> > term!
> 
> Because you apparently want an interface to FDP in the block layer.  And
> if you want that you need to stop bypassing the file systems as pointed
> out not just by me but also at least one other file system maintainer
> and the maintainer of the most used block subsystem.  I've thrown you
> some bones how that can be done while doing everything else you did
> before (at least assuming you get the fs side past the fs maintainers),
> but the only thanks for that is bullshit attacks at a personal level.
> 

