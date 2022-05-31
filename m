Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35451539666
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347084AbiEaSls (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347086AbiEaSlm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:41:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C508B7B
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k16so15507251wrg.7
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GyYrzMYdcSF2goCR70E9AdY9237cGTWSWoDyblu5Hto=;
        b=2rvIVYNwD6PevpWnhzXXXCr8CZ+NoyLRKxabrGzLYHeSnKAdpxQ8h1HvJ6g/VglqWP
         cnQZ+yWOhq7G+hjEoPArYgCiJfz6H8vdJ+jbZMRLrIqWEWxf3yxQpinkMffzRWFkhMMT
         HhnVvPDrENgmNcJaGou11Tf7dEiFJF5Qmh4xuXbSbfFvurQzY+gS0T2wT2Om5TQP/yLW
         K5pzW5C/pW/8qjRdAAlsVX82ebzqioK8G96CEIG8xCjX8eUmmY9DDxuv1yeeuBajNB2x
         DHYKu5AqDExgpu36tsevh6g3o1Y5g4zDbBZE7f4MIYkIr6GfkyKz5pVYHpMLeIeiC4xn
         EVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GyYrzMYdcSF2goCR70E9AdY9237cGTWSWoDyblu5Hto=;
        b=gsETjhS9oMRSveCgsuUdWz3B5Qgyzhrj9/HCtK9JNedjP01+EbYeVZFAnrTc+mumVG
         9saR2eW7kXQN9Fx4QRHmgTeRK3kH2VewCAyVF81u1IGWRLIiW7D54esjAu0c5pAXQ8DG
         BwzDzH/WDLAolHExghCanTOJB6ssr5bqUwJkLi+iBdBTbaWmuehfiwm2Yij6UdMSC2y7
         LN8KFnZ5vRoAC0NIOfQM6HlRserflp9Oxe3gVN38g/tnkoz6txvzlmRLkHue9uJtsSvc
         xpNy+8TklhQe4lGzZZAfyL9Ini3OCFQt2fYAq4ebVpAPBal2n8DHdm0vGbhM/78NPCt1
         kj9A==
X-Gm-Message-State: AOAM532wvZD6DJ/daXLjA/Jc6aNVTXb6naU5H+wo/UCSUnzI90hJCZDY
        vta1kxZTcmTK+hRsRxymsgzuM7zKp2PxmaR5
X-Google-Smtp-Source: ABdhPJx9uvIPQcHnGrm7Y5H8Jcw5DOfOm5cIXrJq76TAyMmoI9XRYWN4SjYmxzRMsMlO+9lrlT6ZHA==
X-Received: by 2002:adf:d1a8:0:b0:210:2bc3:c3b4 with SMTP id w8-20020adfd1a8000000b002102bc3c3b4mr13231172wrc.54.1654022497955;
        Tue, 31 May 2022 11:41:37 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c059000b00397342bcfb7sm2831877wmd.46.2022.05.31.11.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:41:37 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 2/5] io_uring: add unlink opcode for current working directory
Date:   Tue, 31 May 2022 19:41:22 +0100
Message-Id: <20220531184125.2665210-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220531184125.2665210-1-usama.arif@bytedance.com>
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This provides consistency between io_uring and the respective I/O syscall
and avoids having the user of liburing specify the cwd in sqe for
IORING_OP_UNLINKAT.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 22 ++++++++++++++++------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bf56523ff7f..d38c5f54f6a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1308,6 +1308,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAME] = {},
 	[IORING_OP_RENAMEAT] = {},
+	[IORING_OP_UNLINK] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
@@ -1454,6 +1455,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "RENAME";
 	case IORING_OP_RENAMEAT:
 		return "RENAMEAT";
+	case IORING_OP_UNLINK:
+		return "UNLINK";
 	case IORING_OP_UNLINKAT:
 		return "UNLINKAT";
 	case IORING_OP_MKDIRAT:
@@ -4847,8 +4850,8 @@ static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_unlinkat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
+static int io_unlink_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe, bool is_cwd)
 {
 	struct io_unlink *un = &req->unlink;
 	const char __user *fname;
@@ -4858,7 +4861,10 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	un->dfd = READ_ONCE(sqe->fd);
+	if (is_cwd)
+		un->dfd = AT_FDCWD;
+	else
+		un->dfd = READ_ONCE(sqe->fd);
 
 	un->flags = READ_ONCE(sqe->unlink_flags);
 	if (un->flags & ~AT_REMOVEDIR)
@@ -4873,7 +4879,7 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
+static int io_unlink(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_unlink *un = &req->unlink;
 	int ret;
@@ -8087,8 +8093,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_rename_prep(req, sqe, 1);
 	case IORING_OP_RENAMEAT:
 		return io_rename_prep(req, sqe, 0);
+	case IORING_OP_UNLINK:
+		return io_unlink_prep(req, sqe, 1);
 	case IORING_OP_UNLINKAT:
-		return io_unlinkat_prep(req, sqe);
+		return io_unlink_prep(req, sqe, 0);
 	case IORING_OP_MKDIRAT:
 		return io_mkdirat_prep(req, sqe);
 	case IORING_OP_SYMLINKAT:
@@ -8243,6 +8251,7 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->rename.oldpath);
 			putname(req->rename.newpath);
 			break;
+		case IORING_OP_UNLINK:
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
@@ -8409,8 +8418,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_RENAMEAT:
 		ret = io_rename(req, issue_flags);
 		break;
+	case IORING_OP_UNLINK:
 	case IORING_OP_UNLINKAT:
-		ret = io_unlinkat(req, issue_flags);
+		ret = io_unlink(req, issue_flags);
 		break;
 	case IORING_OP_MKDIRAT:
 		ret = io_mkdirat(req, issue_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 73f4e1c4133d..7828b7183d01 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -190,6 +190,7 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_RENAME,
+	IORING_OP_UNLINK,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

