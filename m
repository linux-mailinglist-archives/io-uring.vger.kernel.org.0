Return-Path: <io-uring+bounces-10679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EC861C726BE
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E9CA4E9DFC
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BBE302164;
	Thu, 20 Nov 2025 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LQAjjNmU"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541962FCBE1;
	Thu, 20 Nov 2025 06:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621385; cv=none; b=FZVrlpIjvbbJHeIhS3mrIxz8VrijvTiLTjUQ/rWv2YA1aBQocOc/+JOz4kKs6WHhAUEHwobI1AEV4IZQnjnCBiBzOtSAROxfvkQ/APDa2r8eyoOvzEr2qjhp357/Q+iLXYScEJh4ql8mMtQBuwWts4yTZd3QtmhXyIuVuX9BU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621385; c=relaxed/simple;
	bh=4QwBBgYfA3lTmm8uH9/tlk2p+sTf2J8UOruCEcwSbYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skk4FxMBL7K6mjGGRK3mPKnr5fyQpPI02go9DisCblMAgna2qWZIJz5SClZEQbgpQ0geclAiCSiBQR9PNr6cZNjQUOBWCrnJMJqQQjYma8RCiTQt5oK4jBcaCWHEnwkwXxIVHqEU7F8+u0+P9vDzXT9rrjx9ewMc3RI6QeDSWiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LQAjjNmU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+8B9oWG5aA/UpMew3fwZdGWUhdhBZioFCh2YAnwodYg=; b=LQAjjNmUZnlfa7OWFHiro2b9i/
	2gfE8nTHpdxz/gsiSPbKgi+C+FHYzWpDeSSHoZaZD1qAoT2FkkDdFwKflLNnhHb/zYls0IeVTB8u+
	Fc04WRyumWJ/SN2YSYqLClPHPu+QkVGKQOKyxD9vh2+QmqwYnTYKoF7NMmACP7R1kGHsAnMt1+bJj
	CLcS6P+oyn2xAfAXg5U1qfk05ma+PpNgPbTLf4cPDztxkR21jUyRFSyr5dMkQ4KVatyciNBvcqTXk
	A/9Kk1AxJbCSvDCo7v3t8YGNJfKYLhhRCwjB86PBdctDPWuphk01KUtMAAAdJ4yxYFfDBiaBq4vRO
	3CbU04Vg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyU9-00000006Ein-02Nc;
	Thu, 20 Nov 2025 06:49:41 +0000
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
Subject: [PATCH 04/16] btrfs: use vfs_utimes to update file timestamps
Date: Thu, 20 Nov 2025 07:47:25 +0100
Message-ID: <20251120064859.2911749-5-hch@lst.de>
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

Btrfs updates the device node timestamps for block device special files
when it stop using the device.

Commit 8f96a5bfa150 ("btrfs: update the bdev time directly when closing")
switch that update from the correct layering to directly call the
low-level helper on the bdev inode.  This is wrong and got fixed in
commit 54fde91f52f5 ("btrfs: update device path inode time instead of
bd_inode") by updating the file system inode instead of the bdev inode,
but this kept the incorrect bypassing of the VFS interfaces and file
system ->update_times method.  Fix this by using the propet vfs_utimes
interface.

Fixes: 8f96a5bfa150 ("btrfs: update the bdev time directly when closing")
Fixes: 54fde91f52f5 ("btrfs: update device path inode time instead of bd_inode")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/volumes.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2bec544d8ba3..259e8b0496df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2002,14 +2002,11 @@ static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 static void update_dev_time(const char *device_path)
 {
 	struct path path;
-	int ret;
 
-	ret = kern_path(device_path, LOOKUP_FOLLOW, &path);
-	if (ret)
-		return;
-
-	inode_update_time(d_inode(path.dentry), S_MTIME | S_CTIME | S_VERSION);
-	path_put(&path);
+	if (!kern_path(device_path, LOOKUP_FOLLOW, &path)) {
+		vfs_utimes(&path, NULL);
+		path_put(&path);
+	}
 }
 
 static int btrfs_rm_dev_item(struct btrfs_trans_handle *trans,
-- 
2.47.3


