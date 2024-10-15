Return-Path: <io-uring+bounces-3686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD2299DDA8
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 07:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63375B21AE5
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 05:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E338170A0B;
	Tue, 15 Oct 2024 05:50:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF813D69;
	Tue, 15 Oct 2024 05:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728971414; cv=none; b=cQAaL/kFTWgwAoz0E6hLkNWDV7WC0cLny854wQemlQu+TFX5SGPfiR3nLRymHHrXPXPlPF3es2e8RrrujCI/yAm4FxYOqwQx14ECX7QoKRjkx+V2a8OohsBtiDE/i5TrdxRmvqBlu4zGo7yB1OWvYsgDxGc3oVY3KReaW8gptyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728971414; c=relaxed/simple;
	bh=wA9Uzsm2+2RenSWhGYDjyfwfyydcSEoqr0kEd68mP5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=giLX1gfefYBDE5SWWJ4SaBbrCT47bH3sqQ9mLnNVFe8Xt7+zd9jpEA6gAIJ3o+oRHNgKOqNpFqqrWilCsFbGYvl8Ip2Iyn2iexz4WGbVrhXTWcZwuN1IQlCH/lOaLxbev7eZo4U+mG8t0iPppVQq6qXafd5JlNtPH9hJJta/MSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 00F65227AA8; Tue, 15 Oct 2024 07:50:06 +0200 (CEST)
Date: Tue, 15 Oct 2024 07:50:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241015055006.GA18759@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930181305.17286-1-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

As the current discussion is probably too tiring for anyone who is not a
professional mud fighter I'll summarize my objections and comments here
once again in a way that even aspiring middle managers should be able
understand.

1) While the current per-file temperature hints interface is not perfect
it is okay and make sense to reuse until we need something more fancy.
We make good use of it in f2fs and the upcoming zoned xfs code to help
with data placement and have numbers to show that it helps.

2) A per-I/O interface to set these temperature hint conflicts badly
with how placement works in file systems.  If we have an urgent need
for it on the block device it needs to be opt-in by the file operations
so it can be enabled on block device, but not on file systems by
default.  This way you can implement it for block device, but not
provide it on file systems by default.  If a given file system finds
a way to implement it it can still opt into implementing it of course.

3) Mapping from temperature hints to separate write streams needs to
happen above the block layer, because file systems need to be in
control of it to do intelligent placement.  That means if you want to
map from temperature hints to stream separation it needs to be
implemented at the file operation layer, not in the device driver.
The mapping implemented in this series is probably only useful for
block devices.  Maybe if dumb file systems want to adopt it, it could
be split into library code for reuse, but as usual that's probably
best done only when actually needed.

4) To support this the block layer, that is bios and requests need
to support a notion of stream separation.   Kanchan's previous series
had most of the bits for that, it just needs to be iterated on.

All of this could have probably be easily done in the time spent on
this discussion.

