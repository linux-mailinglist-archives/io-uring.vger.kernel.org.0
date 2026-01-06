Return-Path: <io-uring+bounces-11427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D121CFB202
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 22:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F312301C933
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 21:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCAD30FC24;
	Tue,  6 Jan 2026 21:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxvm20hE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2667E280CE5;
	Tue,  6 Jan 2026 21:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767735836; cv=none; b=qltDaDFyREiZ9xF3VGqLoAedLYc0tiAk45VUlsTRMVwtHT+Q/YstYSK5a41Qw8D0piAoNA/LdBmIiWy5+9HbBZrI1Cq1Cn78L1799BprZVKPa/WQN9b5McyeyDIZ0HSNITec3DIc/trxdNlPo7jTkGUGeQzI831kmm4OQycgKTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767735836; c=relaxed/simple;
	bh=oy0nq2zmkLlQ8H2hYCSqLD1m9F9tLj75bp9TRPzk9nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o36bnFxdAIupFG7fafTi0tRe88jo5oYCrGHtC7AWb7pEN4zAeiY9mbon+VrxQ6vrcRv+b6K7QUSJnsJ1Ls2+jIOhDxxwMzIl2qkcmBWp6G3TUluROFHAHH3zL22bsqHsRkbEmQTUCijXxTmx/g0Ttj6yMJJhcO0nRgq/ECKGR+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxvm20hE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1127C116C6;
	Tue,  6 Jan 2026 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767735835;
	bh=oy0nq2zmkLlQ8H2hYCSqLD1m9F9tLj75bp9TRPzk9nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sxvm20hE+Y7hNroZuQmjk2Hk3ZkHX6MDfP9oEcQv2V8VwA6ijnWVVjdCIUkpvBFm8
	 GDImaxG+L4xFILzUiX5hvqWw+uQSanWkyG4HZLd6jLk+FbSbAsUtzi6I/+PyE4HMLU
	 rcuCeMAqaqP73xT9SNOxAUIeaBr+I1iLvMFBIHhkrdKyW3ZsKbQF51b1RsuHqoMa9L
	 3Ybt9gkFk4x2VPZ9ZpZWF2XzVkjTqmobY6LBgjg33uYVWLB0M4T82oejV3ON7Y9PiR
	 8al5v9sdVf6qKwJRzzRzNQNHsrCJIKkf6wlcNffIiwlbTPk/2ww0YF4quW5B4zpuZ7
	 x5Kf4szM/lVMw==
Date: Tue, 6 Jan 2026 22:43:49 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, 
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, 
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, io-uring@vger.kernel.org, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v4
Message-ID: <20260106-bequem-albatros-3c747261974f@brauner>
References: <20251223003756.409543-1-hch@lst.de>
 <20251224-zusah-emporsteigen-764a9185a0a1@brauner>
 <20260106062409.GA16998@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260106062409.GA16998@lst.de>

On Tue, Jan 06, 2026 at 07:24:09AM +0100, Christoph Hellwig wrote:
> > Applied to the vfs-7.0.nonblocking_timestamps branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.0.nonblocking_timestamps branch should appear in linux-next soon.
> 
> Umm, as in my self reply just before heading out for vacation, Julia
> found issues in it using static type checking tools.  I have a new
> version that fixes that and sorts out the S_* mess.  So please drop
> it again for now, I'll resend the fixed version ASAP.

It has never been pushed nor applied as I saw your mail right before all
of that.

