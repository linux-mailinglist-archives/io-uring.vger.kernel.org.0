Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31044539669
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347093AbiEaSlt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347103AbiEaSlq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:41:46 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF4F9FDA
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:41 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id f7-20020a1c3807000000b0039c1a10507fso1665143wma.1
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rtdKQ4qOY7eJ81qn7DIrL6RA+TOtlT/guME4SLgx8hA=;
        b=IoPnpQ2UYg24JkCaXCtMCELRX9jOalyKmiY8t7lqqbbgj9yx+84lc6jRBgDKfwQcs/
         le+0CSrfgIOKm9w9FEtmjNsQ019r5XkSEP6+yivbWl6BHK8feQuPnsO7OJBzoWMOuBQS
         xXwDi65nMUBF5g2nNKun0TZQ+vWCymwFF3tyoHPRnRml3nrawQ37ofwBPGHNFM14NNQf
         x+fXwAJWGKQ1rZ0ChxNvf3s3sNJn5nRPer5MPBIjuK9e5sHWI4wndTVJi2JHYoV6GSZJ
         8sNx9S6eqKR9wv8TE77CcNt0lHHeVMlTtFJMv88DJHbfnFvpsyhmE8pV7P/iDOdGuAUQ
         MRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtdKQ4qOY7eJ81qn7DIrL6RA+TOtlT/guME4SLgx8hA=;
        b=N56HTkRrh+McDrOyaX7tyNnssE9Rlq/pdA6zFTAaQgA0uNHBwPq/pkNOUp06Zbzva3
         v3xH0Pkmdfc6SJoCfYv7svAxirGO+OUdkX+Nfi1wY20IAv1zm3vndclhsX6lPBMor6Np
         F3Lg1xQFgZOfMOfOUR0BM8dONQU4YJUSvKixBwVN4rps71+M/AUhvrfiYVBkvYCBzqZz
         fGTxEm+nJZPwFSpcKHMzrnuKxmyTbRzaS6t82GqfdBfTVGFJGZF6EkLnAjmz4vLbtLdS
         sGUh1nX5ECs2afIsLRGct+M3JNUv2KgQhwUHUI5xdDpZ3ROBPVN+EGqcjs2giqcJ6Mpj
         2QUA==
X-Gm-Message-State: AOAM532p+VtnjjuZTHFRWmmF8WmwzVChJ7hyVsdHx1PW7S+OH6AJHOnw
        wCLVNwWDoRAkfkT2PKXIUr2A3+heBUq2oxWQ
X-Google-Smtp-Source: ABdhPJy/WhfHbCAR+5T7Jjp14rcTZbIYgUERAB+nV4C3UT3y5r4I9MqV8SK67p86Yt1MDc7rPypqGw==
X-Received: by 2002:a05:600c:1492:b0:397:4afc:cc76 with SMTP id c18-20020a05600c149200b003974afccc76mr25153221wmh.124.1654022499653;
        Tue, 31 May 2022 11:41:39 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c059000b00397342bcfb7sm2831877wmd.46.2022.05.31.11.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:41:39 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 4/5] io_uring: add symlink opcode for current working directory
Date:   Tue, 31 May 2022 19:41:24 +0100
Message-Id: <20220531184125.2665210-5-usama.arif@bytedance.com>
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
IORING_OP_SYMLINKAT.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 20 +++++++++++++++-----
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c9fa0b3938d..4050377619d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1312,6 +1312,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIR] = {},
 	[IORING_OP_MKDIRAT] = {},
+	[IORING_OP_SYMLINK] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
 	[IORING_OP_MSG_RING] = {
@@ -1464,6 +1465,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "MKDIR";
 	case IORING_OP_MKDIRAT:
 		return "MKDIRAT";
+	case IORING_OP_SYMLINK:
+		return "SYMLINK";
 	case IORING_OP_SYMLINKAT:
 		return "SYMLINKAT";
 	case IORING_OP_LINKAT:
@@ -4941,8 +4944,8 @@ static int io_mkdir(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_symlinkat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
+static int io_symlink_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe, bool is_cwd)
 {
 	struct io_symlink *sl = &req->symlink;
 	const char __user *oldpath, *newpath;
@@ -4952,7 +4955,10 @@ static int io_symlinkat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	sl->new_dfd = READ_ONCE(sqe->fd);
+	if (is_cwd)
+		sl->new_dfd = AT_FDCWD;
+	else
+		sl->new_dfd = READ_ONCE(sqe->fd);
 	oldpath = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	newpath = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 
@@ -4970,7 +4976,7 @@ static int io_symlinkat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
+static int io_symlink(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_symlink *sl = &req->symlink;
 	int ret;
@@ -8107,8 +8113,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_mkdir_prep(req, sqe, 1);
 	case IORING_OP_MKDIRAT:
 		return io_mkdir_prep(req, sqe, 0);
+	case IORING_OP_SYMLINK:
+		return io_symlink_prep(req, sqe, 1);
 	case IORING_OP_SYMLINKAT:
-		return io_symlinkat_prep(req, sqe);
+		return io_symlink_prep(req, sqe, 0);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
 	case IORING_OP_MSG_RING:
@@ -8267,6 +8275,7 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_MKDIRAT:
 			putname(req->mkdir.filename);
 			break;
+		case IORING_OP_SYMLINK:
 		case IORING_OP_SYMLINKAT:
 			putname(req->symlink.oldpath);
 			putname(req->symlink.newpath);
@@ -8435,6 +8444,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_MKDIRAT:
 		ret = io_mkdirat(req, issue_flags);
 		break;
+	case IORING_OP_SYMLINK:
 	case IORING_OP_SYMLINKAT:
 		ret = io_symlinkat(req, issue_flags);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 58f2e0611152..74e6b70638ee 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -192,6 +192,7 @@ enum io_uring_op {
 	IORING_OP_RENAME,
 	IORING_OP_UNLINK,
 	IORING_OP_MKDIR,
+	IORING_OP_SYMLINK,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

