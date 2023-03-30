Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5166D0362
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjC3Lid (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjC3Lia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE319ECB
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0DTv4gl8fMLayIUkvMe05PQQKcmNOxgRlRQJo/UHTk=;
        b=GaYWEunEOGJ96sKqVBNGqvUpBkA75E9iaUrnI7llwvx3iTO6kvVfexsNgXKj0AQX1kTrD6
        0/szhv2h65XWYg3PnefDF3U1VK7bOKdb46R96HPa+WT4jhxgOvcyuBBHn1z2eqx4omQQ7q
        u22tCK8Lu4d4x8exX3+oeI66NmqEaEg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-0F5Xh6MCNryUTMXNPDqzxw-1; Thu, 30 Mar 2023 07:37:06 -0400
X-MC-Unique: 0F5Xh6MCNryUTMXNPDqzxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D6A21C0754C;
        Thu, 30 Mar 2023 11:37:06 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55D9DC15BA0;
        Thu, 30 Mar 2023 11:37:04 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V6 05/17] io_uring: support OP_READ/OP_WRITE for fused secondary request
Date:   Thu, 30 Mar 2023 19:36:18 +0800
Message-Id: <20230330113630.1388860-6-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Start to allow fused secondary request to support OP_READ/OP_WRITE, and
the buffer can be retrieved from the primary request.

Once the secondary request is completed, the primary request buffer will
be returned back.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/opdef.c |  4 ++++
 io_uring/rw.c    | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 63b90e8e65f8..d81c9afd65ed 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -235,6 +235,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.fused_secondary	= 1,
+		.buf_dir		= WRITE,
 		.prep			= io_prep_rw,
 		.issue			= io_read,
 	},
@@ -248,6 +250,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.fused_secondary	= 1,
+		.buf_dir		= READ,
 		.prep			= io_prep_rw,
 		.issue			= io_write,
 	},
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5431caf1e331..5ce7c8a2f74d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -19,6 +19,7 @@
 #include "kbuf.h"
 #include "rsrc.h"
 #include "rw.h"
+#include "fused_cmd.h"
 
 struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
@@ -371,6 +372,18 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 	size_t sqe_len;
 	ssize_t ret;
 
+	/*
+	 * fused_secondary OP passes buffer offset from sqe->addr actually, since
+	 * the fused cmd buf's mapped start address is zero.
+	 */
+	if (io_req_use_fused_buf(req)) {
+		ret = io_import_buf_from_fused(rw->addr, rw->len, ddir,
+				iter, req);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		ret = io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
 		if (ret)
@@ -443,11 +456,19 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 {
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
 	loff_t *ppos;
 
+	/*
+	 * Fused secondary req hasn't user buffer, so ->read/->write can't
+	 * be supported
+	 */
+	if (io_req_use_fused_buf(req))
+		return -EOPNOTSUPP;
+
 	/*
 	 * Don't support polled IO through this interface, and we can't
 	 * support non-blocking either. For the latter, this just causes
-- 
2.39.2

