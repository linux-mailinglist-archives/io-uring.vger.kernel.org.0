Return-Path: <io-uring+bounces-10619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF28C5B891
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 508B835851A
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA7C2F1FD5;
	Fri, 14 Nov 2025 06:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZSLVu4JA"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF7B2EBB84;
	Fri, 14 Nov 2025 06:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101640; cv=none; b=bNVtQwZGylK5Zl4pPW+JL/s2MAc1rc9Ipq5xVQqVWIeduGPdJeNUynYdbXjTMRmrnPs+9xoD9hfokB7WvSY9R0i1n6XggcvOXXhrgb+W6vLVEuJhtJ/Rtg8I8mWIctT+8TwnTGTF9o3ItDnxCnrmw0c8l8+dijrijHFn7Phy8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101640; c=relaxed/simple;
	bh=zSw4I99cyk/FTg1qtBdMutKYkhlmlCIS3jIzqgcnZwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKi6GbkJlhKPoa9mldGvw434ahLuqoue9czfqyOMKwAxa0fRIdiqxIQES1nbGN7t35FT5OUhRgF+uaIqniTcJhwICHSv4sSsRpAuO9+j2Y1ILk0Nef4KgAIvKG8dCbjWbs+EETrr4nXCNUL2TCFrnVavY6eDLFiqFLOMG6jyVok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZSLVu4JA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F4A5b1wWmxAG2fOHUBHnCN5dWIgfEeK+ZFvC9JUjlts=; b=ZSLVu4JAikh5153XIjVH1ytuFP
	mZo1YOp+yKq4ZWFbtch39uNHmN36RCkqf00LAoupA2ns+JM2mZp26Fm8wMUXx9txZ7xubR9Wmc6ul
	aR9gS1xrBO/Xr9RDSZymQ+V893S8uxkdaoJmJ2HJ3bIEUijTEohuSBnCEDCQYYAoa6ZDXHvsBwrQX
	wP7C1e3tfmi7shGhGpManWGHsluMdmGL8SS+B+3LdJzdayf6QysqdcjqmI0RJOPduvHZrAgXhW58c
	z6wituelMjAdqGt5dTJdGowwDUFT1V+OUOJzMLnjqBbS350Ym1z9n7fBV25b2/yWEYz3g3/6opYMc
	04zMY8+Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHA-0000000BeWc-04Zk;
	Fri, 14 Nov 2025 06:27:16 +0000
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
Subject: [PATCH 04/14] btrfs: use vfs_utimes to update file timestamps
Date: Fri, 14 Nov 2025 07:26:07 +0100
Message-ID: <20251114062642.1524837-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114062642.1524837-1-hch@lst.de>
References: <20251114062642.1524837-1-hch@lst.de>
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


