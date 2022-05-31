Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B558253966B
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347106AbiEaSlv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347095AbiEaSlq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:41:46 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848E9E15
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:40 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o29-20020a05600c511d00b00397697f172dso1573900wms.0
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTP4iDeAMMuWaU0byLugZsxmmGz2FMBqZk2mPA87o8Q=;
        b=p0YDYKj8oZBxmO/xWmHF5WPpVOyfJA/9pKYiDLKO7RewCeqRaFWDAJV2ZrFdEeHThp
         p4KkXG+5GqWE7Xc3tp4VkSidmYM71M0yddL14rOXcHDOIYyqej6GFQjgSoB1Xk1xWTkG
         dkSn3hXbDI4d/vF5qI+RiSaSOKtYrtxLNoNYTl71aCHZVlbDN1L9Fx9G8qyuXgO5wUBm
         cr/QYqDcVFQi/s7B+bjZEhTws0JlGFgC3JpQ1laGjlL+14RLYMojR744BKAOwsYte/9Y
         ZYyq0LBDoGNjWAb1ZHeVnXmbrtNQXkLpwtfmYAbKvzSeFfr4AOGgQs/aMsz1c1pB3G80
         t3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTP4iDeAMMuWaU0byLugZsxmmGz2FMBqZk2mPA87o8Q=;
        b=E5sImIk3F/WBMjrNV+SixNkDeE9PuoqYJJOzte4vedanyGkIFTKutTluejFMnj9YBc
         DlmlGeIg1o1mA/IyLSJmHRMSBUTuX/lybGp+WhGUVYhguCZepVL9Ireml2KvzuTt4oYS
         14Ng9d72VfOcM9Ee3MPGwcZ6Q+8fxbPki5nhpBR1YxMwDZAUHIhJ3p4HKOKxtMODq/DC
         Ui00vMQInzaoXKlFB+8PWcdb4kgs2tj05PqDpCQ8Wig1htHlhy7RJhX7qx3Dk5Tt5Qfm
         M2nLYEqtEUpYc1Py49XmLLr16XI7V+wNLtmd44zHW1L/Ot5fYpfOgu7Hg4mhyA8OPiXS
         7rFg==
X-Gm-Message-State: AOAM530jHnlrM3GW/CYYy84erUJLpk8SWbwYs+0HenB15DlOEiWmPo4g
        cmNTkAUsBc3MNxYhitezSBlp+eS4PzmQFuJ5
X-Google-Smtp-Source: ABdhPJzx6d9KhKDRsVYcHz8vULjo9gLdcOVZTLF/sAl1DSfU3ljxs+Atq3KRXfcrkUi6rhU56lnIlA==
X-Received: by 2002:a1c:5403:0:b0:397:3437:bbcf with SMTP id i3-20020a1c5403000000b003973437bbcfmr24705133wmb.1.1654022498794;
        Tue, 31 May 2022 11:41:38 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c059000b00397342bcfb7sm2831877wmd.46.2022.05.31.11.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:41:38 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 3/5] io_uring: add mkdir opcode for current working directory
Date:   Tue, 31 May 2022 19:41:23 +0100
Message-Id: <20220531184125.2665210-4-usama.arif@bytedance.com>
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
IORING_OP_MKDIRAT.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 20 +++++++++++++++-----
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d38c5f54f6a4..9c9fa0b3938d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1310,6 +1310,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINK] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIR] = {},
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
@@ -1459,6 +1460,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "UNLINK";
 	case IORING_OP_UNLINKAT:
 		return "UNLINKAT";
+	case IORING_OP_MKDIR:
+		return "MKDIR";
 	case IORING_OP_MKDIRAT:
 		return "MKDIRAT";
 	case IORING_OP_SYMLINKAT:
@@ -4897,8 +4900,8 @@ static int io_unlink(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_mkdirat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
+static int io_mkdir_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe, bool is_cwd)
 {
 	struct io_mkdir *mkd = &req->mkdir;
 	const char __user *fname;
@@ -4908,7 +4911,10 @@ static int io_mkdirat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	mkd->dfd = READ_ONCE(sqe->fd);
+	if (is_cwd)
+		mkd->dfd = AT_FDCWD;
+	else
+		mkd->dfd = READ_ONCE(sqe->fd);
 	mkd->mode = READ_ONCE(sqe->len);
 
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4920,7 +4926,7 @@ static int io_mkdirat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
+static int io_mkdir(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_mkdir *mkd = &req->mkdir;
 	int ret;
@@ -8097,8 +8103,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_unlink_prep(req, sqe, 1);
 	case IORING_OP_UNLINKAT:
 		return io_unlink_prep(req, sqe, 0);
+	case IORING_OP_MKDIR:
+		return io_mkdir_prep(req, sqe, 1);
 	case IORING_OP_MKDIRAT:
-		return io_mkdirat_prep(req, sqe);
+		return io_mkdir_prep(req, sqe, 0);
 	case IORING_OP_SYMLINKAT:
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
@@ -8255,6 +8263,7 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIR:
 		case IORING_OP_MKDIRAT:
 			putname(req->mkdir.filename);
 			break;
@@ -8422,6 +8431,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlink(req, issue_flags);
 		break;
+	case IORING_OP_MKDIR:
 	case IORING_OP_MKDIRAT:
 		ret = io_mkdirat(req, issue_flags);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7828b7183d01..58f2e0611152 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -191,6 +191,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_RENAME,
 	IORING_OP_UNLINK,
+	IORING_OP_MKDIR,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

