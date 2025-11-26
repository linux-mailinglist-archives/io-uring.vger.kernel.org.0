Return-Path: <io-uring+bounces-10812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04281C8A19A
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 14:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B643B0B94
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 13:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E0632938A;
	Wed, 26 Nov 2025 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8iRE1/W"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9E3329379;
	Wed, 26 Nov 2025 13:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764165083; cv=none; b=GttN/x6x5txv4WMGNCEOwG0pbYPqot5Mpc1/7HfHatjshvpH8vZ0Fr4OvYZe5tayj0oagbxasnGC6j04xdsHI49aVARFgCj585/OyL6G/0p4B3K29UkeBCykme4cX1h8liF4xFP84dyz6f0XzuLfnxFHgDbdgAOkUiM84na8ruc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764165083; c=relaxed/simple;
	bh=yUKYtxHtKaR+6m/xsrQsQe67bKqXRGc4JbcKnKX+a20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=miBPd+zx84BIYY2sJDRpPl31r9nQyIpvhZzr2TPGl63tV4UnoM5wUhLQl7EckeRYSUxL2rtH9aCL+gSsFmlTV/dfXzXf+5iNiKbGo7d8i1phYul4n7nM0J/Ad9xctin6JEmsXDFPLXtwLeC/A/+FoqogPGINHMR6LhXvruItRCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8iRE1/W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADBEC4CEF8;
	Wed, 26 Nov 2025 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764165082;
	bh=yUKYtxHtKaR+6m/xsrQsQe67bKqXRGc4JbcKnKX+a20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8iRE1/WnH5hQhQsb+gz1I+WE9aSLdfLQQiRWd7g4hWBfFLiJ7GeKN9MfcROfuy14
	 Bg5ifG0mRnEDa0wLCNWcaWSef/QLNZ9iuJt146gvNW8/fk6cYnq1PxKc4hQKhLNIBA
	 sNEXQMAYyhZpIavSfz+KkkZ7tBQo4jX83xz4wgdkgk+sAnQZiGPm4kG9cVpDUNx50f
	 GszRnMspkE9d7aOOvEx8eAK322hwR8CBYnIQYVbVZy8dg9+z7898oFiThB1IRsH5Xr
	 Ex3oGaOerSkIflHQPu0XSvcuPfWP3Yma6L1dTMlIVWE32f0gwXl7q8tXr7D18MuVes
	 /vgMU+UkTu2HA==
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
Subject: Re: (subset) re-enable IOCB_NOWAIT writes to files v2
Date: Wed, 26 Nov 2025 14:51:10 +0100
Message-ID: <20251126-freigaben-fixkosten-7f8ba6710fce@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>
References: <20251120064859.2911749-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1827; i=brauner@kernel.org; h=from:subject:message-id; bh=yUKYtxHtKaR+6m/xsrQsQe67bKqXRGc4JbcKnKX+a20=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSqs17kYtX3/zt7guqDZZHcotIzSu/JuZ8vW1f2x9Tzn jjvrEs8HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5NJ/hfwz3tQVV/86ebZ6Q ZOX2S/x94+vvFxzsdzFb2M/tOJ9ddJzhf+6cWXKXJ/IYCjVvXXqrOyfkypPfnuY+G+fPOLtET2K HGS8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 20 Nov 2025 07:47:21 +0100, Christoph Hellwig wrote:
> commit 66fa3cedf16a ("fs: Add async write file modification handling.")
> effectively disabled IOCB_NOWAIT writes as timestamp updates currently
> always require blocking, and the modern timestamp resolution means we
> always update timestamps.  This leads to a lot of context switches from
> applications using io_uring to submit file writes, making it often worse
> than using the legacy aio code that is not using IOCB_NOWAIT.
> 
> [...]

Applied to the vfs-6.19.misc branch of the vfs/vfs.git tree.
Patches in the vfs-6.19.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.19.misc

[01/16] fs: refactor file timestamp update logic
        https://git.kernel.org/vfs/vfs/c/3cd9a42f1b5e
[02/16] fs: lift the FMODE_NOCMTIME check into file_update_time_flags
        https://git.kernel.org/vfs/vfs/c/7f30e7a42371
[03/16] fs: export vfs_utimes
        https://git.kernel.org/vfs/vfs/c/013983665227
[04/16] btrfs: use vfs_utimes to update file timestamps
        https://git.kernel.org/vfs/vfs/c/ded99587047c
[05/16] btrfs: fix the comment on btrfs_update_time
        https://git.kernel.org/vfs/vfs/c/f981264ae75e
[06/16] orangefs: use inode_update_timestamps directly
        https://git.kernel.org/vfs/vfs/c/eff094a58d00

