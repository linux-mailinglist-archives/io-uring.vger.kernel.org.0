Return-Path: <io-uring+bounces-4211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C56B39B684E
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 16:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655D31F2304B
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 15:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBED3213EEA;
	Wed, 30 Oct 2024 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkL3EWvp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA236200B8D;
	Wed, 30 Oct 2024 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730303322; cv=none; b=Jp+MFuuRUQDTRjQozmZWEDneyGmqAYc4iSEmCOWTV/YKiqb104E81T2iStC9eOlMdBBAFr0No5h6aRaxDc9HrZI77j26SsdjmrkbQcfcjK3DcEDYw2iRIvjgoLrNk/AJgmdRH/dFg4HljLOUwuczrPk5W1cY+KVsCEdh3cYGLbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730303322; c=relaxed/simple;
	bh=Z7lajVfLj1duP+n0l9P3p1bDBmdmQ/uGrXYyAs1awrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkKGm+bD2t9ml2cP7z1ZAdWRnqmeps3DXIlbld0g7oo8kGUmcfWQiS0XEcJM6/LcV7fspGef0Y3eUio9yXvbPW3jwYU/fcHUTBLr1TrgIuSXa2ZmQYhb6OptFDGmd/wmg6KdktUq84+hrQ9kRlezSIkPl9YPYUHue+SaK1DpXsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkL3EWvp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7077BC4CECE;
	Wed, 30 Oct 2024 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730303322;
	bh=Z7lajVfLj1duP+n0l9P3p1bDBmdmQ/uGrXYyAs1awrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZkL3EWvpb8K5NgMoHoQdSjnWhqgeT/ifVHYWMEqBAt72nkBJAWTSZrxYBsSNOL4VM
	 GA/qVnQvLSv1GxERFJ4glw/zCmJEAzDhCEtlmdWnhHR36G7fkEzkkaaX4dXmRzFXL3
	 z7tcnucMKack9hNoyWyPPAFhzeRWkEpaARoyW7KaPKkPYHXoNVPVmBenL5Euz1prh6
	 SfPZTMxJyhUwbjaRBL/L3vkgj8VR591C2m1kHKhCBQDWuL3DKek/v8PtdnvYJRXJTR
	 91WgiFFQVFeD1AachWwzHX2B2oOyqK42AxCdrALeTr119K3LVqry2xIHMKmpWs3uaH
	 YOLGgmFvJZmug==
Date: Wed, 30 Oct 2024 09:48:39 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029151922.459139-10-kbusch@meta.com>
 <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
 <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030154556.GA4449@lst.de>

On Wed, Oct 30, 2024 at 04:45:56PM +0100, Christoph Hellwig wrote:
> On Wed, Oct 30, 2024 at 09:41:39AM -0600, Keith Busch wrote:
> > On Wed, Oct 30, 2024 at 05:55:26AM +0100, Christoph Hellwig wrote:
> > > On Tue, Oct 29, 2024 at 10:22:56AM -0600, Keith Busch wrote:
> > > 
> > > > No need to create a new fcntl. The people already testing this are
> > > > successfully using FDP with the existing fcntl hints. Their applications
> > > > leverage FDP as way to separate files based on expected lifetime. It is
> > > > how they want to use it and it is working above expectations. 
> > > 
> > > FYI, I think it's always fine and easy to map the temperature hits to
> > > write streams if that's all the driver offers.  It loses a lot of the
> > > capapilities, but as long as it doesn't enforce a lower level interface
> > > that never exposes more that's fine.
> > 
> > But that's just the v2 from this sequence:
> > 
> > https://lore.kernel.org/linux-nvme/20240528150233.55562-1-joshi.k@samsung.com/
> > 
> > If you're okay with it now, then let's just go with that and I'm happy
> > continue iterating on the rest separately. 
> 
> That's exactly what I do not want - it takes the temperature hints
> and force them into the write streams down in the driver 

What??? You said to map the temperature hints to a write stream. The
driver offers that here. But you specifically don't want that? I'm so
confused.

> with no way to make actually useful use of the stream separation.

Have you tried it? The people who actually do easily demonstrate it is
in fact very useful.

