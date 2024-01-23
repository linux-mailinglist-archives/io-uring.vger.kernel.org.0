Return-Path: <io-uring+bounces-470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 46952839C4B
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A32B9B26287
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95D351024;
	Tue, 23 Jan 2024 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuRiTQzk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1E350245
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706049234; cv=none; b=UO79bVpwLhS+F1lGGmJQtLleVgYeCxLANOvr1JJaT3srwgcY1UlMRPT7omZBQcQM/76JYasFVXL5SKmR9k7x94QOBKoVsCC9iVVwlcOXS+4uLU4KCstvrYCsS8iIRQbu2s2JmEkJHmLxFRdd+Kiqds4itD1FIH+99kr4o51Ozvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706049234; c=relaxed/simple;
	bh=ufx37yWDc607w5zJuEiXrTZsvL1QTPVQvIrC9K5vtv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rW2dgGtmlftzDKVsav4fYssrYL2dhgGyX/GX5grXX+K7ZhVFsAUTatjoUMM+5rw3+nnp/6ZnbxsPgC0ZPtncJs8w6NOccxPepOtNKD8WXmG7LLOEG7rwdAJMgtaCBpPe04MvIW/vf0jchsgXl+e95aJDZWj9HC0ana83ymmhSuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VuRiTQzk; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-339208f5105so4161541f8f.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706049231; x=1706654031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuUx9kNqNqCLHIn9WIMcvochR91I2HEz6Us7mVIXsXY=;
        b=VuRiTQzk5W5/Pf7PnaY5RqNYWvcWfPvl2BH9d8YNgxgdmRv3jz3WDgFky5VJ271eQ4
         isIcjkJpebOfkJKJ6QxFHRsltAo3yUW/XichRbl5MIUAtlCbouPj1jQRV7v/e1cvRcCO
         /GWNd/PK422bygcKF9o3kWXxxZrcl8yGAxuhum9igfkxsFNbPebD3Zk3fg8mWlKxXAgT
         XzpB8X/DbLA1KFlLkkH8atAR9B3zBBdsXLWgXbZouTfkXxJ2ZQR2yauNgXy4NEiKuKSf
         CbqE/Hsdmgl6VuQmONM+ieFcB4RuQsJnLmJFzUbX3rwVSQ/kCgDiXuYWDuGOq6cEonK4
         G7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706049231; x=1706654031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuUx9kNqNqCLHIn9WIMcvochR91I2HEz6Us7mVIXsXY=;
        b=AOI6Ks6XgBu0vudIqT15CK3CGXNCzamfbXoruODUzP0O/zhkiAdQye6NHJyGAKpa9a
         nb8EIUcwaJmHAB1wnVg7GXeoivsXBy5uja2QJx9TmQsvh0xnF6ff+kXS+0RD9BvRYvbx
         OZ4TQnjjzMOAhghQXPkN6RA9K3tXWDkHl4ZlQkF0nnnLJTmFMuMDNMGnQGxCmrNT8HyU
         KDKhJuP/SE0KuknfzgRZDMc62EG/p1W2HgxTwBkACzUsUCoKKq8q895tCEcWgpzY6pJu
         +j9ehdRgv0nL1t/+EOxR9sRdoWveRBfv/8yjVByuU8WAO17CC/ZH//seJ6QGwph/ia5g
         0gVQ==
X-Gm-Message-State: AOJu0Yy16nxTE7/DfO+68riI9P4HMckGHTWnjABny8a2kI+fidhvrCgf
	SqsYJIaana0NU83N+wCd/XCTrB3hzSgRNZvt3swhFI2S/OBi4x0a
X-Google-Smtp-Source: AGHT+IHLZ8NbKjH6sdPA7wT1ODbtlkB0JtAYD1c1D83TW7UKW9SzPT/NOnP9YJ4BnBQaWACbwdyhsg==
X-Received: by 2002:a5d:5392:0:b0:339:219a:4619 with SMTP id d18-20020a5d5392000000b00339219a4619mr2337923wrv.192.1706049231059;
        Tue, 23 Jan 2024 14:33:51 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id p12-20020adfce0c000000b0033865f08f2asm12436514wrn.34.2024.01.23.14.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 14:33:50 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v4 1/2] Add ftruncate_file that truncates a struct file
Date: Wed, 24 Jan 2024 00:33:40 +0200
Message-Id: <20240123223341.14568-2-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123223341.14568-1-tony.solomonik@gmail.com>
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123223341.14568-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_sys_ftruncate receives a file descriptor, fgets the struct file, and
finally actually truncates the file.

ftruncate_file allows for passing in a file directly, with the caller
already holding a reference to it.

Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
---
 fs/internal.h |  1 +
 fs/open.c     | 53 +++++++++++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 58e43341aebf..78a641ebd16e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -182,6 +182,7 @@ extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 extern struct file *__close_fd_get_file(unsigned int fd);
 
+long ftruncate_file(struct file *file, loff_t length, int small);
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);
 int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
diff --git a/fs/open.c b/fs/open.c
index 02dc608d40d8..649d38eecfe4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -154,49 +154,52 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
 }
 #endif
 
-long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+long ftruncate_file(struct file *file, loff_t length, int small)
 {
 	struct inode *inode;
 	struct dentry *dentry;
-	struct fd f;
 	int error;
 
-	error = -EINVAL;
-	if (length < 0)
-		goto out;
-	error = -EBADF;
-	f = fdget(fd);
-	if (!f.file)
-		goto out;
-
 	/* explicitly opened as large or we are on 64-bit box */
-	if (f.file->f_flags & O_LARGEFILE)
+	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = f.file->f_path.dentry;
+	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
-	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
-		goto out_putf;
+	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
+		return -EINVAL;
 
-	error = -EINVAL;
 	/* Cannot ftruncate over 2^31 bytes without large file support */
 	if (small && length > MAX_NON_LFS)
-		goto out_putf;
+		return -EINVAL;
 
-	error = -EPERM;
 	/* Check IS_APPEND on real upper inode */
-	if (IS_APPEND(file_inode(f.file)))
-		goto out_putf;
+	if (IS_APPEND(file_inode(file)))
+		return -EPERM;
 	sb_start_write(inode->i_sb);
-	error = security_file_truncate(f.file);
+	error = security_file_truncate(file);
 	if (!error)
-		error = do_truncate(file_mnt_idmap(f.file), dentry, length,
-				    ATTR_MTIME | ATTR_CTIME, f.file);
+		error = do_truncate(file_mnt_idmap(file), dentry, length,
+				    ATTR_MTIME | ATTR_CTIME, file);
 	sb_end_write(inode->i_sb);
-out_putf:
+
+  return error;
+}
+
+long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+{
+	struct fd f;
+	int error;
+
+	if (length < 0)
+		return -EINVAL;
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = ftruncate_file(f.file, length, small);
+
 	fdput(f);
-out:
 	return error;
 }
 
-- 
2.34.1


