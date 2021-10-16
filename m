Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F394A43058E
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbhJPXKK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbhJPXKJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:10:09 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AE0C061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:08:00 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w19so53625924edd.2
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XFSkS44tD3jJl5ByRAL1zgYn9vWxwoscOwGATsIjzF8=;
        b=Uak1iR2Ezzv6sJ/1fGHNZb80iwbt8tLTF1BY+e0nGu1ZLYgaRkyBwKc6KNur7W6G07
         8gy6sDG7SYPUxY5+PjECCYjH26Zpz6guvYQUW9MD4WAUQRoruRJT9jKS8vtc7YWqWX0v
         DCEwRWlNUzLmdTktj+Ejgw76GzSAdC58sK2iVV844vR/eFPZPIl+K6NIPfewQjohdL7O
         EKmsksjYcHl2E0tHEXKIOy6THdrbaVJpaxJIZzZUMJBx+n9z09eptZUDMzeO1BXXsBc7
         MRpJIt71cUPB6fhCBeqYQnINdp4NmVoSMsyiTbZENYCgEeX9yyBLnpSLD2UDCYVBKDkH
         4Dsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XFSkS44tD3jJl5ByRAL1zgYn9vWxwoscOwGATsIjzF8=;
        b=vgGEf0mUQqaw6q6jO/uJSV1BQ7t4/xuwzol/nXwMXpdP/p3rsAvPsAy2t+JasU51hU
         7vmuXYwQ5lIRfruqygU76CV7bJRK9lHIQhKQPwlSyYznXONGNbgQzIfKa9n0KY4kLS7F
         XuOJ714WLTvILsir5L51SnNLoye4vJoSdQo4+vQV+yYdkvlMg2zVJPYd2ZZJ+K3jR8nR
         MhsQKch6SNIEUSYOLcnAtJUQEzXaXAt5CuKDkG4WeV0GrVcrTOTBmB4bJ8W1qTQsil+V
         J/o3Zegwvv49iztdGhuNsMg+6F2DyuSAl5HWMXaH7UeOLPDYq0bVomcEK2RDGqRID4hy
         aaHg==
X-Gm-Message-State: AOAM532X9SpInW6CbkSETSpOfuFfW40eALLFxkqddWgxVr4KAaKlg8qt
        Ey1seKeSgto6dsylmDwiq9NKlvDNKPQNhg==
X-Google-Smtp-Source: ABdhPJzw+z81efNbkNaCM23LJP6em88yI2/KyuqH761wmgSSw6dTIIKa6UcIFLX36zHHQoOBHvo9dA==
X-Received: by 2002:a05:6402:40f:: with SMTP id q15mr29424886edv.333.1634425679322;
        Sat, 16 Oct 2021 16:07:59 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id q14sm6791217eji.63.2021.10.16.16.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:07:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: simplify io_file_supports_nowait()
Date:   Sun, 17 Oct 2021 00:07:10 +0100
Message-Id: <60c8f1f5e2cb45e00f4897b2cec10c5b3669da91.1634425438.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634425438.git.asml.silence@gmail.com>
References: <cover.1634425438.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure that REQ_F_SUPPORT_NOWAIT is always set io_prep_rw(), and so
we can stop caring about setting it down the line simplifying
io_file_supports_nowait().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06444b2f9a32..18dac2aece59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2767,10 +2767,8 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool __io_file_supports_nowait(struct file *file)
+static bool __io_file_supports_nowait(struct file *file, umode_t mode)
 {
-	umode_t mode = file_inode(file)->i_mode;
-
 	if (S_ISBLK(mode)) {
 		if (IS_ENABLED(CONFIG_BLOCK) &&
 		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
@@ -2793,11 +2791,26 @@ static bool __io_file_supports_nowait(struct file *file)
 	return file->f_mode & FMODE_NOWAIT;
 }
 
+/*
+ * If we tracked the file through the SCM inflight mechanism, we could support
+ * any file. For now, just ensure that anything potentially problematic is done
+ * inline.
+ */
+static unsigned int io_file_get_flags(struct file *file)
+{
+	umode_t mode = file_inode(file)->i_mode;
+	unsigned int res = 0;
+
+	if (S_ISREG(mode))
+		res |= FFS_ISREG;
+	if (__io_file_supports_nowait(file, mode))
+		res |= FFS_NOWAIT;
+	return res;
+}
+
 static inline bool io_file_supports_nowait(struct io_kiocb *req)
 {
-	if (likely(req->flags & REQ_F_SUPPORT_NOWAIT))
-		return true;
-	return __io_file_supports_nowait(req->file);
+	return req->flags & REQ_F_SUPPORT_NOWAIT;
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -2809,8 +2822,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	unsigned ioprio;
 	int ret;
 
-	if (!io_req_ffs_set(req) && S_ISREG(file_inode(file)->i_mode))
-		req->flags |= REQ_F_ISREG;
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	if (kiocb->ki_pos == -1 && !(file->f_mode & FMODE_STREAM)) {
@@ -6764,10 +6777,7 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 {
 	unsigned long file_ptr = (unsigned long) file;
 
-	if (__io_file_supports_nowait(file))
-		file_ptr |= FFS_NOWAIT;
-	if (S_ISREG(file_inode(file)->i_mode))
-		file_ptr |= FFS_ISREG;
+	file_ptr |= io_file_get_flags(file);
 	file_slot->file_ptr = file_ptr;
 }
 
-- 
2.33.0

