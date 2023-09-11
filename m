Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D136579B52C
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358425AbjIKWKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244555AbjIKUki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 16:40:38 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A00127
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68fd6dcb6c8so131299b3a.1
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694464830; x=1695069630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5d7pLYJCHN5fqfnPez7rv1tfEDXGnkJm4TIMr7pJ0w=;
        b=hAV5Ah9Yr9OSl7G7aVqoGqDuMouvli7bwpmR64n9+GaPhCeymbfx03qUWcj45rvb/G
         JDunyg6swnCT4D3BoOi6tthH7/9vDY4KCGKqEk6q3YsUadd2E16mXGQ4Ah8SjXEexTYQ
         AdbV47KSo273Sq8K9zg+3sGfZxYlqce1+pMWEE1veZKba7J3Vs0Z+uFXXDbCd1rkZGSh
         9P9uqQ0NacSxk9hWMKPr8pEyUf3TBnqaoTUbwVa56Ljsxf1z32rmCxDVOKuP72KsvB5x
         IqQSXZYTto/HuIv+S7IzEnhYBA1ZMTJFTBJAHYyGdK0DRVVCfOM1Op6UdF/CIiKPUNZi
         H4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694464830; x=1695069630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5d7pLYJCHN5fqfnPez7rv1tfEDXGnkJm4TIMr7pJ0w=;
        b=EIdGdE/pX2qJuZ5GnHTnHvx0FkR2MB92BNdW7KdUUlKLvX27nCuzWwGxmJE7cApRch
         DdEfC6obBZ8bM/pfwtuaDoDLojBd8nOTNypNdimO6ad4LTDBE3xeuMA5BI5dvOyDw1YE
         koSZa8bpPZbxRn0z/D49b6dOTh5f4hbq2aQui5Agvtyg0XlbPPeqtT5AXvWANR8RnIVq
         jTE+mTm6nEkHsb5ngMqA4ZFy4/0gtFcYA0yTwFyrVbwONJ8yZsi/ooP0xBLl9nAOZDYc
         0fOqIVfXpzIMK7+PDPqnjBbfM2XWh1q3BJHEobXYRVQV+HSlRvqqwXORxqQN0pE849vQ
         9JlA==
X-Gm-Message-State: AOJu0YwcLUyN8l9OrvajNZLcXrDRIpPr3veu7mbT8CpX3v93gSEZ7g26
        8XKHFXQom678F5VXfbWpb/vM0TJmZUcXAUFCzBJ5EQ==
X-Google-Smtp-Source: AGHT+IEzf83Tr7NQFpIW/uH4lXYhiohpOjHx+S8QBAKq7EVnCR4q9Wbn2WmYugONdeKgY44gQlD5GQ==
X-Received: by 2002:a05:6a00:158e:b0:68e:3eff:e93a with SMTP id u14-20020a056a00158e00b0068e3effe93amr11574230pfk.2.1694464829789;
        Mon, 11 Sep 2023 13:40:29 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ef22-20020a056a002c9600b0068fe5a5a566sm100544pfb.142.2023.09.11.13.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 13:40:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
Date:   Mon, 11 Sep 2023 14:40:21 -0600
Message-Id: <20230911204021.1479172-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911204021.1479172-1-axboe@kernel.dk>
References: <20230911204021.1479172-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 io_uring/opdef.c              | 13 +++++++
 io_uring/rw.c                 | 66 +++++++++++++++++++++++++++++++++++
 io_uring/rw.h                 |  2 ++
 4 files changed, 82 insertions(+)

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
index bfb7c53389c0..03e1a6f26fa5 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -460,6 +460,16 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READ_MULTISHOT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.prep			= io_read_mshot_prep,
+		.issue			= io_read_mshot,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -692,6 +702,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_READ_MULTISHOT] = {
+		.name			= "READ_MULTISHOT",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c3bf38419230..7305792fbbbf 100644
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
@@ -869,6 +885,56 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	return kiocb_done(req, ret, issue_flags);
 }
 
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
+	 * Any error will terminate a multishot request
+	 */
+	if (ret <= 0) {
+finish:
+		io_req_set_res(req, ret, cflags);
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_STOP_MULTISHOT;
+		return IOU_OK;
+	}
+
+	/*
+	 * Put our buffer and post a CQE. If we fail to post a CQE, then
+	 * jump to the termination path. This request is then done.
+	 */
+	cflags = io_put_kbuf(req, issue_flags);
+
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				ret, cflags | IORING_CQE_F_MORE)) {
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_ISSUE_SKIP_COMPLETE;
+		else
+			return -EAGAIN;
+	}
+
+	goto finish;
+}
+
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
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

