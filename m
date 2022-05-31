Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F07539664
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347112AbiEaSlr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347084AbiEaSlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:41:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7201F207
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p10so19828478wrg.12
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S9z0cgWSdzuNDYsClRCoaHxcUfzXO4qdo7JoYy7eKoQ=;
        b=SyurLTOPAgt8jtpuqmCy2s27VTT6DzLTYWIb0oBionaq6/S2ik6d80OCcJCnAhaLqi
         iG1XUUg2J7GGKWQoWAV2vaS4qK6ipDubfqfnZJ33pf51JlrR3vBId3JMY6Ri41vl66//
         fKNPZYH+92lozH4IlkJVJe0HNPjqIGDIq2bhV4+7v/2m3TsBurCfRRUbO5zPb8x013hK
         t0NfNh3KaD2ggi2zsTcY7TuznIzEMnBovrA75CyKxE2OIqYGAYXGgHbls3XSCT8LWEii
         uf9qiTVuT5tWD48SgXQVJUQ3GNGZNZtSpkGXCF2slG8N0AhxK1B4kIx7iDsO4W6q8bSS
         gxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9z0cgWSdzuNDYsClRCoaHxcUfzXO4qdo7JoYy7eKoQ=;
        b=BYIR1Cbyjw6bP/u3gUvG2YYIe4q1mOmB58oxM6prtexZGAn9SGt8Xr+L9dy2WK62Wv
         BVEHGi1G9YGmaTWqCwNy6E6ITuKS3aI32TDTJXi7N61cXEWwyVi/8gUZQzorr0+7FI/Y
         ysb1krk2Y3+rx1y/ycqQYYr1bKuAHTMM/NQHwZ/HUJ2w3fjNgJu/Sg5IGORxUgEYfrSx
         gC7vmn2BGEDBN+UxeWk8x4OpnTPFwr0mYAUqWxrmhHUkembKDN0dYEGcuRxaI78gscII
         fC2yTO7cC6CxBImCwcw5EDpjQegwNb7mSEuzJneucAFJY+1d9a2RkGFCreiQipWSbgS+
         9T6g==
X-Gm-Message-State: AOAM532mBGyQ7C/RLriKjFdB5fQKafHrcOF8fan2dhNHQTvAHqCQAi8E
        bdO1l7+UNZQyqojWhdrzGMym4tyu5450t3+s
X-Google-Smtp-Source: ABdhPJxwFiuca8ofjiHGT50feRtrXarHzbJ8vQ4TAwDQvdZJ65iPV3gNXFQJ6kxo0/4VYqc1Nr+FTA==
X-Received: by 2002:adf:fa0d:0:b0:210:1225:fc77 with SMTP id m13-20020adffa0d000000b002101225fc77mr20969006wrr.528.1654022496954;
        Tue, 31 May 2022 11:41:36 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c059000b00397342bcfb7sm2831877wmd.46.2022.05.31.11.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:41:36 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 1/5] io_uring: add rename opcode for current working directory
Date:   Tue, 31 May 2022 19:41:21 +0100
Message-Id: <20220531184125.2665210-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220531184125.2665210-1-usama.arif@bytedance.com>
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This provides consistency between io_uring and the respective I/O syscall
and avoids having the user of liburing specify the cwd in sqe for
IORING_OP_RENAMEAT.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 25 ++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f1c682d7caf..8bf56523ff7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1306,6 +1306,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_SHUTDOWN] = {
 		.needs_file		= 1,
 	},
+	[IORING_OP_RENAME] = {},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
@@ -1449,6 +1450,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "TEE";
 	case IORING_OP_SHUTDOWN:
 		return "SHUTDOWN";
+	case IORING_OP_RENAME:
+		return "RENAME";
 	case IORING_OP_RENAMEAT:
 		return "RENAMEAT";
 	case IORING_OP_UNLINKAT:
@@ -4553,8 +4556,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
-static int io_renameat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
+static int io_rename_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe, bool is_cwd)
 {
 	struct io_rename *ren = &req->rename;
 	const char __user *oldf, *newf;
@@ -4564,10 +4567,14 @@ static int io_renameat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	ren->old_dfd = READ_ONCE(sqe->fd);
+	if (is_cwd) {
+		ren->old_dfd = ren->new_dfd = AT_FDCWD;
+	} else {
+		ren->old_dfd = READ_ONCE(sqe->fd);
+		ren->new_dfd = READ_ONCE(sqe->len);
+	}
 	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	ren->new_dfd = READ_ONCE(sqe->len);
 	ren->flags = READ_ONCE(sqe->rename_flags);
 
 	ren->oldpath = getname(oldf);
@@ -4584,7 +4591,7 @@ static int io_renameat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
+static int io_rename(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rename *ren = &req->rename;
 	int ret;
@@ -8076,8 +8083,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_tee_prep(req, sqe);
 	case IORING_OP_SHUTDOWN:
 		return io_shutdown_prep(req, sqe);
+	case IORING_OP_RENAME:
+		return io_rename_prep(req, sqe, 1);
 	case IORING_OP_RENAMEAT:
-		return io_renameat_prep(req, sqe);
+		return io_rename_prep(req, sqe, 0);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_MKDIRAT:
@@ -8229,6 +8238,7 @@ static void io_clean_op(struct io_kiocb *req)
 			if (req->open.filename)
 				putname(req->open.filename);
 			break;
+		case IORING_OP_RENAME:
 		case IORING_OP_RENAMEAT:
 			putname(req->rename.oldpath);
 			putname(req->rename.newpath);
@@ -8395,8 +8405,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SHUTDOWN:
 		ret = io_shutdown(req, issue_flags);
 		break;
+	case IORING_OP_RENAME:
 	case IORING_OP_RENAMEAT:
-		ret = io_renameat(req, issue_flags);
+		ret = io_rename(req, issue_flags);
 		break;
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53e7dae92e42..73f4e1c4133d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -189,6 +189,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_RENAME,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

