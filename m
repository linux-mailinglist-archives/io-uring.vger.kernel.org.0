Return-Path: <io-uring+bounces-450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4379E838D78
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 12:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49F44B22852
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 11:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3643B5D749;
	Tue, 23 Jan 2024 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLyVsOHd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ECC3D7B
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 11:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706009561; cv=none; b=jxFIaSHmCo9ggpqGvtMdBasI+lCO4P1CB94uFSe22+4mMx06OPRfNHRXLVjv89/ATNdkxi3FMUyCN5ZWvvTXKH3/a5VV8L9WwCbTe3FvclOiB6SQjOewcZ3yZFDlX/D26EjVW3hVL2ilwukqLdfkDmjX7WoSfayG8mU40Jh7yFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706009561; c=relaxed/simple;
	bh=zOz4hLkdmkTYGfCt/cUwyAyL0WtERi/QQFzomtoUEos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eUypJbrBPaylO/Y2J/d6bhcaIJGAhy3YUPPRYhCN0NbQPqJM8bVMD1Pyjdi8+8DuqnkC420KhS6oeiM8IIXu/mgK75TqBAIGcaS7wZSrUF2cac4MUnKjo6dYdrERJHbQ8U8vOsKZWDrtEsuUS76tgUAd08PH5ufJHLDLFngfJxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLyVsOHd; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-337d32cd9c1so3722255f8f.2
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 03:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706009557; x=1706614357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+oyAFKxKxw/19olhMJD22JnaO3CvIZPuaFLwbGy625I=;
        b=KLyVsOHdisDgnZi6ilypM9fcIPVrmDXLVHPkK0+TmJ7HPYFKDKK2PEeKsFdwIO0XuS
         0zjZjUGS03smhhiNDQCcSCNxeuSvtyU/0VsWc7R8zigZVBjLZvpv6STXAtEHZEHL2oWp
         uf84AgHxm6/QM6f4RDups1iEdxIoOZDhbIrPqP7RUyVteaWXA1v3z3A3HgaW32aFr+Q7
         QunIb6w3tWg6eBYO28WB6aOxEdvUSKo+Ti48zcrkNCZZdoSii5K+HyErxobtckZu7i6D
         ADYkVL9wgRlos9mbqTbvibS2KpwdJk+fbB0OeMf9nnEqM+e0qnWxLTPlfoeM9Q+Y2xuM
         DiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706009557; x=1706614357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+oyAFKxKxw/19olhMJD22JnaO3CvIZPuaFLwbGy625I=;
        b=T3z95Vlbr7yYVdVlhlxBwTTOWJEuJezvr9NLs9cyxZWqYp+ra2E3n1ogHaMNOGo1s0
         ZbolOxhtyzi0RmqgesMCz21Nh7nDh0xQAPgdmrTkoNm8zLSvaAktWvEe/yEI3KFZt/Y3
         SudEepzoQJSttvGV5W1eMRqHt/xSwT+gMYaUE1AOmqe+7rnuE1ouOX17ig1rNRKPDVxm
         03ga6fnfjJJ+s3COegeq+9BfJiTnWIbSPy9bSV9yz8V326yhsgTo8WUh+AtX2vPgwDe1
         MLXsFRfi9wgZxxtEaKxGDOHJ9PISzsu0Yv4STAiE/16BnPoMDgfUQplGTyTWy5Ry0s0L
         aDag==
X-Gm-Message-State: AOJu0YwJkl0Vw0VNu2Jo0X64jVyVDTBpJDgprAJkq7P7IdigUEry3hri
	s48rbb35iAnidyTaGXU2zFDyCMAmCXDX/qrctTxQ7rnKtsUIbyBJ
X-Google-Smtp-Source: AGHT+IHBunwj7oPaXETEoDQH5etgZqyWZzuv4fMd825pWbVQkQmvkP+jrnjPoi0Q8Zdy/7VpWr+LyQ==
X-Received: by 2002:a5d:540a:0:b0:337:2b67:25 with SMTP id g10-20020a5d540a000000b003372b670025mr2897712wrv.114.1706009557364;
        Tue, 23 Jan 2024 03:32:37 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id q7-20020adffec7000000b0033926505eafsm8998771wrs.32.2024.01.23.03.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 03:32:37 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v2 1/2] Add __do_ftruncate that truncates a struct file*
Date: Tue, 23 Jan 2024 13:32:23 +0200
Message-Id: <20240123113224.79315-1-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123112358.78030-1-tony.solomonik@gmail.com>
References: <20240123112358.78030-1-tony.solomonik@gmail.com>
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


