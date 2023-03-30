Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898246D0368
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjC3Lja (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjC3LjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:39:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950979EEA
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VFZ4HTDXQ9j9mvF7AZrrlFzXBT77MGX93ZTMUgSaoQU=;
        b=Sf938ObsnVvDcUkpicL6eWfttAGXp6Z+ykYxNXIWhOf8xW6mXiQSfGlrj+JwHEe/mq082q
        t16JekFoSGaztBo28q3Vv/WnQe3meMNkaDW7PUEO10OMBuRAH1xw3bcuhDNxWycF6q56Vq
        SKkCsU1g9Lv8CjqEJ3kIdOOuri5E5so=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-5dSRH69cN2WxjCzoc7DlOA-1; Thu, 30 Mar 2023 07:37:11 -0400
X-MC-Unique: 5dSRH69cN2WxjCzoc7DlOA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 532C3101A552;
        Thu, 30 Mar 2023 11:37:10 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BB562166B33;
        Thu, 30 Mar 2023 11:37:08 +0000 (UTC)
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
Subject: [PATCH V6 06/17] io_uring: support OP_SEND_ZC/OP_RECV for fused secondary request
Date:   Thu, 30 Mar 2023 19:36:19 +0800
Message-Id: <20230330113630.1388860-7-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Start to allow fused secondary request to support OP_SEND_ZC/OP_RECV, and
the buffer can be retrieved from primary request.

Once secondary request is completed, the primary command will be done and
the associated buffer is returned back.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/net.c   | 30 ++++++++++++++++++++++++++++--
 io_uring/opdef.c |  6 ++++++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4040cf093318..f0fce1db7596 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "fused_cmd.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -69,6 +70,13 @@ struct io_sr_msg {
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
@@ -379,7 +387,11 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	if (!io_req_use_fused_buf(req))
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	else
+		ret = io_import_buf_from_fused(user_ptr_to_u64(sr->buf),
+				sr->len, ITER_SOURCE, &msg.msg_iter, req);
 	if (unlikely(ret))
 		return ret;
 
@@ -870,7 +882,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		sr->buf = buf;
 	}
 
-	ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
+	if (!io_req_use_fused_buf(req))
+		ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
+	else
+		ret = io_import_buf_from_fused(user_ptr_to_u64(sr->buf),
+				sr->len, ITER_DEST, &msg.msg_iter, req);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -984,6 +1000,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
 
+		if (io_req_use_fused_buf(req))
+			return -EINVAL;
+
 		if (unlikely(idx >= ctx->nr_user_bufs))
 			return -EFAULT;
 		idx = array_index_nospec(idx, ctx->nr_user_bufs);
@@ -1120,8 +1139,15 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret))
 			return ret;
 		msg.sg_from_iter = io_sg_from_iter;
+	} else if (io_req_use_fused_buf(req)) {
+		ret = io_import_buf_from_fused(user_ptr_to_u64(zc->buf),
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
index d81c9afd65ed..c31badf4fe45 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -273,6 +273,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.fused_secondary	= 1,
+		.buf_dir		= READ,
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
@@ -287,6 +289,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.fused_secondary	= 1,
+		.buf_dir		= WRITE,
 #if defined(CONFIG_NET)
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recv,
@@ -413,6 +417,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.fused_secondary	= 1,
+		.buf_dir		= READ,
 #if defined(CONFIG_NET)
 		.prep			= io_send_zc_prep,
 		.issue			= io_send_zc,
-- 
2.39.2

