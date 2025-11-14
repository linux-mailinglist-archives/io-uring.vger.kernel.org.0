Return-Path: <io-uring+bounces-10615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7706C5B81C
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48FC43B9905
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77022737F6;
	Fri, 14 Nov 2025 06:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yc1BbnIP"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6926A242D86;
	Fri, 14 Nov 2025 06:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101613; cv=none; b=ra3XoVsukAJn1SwvzmgfOtJnW2tN7JtJKo3tP6uN8NAdRDFOR+ElUBmZFOdQx1VOW26xAIfWQH4cn35bFsTR8muaRmwZ4uSn2dcSg3+w5A56NubBff/s4jBIa/XFPOFmQsT13OhX5+FD+BzHJZVNzabO+05neR9BerBEOecz0mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101613; c=relaxed/simple;
	bh=5V0zYJxbf6yTcvA5sVd3U6L3B6QdKntz+6MjepAGQS0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LScG4zl2bf8zhLhWz4Ab6W26nBIXfNSNczbHwEZM/1aZl7jZX85ZJwGveay+nqzVXbETc8NAU/RYDETCaU3VznDQy8q6r314DvX5FihZpqWiPHupBg0VJ0AsJYkOi2CGAB4uxloiD+aFcj4w8jdwTW8gTHfHi1X1CmFc2uM+IGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yc1BbnIP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=k1LbDExrN0ggsKL8BG2ZZifr9NCiwP7806AdNTSqrTo=; b=yc1BbnIPmw7r8r6Ligj0NRD8pt
	XBQJz9ltXrPwFOlsy0m+7pUmq9nSRoegHccYW3JeNVnf6Wp/qlgoA6DzKwejQfJud0x/kY8PTIkoz
	bg/dq3maUqbxl0MC/eedcbkJL9LoHn29AfMeOojS4jhZZP8Z7JYv2T+voKIls25rangHauouswCkJ
	6TyZED9nZGX6JYDJmxJEAUJQlehv8IlNyHtuG0jLcueP2dqrt/DssOEhSyR1FYdXlUE5fGlkAlW9C
	U5ZrPbzRoj2Db8vZur7MJyMdF6cTXKn5Cl3BS/2BkYx7vJoE7l1EebrCU0dao8tzuRmslpJbrZyqr
	ugVlRwsw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnGh-0000000BeQ2-3r71;
	Fri, 14 Nov 2025 06:26:48 +0000
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
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: re-enable IOCB_NOWAIT writes to files
Date: Fri, 14 Nov 2025 07:26:03 +0100
Message-ID: <20251114062642.1524837-1-hch@lst.de>
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

Diffstat:
 Documentation/filesystems/locking.rst |    2 
 Documentation/filesystems/vfs.rst     |    6 ++
 fs/btrfs/inode.c                      |    3 +
 fs/btrfs/volumes.c                    |   11 +--
 fs/fat/misc.c                         |    3 +
 fs/fs-writeback.c                     |   53 ++++++++++++++----
 fs/gfs2/inode.c                       |    6 +-
 fs/inode.c                            |  100 +++++++++++-----------------------
 fs/internal.h                         |    3 -
 fs/orangefs/inode.c                   |    7 ++
 fs/overlayfs/inode.c                  |    3 +
 fs/sync.c                             |    4 -
 fs/ubifs/file.c                       |    9 +--
 fs/utimes.c                           |    1 
 fs/xfs/xfs_iops.c                     |   29 ++++++++-
 fs/xfs/xfs_super.c                    |   29 ---------
 include/linux/fs.h                    |   17 +++--
 include/trace/events/writeback.h      |    6 --
 18 files changed, 152 insertions(+), 140 deletions(-)

