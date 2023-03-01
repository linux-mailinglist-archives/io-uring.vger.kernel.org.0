Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D5C6A6DF1
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjCAOJV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCAOJO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:09:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B447C2DE43
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YhpzQlaHIrcPWh0ozP8XZ7+aBtM5xeXxoPc3fRNzGPY=;
        b=MagwIYPlDUghTDlYeN2UIgE7m4mWopv0h6kV5k6oi57JCaIehSF71QsAOfaxSNK1wOIPw2
        BYQz6sxn9dZ6Dr9NvR+/WX3SNiY5Wi6iyfNXydtXd/8LlHHBW2fAf1SwJ/t4afGJVKoMIo
        Bcl9zfuKNAtY36NSIBrJR/ynMohVO70=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-WBFGjnlaOVmES13dKljw6Q-1; Wed, 01 Mar 2023 09:08:23 -0500
X-MC-Unique: WBFGjnlaOVmES13dKljw6Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76CEF95E165;
        Wed,  1 Mar 2023 14:06:58 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B65C0492C14;
        Wed,  1 Mar 2023 14:06:57 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 09/12] io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
Date:   Wed,  1 Mar 2023 22:06:08 +0800
Message-Id: <20230301140611.163055-10-ming.lei@redhat.com>
In-Reply-To: <20230301140611.163055-1-ming.lei@redhat.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 io_uring/net.c   | 23 +++++++++++++++++++++--
 io_uring/opdef.c |  3 +++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cbd4b725f58c..be5ae5ca823d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "fused_cmd.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -378,7 +379,11 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	if (!(req->flags & REQ_F_FUSED_SLAVE))
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	else
+		ret = io_import_kbuf_for_slave((u64)sr->buf, sr->len,
+				ITER_SOURCE, &msg.msg_iter, req);
 	if (unlikely(ret))
 		return ret;
 
@@ -869,7 +874,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		sr->buf = buf;
 	}
 
-	ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
+	if (!(req->flags & REQ_F_FUSED_SLAVE))
+		ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
+	else
+		ret = io_import_kbuf_for_slave((u64)sr->buf, sr->len, ITER_DEST,
+				&msg.msg_iter, req);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -983,6 +992,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
 
+		if (req->flags & REQ_F_FUSED_SLAVE)
+			return -EINVAL;
+
 		if (unlikely(idx >= ctx->nr_user_bufs))
 			return -EFAULT;
 		idx = array_index_nospec(idx, ctx->nr_user_bufs);
@@ -1119,8 +1131,15 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret))
 			return ret;
 		msg.sg_from_iter = io_sg_from_iter;
+	} else if (req->flags & REQ_F_FUSED_SLAVE) {
+		ret = io_import_kbuf_for_slave((u64)zc->buf, zc->len,
+				ITER_SOURCE, &msg.msg_iter, req);
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
2.31.1

