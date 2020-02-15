Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C331600CC
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgBOWCb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:02:31 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52438 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgBOWCa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:02:30 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so13554054wmc.2;
        Sat, 15 Feb 2020 14:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IV/9B3Yx7DxWj2ay4TCvf//kkqx4h0S14kvTJLNGCoU=;
        b=snRED7zDyjFqGmvzUOfzOBaDoCh/gMgHvdME2fUYjQMU1b5xbGoGmtXgf6qfjgJvqZ
         sMCP6sw/bEn3JgdXIJVGDvMHCpJMc7ZSxZUlORCElVGl0glPvTs6vsKOgiG9T52CVuoc
         4jog2yKMKXbl5jKvpwRKk52hb/VYIHKKDrEPWB+7Uo+9c2zFvz4GzkCA1hrZLDMOSWTh
         HzrhwGXhBiDLkAAp5049EDtZ8ZG8QeKc66RTKFTMttCXZMBt4wmTmPoGoFzIMmruqfK0
         ObZDGN4ZhwUXw4HDkLOuS4OQ4ZWaANwby0VAwKZs9QlnaNERmPnknvVk0PfFR8eBuYZM
         ivwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IV/9B3Yx7DxWj2ay4TCvf//kkqx4h0S14kvTJLNGCoU=;
        b=Dz7tyTO2cKbP/C8Ua5ujC0MCI8a9OGPGrj0AyrKP07lqF6OImxc6ZcENRRRmmB/G+6
         JkR038BDeEaagmSQ9oqWhiBPhlo7Sr4atNVoPw+YMQYskm4d7GYxyr4vT6ZA6n8XE21q
         kWpLkWjhokaXbV6LNH8Il+TBoyanLesSy8O8ultTH3Hxi9n81iM30pxXRcLwsbFzZpjV
         /dt6MKDXywVGZ4QIMHQSHvaoKG0MPrZxFwISBkPtnSRAai7hGgX4Tj+zT17CunIhDcIV
         sqAQx+KagVuqqd/gVTI7BVy049+VOY+atXnaU5DpXnCLDCTDizc3QLgDw4cQ/7MWQtX4
         3//A==
X-Gm-Message-State: APjAAAV2Lq0PEWLnoQNtonfYJTBu8QvaPSEneNzvGE9FQU8Ob+GHAmAf
        vQLIpEc5lUwXx4T2O3AWZjE=
X-Google-Smtp-Source: APXvYqybPpxgVAKXj1XA0NpQQb/RGjPWGZ1iJJmkORAMr5cpkxYp/2Ddh/U3VXyrinF6QOxyFge17Q==
X-Received: by 2002:a1c:491:: with SMTP id 139mr12622503wme.117.1581804147230;
        Sat, 15 Feb 2020 14:02:27 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id b18sm13377021wru.50.2020.02.15.14.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:02:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] io_uring: don't do full *prep_worker() from io-wq
Date:   Sun, 16 Feb 2020 01:01:21 +0300
Message-Id: <b1d0bfedb3d30f406a1adbd34a3ef52cc23764d2.1581785642.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581785642.git.asml.silence@gmail.com>
References: <cover.1581785642.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_prep_async_worker() called io_wq_assign_next() do many useless checks:
io_req_work_grab_env() was already called during prep, and @do_hashed
is not ever used. Add io_prep_next_work() -- simplified version, that
can be called io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0dd2f10d8ad8..4515db6a64d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -952,6 +952,17 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
+static inline void io_prep_next_work(struct io_kiocb *req,
+				     struct io_kiocb **link)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
+	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+
+	*link = io_prep_linked_timeout(req);
+}
+
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -2459,7 +2470,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
 
-	io_prep_async_work(nxt, &link);
+	io_prep_next_work(nxt, &link);
 	*workptr = &nxt->work;
 	if (link) {
 		nxt->work.flags |= IO_WQ_WORK_CB;
-- 
2.24.0

