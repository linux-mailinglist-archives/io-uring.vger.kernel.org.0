Return-Path: <io-uring+bounces-462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74495839AF3
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 246CA28BEFD
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 21:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E5436B04;
	Tue, 23 Jan 2024 21:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jKPU7zEk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34F633CED
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 21:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706044800; cv=none; b=kxizMEZCZPJ411G09Pq5FTNlCFbIfexT9duR3rt2tifBFgdgsnS5EtW5LIn99N7DzuMtxfkXLaUIfiia7TAssg+1tUmIZ1xxqEEO9DALFBFNgWAiNmr1m2undZSFjZSnu5YNk2eBQcq3S+AV2pJGEOxluS97hMk3eQsspbu+2bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706044800; c=relaxed/simple;
	bh=2ob7RRiN2m0a3WxJGXImQCKHMloXhHNJRI1wow+XJr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bpYXX3Txu76DMJrRVpTufRvuH693rPER+/Feu6qYN8XlF6ubzo+Qzr5CkCl1JAhzviPxhUBkVLJqalWgmCdHoaMBI6KG45r6n48c29vwTnF5H+dSZ2bLbAqz+cKiTj1HwnyTHH5DnxZJ9XRrEOddU6MkiGsr2p13wYjBZH43HM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jKPU7zEk; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40ec2594544so7575705e9.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 13:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706044797; x=1706649597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3LTupyv7arTaquI/M0x46Iv/MjBX6OnNdvLSWUrOVM=;
        b=jKPU7zEkCqchd7TRW4DXKyGkWuZqtFxkzVCST+DlnC44yJTHVwDzq7N2dT+6k0pzHr
         VaRrTTM4AgobxQoY/P5mysetCVx57IBa5f3YrSLZTeupPvw9bYVLA9MJzwga1qEa6wpj
         6f28wlJ0iFKms9dSiDOF9+rXaDY+Ma5tcshaDnJ8zZUIr2+SXEEDNhDl6RjyLD+Pq8ub
         QUyqY9CNYmeXbAraTcWpdf3n0fuuu+SX8NHF1jL9zo+1SQLhHjxUbOE5GDCE6SA/ldnz
         MK621eKRlT0jCa+MeUP5SQmbDFxzlhEpasz8gwQlQ59U7k3iwrxVxzl0bXT071887dPe
         zesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706044797; x=1706649597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v3LTupyv7arTaquI/M0x46Iv/MjBX6OnNdvLSWUrOVM=;
        b=EXMkYBK3CHsWzvhtMTCS4Gay7pbi0UA/K/RFZr04iMWTJt12uK+x8nqmzH2VjZZsvb
         6wv0XIu9uB24Mmp6h35vPbmdQubEWYOc8HiDqX8wAoHt3iHHIwa0BR90nWWCHwsr7d6l
         Jq1QdpUF71vDt1Cbz3IK/6kTxqnlwxQe5pTCIDwMhvzeGiiyaHJPBEKti5xOB2lcqb1X
         Ezhq3CjFjmrQHczpQIf1egd1Om2g86y++XFaH2itGFLMZJk01iiSNjP9U4gMoeJPuPDb
         dhzTCEn/0LJ+YH+387fQeadRbtQuVQbOc7Qfaglz1sxfmszbARzAJO8wfhqzI83gHfr6
         dTlQ==
X-Gm-Message-State: AOJu0YzeiocD/f+jY973ytJV4TQpK1K42C+MQKmgiUaUGuQkYSklaYdk
	zyKhz386QNGr55SM1Qnw+xuZkokO8YwtI0jiuNJL/dahyVZYz9Z/
X-Google-Smtp-Source: AGHT+IHjZVqZ4S04qsLZsudAigvLlLeRtLda5cYec7kfzYiDEt1PVu6QlY19YNUKHKtyXPs7j4yKPg==
X-Received: by 2002:a05:600c:46c4:b0:40e:a456:3570 with SMTP id q4-20020a05600c46c400b0040ea4563570mr519237wmo.15.1706044796999;
        Tue, 23 Jan 2024 13:19:56 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c19d100b0040e47dc2e8fsm43512169wmq.6.2024.01.23.13.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 13:19:56 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v3 1/2] Add ftruncate_file that truncates a struct file*
Date: Tue, 23 Jan 2024 23:19:51 +0200
Message-Id: <20240123211952.32342-2-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123211952.32342-1-tony.solomonik@gmail.com>
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123211952.32342-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_sys_ftruncate receives a file descriptor, fgets the struct file*, and
finally actually truncates the file.

ftruncate_file allows for truncating a file without fgets.

Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
---
 fs/internal.h |  1 +
 fs/open.c     | 51 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 21 deletions(-)

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
index 02dc608d40d8..0c505402e93d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -154,47 +154,56 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
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
 	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
-		goto out_putf;
+	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
+		return error;
 
 	error = -EINVAL;
 	/* Cannot ftruncate over 2^31 bytes without large file support */
 	if (small && length > MAX_NON_LFS)
-		goto out_putf;
+		return error;
 
 	error = -EPERM;
 	/* Check IS_APPEND on real upper inode */
-	if (IS_APPEND(file_inode(f.file)))
-		goto out_putf;
+	if (IS_APPEND(file_inode(file)))
+		return error;
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
+	error = -EINVAL;
+	if (length < 0)
+		goto out;
+	error = -EBADF;
+	f = fdget(fd);
+	if (!f.file)
+		goto out;
+
+	error = ftruncate_file(f.file, length, small);
+
 	fdput(f);
 out:
 	return error;
-- 
2.34.1


