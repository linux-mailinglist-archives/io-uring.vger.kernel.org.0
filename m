Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D49B6C7F3F
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjCXOAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 10:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjCXN7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 09:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F8915CB1
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 06:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=97jH9oZY/nZ/Q7njPQq53hgrYxqtyPQC3OYlAlAsaNY=;
        b=c4PWe54Vh6z5ZuW/Pfsk6Ojt4ZgYtHG5IGZiCgd4dIywq6M1rbkcJeHs9ZN2Iq440b8d8a
        R1nKFxiHwGnqJSamGH+TKEdl7VdrAuEOErkq+i1bUN5onC1UXyTfUr2l27zpJQm/T37jOw
        q2cS//wgcpHXAlxjz0ftmPW8F1McNKQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-z2fEdsF5Ov6b0InxriGYoQ-1; Fri, 24 Mar 2023 09:58:38 -0400
X-MC-Unique: z2fEdsF5Ov6b0InxriGYoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 973B48030D1;
        Fri, 24 Mar 2023 13:58:35 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAB70140E96A;
        Fri, 24 Mar 2023 13:58:34 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 04/17] io_uring: support OP_READ/OP_WRITE for fused slave request
Date:   Fri, 24 Mar 2023 21:57:55 +0800
Message-Id: <20230324135808.855245-5-ming.lei@redhat.com>
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Start to allow fused slave request to support OP_READ/OP_WRITE, and
the buffer can be retrieved from master request.

Once the slave request is completed, the master buffer will be returned
back.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/opdef.c |  4 ++++
 io_uring/rw.c    | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 63b90e8e65f8..9b376df91abd 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -235,6 +235,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.fused_slave		= 1,
+		.buf_dir		= WRITE,
 		.prep			= io_prep_rw,
 		.issue			= io_read,
 	},
@@ -248,6 +250,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.fused_slave		= 1,
+		.buf_dir		= READ,
 		.prep			= io_prep_rw,
 		.issue			= io_write,
 	},
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c233910e200..0c292ef9a40f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -19,6 +19,7 @@
 #include "kbuf.h"
 #include "rsrc.h"
 #include "rw.h"
+#include "fused_cmd.h"
 
 struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
@@ -371,6 +372,17 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 	size_t sqe_len;
 	ssize_t ret;
 
+	/*
+	 * SLAVE OP passes buffer offset from sqe->addr actually, since
+	 * the fused cmd kbuf's mapped start address is zero.
+	 */
+	if (req->flags & REQ_F_FUSED_SLAVE) {
+		ret = io_import_buf_for_slave(rw->addr, rw->len, ddir, iter, req);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		ret = io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
 		if (ret)
@@ -428,11 +440,19 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 {
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
 	loff_t *ppos;
 
+	/*
+	 * Fused slave req hasn't user buffer, so ->read/->write can't
+	 * be supported
+	 */
+	if (req->flags & REQ_F_FUSED_SLAVE)
+		return -EOPNOTSUPP;
+
 	/*
 	 * Don't support polled IO through this interface, and we can't
 	 * support non-blocking either. For the latter, this just causes
-- 
2.39.2

