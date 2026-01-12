Return-Path: <io-uring+bounces-11586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BB0D12AA4
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 14:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 707B2304F157
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 13:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927D13563EA;
	Mon, 12 Jan 2026 13:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GuBawYgi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF522D47E3;
	Mon, 12 Jan 2026 13:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768222932; cv=none; b=Rekm7lgVLXBgiAAMQ+om4GvmNEqGwDMrGEcoOPYQkAQB6J1eLtUeH1KwGlQqPLBNDdaXzmAwLeJ/HYiheTPATAj932eKnQa5PR0ZvypZURKgJp5zlaQpNfbFc6BKgAJI/fFNLiyMmJDrJVv+hOO4c7EQ32FjaxQ1B/BhBPE6qB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768222932; c=relaxed/simple;
	bh=RIH5DGw9iaODSe+GboFTs0O7c0cEBRdRfN8567Qvz9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOdeLo4ZbMxZPciLiPUTxU9M4D5eXoSJujLY5srCHZjYqK7q9yjLCK8ERKKfwMOzFzgrSm3Gt3Rtv1r2wcEkzKy1wr7lPzdMK5QJTm5knd7IxPVTio/m1vyhqgx98T/YNe0fBtqOgy2IQMPxWGzmrojMTfIBxE3u4CiE0CNjj+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GuBawYgi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EF4C16AAE;
	Mon, 12 Jan 2026 13:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768222932;
	bh=RIH5DGw9iaODSe+GboFTs0O7c0cEBRdRfN8567Qvz9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuBawYgiub2dv2qsF9RKZVhe0V/aSnkEu4nPJWorZt+trDE7QgUWV0DL+v3F9lYFb
	 S8jkjZescwZ86TegZq0zHtZhaq9OiP/XT4Ek5oC6djgknJE1zX7QEA/iqpuP2EIHYd
	 i/AUasa7Z7UImS/J0tHpsy/U9HlOS5XOAxCNzfi5lx8vhyf2Wb4IsdXz0HYl/2ybgd
	 zyMbLaIzdD+bTqh0IYPV9h+8sw3TKlpbpGyacEvIK+RA3MswzE5pZ8VVVdUD7aZwhB
	 Xj9stBjtg4cBkuHHRQP3fuSvhrKmcBkeAARfw51Fmp9ppfpQRplOXvMpP4uYYgpMYD
	 hcqUp5Kh8q71w==
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
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
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
Subject: Re: re-enable IOCB_NOWAIT writes to files v6
Date: Mon, 12 Jan 2026 14:02:02 +0100
Message-ID: <20260112-geben-ausrichten-20a6cad7e163@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108141934.2052404-1-hch@lst.de>
References: <20260108141934.2052404-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2358; i=brauner@kernel.org; h=from:subject:message-id; bh=RIH5DGw9iaODSe+GboFTs0O7c0cEBRdRfN8567Qvz9A=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSmfDgTzOJR2bBdxfHs4lPvNzr2Vs6TUNwx6US+esA93 wOa+bFsHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5dI2R4ZP6ftH/fWt4PbWW uef2Z5wtW9WpnhlzeM35ddH5pfqvghj+lxkqrN5Xtz+j/JXujQs9eTrzbzdP4Od/964lr1hHb7E MCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 08 Jan 2026 15:19:00 +0100, Christoph Hellwig wrote:
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
        https://git.kernel.org/vfs/vfs/c/20b781834ea0
[02/11] fs: allow error returns from generic_update_time
        https://git.kernel.org/vfs/vfs/c/dc9629faef0a
[03/11] nfs: split nfs_update_timestamps
        https://git.kernel.org/vfs/vfs/c/b8b3002fbfef
[04/11] fat: cleanup the flags for fat_truncate_time
        https://git.kernel.org/vfs/vfs/c/1cbc82281675
[05/11] fs: refactor ->update_time handling
        https://git.kernel.org/vfs/vfs/c/761475268fa8
[06/11] fs: factor out a sync_lazytime helper
        https://git.kernel.org/vfs/vfs/c/188344c8ac0b
[07/11] fs: add a ->sync_lazytime method
        https://git.kernel.org/vfs/vfs/c/5cf06ea56ee6
[08/11] fs: add support for non-blocking timestamp updates
        https://git.kernel.org/vfs/vfs/c/85c871a02b03
[09/11] fs: refactor file_update_time_flags
        https://git.kernel.org/vfs/vfs/c/2d72003ba244
[10/11] xfs: implement ->sync_lazytime
        https://git.kernel.org/vfs/vfs/c/f92f8eddbbfb
[11/11] xfs: enable non-blocking timestamp updates
        https://git.kernel.org/vfs/vfs/c/08489c4f4133

