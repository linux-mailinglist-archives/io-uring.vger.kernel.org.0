Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9D06EB80E
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 10:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjDVIk7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 04:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjDVIk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 04:40:56 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0FC1BC2;
        Sat, 22 Apr 2023 01:40:55 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id F25B8C022; Sat, 22 Apr 2023 10:40:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682152850; bh=fmiVfF7XjOAyzByT51CixzO2cWUnuN4nSoCZntxTvEk=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=QOZoELBEiPEWSRqYNF9xE3Ml2EFrvW6//F3yKRElRhvFYyZLBFROvkkESYxmvfV2S
         m6VMEOSlGjMy6ViVN3BtUKxvFzcNMQQ3fWkNP58oTeuFMLmzt4CzUhePtdueYpdLHS
         t3L5anqSH0ur+jKlfFh6JDCu0qfqElqm7XfG9SKHrGUw6A/4W5xzHehoryKAgABE+T
         cE9rwNOO7u14eol9mvEyBEX9e7sk4W3RcTDWCkpo8gOVdBlkMhztkrbf/EaAPPb0v1
         ya9cxkdHtwiPWVTau2o4rlJ+MKVjNnKCQmBaLJ35Vhp6DO7cmI2X9QrE5q5TC7kLAE
         GxNVrTZFBv8Ew==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 89A6BC01D;
        Sat, 22 Apr 2023 10:40:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682152850; bh=fmiVfF7XjOAyzByT51CixzO2cWUnuN4nSoCZntxTvEk=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=QOZoELBEiPEWSRqYNF9xE3Ml2EFrvW6//F3yKRElRhvFYyZLBFROvkkESYxmvfV2S
         m6VMEOSlGjMy6ViVN3BtUKxvFzcNMQQ3fWkNP58oTeuFMLmzt4CzUhePtdueYpdLHS
         t3L5anqSH0ur+jKlfFh6JDCu0qfqElqm7XfG9SKHrGUw6A/4W5xzHehoryKAgABE+T
         cE9rwNOO7u14eol9mvEyBEX9e7sk4W3RcTDWCkpo8gOVdBlkMhztkrbf/EaAPPb0v1
         ya9cxkdHtwiPWVTau2o4rlJ+MKVjNnKCQmBaLJ35Vhp6DO7cmI2X9QrE5q5TC7kLAE
         GxNVrTZFBv8Ew==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 2a928d4e;
        Sat, 22 Apr 2023 08:40:36 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Sat, 22 Apr 2023 17:40:19 +0900
Subject: [PATCH RFC 2/2] io_uring: add support for getdents
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=4880;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=N1xhUa8bfo36AvgC23A4t1KwwPLuIpzZO8R1HlkfPf0=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkQ52EOlnH3HKltBNfDVzmnD4r4WTH+tQQrkcel
 JAQDo0Xl2eJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEOdhAAKCRCrTpvsapjm
 cB73EACEKl/hQl1z0FFKjzFHHmOZJqdnDUAKcV/gHp3wzcvYMlmMYFW9GCNVf8UjDhcJiMw9ieK
 NdSzqkUy3laPW8PAXun3UaEDiZzfeT04md0wyBJ/I9dqziCAs8JoJLwWaOuIeMB5T1ptOHxkkrF
 5BWM2uHYLuCcQ466Jbn3GduMB4XGDO38iCJ9pNtTV6vuopKfU1M1GJkPmAchCvJFkzpSGTjwLRC
 4PWiHvA+41ZivqLjEURhn83oM36ZRBoTM2kKmtpdsThG3dYLcYLHaam5mEq7cpOG7h+/pMoUWtx
 etOGTvy6qFv7YyrIGTrTTqJLU6A8Zxh+kspOmxi4X30ZChavMC/MKco5opU4rYvZkR5uw6NqmCf
 asAMwDte5Ghh/dFNvDdUBKcPCgEXWjimjSDBgV07toaE59AoeNCBb/by8GEFr75nSA+1pRiYqph
 kSgwJr4aDmSjyDrLOfkaZfHuFzgfbKVFhKZxUZFfADEbvA7A+0HJp0gMzpqa1b91HmEFfX89j+p
 RAF+DeXC1E3j2d6P8s+XrkUiBQgb2MpdhCuM5QgVHLVsrUglGuZEwayg37UhPSjCj0LUbgRCFc+
 oCPiCj8higlig/latNSKq4tKgEUczLHtZ650GPbyRlaFDfwQ58J4rxUnnBJ2q6odQXSgS6Ezswv
 TO+Le3LXz/HiyWQ==
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

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 include/uapi/linux/io_uring.h |  7 ++++++
 io_uring/fs.c                 | 51 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 +++
 io_uring/opdef.c              |  8 +++++++
 4 files changed, 69 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 709de6d4feb2..44c87fad2714 100644
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
@@ -258,6 +260,11 @@ enum io_uring_op {
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
index f6a69a549fd4..cb555bc738bd 100644
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
@@ -291,3 +298,47 @@ void io_link_cleanup(struct io_kiocb *req)
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
+
+	return 0;
+}
+
+int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	if ((gd->flags & IORING_GETDENTS_REWIND)) {
+		ret = vfs_llseek(req->file, 0, SEEK_SET);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = vfs_getdents(req->file, gd->dirent, gd->count);
+out:
+	if (ret < 0) {
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+
+		req_set_fail(req);
+	}
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

