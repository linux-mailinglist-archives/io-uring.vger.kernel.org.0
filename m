Return-Path: <io-uring+bounces-10675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDF7C7263A
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 846514E60EC
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C10426E16C;
	Thu, 20 Nov 2025 06:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SJCkRycS"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48542BDC01;
	Thu, 20 Nov 2025 06:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621357; cv=none; b=YzyZRNQYcrE/04m5TW3gjMvWu/36eyxUscq13fmhDni+s4CqS9Lc0xHfD6qe/z3zqxB60hpek2iwqKpeT7xp0jZzUrF8Sym53qgVPo1AA1J+XfZwGMGMW83HcrrlCqaFhrBkeePKyeMxpbanevgwSyvuvHerUIDRVil5VLzFO+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621357; c=relaxed/simple;
	bh=xFOx6jB1/jIm33IEiFx9URMIFU3GJ8PppOUR2OvBCbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c6ztSwXEaDyn3YuIJEczuc+I+oxxM4t1knMyBOaQpyd1gzgTxS/CfLQb0XA/foWOvdZO8g4FJpRMDqb7gj3mhZowehID5MWQOanWWCaerUMiBCineMu2GH/aZFf9D8lZkn5YdHGtCFxMXQ05bJkAkm+Yw9NWNSj1KLniGW/Usqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SJCkRycS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=cpTungSQVD0x31/iY7Zqb7COYgAEJ4A1OQabJ1J5QlM=; b=SJCkRycSr6fdZe2w2Malbw+wDx
	UlHo/HdCKiU6GT+xcemjeVOiyv+dNYh2rX3GmHhobtpwqY//BhuzXigVUxDjwLG2zTKaOWVZ1FVh6
	HUWzTcNFgwZhh6RVzGeGvXXiyAbM6ZAYEin2V+HDp0J7p0TPASVyKvrQDmxlLhKFtWqyMMGHLU+0F
	7XK3BWmiWfIb5sDxa4zyl4uY0/re7eXjQwqM4J/VIWR+kgrqVtNeq5sZQG9ag1CXSDINAzmldZFmf
	V/ne7pIhibJjqLxQOxQQnIzyPb3feN3FMoYwZAeoJNeaZtxjsLDPSIdM1xL7Y208qQHMjn0MsbAjD
	YCL0MuHg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyTc-00000006Ed6-2HbS;
	Thu, 20 Nov 2025 06:49:09 +0000
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
Subject: re-enable IOCB_NOWAIT writes to files v2
Date: Thu, 20 Nov 2025 07:47:21 +0100
Message-ID: <20251120064859.2911749-1-hch@lst.de>
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

It also fixes the layering bypass in btrfs when updating timestamps on
device files for devices removed from btrfs usage, and FMODE_NOCMTIME
handling in the VFS now that nfsd started using it.  Note that I'm still
not sure that nfsd usage is fully correct for all file systems, as only
XFS explicitly supports FMODE_NOCMTIME, but at least the generic code
does the right thing now.

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
 fs/btrfs/inode.c                      |   15 ++-
 fs/btrfs/volumes.c                    |   11 --
 fs/fat/misc.c                         |    3 
 fs/fs-writeback.c                     |   56 ++++++++++---
 fs/gfs2/inode.c                       |    6 -
 fs/inode.c                            |  143 ++++++++++++++++------------------
 fs/internal.h                         |    3 
 fs/nfs/inode.c                        |    4 
 fs/orangefs/inode.c                   |   10 ++
 fs/overlayfs/inode.c                  |    3 
 fs/sync.c                             |    4 
 fs/ubifs/file.c                       |   11 +-
 fs/utimes.c                           |    1 
 fs/xfs/xfs_iops.c                     |   35 +++++++-
 fs/xfs/xfs_super.c                    |   29 ------
 include/linux/fs.h                    |   19 ++--
 include/trace/events/writeback.h      |    6 -
 19 files changed, 209 insertions(+), 158 deletions(-)

