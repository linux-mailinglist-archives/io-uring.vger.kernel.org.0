Return-Path: <io-uring+bounces-452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A9E838D7E
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 12:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 386C3285DA9
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 11:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F4D5D74F;
	Tue, 23 Jan 2024 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVoEOqhW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2155D73B
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 11:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706009620; cv=none; b=J5LniQVOaFBwON6hEkuH20/bLm/QpaLqiyXROdwT5UR4WSxjdbG3eD6Qw3ElLlGnwWIdkuZMJRP9Fq7XZbe7cbPQsgB7yVxRK+uiMVWl7WyFMBSuLovWzPLlsYTMGToqz23qzxzcCQLobk3exbVD5T/9FaHtYurZ/hdMkD19IiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706009620; c=relaxed/simple;
	bh=zOz4hLkdmkTYGfCt/cUwyAyL0WtERi/QQFzomtoUEos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HCaMt1cmpBS/ns2Y12Hzpf334r+ZttZxhBrGuZkpRc8ojRi/+Mlbcdy5alrOJDcEY1Xx8gxc8XuSjg6Kbna7tVejq9gjmvAEzX/cfjnbWNt5W3jAMVHtd5IaNRJYXmp2uQEme24/FsSn3r4QMtpgbJ2OChDlT4zlV4XUJwLLIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MVoEOqhW; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2cf161b5eadso3990791fa.2
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 03:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706009617; x=1706614417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+oyAFKxKxw/19olhMJD22JnaO3CvIZPuaFLwbGy625I=;
        b=MVoEOqhWsfV5ySwyWoCmAoln8N0aeKAP+MniuHudpJnwemI/iIlPMy3Y8ea7cCRHDC
         EHUbpLXxziGekezNOgCiDnW2bvAbzibBczjlD1GVeZUczL2/dgehWgJDARQWVl5KtTft
         VHlh3KlosEzdvj3yPrZ9zgebjWM32bGEXzQcMCCQdywunoenEP/SIYYiqwUju4n6bJWW
         OVSlxGwCu0OOUE/Bo7BvKi0Vk/3WwRrUJgd27Q+heliBt1rcAdXI2aCIV2tVfd9NJyMi
         Tg28Pg7H3YxV7+rsslgOtv9Lz1zBTz/Bqj6zCL3vxTD85XzEUZOgrLZiyUulL49yIZpk
         DoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706009617; x=1706614417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+oyAFKxKxw/19olhMJD22JnaO3CvIZPuaFLwbGy625I=;
        b=lfdrf7ke3PzV+PgIOQUL+PatEHNE8ug6GlUqSdQcyXr/UotezJCYquW7U3hwa6DOYy
         +oKOKpUkTcQ7gXWS8F246I9d+HbNJHWfEzhYhaTluUFqp9lFdUin0yaTUDUAcT0+savK
         nUFNIppzbRXzxRbWpiezX/f9bmBfhEdHaLrP8BTqKY23xNhr3LxOFa8svDlo5/G/GiEo
         e4zwLEieWq97Cci4EkS5qV0WKw+ygpQ4aWkGugxJGRnfZzCSGlZhjkhuhK+6dx4jFcnP
         nUhgXRN/Cx5wIbteg1C2ZJDuZpF+bpt0bc5lhaUybInq6Yv8iH8aKpJKRrWj0dvi/nHq
         HT9Q==
X-Gm-Message-State: AOJu0YyJ9WRnp7+fM4VdphxKM7SQDh157wnEkSvQF55Z1F8fLHKz6/H8
	LxwBkn6RMVUE7kOTFlX1OeEz5npUk9NdqhhV9YGjgwYPevxKNE0S
X-Google-Smtp-Source: AGHT+IGyKDGQ75vr+XFkBEzO7roQid37hunuiQbxDBksjFkEqWWQT505ZNbKAk6XS3o9FPZjU2yJvQ==
X-Received: by 2002:a2e:bc13:0:b0:2cc:5c19:d009 with SMTP id b19-20020a2ebc13000000b002cc5c19d009mr3525538ljf.45.1706009616655;
        Tue, 23 Jan 2024 03:33:36 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id x8-20020a5d4448000000b0033925e94c89sm9078884wrr.12.2024.01.23.03.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 03:33:36 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v2 1/2] Add __do_ftruncate that truncates a struct file*
Date: Tue, 23 Jan 2024 13:33:32 +0200
Message-Id: <20240123113333.79503-1-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_sys_ftruncate receives a file descriptor, fgets the struct file*, and
finally actually truncates the file.

__do_ftruncate allows for truncating a file without fgets.
---
 fs/open.c                | 52 ++++++++++++++++++++++++----------------
 include/linux/syscalls.h |  2 ++
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 02dc608d40d8..b32ac430666c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -154,47 +154,57 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
 }
 #endif
 
-long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+long __do_ftruncate(struct file *file, loff_t length, int small)
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
 	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
-		goto out_putf;
+	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
+		goto out;
 
 	error = -EINVAL;
 	/* Cannot ftruncate over 2^31 bytes without large file support */
 	if (small && length > MAX_NON_LFS)
-		goto out_putf;
+		goto out;
 
 	error = -EPERM;
 	/* Check IS_APPEND on real upper inode */
-	if (IS_APPEND(file_inode(f.file)))
-		goto out_putf;
+	if (IS_APPEND(file_inode(file)))
+		goto out;
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
+out:
+  return error;
+}
+
+long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+{
+	struct fd f;
+	int error;
+
+	error = -EINVAL;
+	if (length < 0)
+		goto out;
+	error = -EBADF;
+	f = fdget(fd);
+	if (!f.file)
+		goto out;
+
+	error = __do_ftruncate(f.file, length, small);
+
 	fdput(f);
 out:
 	return error;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fd9d12de7e92..e8c56986e751 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1229,6 +1229,8 @@ static inline long ksys_lchown(const char __user *filename, uid_t user,
 			     AT_SYMLINK_NOFOLLOW);
 }
 
+extern long __do_ftruncate(struct file *file, loff_t length, int small);
+
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
 static inline long ksys_ftruncate(unsigned int fd, loff_t length)
-- 
2.34.1


