Return-Path: <io-uring+bounces-3693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5D299F0B1
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 17:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67FF91C20AAC
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 15:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED601CB9FA;
	Tue, 15 Oct 2024 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3yRHmo0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7481CB9E4;
	Tue, 15 Oct 2024 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729004964; cv=none; b=NSOWI005ta7SHAO5LzGt08vf//oMg/mqNllds9HF5Y9a4QtnaX+euy9fuKUZNTmYX9YIsPZ8kNkuMffwEF5hjZ1JOTGWhYGeWgD9uC1Z2RVEHK0CyOIEuUhzKrq19VR1AYAMnuE+WGerJw+ik8Sd0uj3lbtz9+SwYTyXmtgnXZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729004964; c=relaxed/simple;
	bh=HrjQM8lcvtnIvBc0KLhp1g8XVVe9kH8v4PrPbcSFfpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tukwb8lyA8KaWqLLMIH7GIc474IGpjKocMGLDcT7aW2ZiWPYk1lefT/mRjCNKZG8FAurDe/ZdzIWJY+Y3LspbE2W5knvCc66UIoc1KAMQFa5yxom03UxIALQjcUBWjOhD17jPXcpFEdYZSahceJydvJsphoeYZ57NudXiNDdxaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3yRHmo0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE876C4CEC6;
	Tue, 15 Oct 2024 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729004964;
	bh=HrjQM8lcvtnIvBc0KLhp1g8XVVe9kH8v4PrPbcSFfpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h3yRHmo00PbZ4Kkgix4TfSGcO+OO60xnq1qVIUelpWP11a8ggBa/65HbcXOBES0qv
	 ZP1arbfvD4UB70U1Qtao5PovoVng8ecBS8pBbyaCjJbUnEIJxwieDm2nYKEfyQbGLd
	 mqX6NlyaiiO3I/PfaRBapeaGHwNKZyBU7aKdRUBFYgF+3gsKQ1TGOoJa8hjHu5gjZE
	 VP4Gr+Ekk0rLz14GIbB2bre2RyPVvClC8ewDCmUIDLecbdTEhIvetGhyugIZes1r4N
	 MBMJC2VH7Qh69mguw3TTayT/byRUyvLhK+CVpgfTSD6wwzkAUvEcu84HlEE3JZfXSE
	 bw2w/CDIH0G6A==
Date: Tue, 15 Oct 2024 09:09:20 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <Zw6FoPCEJ0-rARGT@kbusch-mbp>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241015055006.GA18759@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015055006.GA18759@lst.de>

On Tue, Oct 15, 2024 at 07:50:06AM +0200, Christoph Hellwig wrote:
> 1) While the current per-file temperature hints interface is not perfect
> it is okay and make sense to reuse until we need something more fancy.
> We make good use of it in f2fs and the upcoming zoned xfs code to help
> with data placement and have numbers to show that it helps.

So we're okay to proceed with patch 1?
 
> 2) A per-I/O interface to set these temperature hint conflicts badly
> with how placement works in file systems.  If we have an urgent need
> for it on the block device it needs to be opt-in by the file operations
> so it can be enabled on block device, but not on file systems by
> default.  This way you can implement it for block device, but not
> provide it on file systems by default.  If a given file system finds
> a way to implement it it can still opt into implementing it of course.

If we add a new fop_flag that only block fops enables, then it's okay?

> 3) Mapping from temperature hints to separate write streams needs to
> happen above the block layer, because file systems need to be in
> control of it to do intelligent placement.  That means if you want to
> map from temperature hints to stream separation it needs to be
> implemented at the file operation layer, not in the device driver.
> The mapping implemented in this series is probably only useful for
> block devices.  Maybe if dumb file systems want to adopt it, it could
> be split into library code for reuse, but as usual that's probably
> best done only when actually needed.

IMO, I don't even think the io_uring per-io hint needs to be limited to
the fcntl lifetime values. It could just be a u16 value opaque to the
block layer that just gets forwarded to the device.

> 4) To support this the block layer, that is bios and requests need
> to support a notion of stream separation.   Kanchan's previous series
> had most of the bits for that, it just needs to be iterated on.
> 
> All of this could have probably be easily done in the time spent on
> this discussion.

