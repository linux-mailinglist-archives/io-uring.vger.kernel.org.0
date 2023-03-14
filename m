Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C606B9608
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 14:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCNNZQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 09:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjCNNYy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 09:24:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADFD6A1DF
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 06:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678800001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfHLB2ox6YkOqgmUOX+NH1p6r+yw7PXTLeUMAg6Gpb8=;
        b=b0+vVp47HaX1iU1/qyuUjEGU1m8wKFuUMDJih+1xfYr4zpFRySg3zmpqpPtWXToH35FYSZ
        OfEFs5rWQ/BpL9kYubpjZ2tv2q6M9f3HBq7hCxX155IiZnBLUs17+//cIn6N4dFXy2Iach
        QK68qopDXUpfbjappN4bm+MZT7GGvXk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-BvsCLfoVOQSIs7RBjoSfqg-1; Tue, 14 Mar 2023 08:57:51 -0400
X-MC-Unique: BvsCLfoVOQSIs7RBjoSfqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05ADD1C0878B;
        Tue, 14 Mar 2023 12:57:50 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A24E40C6E69;
        Tue, 14 Mar 2023 12:57:48 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 04/16] io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
Date:   Tue, 14 Mar 2023 20:57:15 +0800
Message-Id: <20230314125727.1731233-5-ming.lei@redhat.com>
In-Reply-To: <20230314125727.1731233-1-ming.lei@redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Start to allow fused slave request to support OP_SEND_ZC/OP_RECV, and
the buffer can be retrieved from master request.

Once the slave request is completed, the master buffer will be returned
back.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/net.c   | 30 ++++++++++++++++++++++++++++--
 io_uring/opdef.c |  3 +++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index b7f190ca528e..78fb2d08ecd0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "fused_cmd.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -68,6 +69,13 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+#define user_ptr_to_u64(x) (		\
+{					\
+	typecheck(void __user *, (x));		\
+	(u64)(unsigned long)(x);	\
+}					\
+)
+
 static inline bool io_check_multishot(struct io_kiocb *req,
 				      unsigned int issue_flags)
 {
@@ -378,7 +386,11 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	if (!(req->flags & REQ_F_FUSED_SLAVE))
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	else
+		ret = io_import_kbuf_for_slave(user_ptr_to_u64(sr->buf),
+				sr->len, ITER_SOURCE, &msg.msg_iter, req);
 	if (unlikely(ret))
 		return ret;
 
@@ -869,7 +881,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		sr->buf = buf;
 	}
 
-	ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
+	if (!(req->flags & REQ_F_FUSED_SLAVE))
+		ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
+	else
+		ret = io_import_kbuf_for_slave(user_ptr_to_u64(sr->buf),
+				sr->len, ITER_DEST, &msg.msg_iter, req);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -983,6 +999,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
 
+		if (req->flags & REQ_F_FUSED_SLAVE)
+			return -EINVAL;
+
 		if (unlikely(idx >= ctx->nr_user_bufs))
 			return -EFAULT;
 		idx = array_index_nospec(idx, ctx->nr_user_bufs);
@@ -1119,8 +1138,15 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret))
 			return ret;
 		msg.sg_from_iter = io_sg_from_iter;
+	} else if (req->flags & REQ_F_FUSED_SLAVE) {
+		ret = io_import_kbuf_for_slave(user_ptr_to_u64(zc->buf),
+				zc->len, ITER_SOURCE, &msg.msg_iter, req);
+		if (unlikely(ret))
+			return ret;
+		msg.sg_from_iter = io_sg_from_iter;
 	} else {
 		io_notif_set_extended(zc->notif);
+
 		ret = import_ubuf(ITER_SOURCE, zc->buf, zc->len, &msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index f044629e5475..0a9d39a9db16 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -271,6 +271,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.fused_slave		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
@@ -285,6 +286,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.fused_slave		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recv,
@@ -411,6 +413,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.fused_slave		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_send_zc_prep,
 		.issue			= io_send_zc,
-- 
2.39.2

