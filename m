Return-Path: <io-uring+bounces-10677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 439E7C72619
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BAB32346E95
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1723002B4;
	Thu, 20 Nov 2025 06:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XyYrpTgQ"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E562FF65B;
	Thu, 20 Nov 2025 06:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621372; cv=none; b=F/4FKo39b7427eJ3OQOikyyn0CGlBKWA23tcSI4hMhvE8WZW+gL2lPZV3A4ZfWtan2HFN3bfPIMlay+HCaBGdFgMdVnR08eJfrdjO7buSK1u8o3QPbYbAOn5fk/ZpvQp4OZ9ioDZM9Q36AxPczB4n40yFs/mD6wxyhwkmY2C8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621372; c=relaxed/simple;
	bh=q1pu98stdTIykhPc+n0Lq5RAGZ6A3LONUlcs6PoMbLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMUCTMMWX0JxiAEAUwLVYClwZIvW8OjxKa9dqMUjwyk6EwvntuGDt5cT52ApSkIKPU0WJTGOgCjWpz0eWTaOp/4B6xK/yz6FEosr4t72G07AAp4UwzoG1iZ9aWWZc+hwn+3pT1pv80G3V9QZTxvhtcaAWjTtnomcT00mLE99KzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XyYrpTgQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6mBDm1v0QSL2bY7XVx/upIBfJXF550GhEGzeJKVBDuA=; b=XyYrpTgQ9ejysaYTP4uPk+ciG8
	Uy9qKUNyVevX3MvJlc9m2P0lSmNrNGZWNWXALtX2BAAtrQDbLN0imFbIvbcptuahgp0fO0CwCcC8o
	aWEGjTSLESGcBtGCJx7cYIxwBTALGTsJhLg1nvFizIr0QhhSlZDlSi0xc2YTORlLfOe395capkKLH
	62PIi3b6+vaCFrWtLF5Xnjc3xaN8Od9CQ9QCWYN8A02AVvcojg18FrWuD+9Lt8mdlB8lKf2JINHs0
	4LeAVLxixraNKeQ0J5A7uCZnICiGGkwQr6Io4z2kJoeuKRnqqaoTsKQvuWUJTTpavJxw1i6QsZpzU
	QPjxuMnw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyTw-00000006EeT-0m56;
	Thu, 20 Nov 2025 06:49:28 +0000
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
	linux-nfs@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 02/16] fs: lift the FMODE_NOCMTIME check into file_update_time_flags
Date: Thu, 20 Nov 2025 07:47:23 +0100
Message-ID: <20251120064859.2911749-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>
References: <20251120064859.2911749-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FMODE_NOCMTIME used to be just a hack for the legacy XFS handle-based
"invisible I/O", but commit e5e9b24ab8fa ("nfsd: freeze c/mtime updates
with outstanding WRITE_ATTRS delegation") started using it from
generic callers.

I'm not sure other file systems are actually read for this in general,
so the above commit should get a closer look, but for it to make any
sense, file_update_time needs to respect the flag.

Lift the check from file_modified_flags to file_update_time so that
users of file_update_time inherit the behavior and so that all the
checks are done in one place.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 540f4a28c202..2c55ec49b023 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2332,6 +2332,8 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return 0;
+	if (unlikely(file->f_mode & FMODE_NOCMTIME))
+		return 0;
 
 	now = current_time(inode);
 
@@ -2403,8 +2405,6 @@ static int file_modified_flags(struct file *file, int flags)
 	ret = file_remove_privs_flags(file, flags);
 	if (ret)
 		return ret;
-	if (unlikely(file->f_mode & FMODE_NOCMTIME))
-		return 0;
 	return file_update_time_flags(file, flags);
 }
 
-- 
2.47.3


