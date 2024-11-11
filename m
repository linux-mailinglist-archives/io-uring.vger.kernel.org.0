Return-Path: <io-uring+bounces-4609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F33BF9C429B
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 17:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A35221F2611E
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 16:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08C9178368;
	Mon, 11 Nov 2024 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZQf0+4y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBFC13C80D;
	Mon, 11 Nov 2024 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731342457; cv=none; b=iGkauuVESVmIqTZqAK8150+PC/HexAegDBLMKogttE/9ihZmuaLWv0cVBiWnzIsvX/APHRhGqltrPVRYUI3cFA8dTxLgf7lJvraUuQvO/xoI086w7BngIOJpadLvr0P3KlCzao7QZAkxN3Aur7+CkAht71SR9hLNltX/jHA2SrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731342457; c=relaxed/simple;
	bh=fJMQuYsECNO8SL8MoMztWuhXknHywKxO6bpFKaQ4/tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fl27/5nMtgrN2AE1d8QkC7NJWUGPiOo3sVHJ1GFtm4+t2S2lA6B6GKIaOVLbS5DWBEppk6RZXFsTcAXewLx6+5Smw4vq55YaEidK0okb8/a6EDac+X0ZbdMMB6D+l6XIzZjDfucnK7SP55PwczSs14KqlIzgPaGM3+Mby6VFB0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rZQf0+4y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555DAC4CECF;
	Mon, 11 Nov 2024 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731342457;
	bh=fJMQuYsECNO8SL8MoMztWuhXknHywKxO6bpFKaQ4/tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rZQf0+4yfZt5LKsbrtjWZLo88wX1EU9zpd2YctRXKMVU2fN+CkFXHpbROUtJe9O15
	 /kvN6WXl0rbXesHJ9B4wWSh8aCTrBBS3SIAtmhOFzGpuEEqWhzh0RaYs1XKEIUI4hX
	 jTCd+eGz8qgqTgz2lTuCmRmo0/lsl6Rv3brNNr5Kyh94rFdbCbHMAoGyIe/5WSlVSS
	 KDyUpkbgXIp5Isx+39PNn0sYUtTAIv/aoK10rcaNSI2qUKBKih0Gu5/UpFCwEycIoe
	 rebe0foqrYFiPhXRxGui7NFwBduK/0JiigPipoP54RuVXtPlZ/JmOoVxRlVChkz9X8
	 R2MQ0jI6pEHiQ==
Date: Mon, 11 Nov 2024 09:27:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <ZzIwdW0-yn6uglDF@kbusch-mbp>
References: <20241108193629.3817619-1-kbusch@meta.com>
 <20241111102914.GA27870@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111102914.GA27870@lst.de>

On Mon, Nov 11, 2024 at 11:29:14AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 08, 2024 at 11:36:20AM -0800, Keith Busch wrote:
> >   Default partition split so partition one gets all the write hints
> >   exclusively
> 
> I still don't think this actually works as expected, as the user
> interface says the write streams are contigous, and with the bitmap
> they aren't.
> 
> As I seem to have a really hard time to get my point across, I instead
> spent this morning doing a POC of what I mean, and pushed it here:
> 
> http://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/block-write-streams

Just purely for backward compatibility, I don't think you can have the
nvme driver error out if a stream is too large. The fcntl lifetime hint
never errored out before, which gets set unconditionally from the
file_inode without considering the block device's max write stream.

> The big differences are:
> 
>  - there is a separate write_stream value now instead of overloading
>    the write hint.  For now it is an 8-bit field for the internal
>    data structures so that we don't have to grow the bio, but all the
>    user interfaces are kept at 16 bits (or in case of statx reduced to
>    it).  If this becomes now enough because we need to support devices
>    with multiple reclaim groups we'll have to find some space by using
>    unions or growing structures

As far as I know, 255 possible streams exceeds any use case I know
about.

>  - block/fops.c is the place to map the existing write hints into
>    the write streams instead of the driver

I might be something here, but that part sure looks the same as what's
in this series.

>  - the stream granularity is added, because adding it to statx at a
>    later time would be nasty.  Getting it in nvme is actually amazingly
>    cumbersome so I gave up on that and just fed a dummy value for
>    testing, though

Just regarding the documentation on the write_stream_granularity, you
don't need to discard the entire RU in a single command. You can
invalidate the RU simply by overwriting the LBAs without ever issuing
any discard commands.

If you really want to treat it this way, you need to ensure the first
LBA written to an RU is always aligned to NPDA/NPDAL.

If this is really what you require to move this forward, though, that's
fine with me.

>  - the partitions remapping is now done using an offset into the global
>    write stream space so that the there is a contiguous number space.
>    The interface for this is rather hacky, so only treat it as a start
>    for interface and use case discussions.
>  - the generic stack limits code stopped stacking the max write
>    streams.  While it does the right thing for simple things like
>    multipath and mirroring/striping is is wrong for anything non-trivial
>    like parity raid.  I've left this as a separate fold patch for the
>    discussion.

