Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296646CC584
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjC1POt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjC1POd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:14:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FC510403
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680016320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epgMYPHiL/drcoyXP4r134WY88eox9+1YtvoGLQRluU=;
        b=G1u8eihCT1m68Qg029d/4S+WrN1nTgtsuGmWA+8sOYmbWDqunwvoiPx0kROmMyApjFnbf7
        fuca2TWuY8mTyeKSdIAe7Kg7U1n9GpbWRbFr/xpes1sWY3wLIbBY1GnokxD9ihec4BL0bK
        pMtxZd4C1+pSh33nXCnPAL8/ZxaspX8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-NUuhNtO5O_SR8Ng9fEVPbQ-1; Tue, 28 Mar 2023 11:11:54 -0400
X-MC-Unique: NUuhNtO5O_SR8Ng9fEVPbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6211B887403;
        Tue, 28 Mar 2023 15:11:53 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57D7E4020C82;
        Tue, 28 Mar 2023 15:11:51 +0000 (UTC)
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
Subject: [PATCH V5 14/16] block: ublk_drv: add read()/write() support for ublk char device
Date:   Tue, 28 Mar 2023 23:09:56 +0800
Message-Id: <20230328150958.1253547-15-ming.lei@redhat.com>
In-Reply-To: <20230328150958.1253547-1-ming.lei@redhat.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We are going to support zero copy by fused uring command, the userspace
can't read from or write to the io buffer any more, it becomes not
flexible for applications:

1) some targets need to zero buffer explicitly, such as when reading
unmapped qcow2 cluster

2) some targets need to support passthrough command, such as zoned
report zones, and still need to read/write the io buffer

Support pread()/pwrite() on ublk char device for reading/writing request
io buffer, so ublk server can handle the above cases easily.

This also can help to make zero copy becoming the primary option, and
non-zero-copy will become legacy code path since the added read()/write()
can cover non-zero-copy feature.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 131 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ublk_cmd.h |  31 +++++++-
 2 files changed, 161 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 32304942ab87..03ad33686808 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1322,6 +1322,36 @@ static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
 	ublk_queue_cmd(ubq, req);
 }
 
+static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
+		struct ublk_queue *ubq, int tag, size_t offset)
+{
+	struct request *req;
+
+	if (!ublk_support_zc(ubq))
+		return NULL;
+
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
+	if (!req)
+		return NULL;
+
+	if (!ublk_get_req_ref(ubq, req))
+		return NULL;
+
+	if (unlikely(!blk_mq_request_started(req) || req->tag != tag))
+		goto fail_put;
+
+	if (!ublk_rq_has_data(req))
+		goto fail_put;
+
+	if (offset > blk_rq_bytes(req))
+		goto fail_put;
+
+	return req;
+fail_put:
+	ublk_put_req_ref(ubq, req);
+	return NULL;
+}
+
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
@@ -1423,11 +1453,112 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -EIOCBQUEUED;
 }
 
+static inline bool ublk_check_ubuf_dir(const struct request *req,
+		int ubuf_dir)
+{
+	/* copy ubuf to request pages */
+	if (req_op(req) == REQ_OP_READ && ubuf_dir == ITER_SOURCE)
+		return true;
+
+	/* copy request pages to ubuf */
+	if (req_op(req) == REQ_OP_WRITE && ubuf_dir == ITER_DEST)
+		return true;
+
+	return false;
+}
+
+static struct request *ublk_check_and_get_req(struct kiocb *iocb,
+		struct iov_iter *iter, size_t *off, int dir)
+{
+	struct ublk_device *ub = iocb->ki_filp->private_data;
+	struct ublk_queue *ubq;
+	struct request *req;
+	size_t buf_off;
+	u16 tag, q_id;
+
+	if (!ub)
+		return ERR_PTR(-EACCES);
+
+	if (!user_backed_iter(iter))
+		return ERR_PTR(-EACCES);
+
+	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
+		return ERR_PTR(-EACCES);
+
+	tag = ublk_pos_to_tag(iocb->ki_pos);
+	q_id = ublk_pos_to_hwq(iocb->ki_pos);
+	buf_off = ublk_pos_to_buf_offset(iocb->ki_pos);
+
+	if (q_id >= ub->dev_info.nr_hw_queues)
+		return ERR_PTR(-EINVAL);
+
+	ubq = ublk_get_queue(ub, q_id);
+	if (!ubq)
+		return ERR_PTR(-EINVAL);
+
+	if (tag >= ubq->q_depth)
+		return ERR_PTR(-EINVAL);
+
+	req = __ublk_check_and_get_req(ub, ubq, tag, buf_off);
+	if (!req)
+		return ERR_PTR(-EINVAL);
+
+	if (!req->mq_hctx || !req->mq_hctx->driver_data)
+		goto fail;
+
+	if (!ublk_check_ubuf_dir(req, dir))
+		goto fail;
+
+	*off = buf_off;
+	return req;
+fail:
+	ublk_put_req_ref(ubq, req);
+	return ERR_PTR(-EACCES);
+}
+
+static ssize_t ublk_ch_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct ublk_queue *ubq;
+	struct request *req;
+	size_t buf_off;
+	size_t ret;
+
+	req = ublk_check_and_get_req(iocb, to, &buf_off, ITER_DEST);
+	if (unlikely(IS_ERR(req)))
+		return PTR_ERR(req);
+
+	ret = ublk_copy_user_pages(req, buf_off, to, ITER_DEST);
+	ubq = req->mq_hctx->driver_data;
+	ublk_put_req_ref(ubq, req);
+
+	return ret;
+}
+
+static ssize_t ublk_ch_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct ublk_queue *ubq;
+	struct request *req;
+	size_t buf_off;
+	size_t ret;
+
+	req = ublk_check_and_get_req(iocb, from, &buf_off, ITER_SOURCE);
+	if (unlikely(IS_ERR(req)))
+		return PTR_ERR(req);
+
+	ret = ublk_copy_user_pages(req, buf_off, from, ITER_SOURCE);
+	ubq = req->mq_hctx->driver_data;
+	ublk_put_req_ref(ubq, req);
+
+	return ret;
+}
+
 static const struct file_operations ublk_ch_fops = {
 	.owner = THIS_MODULE,
 	.open = ublk_ch_open,
 	.release = ublk_ch_release,
 	.llseek = no_llseek,
+	.read_iter = ublk_ch_read_iter,
+	.write_iter = ublk_ch_write_iter,
 	.uring_cmd = ublk_ch_uring_cmd,
 	.mmap = ublk_ch_mmap,
 };
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index f6238ccc7800..d1a6b3dc0327 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -54,7 +54,36 @@
 #define UBLKSRV_IO_BUF_OFFSET	0x80000000
 
 /* tag bit is 12bit, so at most 4096 IOs for each queue */
-#define UBLK_MAX_QUEUE_DEPTH	4096
+#define UBLK_TAG_BITS		12
+#define UBLK_MAX_QUEUE_DEPTH	(1U << UBLK_TAG_BITS)
+
+/* used for locating each io buffer for pread()/pwrite() on char device */
+#define UBLK_BUFS_SIZE_BITS	42
+#define UBLK_BUFS_SIZE_MASK    ((1ULL << UBLK_BUFS_SIZE_BITS) - 1)
+#define UBLK_BUF_SIZE_BITS     (UBLK_BUFS_SIZE_BITS - UBLK_TAG_BITS)
+#define UBLK_BUF_MAX_SIZE      (1ULL << UBLK_BUF_SIZE_BITS)
+
+static inline __u16 ublk_pos_to_hwq(__u64 pos)
+{
+	return pos >> UBLK_BUFS_SIZE_BITS;
+}
+
+static inline __u32 ublk_pos_to_buf_offset(__u64 pos)
+{
+	return (pos & UBLK_BUFS_SIZE_MASK) & (UBLK_BUF_MAX_SIZE - 1);
+}
+
+static inline __u16 ublk_pos_to_tag(__u64 pos)
+{
+	return (pos & UBLK_BUFS_SIZE_MASK) >> UBLK_BUF_SIZE_BITS;
+}
+
+/* offset of single buffer, which has to be < UBLK_BUX_MAX_SIZE */
+static inline __u64 ublk_pos(__u16 q_id, __u16 tag, __u32 offset)
+{
+	return (((__u64)q_id) << UBLK_BUFS_SIZE_BITS) |
+		((((__u64)tag) << UBLK_BUF_SIZE_BITS) + offset);
+}
 
 /*
  * zero copy requires 4k block size, and can remap ublk driver's io
-- 
2.39.2

