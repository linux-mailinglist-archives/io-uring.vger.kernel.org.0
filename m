Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0A86D0374
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjC3Lje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjC3LjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:39:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C151319A9
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F7F6vbrS0gh77HT5XSUWKXsVAOVZJQ/PeMG00WEkJhQ=;
        b=JjcmF5ZobPPWQ5TAX5nvJrmsJY/6hmsZ1a3RS51ud03QnJzsADcP8cbhpGY+ZfCzjNy32T
        RiHOvRAJ7K5/azGzKQGk5GGB9k3li0O/wVhJvYchigqklkXS03Y1rCbDrrFc8FdQver2J8
        FUhxFn2R3dgpOy8aU8xeWQ4m+UIm+/c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-qJ6wA3vFNyqWH4EHtEt7Yw-1; Thu, 30 Mar 2023 07:37:38 -0400
X-MC-Unique: qJ6wA3vFNyqWH4EHtEt7Yw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 677B83815EF1;
        Thu, 30 Mar 2023 11:37:37 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F54B202701E;
        Thu, 30 Mar 2023 11:37:35 +0000 (UTC)
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
Subject: [PATCH V6 13/17] block: ublk_drv: grab request reference when the request is handled by userspace
Date:   Thu, 30 Mar 2023 19:36:26 +0800
Message-Id: <20230330113630.1388860-14-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add one reference counter into request pdu data, and hold this reference
in the request's lifetime. This way is always safe. In theory, the ublk
request won't be completed until fused commands are done. However, it
is userspace, and application can submit fused command at will.

Prepare for supporting zero copy, which needs to retrieve request buffer
by fused command, so we have to guarantee:

- the fused command can't succeed unless the request isn't queued

- when any fused command is successful, this request can't be freed
until all fused commands on this request are done.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 67 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index cca0e95a89d8..0dc8eb04b9a5 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -43,6 +43,7 @@
 #include <asm/page.h>
 #include <linux/task_work.h>
 #include <linux/namei.h>
+#include <linux/kref.h>
 #include <uapi/linux/ublk_cmd.h>
 
 #define UBLK_MINORS		(1U << MINORBITS)
@@ -62,6 +63,17 @@
 struct ublk_rq_data {
 	struct llist_node node;
 	struct callback_head work;
+
+	/*
+	 * Only for applying fused command to support zero copy:
+	 *
+	 * - if there is any fused command aiming at this request, not complete
+	 *   request until all fused commands are done
+	 *
+	 * - fused command has to fail unless this reference is grabbed
+	 *   successfully
+	 */
+	struct kref ref;
 };
 
 struct ublk_uring_cmd_pdu {
@@ -180,6 +192,9 @@ struct ublk_params_header {
 	__u32	types;
 };
 
+static inline void __ublk_complete_rq(struct request *req);
+static void ublk_complete_rq(struct kref *ref);
+
 static dev_t ublk_chr_devt;
 static struct class *ublk_chr_class;
 
@@ -288,6 +303,35 @@ static int ublk_apply_params(struct ublk_device *ub)
 	return 0;
 }
 
+static inline bool ublk_support_zc(const struct ublk_queue *ubq)
+{
+	return ubq->flags & UBLK_F_SUPPORT_ZERO_COPY;
+}
+
+static inline bool ublk_get_req_ref(const struct ublk_queue *ubq,
+		struct request *req)
+{
+	if (ublk_support_zc(ubq)) {
+		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+		return kref_get_unless_zero(&data->ref);
+	}
+
+	return true;
+}
+
+static inline void ublk_put_req_ref(const struct ublk_queue *ubq,
+		struct request *req)
+{
+	if (ublk_support_zc(ubq)) {
+		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+		kref_put(&data->ref, ublk_complete_rq);
+	} else {
+		__ublk_complete_rq(req);
+	}
+}
+
 static inline bool ublk_can_use_task_work(const struct ublk_queue *ubq)
 {
 	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&
@@ -632,13 +676,19 @@ static inline bool ubq_daemon_is_dying(struct ublk_queue *ubq)
 }
 
 /* todo: handle partial completion */
-static void ublk_complete_rq(struct request *req)
+static inline void __ublk_complete_rq(struct request *req)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	struct ublk_io *io = &ubq->ios[req->tag];
 	unsigned int unmapped_bytes;
 	blk_status_t res = BLK_STS_OK;
 
+	/* called from ublk_abort_queue() code path */
+	if (io->flags & UBLK_IO_FLAG_ABORTED) {
+		res = BLK_STS_IOERR;
+		goto exit;
+	}
+
 	/* failed read IO if nothing is read */
 	if (!io->res && req_op(req) == REQ_OP_READ)
 		io->res = -EIO;
@@ -678,6 +728,15 @@ static void ublk_complete_rq(struct request *req)
 	blk_mq_end_request(req, res);
 }
 
+static void ublk_complete_rq(struct kref *ref)
+{
+	struct ublk_rq_data *data = container_of(ref, struct ublk_rq_data,
+			ref);
+	struct request *req = blk_mq_rq_from_pdu(data);
+
+	__ublk_complete_rq(req);
+}
+
 /*
  * Since __ublk_rq_task_work always fails requests immediately during
  * exiting, __ublk_fail_req() is only called from abort context during
@@ -696,7 +755,7 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 		if (ublk_queue_can_use_recovery_reissue(ubq))
 			blk_mq_requeue_request(req, false);
 		else
-			blk_mq_end_request(req, BLK_STS_IOERR);
+			ublk_put_req_ref(ubq, req);
 	}
 }
 
@@ -734,6 +793,7 @@ static inline void __ublk_rq_task_work(struct request *req,
 				       unsigned issue_flags)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
 	int tag = req->tag;
 	struct ublk_io *io = &ubq->ios[tag];
 	unsigned int mapped_bytes;
@@ -805,6 +865,7 @@ static inline void __ublk_rq_task_work(struct request *req,
 			mapped_bytes >> 9;
 	}
 
+	kref_init(&data->ref);
 	ubq_complete_io_cmd(io, UBLK_IO_RES_OK, issue_flags);
 }
 
@@ -1017,7 +1078,7 @@ static void ublk_commit_completion(struct ublk_device *ub,
 	req = blk_mq_tag_to_rq(ub->tag_set.tags[qid], tag);
 
 	if (req && likely(!blk_should_fake_timeout(req->q)))
-		ublk_complete_rq(req);
+		ublk_put_req_ref(ubq, req);
 }
 
 /*
-- 
2.39.2

