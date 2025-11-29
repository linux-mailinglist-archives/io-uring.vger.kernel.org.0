Return-Path: <io-uring+bounces-10849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85316C94555
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85FD93AA362
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F61310763;
	Sat, 29 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="h6uuA4b9"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B33C30F944;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435702; cv=none; b=rXxzwFBKMJtxEPWrW19m/IDwykntoMH86zFvBODs2fjEXKy+D+hCZu/KU0mVnn521eeiO3ie18GvKzYCl9lI067+6WJSTC4Mya3v21yY/GFtd6/O3Tq27yQvWgQtdMKarBJkGizndsNRBnC4tbSoBaivxhkH5TNCB9vvnWGGbCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435702; c=relaxed/simple;
	bh=ctw5JGChyyg5KmFk71wRpU0DsgF0Dzi02aIeIk40ixk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBRcY9ppEkQ3OcUIa08MlnCMUqdr2n19uqafoQysjApDz+idulV85w0OFviMT1K6sHOL6UuI6HPbm1xg6b2ZzB5lY2yjhzklE3Y0kAmdZ1EjecbP0qmzQA+BJUnHWbaDjS+XXDEBg3vCj+EU0kEXBsCaJ/MC6MCqJJ5fyE4tVuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=h6uuA4b9; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cjZ+T+w+ICLfQxhVKuOuUsp4YRPjjwRhob+updYTJ6E=; b=h6uuA4b9qFb0eam6fJSWLcMUAD
	Xr8DuD5mCpI/YlgG6iQ4bMlJf0tXEzA7k7R9mNzjgr46q4/ZbA9pHCQQGe3f+gPedyuLfRU9oc0Il
	ffmQo045Dv/CEDtnBB7HiNOTu5rUmlRxlS96j9wU6MOzGoDPSjD9yV3lh3SPPMFqTETuQ8v4rjlF3
	3Q8+4tihyDebj49JSq0wEtUkGoQWiz4R+S9YPNnpxmp/n6BOwsxVSUlYRBMPIut/rb6WxVnpVq+V1
	IGf8REaYla7iC1/4x8DGEHZUx7FMnRCYXKrXMXdokwHg+i0PFOAAeJRiZ8klc0LAuQPPBdIJzhaPX
	8UCmfLDA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dD3-2M6v;
	Sat, 29 Nov 2025 17:01:43 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH v2 11/18] ntfs: ->d_compare() must not block
Date: Sat, 29 Nov 2025 17:01:35 +0000
Message-ID: <20251129170142.150639-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

... so don't use __getname() there.  Switch it (and ntfs_d_hash(), while
we are at it) to kmalloc(PATH_MAX, GFP_NOWAIT).  Yes, ntfs_d_hash()
almost certainly can do with smaller allocations, but let ntfs folks
deal with that - keep the allocation size as-is for now.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ntfs3/namei.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 82c8ae56beee..ab96290ee6d9 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -407,7 +407,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
+	uni = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -429,7 +429,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	kmem_cache_free(names_cachep, uni);
+	kfree(uni);
 	return err;
 }
 
@@ -468,7 +468,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	 * Try slow way with current upcase table
 	 */
 	sbi = dentry->d_sb->s_fs_info;
-	uni1 = __getname();
+	uni1 = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni1)
 		return -ENOMEM;
 
@@ -498,7 +498,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	ret = !ntfs_cmp_names_cpu(uni1, uni2, sbi->upcase, false) ? 0 : 1;
 
 out:
-	__putname(uni1);
+	kfree(uni1);
 	return ret;
 }
 
-- 
2.47.3


