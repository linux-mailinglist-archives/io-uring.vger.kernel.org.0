Return-Path: <io-uring+bounces-11277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3467FCD7884
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA73B301E239
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0772D205E3B;
	Tue, 23 Dec 2025 00:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CvxXWh3z"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CF019C553;
	Tue, 23 Dec 2025 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450293; cv=none; b=HmN3xvl8MfcjEQeKANuiMd1qLc6K8zbKa7ZRRo/rkV7/yBy9BgizXohVN59GKVgIheqDLnZqIJnuN07ZWY7z2IDNEYBxnHlt9AuVGDNM2vqdmxXi9tWz/aTFbirJPQ1Bn+FRLT57doUwRl0Vj4CavNXLYCMlhQniwryBLataXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450293; c=relaxed/simple;
	bh=vOZU3RKAMr10oE1z8eEjaGiHykBBPMEzR57f+8A3A8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gZeLCVK8fxCta2lsEOAmEOGJ6r5Qqe17pGpSO6xzJkWgncPxFcMh7g4ZMqxXnBi/AKD5BQWWN71ANFQHbIqQjU/KEQG5MnK6+TcCAWB24Ny/lUhGcNagMu32ozf4eO4oPZq2lBTwE5001jb37pe1JN0zxAiRTLTdyVJgxLIyk/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CvxXWh3z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kKKFfzAP6QAWeZoKZ4GerSXZJSLPUAXcRs/vrMSzcV4=; b=CvxXWh3z/G6mClmXqkR2XuG5sX
	7AbA1vrHgDkPEih7NE875WhZNdWAM4QnIWKGVx/7XxCUelTJ382C6iSn6rHBPS0Qvbco7elqj9jqD
	WCTpLeHc+LjaSc1Sb8vDLXfOKjvzkvxl2rywYBojKpIRWYG+VTTvPk4DJQb6BNOZuLWc2Q/htjK5Q
	GLg22PJxR1OZd+lz9YlP3A52fjoR/1q4UfD0W+rxugDw7tStkyXJQQiq4rM0aJopwgrVmhgUtc+zi
	baAAQocNtlk+ubFVgW+GxFr9Ha7SiLNNMzQR5ZnvWKP28k4bw6bS2p5rCQf88HmjOzQC/XX3/vvyn
	UaZg9jaA==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqPa-0000000EIiS-1ujH;
	Tue, 23 Dec 2025 00:38:02 +0000
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
Subject: re-enable IOCB_NOWAIT writes to files v4
Date: Tue, 23 Dec 2025 09:37:43 +0900
Message-ID: <20251223003756.409543-1-hch@lst.de>
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

