Return-Path: <io-uring+bounces-10783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D05AC84ADE
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 12:15:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 14B844EA221
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 11:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5603D3148D0;
	Tue, 25 Nov 2025 11:14:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8829C2EE607;
	Tue, 25 Nov 2025 11:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764069249; cv=none; b=BiviQHo4GYlV/k536VEbj8kZNwUNK4PhyklEpUP48dr4XEc1O+7PulZe1DuASrnCIWfT1L37MDpkeQ63UOgWIaGA3kMkosxO4ZLLrVnTvWdjT7d47/tFE6ryk2DDwfgi1MYE0X/k4Dw5x4feSZ71/pGuh0J/4s4rZ7HFIKnfHSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764069249; c=relaxed/simple;
	bh=/69+0EJmS2X7ff7j0q4w9PZqnsVx+XZDiBTAryw5GXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGLD+nj5NZt7B+UERrVxY1nOGG2wLEhmeQvYbSkwErHC9ileViz+NYCZl6azLmiOw/SDAkHvJhSpdJ70ncHS2rKwh60yse9EcJKTkjugcQNzeHey4kGeMmupSOZEH29Ke4cuXD9kcEQk94lkcgaMjkqTX/Zaz0berlqYzg5nicU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1995868C7B; Tue, 25 Nov 2025 12:14:03 +0100 (CET)
Date: Tue, 25 Nov 2025 12:14:02 +0100
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
Subject: Re: re-enable IOCB_NOWAIT writes to files v2
Message-ID: <20251125111402.GB22313@lst.de>
References: <20251120064859.2911749-1-hch@lst.de> <20251125-loten-fabuliert-c0fb6b195b53@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125-loten-fabuliert-c0fb6b195b53@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 25, 2025 at 10:18:32AM +0100, Christian Brauner wrote:
> It's a bit too close to the merge window for my taste and we have about
> 17 pull request topics for this cycle already.
> 
> So I'll take this for vfs-6.20.iomap. As usual I'll create that branch
> now so that the patches don't get lost and will rebase once v6.19-rc1 is
> out.

I can understand that.  Although it would be nice to get the nfsd
and btrfs fixes in, i.e. patch 1-4 (and 5/6 are trivial and would be
neat as well).  I'll need to resend the others anyway based on the
(minor) review feedback, which I'll do right after -rc1.

