Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9E692247
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 16:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjBJPdu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 10:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjBJPdr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 10:33:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A66675F63
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676043181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VW4k8Jn1GSK+lEHPRwD0ODmsDud93vde0Du4DHS3F8w=;
        b=d6a8qWrpi3JeltqzKhtIX/tt1TBsaxVna5ahlxQj6d6V+smHUpJUHpenjsiDLtxTR+mLkx
        J7V2sFpwWn/oYBB5rBg56fs95OHSMfo9+EOzoBA8LRib9GQ5aKb3S7QNP6mqvmWEzdogYw
        tWxgxzURwrERwb/GfhfNs28IlI2momI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-tBE59yxQMBqLOhGiq_LSKA-1; Fri, 10 Feb 2023 10:32:58 -0500
X-MC-Unique: tBE59yxQMBqLOhGiq_LSKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A315A81172A;
        Fri, 10 Feb 2023 15:32:57 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AF042166B29;
        Fri, 10 Feb 2023 15:32:56 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Date:   Fri, 10 Feb 2023 23:32:11 +0800
Message-Id: <20230210153212.733006-4-ming.lei@redhat.com>
In-Reply-To: <20230210153212.733006-1-ming.lei@redhat.com>
References: <20230210153212.733006-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_READ_SPLICE_BUF: read to buffer which is built from
->read_splice() of specified fd, so user needs to provide (splice_fd, offset, len)
for building buffer.

IORING_OP_WRITE_SPLICE_BUF: write from buffer which is built from
->read_splice() of specified fd, so user needs to provide (splice_fd, offset, len)
for building buffer.

The typical use case is for supporting ublk/fuse io_uring zero copy,
and READ/WRITE OP retrieves ublk/fuse request buffer via direct pipe
from device->read_splice(), then READ/WRITE can be done to/from this
buffer directly.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |   2 +
 io_uring/opdef.c              |  37 ++++++++
 io_uring/rw.c                 | 174 +++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 |   1 +
 4 files changed, 213 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 636a4c2c1294..bada0c91a350 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,8 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_READ_SPLICE_BUF,
+	IORING_OP_WRITE_SPLICE_BUF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 5238ecd7af6a..91e8d8f96134 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -427,6 +427,31 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READ_SPLICE_BUF] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.prep			= io_prep_rw,
+		.issue			= io_read,
+	},
+	[IORING_OP_WRITE_SPLICE_BUF] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.prep			= io_prep_rw,
+		.issue			= io_write,
+	},
 };
 
 
@@ -647,6 +672,18 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_READ_SPLICE_BUF] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "READ_TO_SPLICE_BUF",
+		.cleanup		= io_read_write_cleanup,
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITE_SPLICE_BUF] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "WRITE_FROM_SPICE_BUF",
+		.cleanup		= io_read_write_cleanup,
+		.fail			= io_rw_fail,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index efe6bfda9ca9..381514fd1bc5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -73,6 +73,175 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 	return 0;
 }
 
+struct io_rw_splice_buf_data {
+	unsigned long total;
+	unsigned int  max_bvecs;
+	struct io_mapped_ubuf **imu;
+};
+
+/* the max size of whole 'io_mapped_ubuf' allocation is one page */
+static inline unsigned int io_rw_max_splice_buf_bvecs(void)
+{
+	return (PAGE_SIZE - sizeof(struct io_mapped_ubuf)) /
+			sizeof(struct bio_vec);
+}
+
+static inline unsigned int io_rw_splice_buf_nr_bvecs(unsigned long len)
+{
+	return min_t(unsigned int, (len + PAGE_SIZE - 1) >> PAGE_SHIFT,
+			io_rw_max_splice_buf_bvecs());
+}
+
+static inline bool io_rw_splice_buf(struct io_kiocb *req)
+{
+	return req->opcode == IORING_OP_READ_SPLICE_BUF ||
+		req->opcode == IORING_OP_WRITE_SPLICE_BUF;
+}
+
+static void io_rw_cleanup_splice_buf(struct io_kiocb *req)
+{
+	struct io_mapped_ubuf *imu = req->imu;
+	int i;
+
+	if (!imu)
+		return;
+
+	for (i = 0; i < imu->nr_bvecs; i++)
+		put_page(imu->bvec[i].bv_page);
+
+	req->imu = NULL;
+	kfree(imu);
+}
+
+static int io_splice_buf_actor(struct pipe_inode_info *pipe,
+			       struct pipe_buffer *buf,
+			       struct splice_desc *sd)
+{
+	struct io_rw_splice_buf_data *data = sd->u.data;
+	struct io_mapped_ubuf *imu = *data->imu;
+	struct bio_vec *bvec;
+
+	if (imu->nr_bvecs >= data->max_bvecs) {
+		/*
+		 * Double bvec allocation given we don't know
+		 * how many remains
+		 */
+		unsigned nr_bvecs = min(data->max_bvecs * 2,
+				io_rw_max_splice_buf_bvecs());
+		struct io_mapped_ubuf *new_imu;
+
+		/* can't grow, given up */
+		if (nr_bvecs <= data->max_bvecs)
+			return 0;
+
+		new_imu = krealloc(imu, struct_size(imu, bvec, nr_bvecs),
+				GFP_KERNEL);
+		if (!new_imu)
+			return -ENOMEM;
+		imu = new_imu;
+		data->max_bvecs = nr_bvecs;
+		*data->imu = imu;
+	}
+
+	if (!try_get_page(buf->page))
+		return -EINVAL;
+
+	bvec = &imu->bvec[imu->nr_bvecs];
+	bvec->bv_page = buf->page;
+	bvec->bv_offset = buf->offset;
+	bvec->bv_len = buf->len;
+	imu->nr_bvecs++;
+	data->total += buf->len;
+
+	return buf->len;
+}
+
+static int io_splice_buf_direct_actor(struct pipe_inode_info *pipe,
+			       struct splice_desc *sd)
+{
+	return __splice_from_pipe(pipe, sd, io_splice_buf_actor);
+}
+
+static int __io_prep_rw_splice_buf(struct io_kiocb *req,
+				   struct io_rw_splice_buf_data *data,
+				   struct file *splice_f,
+				   size_t len,
+				   loff_t splice_off)
+{
+	unsigned flags = req->opcode == IORING_OP_READ_SPLICE_BUF ?
+			SPLICE_F_KERN_FOR_READ : SPLICE_F_KERN_FOR_WRITE;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags | SPLICE_F_NONBLOCK | SPLICE_F_KERN_NEED_CONFIRM,
+		.pos = splice_off,
+		.u.data = data,
+		.ignore_sig = true,
+	};
+
+	return splice_direct_to_actor(splice_f, &sd,
+			io_splice_buf_direct_actor);
+}
+
+static int io_prep_rw_splice_buf(struct io_kiocb *req,
+				 const struct io_uring_sqe *sqe)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	unsigned nr_pages = io_rw_splice_buf_nr_bvecs(rw->len);
+	loff_t splice_off = READ_ONCE(sqe->splice_off_in);
+	struct io_rw_splice_buf_data data;
+	struct io_mapped_ubuf *imu;
+	struct fd splice_fd;
+	int ret;
+
+	splice_fd = fdget(READ_ONCE(sqe->splice_fd_in));
+	if (!splice_fd.file)
+		return -EBADF;
+
+	ret = -EBADF;
+	if (!(splice_fd.file->f_mode & FMODE_READ))
+		goto out_put_fd;
+
+	ret = -ENOMEM;
+	imu = kmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	if (!imu)
+		goto out_put_fd;
+
+	/* splice buffer actually hasn't virtual address */
+	imu->nr_bvecs = 0;
+
+	data.max_bvecs = nr_pages;
+	data.total = 0;
+	data.imu = &imu;
+
+	rw->addr = 0;
+	req->flags |= REQ_F_NEED_CLEANUP;
+
+	ret = __io_prep_rw_splice_buf(req, &data, splice_fd.file, rw->len,
+			splice_off);
+	imu = *data.imu;
+	imu->acct_pages = 0;
+	imu->ubuf = 0;
+	imu->ubuf_end = data.total;
+	rw->len = data.total;
+	req->imu = imu;
+	if (!data.total) {
+		io_rw_cleanup_splice_buf(req);
+	} else  {
+		ret = 0;
+	}
+out_put_fd:
+	if (splice_fd.file)
+		fdput(splice_fd);
+
+	return ret;
+}
+
+void io_read_write_cleanup(struct io_kiocb *req)
+{
+	if (io_rw_splice_buf(req))
+		io_rw_cleanup_splice_buf(req);
+}
+
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -117,6 +286,8 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		ret = io_iov_buffer_select_prep(req);
 		if (ret)
 			return ret;
+	} else if (io_rw_splice_buf(req)) {
+		return io_prep_rw_splice_buf(req, sqe);
 	}
 
 	return 0;
@@ -371,7 +542,8 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 	size_t sqe_len;
 	ssize_t ret;
 
-	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
+	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED ||
+			io_rw_splice_buf(req)) {
 		ret = io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
 		if (ret)
 			return ERR_PTR(ret);
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3b733f4b610a..b37d6f6ecb6a 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -21,4 +21,5 @@ int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
+void io_read_write_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
-- 
2.31.1

