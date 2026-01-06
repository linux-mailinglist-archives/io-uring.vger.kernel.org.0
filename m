Return-Path: <io-uring+bounces-11381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFC7CF6E5A
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 07:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 900763011750
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 06:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF5C1DBB3A;
	Tue,  6 Jan 2026 06:30:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCFA2F1FE7;
	Tue,  6 Jan 2026 06:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767681016; cv=none; b=vE9Qc21VhZ1VG2jlJvvuk5aMd7koCatzXiNbDxPcmOlUzuiEjCYnwehdApBwqqlq9Gmhb4B/WPQPq/71NEN/igAsR7wJD292WU6YZZQSZ3bkd6tadjhPQoZPRt9fsB7LXu3oYDd3pmcB6+WtgWGhpXSsLnDB1m2cqDt4yfOGvr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767681016; c=relaxed/simple;
	bh=VN0aR/sI5/HACoqCm9oQtgesdAo+T/d7wc4FxYsMtSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZZEJ/f9R3s+OuSfssLzy909K48zc6hmVvbkBOHQr/MErPzdszFvRW4wUul4BSBU7Bk6MjURtIPN36Vdzrn3cPrEz01ir6cO3eFzllgyncJBZibJlkGuhWHmc9cjz4nfmK8U/GyI6w0aJox/By9q6pvYmtvi5QNq+05MtNiUtzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 630CF6732A; Tue,  6 Jan 2026 07:24:09 +0100 (CET)
Date: Tue, 6 Jan 2026 07:24:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v4
Message-ID: <20260106062409.GA16998@lst.de>
References: <20251223003756.409543-1-hch@lst.de> <20251224-zusah-emporsteigen-764a9185a0a1@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224-zusah-emporsteigen-764a9185a0a1@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

> Applied to the vfs-7.0.nonblocking_timestamps branch of the vfs/vfs.git tree.
> Patches in the vfs-7.0.nonblocking_timestamps branch should appear in linux-next soon.

Umm, as in my self reply just before heading out for vacation, Julia
found issues in it using static type checking tools.  I have a new
version that fixes that and sorts out the S_* mess.  So please drop
it again for now, I'll resend the fixed version ASAP.


