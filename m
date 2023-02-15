Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46186972BE
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 01:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjBOAlb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 19:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjBOAl3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 19:41:29 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8EA311E6;
        Tue, 14 Feb 2023 16:41:26 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VbhPXlx_1676421684;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VbhPXlx_1676421684)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 08:41:24 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [RFC 2/3] io_uring: enable io_uring to submit sqes located in kernel
Date:   Wed, 15 Feb 2023 08:41:21 +0800
Message-Id: <20230215004122.28917-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently this feature can be used by userspace block device to reduce
kernel & userspace memory copy overhead. With this feature, userspace
block device driver can submit and complete io requests using kernel
block layer io requests's memory data, and further, by using ebpf, we
can customize how sqe is initialized, how io is submitted and completed.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 include/linux/io_uring.h       | 13 ++++++++
 include/linux/io_uring_types.h |  8 ++++-
 io_uring/io_uring.c            | 59 ++++++++++++++++++++++++++++++++--
 io_uring/rsrc.c                | 15 +++++++++
 io_uring/rsrc.h                |  3 ++
 io_uring/rw.c                  |  7 ++++
 6 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..d69882c98608 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -36,6 +36,12 @@ struct io_uring_cmd {
 	u8		pdu[32]; /* available inline for free use */
 };
 
+struct io_mapped_kbuf {
+	size_t count;
+	unsigned int nr_bvecs;
+	struct bio_vec *bvec;
+};
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
@@ -65,6 +71,8 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+int io_uring_submit_sqe(int fd, const struct io_uring_sqe *sqe, u32 sqe_len,
+			struct io_mapped_kbuf *kbuf);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -96,6 +104,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+int io_uring_submit_sqe(int fd, const struct io_uring_sqe *sqe, u32 sqe_len,
+			struct io_mapped_kbuf *kbuf)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 128a67a40065..260f8365c802 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -398,6 +398,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_KBUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -467,6 +468,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	/* buffer comes from kernel */
+	REQ_F_KBUF		= BIT(REQ_F_KBUF_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
@@ -527,7 +530,7 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
-	unsigned int			flags;
+	u64				flags;
 
 	struct io_cqe			cqe;
 
@@ -540,6 +543,9 @@ struct io_kiocb {
 		/* store used ubuf, so we can prevent reloading */
 		struct io_mapped_ubuf	*imu;
 
+		/* store used kbuf */
+		struct io_mapped_kbuf	*imk;
+
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db623b3185c8..a174365470fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2232,7 +2232,8 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 }
 
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe)
+			 const struct io_uring_sqe *sqe,
+			 struct io_mapped_kbuf *kbuf)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
@@ -2241,6 +2242,10 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
+	if (unlikely(kbuf)) {
+		req->imk = kbuf;
+		req->flags |= REQ_F_KBUF;
+	}
 
 	/* don't need @sqe from now on */
 	trace_io_uring_submit_sqe(req, true);
@@ -2392,7 +2397,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, NULL)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
@@ -3272,6 +3277,54 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	return 0;
 }
 
+int io_uring_submit_sqe(int fd, const struct io_uring_sqe *sqe, u32 sqe_len,
+			struct io_mapped_kbuf *kbuf)
+{
+	struct io_kiocb *req;
+	struct fd f;
+	int ret;
+	struct io_ring_ctx *ctx;
+
+	f = fdget(fd);
+	if (unlikely(!f.file))
+		return -EBADF;
+
+	ret = -EOPNOTSUPP;
+	if (unlikely(!io_is_uring_fops(f.file))) {
+		ret = -EBADF;
+		goto out;
+	}
+	ctx = f.file->private_data;
+
+	mutex_lock(&ctx->uring_lock);
+	if (unlikely(!io_alloc_req_refill(ctx)))
+		goto out;
+	req = io_alloc_req(ctx);
+	if (unlikely(!req)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	if (!percpu_ref_tryget_many(&ctx->refs, 1)) {
+		kmem_cache_free(req_cachep, req);
+		ret = -EAGAIN;
+		goto out;
+	}
+	percpu_counter_add(&current->io_uring->inflight, 1);
+	refcount_add(1, &current->usage);
+
+	/* returns number of submitted SQEs or an error */
+	ret = !io_submit_sqe(ctx, req, sqe, kbuf);
+	mutex_unlock(&ctx->uring_lock);
+	fdput(f);
+	return ret;
+
+out:
+	mutex_unlock(&ctx->uring_lock);
+	fdput(f);
+	return ret;
+}
+EXPORT_SYMBOL(io_uring_submit_sqe);
+
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		u32, min_complete, u32, flags, const void __user *, argp,
 		size_t, argsz)
@@ -4270,7 +4323,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
 	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
-	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(u64));
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 18de10c68a15..51861f01185f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1380,3 +1380,18 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	return 0;
 }
+
+int io_import_fixed_kbuf(int ddir, struct iov_iter *iter,
+			 struct io_mapped_kbuf *kbuf,
+			u64 offset, size_t len)
+{
+	if (WARN_ON_ONCE(!kbuf))
+		return -EFAULT;
+	if (offset >= kbuf->count)
+		return -EFAULT;
+
+	iov_iter_bvec(iter, ddir, kbuf->bvec, kbuf->nr_bvecs, offset + len);
+	iov_iter_advance(iter, offset);
+	return 0;
+}
+
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2b8743645efc..c6897d218bb9 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -69,6 +69,9 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len);
 
+int io_import_fixed_kbuf(int ddir, struct iov_iter *iter,
+		struct io_mapped_kbuf *kbuf, u64 buf_addr, size_t len);
+
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9c3ddd46a1ad..bdf4c4f0661f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -378,6 +378,13 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 		return NULL;
 	}
 
+	if (unlikely(req->flags & REQ_F_KBUF)) {
+		ret = io_import_fixed_kbuf(ddir, iter, req->imk, rw->addr, rw->len);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
 	buf = u64_to_user_ptr(rw->addr);
 	sqe_len = rw->len;
 
-- 
2.31.1

