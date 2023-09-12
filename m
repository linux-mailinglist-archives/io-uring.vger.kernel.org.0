Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65E879D77D
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbjILRZM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 13:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjILRZL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 13:25:11 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251C910D9
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:07 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34f17290a9cso7001055ab.1
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694539506; x=1695144306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhwDKUMlxs2yeRrM/DkIsCjwkJ4Tywn4ltEYD1AeANY=;
        b=v5UATE+wJ6dZ597NpNWmBYnSHBupGEPYCtwFmgEbliql224hG62Ansh4JlEQru5K5x
         cAGtNO3LOM9lV7JT9ILKH84uxVj790OibLhBvWel48msL1i3KtOOmC6LRCbSv527go3J
         CCulb3+BraSkQswhlBYHyGdPp5iPOktzzLzM0cGPGFgeE2qN3xgbL3HM8FZb23kxycbe
         TORMi68pyNOwW08v2yWf6L4efOBgpafZSD3m9tc+B9S2n8Bx9YqzSHOcEvHYAEYsnIE9
         2xneZuyXQMDPn5tmevpZ9/KY7q1U8NIviktWhbjQtinqTdDw51Q8CVuxth6QLYSBVS2j
         PbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694539506; x=1695144306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VhwDKUMlxs2yeRrM/DkIsCjwkJ4Tywn4ltEYD1AeANY=;
        b=gKwlga/nwkkX8Wq2PfT/pi+GRti3f2pAq8+JGkrCIuPnclZYvekMbmzcicRZI1XRz3
         LsjCkICfLv87Z4tRfFP0amvYtHGGZ0FMOHtMM3qTio/GFKm/3Y92B0HaSyhnVPihBPXr
         Mu7oA/+9R9VjyinYfLQGJgdyKlfQTK7S5H0dL46htEuLQf2peqgdUCYnMYkVnvqh6Xa0
         ZbP/DKgw+zIrOj9uvDlGMVvIAkTCLZPiOkEI6JFI3TpUczfGlDbp6Tm5UlQkTDHaZiJQ
         fnpk00MQS5e3lCPSgqINy1GdnUglpqJgzmNCkBYpndQqRGiaulDlv4kiJ+7O/mC2xnF3
         bN4g==
X-Gm-Message-State: AOJu0YzhNeg7I9pIBYoSqqlk2GrzhIDIP/PdXJyi4/5ckxIzB3zw1Dth
        fV3LhKE2Y20OeQzeJafIeOqTKNSqZT/8YhcyIhmv8Q==
X-Google-Smtp-Source: AGHT+IF+Qk70YPsYWGyazplgbkRJ5jQ6wXIeTQaRHF0OwvY/gls20uRKsXXSTlraHE1deXarIcHPiw==
X-Received: by 2002:a92:c9c2:0:b0:34f:7ba2:50e8 with SMTP id k2-20020a92c9c2000000b0034f7ba250e8mr197540ilq.2.1694539506088;
        Tue, 12 Sep 2023 10:25:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d4-20020a056e02214400b0034ac1a32fd9sm1777055ilv.44.2023.09.12.10.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:25:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, krisman@suse.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
Date:   Tue, 12 Sep 2023 11:24:58 -0600
Message-Id: <20230912172458.1646720-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230912172458.1646720-1-axboe@kernel.dk>
References: <20230912172458.1646720-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This behaves like IORING_OP_READ, except:

1) It only supports pollable files (eg pipes, sockets, etc). Note that
   for sockets, you probably want to use recv/recvmsg with multishot
   instead.

2) It supports multishot mode, meaning it will repeatedly trigger a
   read and fill a buffer when data is available. This allows similar
   use to recv/recvmsg but on non-sockets, where a single request will
   repeatedly post a CQE whenever data is read from it.

3) Because of #2, it must be used with provided buffers. This is
   uniformly true across any request type that supports multishot and
   transfers data, with the reason being that it's obviously not
   possible to pass in a single buffer for the data, as multiple reads
   may very well trigger before an application has a chance to process
   previous CQEs and the data passed from them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              | 12 ++++++
 io_uring/rw.c                 | 73 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 |  2 +
 4 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index daa363d1a502..c35438af679a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -246,6 +246,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
+	IORING_OP_READ_MULTISHOT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index bfb7c53389c0..74b3c1ef22b0 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -460,6 +460,15 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READ_MULTISHOT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.audit_skip		= 1,
+		.prep			= io_read_mshot_prep,
+		.issue			= io_read_mshot,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -692,6 +701,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_READ_MULTISHOT] = {
+		.name			= "READ_MULTISHOT",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c3bf38419230..ec0cc38ea682 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -123,6 +123,22 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+/*
+ * Multishot read is prepared just like a normal read/write request, only
+ * difference is that we set the MULTISHOT flag.
+ */
+int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = io_prep_rw(req, sqe);
+	if (unlikely(ret))
+		return ret;
+
+	req->flags |= REQ_F_APOLL_MULTISHOT;
+	return 0;
+}
+
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
@@ -863,10 +879,61 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	ret = __io_read(req, issue_flags);
-	if (unlikely(ret < 0))
-		return ret;
+	if (ret >= 0)
+		return kiocb_done(req, ret, issue_flags);
+
+	return ret;
+}
+
+int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
+{
+	unsigned int cflags = 0;
+	int ret;
+
+	/*
+	 * Multishot MUST be used on a pollable file
+	 */
+	if (!file_can_poll(req->file))
+		return -EBADFD;
+
+	ret = __io_read(req, issue_flags);
+
+	/*
+	 * If we get -EAGAIN, recycle our buffer and just let normal poll
+	 * handling arm it.
+	 */
+	if (ret == -EAGAIN) {
+		io_kbuf_recycle(req, issue_flags);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Any successful return value will keep the multishot read armed.
+	 */
+	if (ret > 0) {
+		/*
+		 * Put our buffer and post a CQE. If we fail to post a CQE, then
+		 * jump to the termination path. This request is then done.
+		 */
+		cflags = io_put_kbuf(req, issue_flags);
+
+		if (io_fill_cqe_req_aux(req,
+					issue_flags & IO_URING_F_COMPLETE_DEFER,
+					ret, cflags | IORING_CQE_F_MORE)) {
+			if (issue_flags & IO_URING_F_MULTISHOT)
+				return IOU_ISSUE_SKIP_COMPLETE;
+			return -EAGAIN;
+		}
+	}
 
-	return kiocb_done(req, ret, issue_flags);
+	/*
+	 * Either an error, or we've hit overflow posting the CQE. For any
+	 * multishot request, hitting overflow will terminate it.
+	 */
+	io_req_set_res(req, ret, cflags);
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		return IOU_STOP_MULTISHOT;
+	return IOU_OK;
 }
 
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 4b89f9659366..c5aed03d42a4 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -23,3 +23,5 @@ int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);
+int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.40.1

