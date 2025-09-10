Return-Path: <io-uring+bounces-9718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5065B523C9
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 985B1A025B7
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B49E2D1926;
	Wed, 10 Sep 2025 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCsNZ8XY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273A25A350;
	Wed, 10 Sep 2025 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540854; cv=none; b=jmGYlK42Xq16SUn1r2eyHb02OW4mrnDd6wJrs9oYLqPd4bbhSA9wlOYQq6OK/f6pLP/6Kf2azZ31xxuIDtERyPIpNRFpHR7NC9frMGY+NYmAYgAEy5QxCg/cO7D0in+6XrYpd2P2YSuR8czdh0DNtIqZOaHucLX1Apd0yTJ2qkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540854; c=relaxed/simple;
	bh=iSaetoiP5yfrSc1YL/X+149oJQiqU35BQr9ETTUajsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmC30JMa1szS4V0+aVC6E+Jkc3DjYxMaaCzmnYnwhyuy9d4ayVOS4vmnjEsG9dyxWT0Tfpti+OSW3mU+qyTfCIRLNPjREILphQMd2khaITBtzmpzH9bQvtmlkY6wLa2/7MpBa6FQ0zB2qaj26FBm0V1zFEOz5IO6Ywk3ypo6E00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCsNZ8XY; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7722bcb989aso54042b3a.1;
        Wed, 10 Sep 2025 14:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540851; x=1758145651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaKxmDGbHOoLQhovZ2teezNE+PbN2wa3t1p94zt6lW0=;
        b=dCsNZ8XY6EkXsznX8I/oKF+6BzmV73rGM24YrMPLyPMxseGjhGlPfVZiIXRW0cMg4N
         wBK2eZ21PUI+0EoW/Qrp3rYROlVMSOOR1wMOa/cU8nTwHjxixiw9VE7lSQFCJ6E3zsZE
         AAqO522I+mszMwQjesif18aYA80kHIjCw6hQmPchsdvyveuwqNrzYEoQjhN90CfM0Cn/
         PROwximMYQ/KCD9NJxgyE4vuJvXZSXbqNHXwOyaegk8yW/SxX4SpHGsb8Tvx9sHzjmqh
         k0HDAI8A+BGoh15QbbYBPM6evhUvOYW5JvgyASL/gPKUgWb1MvNYGRX2/RUBKd6aOl1G
         i3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540851; x=1758145651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaKxmDGbHOoLQhovZ2teezNE+PbN2wa3t1p94zt6lW0=;
        b=OjnRaUqXuifvAsRV4uLAhG7ir5lrzOZXhrUgocHbNPR2XYq632mFENg5kKq5LHRhY4
         0buBDUO6KxawvViEqKwXD6WSupa74WxKKRLoX3srqVjnSiJw/c+jjr2VXDZWgmPWfQc6
         FAhLxA+nnrnd1kcR6N6NBOK1VOgJkiJuqx0na2zMJhwvTJ8mkGYxr3zYqQGKxgumNzhB
         Fr9ndFci16c2jYriAH42cjfyQFdE59p6oOliEAhGuCy+B/HJE0s8Yi4UUIr1GHVliWxg
         8OqbFN8aefND6zlkU1qZNDEdzRfhUtxreeKFfrnEvCJ1FD/7G0d2mnnSGZ442lGAr6ry
         OpCw==
X-Forwarded-Encrypted: i=1; AJvYcCWazoeNCYu/JPPIchh9NHeycK9Yct2buP/ACxWXb2ZSGVXJ9uyk3pqt+t8H2erPtEp1hmPrfAYUIyxp0neX@vger.kernel.org, AJvYcCXAaufSqLORqCr4eN/RgTkgPYbE1Hu+F9Ukj/0j4RWDASs9dBTrYOSD0kljBjXxknX3qNmy4bNARHSG@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5K8m4Nptgc18w9Eilq5VFwrPowE0JANDTw2olZ2So/2qeJS0W
	IOboejkc8chu24OorXflxDmN7gyLDiH96lyYo7eyWkiPIQ3N2moOZiTb2SzCJ9gP
X-Gm-Gg: ASbGncsYDWMJQS3bFf9ejf9EpHVMJNJT2Tm4DUNAq9KP6cqNnmeMdobFCMnH9fuusVR
	cWY+6e4tlpekq15qpDu981erfQQremKee8EmOaFs07LJ1Kzd2qX6EdpqXQC69CLskUJpkieA+DG
	2vhe3OmV+a3kbR3eWg6Nf4m9in1GtGZtDoB5U8r4dipNk45wOKdwoL6t5ilJzMPgdD9SfzX4DMl
	bxdslrqim+dC08oZUYf0uw7RmhdBtquqpVTAvy/5OBZ7aXWdbkkb3Sui5+qOPhpsym9AH07+WNN
	hT1WXGeOYa268fFFH1NkkQKQdUVacnwx4Hu3lLXuHGSsvXCO1PeFPP4cml6/EugvsHn+OVeRnj4
	GzmENA+zH7nrgXaRqpv9UICmlKwzoONBN1FLN
X-Google-Smtp-Source: AGHT+IF6OfqCktcrcgDi0/qIvEbhZ3pmy2/oNtaoVRPQB2Qi6IgaeKWJFL3foDcJYof7UPQMIuJ8+g==
X-Received: by 2002:a05:6a21:3282:b0:250:c76d:1ce0 with SMTP id adf61e73a8af0-2533e950077mr23259192637.2.1757540851543;
        Wed, 10 Sep 2025 14:47:31 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:47:30 -0700 (PDT)
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
Subject: [PATCH 07/10] exportfs: new FILEID_CACHED flag for non-blocking fh lookup
Date: Wed, 10 Sep 2025 15:49:24 -0600
Message-ID: <20250910214927.480316-8-tahbertschinger@gmail.com>
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

This defines a new flag FILEID_CACHED that the VFS can set in the
handle_type field of struct file_handle to request that the FS
implementations of fh_to_{dentry,parent}() only complete if they can
satisfy the request with cached data.

Because not every FS implementation will recognize this new flag, those
that do recognize the flag can indicate their support using a new
export flag, EXPORT_OP_NONBLOCK.

If FILEID_CACHED is set in a file handle, but the filesystem does not
set EXPORT_OP_NONBLOCK, then the VFS will return -EAGAIN without
attempting to call into the filesystem code.

exportfs_decode_fh_raw() is updated to respect the new flag by returning
-EAGAIN when it would need to do an operation that may not be possible
with only cached data.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/exportfs/expfs.c      | 13 +++++++++++++
 fs/fhandle.c             |  2 ++
 include/linux/exportfs.h |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 949ce6ef6c4e..88418b93abbf 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -441,6 +441,7 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		       void *context)
 {
 	const struct export_operations *nop = mnt->mnt_sb->s_export_op;
+	bool decode_cached = fileid_type & FILEID_CACHED;
 	struct dentry *result, *alias;
 	char nbuf[NAME_MAX+1];
 	int err;
@@ -453,6 +454,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 	 */
 	if (!exportfs_can_decode_fh(nop))
 		return ERR_PTR(-ESTALE);
+
+	if (decode_cached && !(nop->flags & EXPORT_OP_NONBLOCK))
+		return ERR_PTR(-EAGAIN);
+
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
 	if (IS_ERR_OR_NULL(result))
 		return result;
@@ -481,6 +486,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		 * filesystem root.
 		 */
 		if (result->d_flags & DCACHE_DISCONNECTED) {
+			err = -EAGAIN;
+			if (decode_cached)
+				goto err_result;
+
 			err = reconnect_path(mnt, result, nbuf);
 			if (err)
 				goto err_result;
@@ -526,6 +535,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		err = PTR_ERR(target_dir);
 		if (IS_ERR(target_dir))
 			goto err_result;
+		err = -EAGAIN;
+		if (decode_cached & (target_dir->d_flags & DCACHE_DISCONNECTED)) {
+			goto err_result;
+		}
 
 		/*
 		 * And as usual we need to make sure the parent directory is
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 276c16454eb7..70e265f6a3ab 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -273,6 +273,8 @@ static int do_handle_to_path(struct file_handle *handle, struct path *path,
 	if (IS_ERR_OR_NULL(dentry)) {
 		if (dentry == ERR_PTR(-ENOMEM))
 			return -ENOMEM;
+		if (dentry == ERR_PTR(-EAGAIN))
+			return -EAGAIN;
 		return -ESTALE;
 	}
 	path->dentry = dentry;
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 30a9791d88e0..8238b6f67956 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -199,6 +199,8 @@ struct handle_to_path_ctx {
 #define FILEID_FS_FLAGS_MASK	0xff00
 #define FILEID_FS_FLAGS(flags)	((flags) & FILEID_FS_FLAGS_MASK)
 
+#define FILEID_CACHED		0x100 /* Use only cached data when decoding handle */
+
 /* User flags: */
 #define FILEID_USER_FLAGS_MASK	0xffff0000
 #define FILEID_USER_FLAGS(type) ((type) & FILEID_USER_FLAGS_MASK)
@@ -303,6 +305,9 @@ struct export_operations {
 						*/
 #define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
 #define EXPORT_OP_NOLOCKS		(0x40) /* no file locking support */
+#define EXPORT_OP_NONBLOCK		(0x80) /* Filesystem supports non-
+						  blocking fh_to_dentry()
+						*/
 	unsigned long	flags;
 };
 
-- 
2.51.0


