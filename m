Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC03539665
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347063AbiEaSls (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347104AbiEaSlq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:41:46 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B65DA470
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:41 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r123-20020a1c2b81000000b0039c1439c33cso1680890wmr.5
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ch0z4GLxWhSAQSUlskRiFrLr2UouERYcjJkCx5IZlDI=;
        b=2TfKkZK+ERXCPWANm00v7HIrcLwM/59MLtjytZfFqSajfcOfZyGtYJ2YS8+qutVbbJ
         9YJb7IhXN8weXZ8QwpcpnMT4QBpxWUJ+ybj41/t6yXmO0oGJX7DjAdAagPCei+WJaYLb
         pI0JuigBY9emmatgiKIRsuITO+Us2gb51yfjJR/HK5Rgtd7WkacpUXovaKlObx0vAAMf
         yZguppMJHbjIuEuakQogO0ZHLw9RhKZrowqNHIcnXRvuZLpuZkWiiczoow2QLlUmBHz4
         k4exUWaJL+TfggIrBgHagTD9prC7/1s9C1t9nzTCyRwaW04NLOkaCCFyxyXTRecbxn7c
         1i9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ch0z4GLxWhSAQSUlskRiFrLr2UouERYcjJkCx5IZlDI=;
        b=z2fHzz97Psw8Uk87qo4tBJLtF841CZtBO+gtEP2mOR9qBghULXbe69R9spAlRSyFfn
         RnE3VXBqUiPRz/ttdoIIFc7Cy4hY0bW+q7dtU5XX00WUZOhDfTL/vrlfXS4Xbkfd2IxH
         VIq7riwXEESsaEgK+SVjPiuegJc7Ib6nB6BW4oDKVIpL2C5FBjpoqa+FFWJBIzvBmX3N
         awfolkHv2T7yi8CybhCiV+AbaupCa+93FO899Oqk9tZ8FauCc+HYo2zXHdC0rdm9DH6B
         p9F6bEvEAx6YkHt9CUriQngXlbZNKe9QUqjyFIrWjjIWzh4AUmfOFiCKmteoCJGmDizX
         yXDw==
X-Gm-Message-State: AOAM532hddGnnSi9GlZ+XAPVRo6s1PRzgSHsM6PsBjE7aEt3665A3V/2
        yM/gZb39w2kJR+GG/2x1X441Bhn+8lsVbR9E
X-Google-Smtp-Source: ABdhPJyqFWflMLghxEqXpcoI6WfIprYW+XBaC21a8WFYhSNnxeE3H2E1oWczy/6QRewvyRxJeDWD6Q==
X-Received: by 2002:a05:600c:4f4e:b0:39c:1bbb:734f with SMTP id m14-20020a05600c4f4e00b0039c1bbb734fmr3690489wmq.116.1654022500477;
        Tue, 31 May 2022 11:41:40 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c059000b00397342bcfb7sm2831877wmd.46.2022.05.31.11.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:41:40 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 5/5] io_uring: add link opcode for current working directory
Date:   Tue, 31 May 2022 19:41:25 +0100
Message-Id: <20220531184125.2665210-6-usama.arif@bytedance.com>
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
IORING_OP_LINKAT.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 29 ++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4050377619d3..31dfad3a7312 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1314,6 +1314,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINK] = {},
 	[IORING_OP_SYMLINKAT] = {},
+	[IORING_OP_LINK] = {},
 	[IORING_OP_LINKAT] = {},
 	[IORING_OP_MSG_RING] = {
 		.needs_file		= 1,
@@ -1469,6 +1470,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "SYMLINK";
 	case IORING_OP_SYMLINKAT:
 		return "SYMLINKAT";
+	case IORING_OP_LINK:
+		return "LINK";
 	case IORING_OP_LINKAT:
 		return "LINKAT";
 	case IORING_OP_MSG_RING:
@@ -4991,8 +4994,8 @@ static int io_symlink(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_linkat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
+static int io_link_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe, bool is_cwd)
 {
 	struct io_hardlink *lnk = &req->hardlink;
 	const char __user *oldf, *newf;
@@ -5002,8 +5005,12 @@ static int io_linkat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	lnk->old_dfd = READ_ONCE(sqe->fd);
-	lnk->new_dfd = READ_ONCE(sqe->len);
+	if (is_cwd) {
+		lnk->old_dfd = lnk->new_dfd = AT_FDCWD;
+	} else {
+		lnk->old_dfd = READ_ONCE(sqe->fd);
+		lnk->new_dfd = READ_ONCE(sqe->len);
+	}
 	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	lnk->flags = READ_ONCE(sqe->hardlink_flags);
@@ -5022,7 +5029,7 @@ static int io_linkat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
+static int io_link(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_hardlink *lnk = &req->hardlink;
 	int ret;
@@ -8117,8 +8124,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlink_prep(req, sqe, 1);
 	case IORING_OP_SYMLINKAT:
 		return io_symlink_prep(req, sqe, 0);
+	case IORING_OP_LINK:
+		return io_link_prep(req, sqe, 1);
 	case IORING_OP_LINKAT:
-		return io_linkat_prep(req, sqe);
+		return io_link_prep(req, sqe, 0);
 	case IORING_OP_MSG_RING:
 		return io_msg_ring_prep(req, sqe);
 	case IORING_OP_FSETXATTR:
@@ -8280,6 +8289,7 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->symlink.oldpath);
 			putname(req->symlink.newpath);
 			break;
+		case IORING_OP_LINK:
 		case IORING_OP_LINKAT:
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
@@ -8442,14 +8452,15 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		break;
 	case IORING_OP_MKDIR:
 	case IORING_OP_MKDIRAT:
-		ret = io_mkdirat(req, issue_flags);
+		ret = io_mkdir(req, issue_flags);
 		break;
 	case IORING_OP_SYMLINK:
 	case IORING_OP_SYMLINKAT:
-		ret = io_symlinkat(req, issue_flags);
+		ret = io_symlink(req, issue_flags);
 		break;
+	case IORING_OP_LINK:
 	case IORING_OP_LINKAT:
-		ret = io_linkat(req, issue_flags);
+		ret = io_link(req, issue_flags);
 		break;
 	case IORING_OP_MSG_RING:
 		ret = io_msg_ring(req, issue_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 74e6b70638ee..41391a762ad1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -193,6 +193,7 @@ enum io_uring_op {
 	IORING_OP_UNLINK,
 	IORING_OP_MKDIR,
 	IORING_OP_SYMLINK,
+	IORING_OP_LINK,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

