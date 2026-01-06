Return-Path: <io-uring+bounces-11385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD20CF7250
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 08:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 38D9C30B9B83
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 07:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB5F30ACF0;
	Tue,  6 Jan 2026 07:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3gWa3pSM"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4F830B510;
	Tue,  6 Jan 2026 07:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767685621; cv=none; b=iOBHeyfn1/LtVFWY2vNUWgbkC7qWYS8VcSuXA8ImY71Ge1wH9TLZVqvYKDDmIk52FSluKAsRu0ZC3WXrEbzkqihzJidtY0gqW2PNuQhVouFwi6KKFAZy/4Xa0Gh+KhXTsTaNjyLvZnmf/VGOnx84DawTX0OJphojP8bqk3q8kGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767685621; c=relaxed/simple;
	bh=84zYz9NXyWkjni5oZak3iqje9K95go1Ph9X/wY7PUnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnHKy1cCAdVoqaNrNgck7TV1WpkKBMPEU74Gu2TqEstgNErw2pqNUErP+733Jbe6C8+Aj8krbZ27xu/ImydWMfemimIbO6hps72rkHMQK33ky4az+9lyPkxiukO3HHaejpDgJPJZrIrhNUSLYA//N45REw+NRcjKEr33MCTTTqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3gWa3pSM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aE+vP16o5dB87FoEUPg+4L7DgFf8Jfcm+kOMl1b7qy4=; b=3gWa3pSM/CKBF44EtppiiCuC9c
	pOC8BRyQMGyfTfYqgFFjfschhOIh1FdRIhMIcaLH1c3ipsjKrV2CSqMQs+dvWkeenYdg9mJaIbq+8
	JrKmFwwSUByXKIGXpkXCUf0f7Ijlfnr8l+7yhUWUbjgLfGIk3Y0XpNvLkH6vVHUFCNkDLSqkRkRqi
	F4bnGv5qTKU0vddwwWNCBR0MDPr4hT3AGj16/24aUMFO+nCQljnujYRMf0pkGQU7btpiQzVF7uot1
	zssbDBHlNp/h39fFQuxnlDhEIbHX8OuruJhHIk1OrqWVAj/EU1aF2UTcvN5V9k9Qf9LzQUtIk/nF1
	m0ZzJOWw==;
Received: from [213.208.157.59] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1mL-0000000CXsy-0N8I;
	Tue, 06 Jan 2026 07:46:57 +0000
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
Subject: [PATCH 03/11] nfs: split nfs_update_timestamps
Date: Tue,  6 Jan 2026 08:44:57 +0100
Message-ID: <20260106074628.1609575-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106074628.1609575-1-hch@lst.de>
References: <20260106074628.1609575-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The VFS paths update either the atime or ctime and mtime but never mix
between atime and the others.  Split nfs_update_timestamps to match this
to prepare for cleaning up the VFS interfaces.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/inode.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 84049f3cd340..3be8ba7b98c5 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -669,35 +669,31 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 	NFS_I(inode)->cache_validity &= ~cache_flags;
 }
 
-static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
+static void nfs_update_atime(struct inode *inode)
 {
-	enum file_time_flags time_flags = 0;
-	unsigned int cache_flags = 0;
+	inode_update_timestamps(inode, S_ATIME);
+	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_ATIME;
+}
 
-	if (ia_valid & ATTR_MTIME) {
-		time_flags |= S_MTIME | S_CTIME;
-		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
-	}
-	if (ia_valid & ATTR_ATIME) {
-		time_flags |= S_ATIME;
-		cache_flags |= NFS_INO_INVALID_ATIME;
-	}
-	inode_update_timestamps(inode, time_flags);
-	NFS_I(inode)->cache_validity &= ~cache_flags;
+static void nfs_update_mtime(struct inode *inode)
+{
+	inode_update_timestamps(inode, S_MTIME | S_CTIME);
+	NFS_I(inode)->cache_validity &=
+		~(NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME);
 }
 
 void nfs_update_delegated_atime(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
 	if (nfs_have_delegated_atime(inode))
-		nfs_update_timestamps(inode, ATTR_ATIME);
+		nfs_update_atime(inode);
 	spin_unlock(&inode->i_lock);
 }
 
 void nfs_update_delegated_mtime_locked(struct inode *inode)
 {
 	if (nfs_have_delegated_mtime(inode))
-		nfs_update_timestamps(inode, ATTR_MTIME);
+		nfs_update_mtime(inode);
 }
 
 void nfs_update_delegated_mtime(struct inode *inode)
@@ -747,7 +743,10 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 						ATTR_ATIME|ATTR_ATIME_SET);
 			}
 		} else {
-			nfs_update_timestamps(inode, attr->ia_valid);
+			if (attr->ia_valid & ATTR_MTIME)
+				nfs_update_mtime(inode);
+			if (attr->ia_valid & ATTR_ATIME)
+				nfs_update_atime(inode);
 			attr->ia_valid &= ~(ATTR_MTIME|ATTR_ATIME);
 		}
 		spin_unlock(&inode->i_lock);
-- 
2.47.3


