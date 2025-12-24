Return-Path: <io-uring+bounces-11301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F945CDC542
	for <lists+io-uring@lfdr.de>; Wed, 24 Dec 2025 14:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DE523303ABFB
	for <lists+io-uring@lfdr.de>; Wed, 24 Dec 2025 13:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5256534AB1D;
	Wed, 24 Dec 2025 13:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4jCnbzM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5F93446C3;
	Wed, 24 Dec 2025 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766581901; cv=none; b=RsdRHRkvZExFwpmJpgKdGAxaJn7P05GJ5J0936+/5Q60lzPjjB6S8NWqfYuwguHwhf6a9EwsHX3oSYD/Ox87pmSyEdrJgBP0D4AQppkPqAhLOXztG5IqJdIxyLpTjNgBEX0Ij3M2XDPAgvqeJckSZ7zJai9BU4XAtUJxFveg920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766581901; c=relaxed/simple;
	bh=xkzFLbJE3Yl6/KjE/bhEo+uzD1k3qFUB9hXgXJmvF9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGUzqlQy1F4hYBgN3P8T5fuigJxYyfFACMjxYwRBfR42La5ZD7fcF3T9BdTy47CZvwDpJ5DkbdajmE1LhmmuJWj6DykdrsXS5bw9CuhSmv+5J53lCSqUgpjfj44LMsXk+rTG6SthMC+eehUJ9kTGX2T7qIT94pTYH+cfLAiRWqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4jCnbzM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD69C4CEFB;
	Wed, 24 Dec 2025 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766581900;
	bh=xkzFLbJE3Yl6/KjE/bhEo+uzD1k3qFUB9hXgXJmvF9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4jCnbzM3mOgqWIdxR3C3K2n3HI1lcBsgb+Ru/Qb0aCw/VL9DX9Lb5CnzIiQswF4A
	 pJKR6nkrEuWDuCES+6pMYluaUXGp0D6J54b5f05m7vMlV0UP2/7BVwL7fzFFwZxcCI
	 nxeWBMa0oQONvUuGckHG2Zg8KqjTzfhVsUT7bJ0zAljCq8un6sQqsNzV1zt5fxX25n
	 JzJIRtOUgTqTb4yxYV1o1KWaRd9nJ0IppElaoiZjpm2unGrwAuLay1lKbTeqC0EFAV
	 G612qY5Z0BsJe6l0vVzhPtIMUOJQgCg40oz5KXe2WIxN6a84IhK91JRBQqaIUzg8vU
	 WjAhNRNhlSJZA==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>,
	Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v4
Date: Wed, 24 Dec 2025 14:11:29 +0100
Message-ID: <20251224-zusah-emporsteigen-764a9185a0a1@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003756.409543-1-hch@lst.de>
References: <20251223003756.409543-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2451; i=brauner@kernel.org; h=from:subject:message-id; bh=xkzFLbJE3Yl6/KjE/bhEo+uzD1k3qFUB9hXgXJmvF9c=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR6P2u9P8NC4Oknl7n+KaseXU9zXzhvZm2QvLrO6W3vJ 6tuyLhc21HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR7BkM/9RVShfZSa156/bx 1eXNz6SeJXfd3dXamjphTqX5hxVNKosZ/lcvu/A9Llf0x8MWnStxfpW3xBwCVpVM83e7znXwGHP 8YRYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 23 Dec 2025 09:37:43 +0900, Christoph Hellwig wrote:
> commit 66fa3cedf16a ("fs: Add async write file modification handling.")
> effectively disabled IOCB_NOWAIT writes as timestamp updates currently
> always require blocking, and the modern timestamp resolution means we
> always update timestamps.  This leads to a lot of context switches from
> applications using io_uring to submit file writes, making it often worse
> than using the legacy aio code that is not using IOCB_NOWAIT.
> 
> [...]

Applied to the vfs-7.0.nonblocking_timestamps branch of the vfs/vfs.git tree.
Patches in the vfs-7.0.nonblocking_timestamps branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.0.nonblocking_timestamps

[01/11] fs: remove inode_update_time
        https://git.kernel.org/vfs/vfs/c/a3c5dc04be9f
[02/11] fs: allow error returns from generic_update_time
        https://git.kernel.org/vfs/vfs/c/829f055d68ee
[03/11] fs: exit early in generic_update_time when there is no work
        https://git.kernel.org/vfs/vfs/c/3c5f7a9696fa
[04/11] fs: delay the actual timestamp updates in inode_update_timestamps
        https://git.kernel.org/vfs/vfs/c/6e827e32c6ae
[05/11] fs: return I_DIRTY_* and allow error returns from inode_update_timestamps
        https://git.kernel.org/vfs/vfs/c/b79904581c69
[06/11] fs: factor out a sync_lazytime helper
        https://git.kernel.org/vfs/vfs/c/0cd53e2011e2
[07/11] fs: add a ->sync_lazytime method
        https://git.kernel.org/vfs/vfs/c/641284ff9133
[08/11] fs: add support for non-blocking timestamp updates
        https://git.kernel.org/vfs/vfs/c/3cb9ff38ddaf
[09/11] fat: enable non-blocking timestamp updates
        https://git.kernel.org/vfs/vfs/c/1736c77f0834
[10/11] xfs: implement ->sync_lazytime
        https://git.kernel.org/vfs/vfs/c/831c93b34fa4
[11/11] xfs: enable non-blocking timestamp updates
        https://git.kernel.org/vfs/vfs/c/bafbe984c54e

