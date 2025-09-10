Return-Path: <io-uring+bounces-9721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A034DB523D8
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3FB17BDD8F
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967C42DFF13;
	Wed, 10 Sep 2025 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLxZmxBw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063ED2DF3D1;
	Wed, 10 Sep 2025 21:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540879; cv=none; b=n7tQn9g7vsmEaJUWoRPHz0sliMFF4tUgPDRAKcAIM8ALTObnck9IAzh6dzuXdl1rZnVflkfgawOWwkJ0awlEJOLtwZW9+cPm0cdBnQya8Lu/BpVk5KO2qewgzkI8jfb9mWDTYHHAlg6sq7cC0RTLdUx3Ez2hKWd5F06LxpJLCxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540879; c=relaxed/simple;
	bh=HM0ofVrxSHq1Bz92Sj1jWe36kTRP0dpeO4I7Bv4bg30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRP8yGscJfQ1/XGI1y+XdXg2JHornWNSM3YXecJbv206eJkoruVNCBxFc1qe5CW7EiV4sjeaRl1NcuOBGzzzRTYGG5ZDs3QyG1dOhu5sZ0NGbKVEa0Ik4I4ovf2MB+ilQqZOHEbC4uaJfnY/bSKZG8xOjkSFel3V5NKzN6lEgCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLxZmxBw; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7725147ec88so72823b3a.0;
        Wed, 10 Sep 2025 14:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540877; x=1758145677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06oifnEAGFR4Ltgc4TOaz5pGi14RXdWh8ksBdzGLZrI=;
        b=FLxZmxBwhJy6dITtG68tu089kywD9OZgH3JfB0V7ZWncEcT1NugnepueEfXxWzs3vZ
         0uFmB4Ye/ZjugQF1q89425wOohnl6tPafTD/5izrsbIvvhglw5b7sAID7QjxuN9ZU3Jr
         JJNxOdDtBAbyBlSWpngf8qx3VrWvf8597ZsdDFfEiXwmtjbzN4h2aLwkThZJoSdPZn+j
         cH86qooR75UU00HscOYKD6SNaPfj9BffrJVtW1vr9qDG7dJ2G8hELHTSeEDD8uuwwnsY
         zSMo3AQnxyVnm8O2jNCss2fY7NGJ3f0dC2wvgn5k3QCp18psBPnON3h8qeVqdZR6KLVg
         Ey4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540877; x=1758145677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06oifnEAGFR4Ltgc4TOaz5pGi14RXdWh8ksBdzGLZrI=;
        b=Qpl9nTBczse0GwLYKVtL9Qt34xbcQpH1s9F4ug1YNPeldr6OfVIl0XmYx8Yd9L50Gl
         YlM5sTketSCOSY6ajQY3aC41GRtPGFsLLYGWoA1DGaOXBdFZdWSCNkpIEh7lf9Ad3CuF
         UnYsWESFr30MNNe6wvwPkpfg1TtGyGMrOr0MzJ/zBdPOcFpb8D+IiCw9vQjS4CgqvOj8
         HJ7BcFWXHiLHPDDO4x0LFusFnYS4kMcMRqWFUhNqyrn2mDmnrhfqp2QdUS6NxQG/3cfk
         5iWXquhaDUBi/ThtpK+W2p04Dkhn9N3rgCSz05N60Mk3O/v8TJoRjQuMY7Pr7K2RtRp7
         e5fw==
X-Forwarded-Encrypted: i=1; AJvYcCUpTSE89FsEfLoW3L0e8P0hOX8hObZqf0tuEULmf3td2jPuV2VVa74JBgFYzlF0cyTsGjZ3k1rzUpRe@vger.kernel.org, AJvYcCVJUA6bK6alRChfyQcUtq1nGc7wRgtRoH8c69B5EtLT3T6eQ8g4DpdKVerprbkdno3a0p+WU/5UFhVe@vger.kernel.org, AJvYcCWP8hlxeDwYf35+f55ZRFGdRBPHIBkxQY0wMZUC9iNCQxfi8C54mavXAVVaUbdYjUciFYU04TWBbds6q009@vger.kernel.org
X-Gm-Message-State: AOJu0YzpiuGwJkLSMMmhgNGNfxf9kVDBYKwM57fBXGBmglLPkGVB+bqX
	hpujIqVkfB7MlDE9Osx507MAnKWX7WWLtii5XEdbSfK1mqYr9T5cIFwn//EdGYM8
X-Gm-Gg: ASbGncuLlGVE5DZNQ2rA7QSZ2LG58gdxx+x8om3cY5+eKjsxHNCooGVEAgkBgJdkx7u
	Hpvt05GufLr/W+NMIJ+FngXi2IfO0fA6AiO4mfXYCZ8gZ83SaaXNl8K2ETujAqINJ4Z7aELVPz8
	7IQqESQ5Syyz+rTEUP4vVngVoEpdRCMlMlNAM4CaXnt9mnBntNwJUycSQcrWwbHTkl+Q4wydLVM
	wmpgk26fe2bUba1YHeAh06eKALb8pJaqRKllw37CyeDroUyoGFzwhpzNdRjr9rN6Jjmyt0+TKXx
	LtKtkFjrq8qvl8upZRWiKYdbVxj/T5Ovo0muk8WVewUvgz7sbs+Zu7fRpaHSU3ubcp505TQ5pns
	4B18Ldi98t23f6h+ZlYa1eHLj/Zypg7nvL3sH
X-Google-Smtp-Source: AGHT+IGinHS6aq16w9b7HGbBpLflNnAoUm+yBwVktzHXKIvCYcxOtzobQyggEUkzUVtXz8kKC87MiQ==
X-Received: by 2002:a05:6a00:3e0e:b0:772:7b9b:b1b6 with SMTP id d2e1a72fcca58-77603240aa0mr1106988b3a.9.1757540877117;
        Wed, 10 Sep 2025 14:47:57 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:47:56 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>,
	linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: [PATCH 10/10] xfs: add support for non-blocking fh_to_dentry()
Date: Wed, 10 Sep 2025 15:49:27 -0600
Message-ID: <20250910214927.480316-11-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910214927.480316-1-tahbertschinger@gmail.com>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is to support using open_by_handle_at(2) via io_uring. It is useful
for io_uring to request that opening a file via handle be completed
using only cached data, or fail with -EAGAIN if that is not possible.

The signature of xfs_nfs_get_inode() is extended with a new flags
argument that allows callers to specify XFS_IGET_INCORE.

That flag is set when the VFS passes the FILEID_CACHED flag via the
fileid_type argument.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/xfs/xfs_export.c | 32 ++++++++++++++++++++++++++------
 fs/xfs/xfs_export.h |  3 ++-
 fs/xfs/xfs_handle.c |  2 +-
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 201489d3de08..ca2a9ed0eb16 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -106,7 +106,8 @@ struct inode *
 xfs_nfs_get_inode(
 	struct super_block	*sb,
 	u64			ino,
-	u32			generation)
+	u32			generation,
+	uint			flags)
 {
  	xfs_mount_t		*mp = XFS_M(sb);
 	xfs_inode_t		*ip;
@@ -123,7 +124,9 @@ xfs_nfs_get_inode(
 	 * fine and not an indication of a corrupted filesystem as clients can
 	 * send invalid file handles and we have to handle it gracefully..
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	flags |= XFS_IGET_UNTRUSTED;
+
+	error = xfs_iget(mp, NULL, ino, flags, 0, &ip);
 	if (error) {
 
 		/*
@@ -140,6 +143,10 @@ xfs_nfs_get_inode(
 		case -EFSCORRUPTED:
 			error = -ESTALE;
 			break;
+		case -ENODATA:
+			if (flags & XFS_IGET_INCORE)
+				error = -EAGAIN;
+			break;
 		default:
 			break;
 		}
@@ -174,6 +181,12 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 {
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
 	struct inode		*inode = NULL;
+	uint			flags = 0;
+
+	if (fileid_type & FILEID_CACHED)
+		flags = XFS_IGET_INCORE;
+
+	fileid_type = FILEID_TYPE(fileid_type);
 
 	if (fh_len < xfs_fileid_length(fileid_type))
 		return NULL;
@@ -181,11 +194,11 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 	case FILEID_INO32_GEN:
-		inode = xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen);
+		inode = xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen, flags);
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		inode = xfs_nfs_get_inode(sb, fid64->ino, fid64->gen);
+		inode = xfs_nfs_get_inode(sb, fid64->ino, fid64->gen, flags);
 		break;
 	}
 
@@ -198,6 +211,12 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
 {
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
 	struct inode		*inode = NULL;
+	uint			flags = 0;
+
+	if (fileid_type & FILEID_CACHED)
+		flags = XFS_IGET_INCORE;
+
+	fileid_type = FILEID_TYPE(fileid_type);
 
 	if (fh_len < xfs_fileid_length(fileid_type))
 		return NULL;
@@ -205,11 +224,11 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		inode = xfs_nfs_get_inode(sb, fid->i32.parent_ino,
-					      fid->i32.parent_gen);
+					      fid->i32.parent_gen, flags);
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		inode = xfs_nfs_get_inode(sb, fid64->parent_ino,
-					      fid64->parent_gen);
+					      fid64->parent_gen, flags);
 		break;
 	}
 
@@ -248,4 +267,5 @@ const struct export_operations xfs_export_operations = {
 	.map_blocks		= xfs_fs_map_blocks,
 	.commit_blocks		= xfs_fs_commit_blocks,
 #endif
+	.flags			= EXPORT_OP_NONBLOCK,
 };
diff --git a/fs/xfs/xfs_export.h b/fs/xfs/xfs_export.h
index 3cd85e8901a5..9addfcd5b1e1 100644
--- a/fs/xfs/xfs_export.h
+++ b/fs/xfs/xfs_export.h
@@ -57,6 +57,7 @@ struct xfs_fid64 {
 /* This flag goes on the wire.  Don't play with it. */
 #define XFS_FILEID_TYPE_64FLAG	0x80	/* NFS fileid has 64bit inodes */
 
-struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen);
+struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen,
+				uint flags);
 
 #endif	/* __XFS_EXPORT_H__ */
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index f19fce557354..7d877ff504d6 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -193,7 +193,7 @@ xfs_khandle_to_inode(
 		return ERR_PTR(-EINVAL);
 
 	inode = xfs_nfs_get_inode(mp->m_super, handle->ha_fid.fid_ino,
-			handle->ha_fid.fid_gen);
+			handle->ha_fid.fid_gen, 0);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-- 
2.51.0


