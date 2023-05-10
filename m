Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFC86FDBF2
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbjEJKxe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbjEJKxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:31 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E272D7AA4;
        Wed, 10 May 2023 03:53:24 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8F293C009; Wed, 10 May 2023 12:53:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716003; bh=6QxWGUx7JcbfJLzcgzoVTnfXsX0NRwgrGu+B7GzT3oE=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=frnSqCTSHQv1C0QPaHCsmLdJhmn6iL3fb13CmnPoQtm7Ig2HE3VU2kpyo25bcFB1z
         IxW7BCRfVG2/S+rFGNBnAbUjLoTgD53kauNfV0KfwXidvNOQLnFdcKE95Xrr36Yav5
         zv3FljxHoZMetPkBdXQnTTpQdb+rblz+dhTE5Q+YUWjT216z5IbnK2Bz/oKRWNzJX6
         qxWe1G28PTDGMtmetta44c2ggjlV1oTYIzdRRnjahwxNcg4gpugbIM55c8xOWX+3Xt
         A5JR851bXCyPusWrJ3jGHF2TMz+fbaAdJH68sSgvuKZdU8nPH/v1XYl/yDFVan4QPJ
         z0KR61BBTkMHQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2BDE3C01F;
        Wed, 10 May 2023 12:53:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716003; bh=6QxWGUx7JcbfJLzcgzoVTnfXsX0NRwgrGu+B7GzT3oE=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=frnSqCTSHQv1C0QPaHCsmLdJhmn6iL3fb13CmnPoQtm7Ig2HE3VU2kpyo25bcFB1z
         IxW7BCRfVG2/S+rFGNBnAbUjLoTgD53kauNfV0KfwXidvNOQLnFdcKE95Xrr36Yav5
         zv3FljxHoZMetPkBdXQnTTpQdb+rblz+dhTE5Q+YUWjT216z5IbnK2Bz/oKRWNzJX6
         qxWe1G28PTDGMtmetta44c2ggjlV1oTYIzdRRnjahwxNcg4gpugbIM55c8xOWX+3Xt
         A5JR851bXCyPusWrJ3jGHF2TMz+fbaAdJH68sSgvuKZdU8nPH/v1XYl/yDFVan4QPJ
         z0KR61BBTkMHQ==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id a820605c;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Wed, 10 May 2023 19:52:51 +0900
Subject: [PATCH v2 3/6] io_uring: add support for getdents
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v2-3-2db1e37dc55e@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=5527;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=lY9CKW6ZADkqYeJH4NCrnDklEklhKGsfq33VwRZEwdo=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eOC1zQrTHzBzXLLRmTJc07x9GKHD6rFw5kJ
 2/VulrZy52JAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jgAKCRCrTpvsapjm
 cP3RD/9B1dAYjRkQDf7/mjiqhh4CCu0Zc0OYp3EAOvIKqhAyW0yjs9xCBXRRnxlwx//3BDdpPa2
 wU33hVMl9a1fYNpCPX3Kx5ZUPSAmQSCi7ujIs4Pfwb3muf3if4fCQVyzX9HTmugtLmTXVh3Zdtr
 2BZb2vYMh469TNQefGbbJ1JSQIZzNpz7QBHL0wbizxuYKTo2QN8lfkKmDS1b01MiEBppy8BUYn4
 YAR85UYr2U/SIOrg7kV8a1gDsC9IeFe87EP0GRbLyIKPAJfD/sLUN3rI6i8K6JN5EA7f9SgbRI2
 KivEW9h47VAAWUZxEXkBU/1s0uxyhZVtjPeRnttqaCbQkCU2b7MEObdkti2AyyTHVfpQhWpYOyb
 rNCl1kLVVpeYd6JHiq06rzgf+Rom8xoYzZMFujFu401izGz1Szbz/3sh3OhrihOGwWmQjdauc1/
 K1M4aLEjbCvTmXBS4CHEeoLglEBQmnB8QCPpGmHLzLVB0NJmR1PIlyZAaYKREesnON5h1MZY3P4
 6slhYtaE3U5sBVT4h3j51oJZNRmW7s2g0E/eOcHSBjn4CdfQaloK/9zVC9D8knUUVoGC1ucsNts
 LoECZ7ctTtQNywACGHbMQwIYTlcnBx4o2KHcbNEV59r2OyqUz1BKtpxHeaA+5F1ORZN0XZO79K/
 zsLgsMyj0lwBebg==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This add support for getdents64 to io_uring, acting exactly like the
syscall: the directory is iterated from it's current's position as
stored in the file struct, and the file's position is updated exactly as
if getdents64 had been called.

Additionally, since io_uring has no way of issuing a seek, a flag
IORING_GETDENTS_REWIND has been added that will seek to the start of the
directory like rewinddir(3) for users that might require such a thing.
This will act exactly as if seek then getdents64 have been called
sequentially with no atomicity guarantee:
if this wasn't clear it is the responsibility of the caller to not use
getdents multiple time on a single file in parallel if they want useful
results, as is currently the case when using the syscall from multiple
threads.

For filesystems that support NOWAIT in iterate_shared(), try to use it
first; if a user already knows the filesystem they use do not support
nowait they can force async through IOSQE_ASYNC in the sqe flags,
avoiding the need to bounce back through a useless EAGAIN return.
(Note we already do that in prep if rewind is requested)

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 include/uapi/linux/io_uring.h |  7 ++++++
 io_uring/fs.c                 | 57 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 +++
 io_uring/opdef.c              |  8 ++++++
 4 files changed, 75 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..35d0de18d893 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -65,6 +65,7 @@ struct io_uring_sqe {
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
 		__u32		uring_cmd_flags;
+		__u32		getdents_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -223,6 +224,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_GETDENTS,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -259,6 +261,11 @@ enum io_uring_op {
  */
 #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
 
+/*
+ * sqe->getdents_flags
+ */
+#define IORING_GETDENTS_REWIND	(1U << 0)
+
 /*
  * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
  * command flags for POLL_ADD are stored in sqe->len.
diff --git a/io_uring/fs.c b/io_uring/fs.c
index f6a69a549fd4..b15ec81c1ed2 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -47,6 +47,13 @@ struct io_link {
 	int				flags;
 };
 
+struct io_getdents {
+	struct file			*file;
+	struct linux_dirent64 __user	*dirent;
+	unsigned int			count;
+	int				flags;
+};
+
 int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
@@ -291,3 +298,53 @@ void io_link_cleanup(struct io_kiocb *req)
 	putname(sl->oldpath);
 	putname(sl->newpath);
 }
+
+int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
+
+	if (READ_ONCE(sqe->off) != 0)
+		return -EINVAL;
+
+	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	gd->count = READ_ONCE(sqe->len);
+	gd->flags = READ_ONCE(sqe->getdents_flags);
+	if (gd->flags & ~IORING_GETDENTS_REWIND)
+		return -EINVAL;
+	/* rewind cannot be nowait */
+	if (gd->flags & IORING_GETDENTS_REWIND)
+		req->flags |= REQ_F_FORCE_ASYNC;
+
+	return 0;
+}
+
+int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
+	unsigned long getdents_flags = 0;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		if (!(req->file->f_mode & FMODE_NOWAIT))
+			return -EAGAIN;
+
+		getdents_flags = DIR_CONTEXT_F_NOWAIT;
+	}
+	if ((gd->flags & IORING_GETDENTS_REWIND)) {
+		WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+
+		ret = vfs_llseek(req->file, 0, SEEK_SET);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = vfs_getdents(req->file, gd->dirent, gd->count, getdents_flags);
+out:
+	if (ret == -EAGAIN &&
+	    (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+
+	io_req_set_res(req, ret, 0);
+	return 0;
+}
+
diff --git a/io_uring/fs.h b/io_uring/fs.h
index 0bb5efe3d6bb..f83a6f3a678d 100644
--- a/io_uring/fs.h
+++ b/io_uring/fs.h
@@ -18,3 +18,6 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags);
 int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_linkat(struct io_kiocb *req, unsigned int issue_flags);
 void io_link_cleanup(struct io_kiocb *req);
+
+int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_getdents(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..8f770c582ab3 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -428,6 +428,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_GETDENTS] = {
+		.needs_file		= 1,
+		.prep			= io_getdents_prep,
+		.issue			= io_getdents,
+	},
 };
 
 
@@ -648,6 +653,9 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_GETDENTS] = {
+		.name			= "GETDENTS",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)

-- 
2.39.2

