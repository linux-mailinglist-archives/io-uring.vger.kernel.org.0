Return-Path: <io-uring+bounces-11133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D923ECC6282
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 634F93036CBD
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63252D592D;
	Wed, 17 Dec 2025 06:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RWaIE1XN"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCD42D3A69;
	Wed, 17 Dec 2025 06:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951828; cv=none; b=MJG4CCd+LeaKu9R5tLVE98GiP7hrzTpoeOCx+wO//kdfim9L3/kTJSQz5Z8IPQfD20/k1ovZqLhydIB469BsWow3gkJckOeAdNV15EQxbVaioiiaxdgmEtC/v4QtGXevotTLxFYFYUHOCRRvvpfE0Fq1B1qrycoJkH//qwJROj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951828; c=relaxed/simple;
	bh=n/ts86dlJHFC1dtjkqgZ3MJH7gMwJ/qoS8cXeqwI98o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fvPL1o0PhGvfeH3/Z2kSnpM9CD471QWJ19O78fMPPvAdysF0KjqNgbV3Cw0Sz9CdAErb0MkflPPS6W22V6TSgcVOqiPH03d41yCrmWCQLM+aSLAvP1WQooF6LbdA20HxnI/LzoyY6rrhK91XqyLhYy0A7w+ok+jq3RdN3vVzCSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RWaIE1XN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Hg/tESeGWqFXyE6OY/4FD3HnRJ5gNtQ9rs6sVZ/sm/I=; b=RWaIE1XNo2xqIf3v0pGEty3Vki
	i+XyIgwgRWHpSRL5IOdxnnbugZImmEzMyU9gjru4003sHk0x1z1h5Q+sR+1QYMYD+zBAX48bDlSkv
	/eY5BUfdn0Roh8veto2Y5ZTRz+JO9BdfXAEGHbqg89WiF9fNB7ILVgKSVlt61wPTxW8LajYjdh4s3
	Vapn/ah77rbNgBkL1F6/I1ldQx6KpEy2cCc9qkJ4qVeH/McHKj//6iOUJFRaTkPXa8uVckHnDKis0
	QEn0e7jOdiGQ5noV1sixi4BZUMf7H0rIvn4F6x7YyBVftkCq4jInersDaT8mfv8JcCU0EDxPMkMpc
	dIe+M5hw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVkjt-00000006DOb-2Y4Q;
	Wed, 17 Dec 2025 06:10:24 +0000
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
Subject: re-enable IOCB_NOWAIT writes to files v3
Date: Wed, 17 Dec 2025 07:09:33 +0100
Message-ID: <20251217061015.923954-1-hch@lst.de>
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
 Documentation/filesystems/vfs.rst     |    6 ++
 fs/btrfs/inode.c                      |   11 +++-
 fs/fat/misc.c                         |    3 +
 fs/fs-writeback.c                     |   52 ++++++++++++++++---
 fs/gfs2/inode.c                       |    6 +-
 fs/inode.c                            |   89 +++++++++++++++++++---------------
 fs/internal.h                         |    3 -
 fs/nfs/inode.c                        |    4 -
 fs/orangefs/inode.c                   |    8 ++-
 fs/overlayfs/inode.c                  |    3 +
 fs/sync.c                             |    4 -
 fs/ubifs/file.c                       |   11 ++--
 fs/xfs/xfs_iops.c                     |   35 ++++++++++++-
 fs/xfs/xfs_super.c                    |   29 -----------
 include/linux/fs.h                    |   19 ++++---
 include/trace/events/writeback.h      |    6 --
 17 files changed, 182 insertions(+), 109 deletions(-)

