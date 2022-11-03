Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E0C61792F
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 09:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiKCIw1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 04:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiKCIwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 04:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC88D2D6
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 01:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667465469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i8JvcZbpi+InOaWaSSfJsW/LYP35SvNLfn87x+CwQHU=;
        b=KGSuo+zYq2IRB1dQOW5/DEU5wbFQAHNm1i7VpBpwY0vyv/hv3HFY52UjaYOyI/XQb3fKBt
        9VO0KLPQzyfzL2sEQhCe3bS0uObmXzwhwkYNEp3bAkEtww+GCxbxL4Qz61olyf2vFfhkNf
        xFxOzJ3J3At0klGsVwcaeX6PoIOInDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-94rabdZCPhWvVKR2uC06aw-1; Thu, 03 Nov 2022 04:50:43 -0400
X-MC-Unique: 94rabdZCPhWvVKR2uC06aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09448101A5AD;
        Thu,  3 Nov 2022 08:50:43 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF4F0C15BA4;
        Thu,  3 Nov 2022 08:50:35 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 3/4] io_uring/splice: support splice from ->splice_read to ->splice_read
Date:   Thu,  3 Nov 2022 16:50:03 +0800
Message-Id: <20221103085004.1029763-4-ming.lei@redhat.com>
In-Reply-To: <20221103085004.1029763-1-ming.lei@redhat.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 1st ->splice_read produces buffer to the pipe of
current->splice_pipe, and the 2nd ->splice_read consumes the buffer
in this pipe.

This way helps to support zero copy of read request for ublk and fuse.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/splice.c               | 146 ++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h        |   2 +
 include/linux/pipe_fs_i.h |   9 +++
 include/linux/splice.h    |  11 +++
 io_uring/splice.c         |  13 ++--
 5 files changed, 169 insertions(+), 12 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index f8999ffe6215..cd5255f9ff13 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -330,17 +330,70 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 	struct iov_iter to;
 	struct kiocb kiocb;
 	int ret;
+	struct bio_vec *array = NULL;
+	bool consumer;
+
+	/*
+	 * So far, in->fops->splice_read() has to make sure the following
+	 * simple page use model works.
+	 *
+	 * pipe->consumed_by_read is set by the in end of the pipe
+	 */
+	if ((flags & SPLICE_F_READ_TO_READ) && pipe->consumed_by_read) {
+		unsigned int head, tail, mask;
+		int nbufs = pipe->max_usage;
+		size_t left = len;
+		int n;
+
+		if (WARN_ON_ONCE(!(flags & SPLICE_F_DIRECT)))
+			return -EINVAL;
+
+		head = pipe->head;
+		tail = pipe->tail;
+		mask = pipe->ring_size - 1;
+
+		array = kcalloc(nbufs, sizeof(struct bio_vec), GFP_KERNEL);
+		if (!array)
+			return -ENOMEM;
+
+		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs;
+				tail++) {
+			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
+			size_t this_len = buf->len;
+
+			/* zero-length bvecs are not supported, skip them */
+			if (!this_len)
+				continue;
+			this_len = min(this_len, left);
+
+			array[n].bv_page = buf->page;
+			array[n].bv_len = this_len;
+			array[n].bv_offset = buf->offset;
+			left -= this_len;
+			n++;
+		}
+
+		consumer = true;
+		iov_iter_bvec(&to, READ, array, n, len - left);
+	} else {
+		/* !consumer means one pipe buf producer */
+		consumer = false;
+		iov_iter_pipe(&to, READ, pipe, len);
+	}
 
-	iov_iter_pipe(&to, READ, pipe, len);
 	init_sync_kiocb(&kiocb, in);
 	kiocb.ki_pos = *ppos;
 	ret = call_read_iter(in, &kiocb, &to);
 	if (ret > 0) {
 		*ppos = kiocb.ki_pos;
 		file_accessed(in);
+
+		if (consumer)
+			splice_dismiss_pipe(pipe, ret);
 	} else if (ret < 0) {
 		/* free what was emitted */
-		pipe_discard_from(pipe, to.start_head);
+		if (!consumer)
+			pipe_discard_from(pipe, to.start_head);
 		/*
 		 * callers of ->splice_read() expect -EAGAIN on
 		 * "can't put anything in there", rather than -EFAULT.
@@ -349,6 +402,11 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 			ret = -EAGAIN;
 	}
 
+	if (consumer) {
+		kfree(array);
+		pipe->consumed_by_read = false;
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(generic_file_splice_read);
@@ -782,7 +840,7 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
  */
 static long do_splice_to(struct file *in, loff_t *ppos,
 			 struct pipe_inode_info *pipe, size_t len,
-			 unsigned int flags)
+			 unsigned int flags, bool consumer)
 {
 	unsigned int p_space;
 	int ret;
@@ -790,8 +848,12 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
 
-	/* Don't try to read more the pipe has space for. */
-	p_space = pipe->max_usage - pipe_occupancy(pipe->head, pipe->tail);
+	if (consumer) /* read is consumer */
+		p_space = pipe_occupancy(pipe->head, pipe->tail);
+	else
+		/* Don't try to read more the pipe has space for. */
+		p_space = pipe->max_usage - pipe_occupancy(pipe->head,
+				pipe->tail);
 	len = min_t(size_t, len, p_space << PAGE_SHIFT);
 
 	ret = rw_verify_area(READ, in, ppos, len);
@@ -875,7 +937,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		size_t read_len;
 		loff_t pos = sd->pos, prev_pos = pos;
 
-		ret = do_splice_to(in, &pos, pipe, len, flags);
+		ret = do_splice_to(in, &pos, pipe, len, flags, false);
 		if (unlikely(ret <= 0))
 			goto out_release;
 
@@ -992,6 +1054,76 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(do_splice_direct);
 
+static int direct_splice_read_consumer_actor(struct pipe_inode_info *pipe,
+			       struct splice_desc *sd)
+{
+	struct file *file = sd->u.file;
+
+	/* Pipe in side has to notify us by ->consumed_by_read */
+	if (!pipe->consumed_by_read)
+		return -EINVAL;
+
+	return do_splice_to(file, sd->opos, pipe, sd->total_len,
+			sd->flags, true);
+}
+
+/**
+ * do_splice_direct_read_consumer - splices data directly with producer/
+ *    consumer model
+ * @in:		file to splice from
+ * @ppos:	input file offset
+ * @out:	file to splice to
+ * @opos:	output file offset
+ * @len:	number of bytes to splice
+ * @flags:	splice modifier flags, SPLICE_F_READ_TO_READ is required
+ *
+ * Description:
+ *    For use by ublk or fuse to implement zero copy for READ request, and
+ *    splice directly over internal pipe from device to file, and device's
+ *    ->splice_read() produces pipe buffers, and file's ->splice_read()
+ *    consumes the buffers.
+ *
+ */
+long do_splice_direct_read_consumer(struct file *in, loff_t *ppos,
+				    struct file *out, loff_t *opos,
+				    size_t len, unsigned int flags)
+{
+	struct splice_desc sd = {
+		.len		= len,
+		.total_len	= len,
+		.flags		= flags,
+		.pos		= *ppos,
+		.u.file		= out,
+		.opos		= opos,
+	};
+	long ret;
+
+	if (!(flags & (SPLICE_F_DIRECT | SPLICE_F_READ_TO_READ)))
+		return -EINVAL;
+
+	if (unlikely(!(out->f_mode & FMODE_READ)))
+		return -EBADF;
+
+	/*
+	 * So far we just support F_READ_TO_READ if it is one plain
+	 * file which ->splice_read points to generic_file_splice_read
+	 */
+	if (out->f_op->splice_read != generic_file_splice_read)
+		return -EINVAL;
+
+	ret = rw_verify_area(READ, out, opos, len);
+	if (unlikely(ret < 0))
+		return ret;
+
+	ret = splice_direct_to_actor(in, &sd,
+			direct_splice_read_consumer_actor);
+	if (ret > 0)
+		*ppos = sd.pos;
+
+	return ret;
+}
+EXPORT_SYMBOL(do_splice_direct_read_consumer);
+
 static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 {
 	for (;;) {
@@ -1023,7 +1155,7 @@ long splice_file_to_pipe(struct file *in,
 	pipe_lock(opipe);
 	ret = wait_for_space(opipe, flags);
 	if (!ret)
-		ret = do_splice_to(in, offset, opipe, len, flags);
+		ret = do_splice_to(in, offset, opipe, len, flags, false);
 	pipe_unlock(opipe);
 	if (ret > 0)
 		wakeup_pipe_readers(opipe);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e654435f1651..e5f84902f149 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3169,6 +3169,8 @@ extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		loff_t *opos, size_t len, unsigned int flags);
+extern long do_splice_direct_read_consumer(struct file *in, loff_t *ppos,
+		struct file *out, loff_t *opos, size_t len, unsigned int flags);
 
 
 extern void
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 6cb65df3e3ba..90c6ff8c82ef 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -72,6 +72,15 @@ struct pipe_inode_info {
 	unsigned int r_counter;
 	unsigned int w_counter;
 	bool poll_usage;
+
+	/*
+	 * If SPLICE_F_READ_TO_READ is applied, in->fops->splice_read()
+	 * should set this flag, so that out->fops->splice_read() can
+	 * observe this flag, then consume buffers in the pipe.
+	 *
+	 * Used by do_splice_direct_read_consumer() only.
+	 */
+	bool consumed_by_read;
 	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 9121624ad198..f48044e5e173 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -26,6 +26,17 @@
 /* used for io_uring interface only */
 #define SPLICE_F_DIRECT	(0x10)	/* direct splice and user needn't provide pipe */
 
+/*
+ * The usual splice is file-to-pipe and pipe-to-file, and this flag means the
+ * splice is file-to-pipe and file-to-pipe. Looks this way is stupid, but
+ * please understand from producer & consumer viewpoint, the 1st file-to-pipe
+ * is producer, and the 2nd file-to-pipe is consumer, so here the 2nd
+ * ->slice_read just consumes buffers stored in the pipe.
+ *
+ *  And this flag is only valid in case of SPLICE_F_DIRECT.
+ */
+#define SPLICE_F_READ_TO_READ	(0x20)
+
 /*
  * Passed to the actors
  */
diff --git a/io_uring/splice.c b/io_uring/splice.c
index c11ea4cd1c7e..df66d89f4f17 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -28,7 +28,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL |
-		SPLICE_F_DIRECT;
+		SPLICE_F_DIRECT | SPLICE_F_READ_TO_READ;
 
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
@@ -111,12 +111,15 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
 	if (sp->len) {
-		if (flags & SPLICE_F_DIRECT)
-			ret = do_splice_direct(in, poff_in, out, poff_out,
-					sp->len, flags);
-		else
+		if (!(flags & (SPLICE_F_DIRECT | SPLICE_F_READ_TO_READ)))
 			ret = do_splice(in, poff_in, out, poff_out, sp->len,
 					flags);
+		else if (flags & SPLICE_F_READ_TO_READ)
+			ret = do_splice_direct_read_consumer(in, poff_in, out,
+					poff_out, sp->len, flags);
+		else
+			ret = do_splice_direct(in, poff_in, out, poff_out,
+					sp->len, flags);
 	}
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
-- 
2.31.1

