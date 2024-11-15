Return-Path: <io-uring+bounces-4721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C65AA9CF179
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B30F293477
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A97E1CEADF;
	Fri, 15 Nov 2024 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXqZSo45"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81C1CEAD6;
	Fri, 15 Nov 2024 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731688089; cv=none; b=d7KcJBjAK3Nyion77ktXTkD7uY8jgJl7Bg8JXKXVteXPHFsCO+S2tjpqqa2dv9EIj6cPEFlbQ68BOZUEHJla5G6+jGqK6g1fyhctFQyXHwrszTMHedI2j6g8idv0Sdl6UhUtBhfBGhX6Xy/jfyfHH+fuIV450RWHGaqMCa7B2oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731688089; c=relaxed/simple;
	bh=XOUgdezN4ZR1SvSwisJLzjliFvPotJwHe9wFvR4ENX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hJFx/7UEXyhuGuPawVrJtDkaEuU5jYYGgrOM91Jbqjnvnwj3ZEpAYsO6dZMnlCrwR0ojNVJTZGyZuJTWLUNRizieW3XOHGBU7YKpHu+GTRLhTCPRkIf9F43WvoQeBCGGGhc6S+KAosWnwdhLE/vLK3HPT989UPbYM6KEkJGxMbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXqZSo45; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA789C4CECF;
	Fri, 15 Nov 2024 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731688089;
	bh=XOUgdezN4ZR1SvSwisJLzjliFvPotJwHe9wFvR4ENX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RXqZSo45vVeTt/JN3nwEBmIhhFCDSMdJ0gFzSXt2LzR+bWzr7z5NDQ/PNKeQVA0hT
	 QHkm3aE4qO44nudL9NZL4aHmVnHQlkh6lDffbKCbMAHAXosypock/hdjoZk9KHFlXO
	 vGKwhpY9gJCiaF+zHU1/bLK8ulxxjEICPa4yKF4hgf1b6wJlPZT2r6YPwJn7+tbfsn
	 ruhVTfUY4jVa6ZNTalNcBjvZOYiyDiRWPhv2zOc3ksqtEWvxiWsciVyv8zKcRhW0R0
	 kSIsqqgklQ7SupdtgZhCdoxIUFGxtMcy5gQBLJpg0GsRh4hqEH3YJqRRvRvw+ufgOI
	 TY0RCoD7mdmyw==
Date: Fri, 15 Nov 2024 09:28:05 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Pierre Labat <plabat@micron.com>,
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
Message-ID: <Zzd2lfQURP70dAxu@kbusch-mbp>
References: <20241108193629.3817619-1-kbusch@meta.com>
 <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com>
 <20241111102914.GA27870@lst.de>
 <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
 <20241112133439.GA4164@lst.de>
 <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
 <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
 <20241113044736.GA20212@lst.de>
 <ZzU7bZokkTN2s8qr@dread.disaster.area>
 <20241114060710.GA11169@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114060710.GA11169@lst.de>

On Thu, Nov 14, 2024 at 07:07:10AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 14, 2024 at 10:51:09AM +1100, Dave Chinner wrote:
> > SGI wrote an entirely new allocator for XFS whose only purpose in
> > life is to automatically separate individual streams of user data
> > into physically separate regions of LBA space.
> 
> One of the interesting quirks of streams/FDP is that they they operate
> on (semi-)physical data placement that is completely decoupled from LBA
> space.  

That's not particularly interesting about FDP. All conventional NAND
SSDs operates that way. FDP just reports more stuff because that's what
people kept asking for. But it doesn't require you fundamentally change
how you acces it. You've singled out FDP to force a sequential write
requirement that that requires unique support from every filesystem
despite the feature not needing that.

We have demonstrated 40% reduction in write amplifcation from doing the
most simplist possible thing that doesn't require any filesystem or
kernel-user ABI changes at all. You might think that's not significant
enough to let people realize those gains without more invasive block
stack changes, but you may not buying NAND in bulk if that's the case.

