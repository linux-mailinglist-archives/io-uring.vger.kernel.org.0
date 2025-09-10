Return-Path: <io-uring+bounces-9717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F692B523D4
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4918D7BD41F
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C15E2DF3D1;
	Wed, 10 Sep 2025 21:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEY0Al6D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB2525A350;
	Wed, 10 Sep 2025 21:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540847; cv=none; b=IyQfjZn3vh41eWplsqfagAwd8t8NCMplqj2UnLFBhXZZddiiR8McOPC0GfT5o+Ji8rNDTzZETfVG5HsDunaAxoQ+61DQ4yYW8dQMpFHRPkxT0KpPRr1nouWFhocOuekbQdJmGRugvtUVP7D0AZQwgE1lDjH8+ohikf/ZEnGX3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540847; c=relaxed/simple;
	bh=R54gedaNck54foIeW7ZD0WRjlBpF4O7iivHMEzfbkoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF5q4w6Sy/sqj46LRvvwzLvi4bGBh4OV7lXUMML8A5fwecof7dy+FSL2q7rgFHDwpmIxG9yQEbLZ0hg87POBpfto/HqkMiKAchYQXfPWWumVW2LhogkXl/9Ia6H4bIwZLMpk9k1MZsbBg2n8DQjEG2bwxi55Jt46rrqZBW/ZoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEY0Al6D; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-772488c78bcso70608b3a.1;
        Wed, 10 Sep 2025 14:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540845; x=1758145645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDsaa0EqzbQdhQHU9kvUw+G3sKFXEgoiyn1nQUSOwuw=;
        b=QEY0Al6DcXXWGA7/kJOccf8PeLAEhtEMQaqNggTVBk2dgNufIbAD1a5LNOLcntfR7U
         28n1oqc5FD0rf2ceMSUXLKuzg21XTr8sLIvnYdaaZvqukODWK1I7mKsthVul2y+VXauO
         JjDzwVm5SW/UMZ1srBs/zhJNoKz6giIVh1wCIrOfz7jjv3ohqndt6qJnIq8Q/l3hvPGS
         8F/bmra1Y8YvqXJwRuhUIIuyDLityO3QiZKiIAlW4svzHl2BWSlHd469iuIzxMlgTPxO
         6VwiKGBERi5C8F61PZ9jI5epTXNqt0ulqF8ldEkulZFeQMlyBGQEjuWXXU+LcEDVXi9g
         ik6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540845; x=1758145645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDsaa0EqzbQdhQHU9kvUw+G3sKFXEgoiyn1nQUSOwuw=;
        b=pFUw/PdVciekVt0rz0Jqkq4//Aa59Nzlts1EOwEuF8j3R3s1IOiJZFS3neOCsPPkHc
         6rFg/0S9HKtUtEwgg1HxD0A3pwFFeFxPaEoyMxQvCZPp3kQxgMYOOjU32oUPUy1T3DjK
         cDnIyZvVRBqjLqN0klnZOAleXaZKgqWdNC8uP+lIuHXKVaDqV7FxJieCmvO1f0mFWg5J
         Qx5td5vX1FDMFLYXwE+tx3qEdODvxKoh8blKtCtLlRPwPTv5+WQWQhCRk+nIS7/QdFBv
         YjBV3Cy2XGxsfW+c56cJwQ2Os5KXTCAETuVUuw28qOVXE3akIHqdLv+iDfp2tLiYxvVB
         MtaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxF/JqQxzFMkj7FJNxGqwQ8feZmzlRZHBxQunet4goO1ohY1ljpQYOyHZuqmxx6Sb5PpdbIaAHa+rIsIV4@vger.kernel.org, AJvYcCX3yKKwqkJZF/IxAlP93nBDF9mA5linlXmPbFsQcNgfzENbB+j1v8x/BajAaeLDs7mTbbvcjYpHrljG@vger.kernel.org
X-Gm-Message-State: AOJu0YwNQLcuHLM56Cg7QJB+fUZ4VXXOvsBEeriegGnix/tS6BGXxAMt
	AesxXHBQVFqnol58WIq7jHYFFYcar55MfivWS+NyIGFdizE8ShJfXP3K884AcF+B
X-Gm-Gg: ASbGncvuWasVmYeckhET5QbOnWwWiK25R1wbrHY4fWugr/eqY1Ik1POSso3fMJcmcMh
	9pKAC5I5ihBgG3nBrzqXWtjDuemJlCA92k3yXIqSEwjwDNsFiTYUeKrrEBdiyv5y1e1495qG9kQ
	W45Q8eV9rctJ8L6PMzbkKy1RxyxkvqfPfGtb4+dRUMdbFAZhrJhdu/gmxpwpZDpsGWNxwN4p8qI
	bv8qCOMiWoSQ61pXa97l7lxMVOBQQjFKtTgAVgT5V/7l9kXduZF4SB70kQPnM8p5rjAQJStpR1+
	TjsJYmr34z67Et3cjXX1nInqst/SgP//Pv0luQBckjl5evQsih6R1iKCDIcXq8oQdJFQgbStk1e
	U4tHewYpVvgqgM3WvckWp1MlJZz0iWRxXi4cn
X-Google-Smtp-Source: AGHT+IGu6Zo9zOvpeDPb25zm0RANih6jEITEBm3GGOuEM36ssAPrtqrPgeKHs7jj2H1QBDjNdyIRPw==
X-Received: by 2002:a05:6a00:3d11:b0:772:934:3e75 with SMTP id d2e1a72fcca58-7742dde2ccamr21376562b3a.11.1757540844614;
        Wed, 10 Sep 2025 14:47:24 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:47:24 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	chuck.lever@oracle.com,
	jlayton@kernel.org
Subject: [PATCH 06/10] exportfs: allow VFS flags in struct file_handle
Date: Wed, 10 Sep 2025 15:49:23 -0600
Message-ID: <20250910214927.480316-7-tahbertschinger@gmail.com>
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

The handle_type field of struct file_handle is already being used to
pass "user" flags to open_by_handle_at() in the upper 16 bits.

Bits 8..15 are still unused, as FS implementations are expected to only
set the lower 8 bits.

This change prepares the VFS to pass flags to FS implementations of
fh_to_{dentry,parent}() using the previously unused bits 8..15 of
handle_type.

The user is prevented from setting VFS flags in a file handle--such a
handle will be rejected by open_by_handle_at(2). Only the VFS can set
those flags before passing the handle to the FS.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/exportfs/expfs.c      |  2 +-
 fs/fhandle.c             |  2 +-
 include/linux/exportfs.h | 29 ++++++++++++++++++++++++++---
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index d3e55de4a2a2..949ce6ef6c4e 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -391,7 +391,7 @@ int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
 	else
 		type = nop->encode_fh(inode, fid->raw, max_len, parent);
 
-	if (type > 0 && FILEID_USER_FLAGS(type)) {
+	if (type > 0 && (type & ~FILEID_HANDLE_TYPE_MASK)) {
 		pr_warn_once("%s: unexpected fh type value 0x%x from fstype %s.\n",
 			     __func__, type, inode->i_sb->s_type->name);
 		return -EINVAL;
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 01fc209853d8..276c16454eb7 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -342,7 +342,7 @@ struct file_handle *get_user_handle(struct file_handle __user *ufh)
 	    (f_handle.handle_bytes == 0))
 		return ERR_PTR(-EINVAL);
 
-	if (f_handle.handle_type < 0 ||
+	if (f_handle.handle_type < 0 || FILEID_FS_FLAGS(f_handle.handle_type) ||
 	    FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER_FLAGS)
 		return ERR_PTR(-EINVAL);
 
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index cfb0dd1ea49c..30a9791d88e0 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -173,10 +173,33 @@ struct handle_to_path_ctx {
 #define EXPORT_FH_DIR_ONLY	0x4 /* Only decode file handle for a directory */
 
 /*
- * Filesystems use only lower 8 bits of file_handle type for fid_type.
- * name_to_handle_at() uses upper 16 bits of type as user flags to be
- * interpreted by open_by_handle_at().
+ * The 32 bits of the handle_type field of struct file_handle are used for a few
+ * different purposes:
+ *
+ *   Filesystems use only lower 8 bits of file_handle type for fid_type.
+ *
+ *   VFS uses bits 8..15 of the handle_type to pass flags to the FS
+ *   implementation of fh_to_{dentry,parent}().
+ *
+ *   name_to_handle_at() uses upper 16 bits of type as user flags to be
+ *   interpreted by open_by_handle_at().
+ *
+ *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *  |           user flags          |   VFS flags   |   fid_type    |
+ *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *  (MSB)                                                       (LSB)
+ *
+ * Filesystems are expected not to fill in any bits outside of fid_type in
+ * their encode_fh() implementation.
  */
+#define FILEID_HANDLE_TYPE_MASK	0xff
+#define FILEID_TYPE(type)	((type) & FILEID_HANDLE_TYPE_MASK)
+
+/* VFS flags: */
+#define FILEID_FS_FLAGS_MASK	0xff00
+#define FILEID_FS_FLAGS(flags)	((flags) & FILEID_FS_FLAGS_MASK)
+
+/* User flags: */
 #define FILEID_USER_FLAGS_MASK	0xffff0000
 #define FILEID_USER_FLAGS(type) ((type) & FILEID_USER_FLAGS_MASK)
 
-- 
2.51.0


