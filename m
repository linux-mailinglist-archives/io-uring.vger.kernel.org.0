Return-Path: <io-uring+bounces-11515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEE6D03536
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 15:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E3270302DD68
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 14:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878D84E90CF;
	Thu,  8 Jan 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HCkUV5Sg"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710EB4E819E;
	Thu,  8 Jan 2026 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881992; cv=none; b=l5H8rRNRi+njebvKGF7CKkaB+cve0IuIFc9xF7LIalOuvHI9FP3zVCeWKAz3d5eMlPm0YmT9qf+sZHUokGApyd92XecdwSd4WFM/676JEgTG016hYnbGfr2OxP3LiIfw3q50LVex3X9fTlqHBK+75IbDGXZhzjwARkppG05zBrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881992; c=relaxed/simple;
	bh=pgFo/tGly54ijlfTPPtxx0Ky8wb8MMinxNhrt4wuMLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cC4rPmZYLTBSvaaEzOfToN0yXD0xWt7jPEwERbQkDphYs6t5NgjD4mbBKltJ1Fe4Nis4dox3F619ugrna98wB66uf3WqsHFqy0C0SaEUi6BAlREAbXUr3kpLKDjXu6EERS+YRST0Hqu42FuFLUOcd3HAeMxdUySeUMPZhNserVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HCkUV5Sg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=47j3Vb5ECJCThNE4hZUuOAtfhlxTrOYUcu9LaYfkCP0=; b=HCkUV5Sg9RjiYn4vXDrQU9X8X2
	QN7lpU67efTqRh1BaVJtEpKYMQAxG7T0N5995XKnZJk7w2W6cfF7OalQFG+1xpn4iCS1mLCF8LFZU
	gI2xKmgSvoXaJnySBF9YEhWtKLaWW7n6Y8WsCHdLazXAFwFVgQFsrhIxgACJfaKplPExgcdHw01Kq
	Ke4GwPEVve9HwaXeITYANFM+28/9dKysmfdekPnByN9rEJlzWGQfqqhw/sYk5H/myvcdC4/dP73NO
	EnAdF+bwO9giTfj+kY8VlOmqBYEyM2N4eNeUEjVZQAm6jkNPHOIPZEmQEn0ZAp410vM3yx9JmCZ62
	jjcnpyIg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdqrX-0000000HJ7f-3drf;
	Thu, 08 Jan 2026 14:19:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
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
Subject: re-enable IOCB_NOWAIT writes to files v6
Date: Thu,  8 Jan 2026 15:19:00 +0100
Message-ID: <20260108141934.2052404-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

commit 66fa3cedf16a ("fs: Add async write file modification handling.")
effectively disabled IOCB_NOWAIT writes as timestamp updates currently
always require blocking, and the modern timestamp resolution means we
always update timestamps.  This leads to a lot of context switches from
applications using io_uring to submit file writes, making it often worse
than using the legacy aio code that is not using IOCB_NOWAIT.

This series allows non-blocking updates for lazytime if the file system
supports it, and adds that support for XFS.

Changes since v5:
 - sample ctime before calling inode_set_ctime_current
 - fix a mild bisection hazard in fat

Changes since v4:
 - replace the S_* flags with an enum indicating either access or
   modification time updates to make the logic less fragile and to
   fix a bug in the previous version

Changes since v3:
 - fix was_dirty_time handling in __mark_inode_dirty for the racy flag
   update case
 - refactor inode_update_timestamps to make the lazytime vs blocking
   logical more clear
 - allow non-blocking timestamp updates for fat

Changes since v2:
 - drop patches merged upstream
 - adjust for the inode state accesors
 - keep a check in __writeback_single_inode instead of exercising
   potentially undefined behavior
 - more spelling fixes

Changes since v1:
 - more regular numbering of the S_* flags
 - fix XFS to actually not block
 - don't ignore the generic_update_time return value in
   file_update_time_flags
 - fix the sync_lazytime return value
 - fix an out of data comment in btrfs
 - fix a race that would update i_version before returning -EAGAIN in XFS

Diffstat:
 Documentation/filesystems/locking.rst |    2 
 Documentation/filesystems/vfs.rst     |    6 +
 fs/btrfs/inode.c                      |    8 +-
 fs/fs-writeback.c                     |   33 +++++++---
 fs/gfs2/inode.c                       |    6 +
 fs/inode.c                            |  111 +++++++++++++++++++++-------------
 fs/internal.h                         |    3 
 fs/nfs/inode.c                        |    4 -
 fs/orangefs/inode.c                   |    5 +
 fs/overlayfs/inode.c                  |    2 
 fs/sync.c                             |    4 -
 fs/ubifs/file.c                       |   13 ++-
 fs/xfs/xfs_iops.c                     |   34 +++++++++-
 fs/xfs/xfs_super.c                    |   29 --------
 include/linux/fs.h                    |   27 ++++++--
 include/trace/events/writeback.h      |    6 -
 16 files changed, 182 insertions(+), 111 deletions(-)

