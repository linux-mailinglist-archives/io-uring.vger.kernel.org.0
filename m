Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6744B0E45
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 14:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiBJNR7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 08:17:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242065AbiBJNR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 08:17:57 -0500
X-Greylist: delayed 529 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 05:17:56 PST
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E2A1BB;
        Thu, 10 Feb 2022 05:17:56 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 807F047755;
        Thu, 10 Feb 2022 13:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1644498549; x=1646312950; bh=zJuO5KYthVaQdujA+S9MFsNEG61XiLFyOv0
        7wW1QBzw=; b=Mp2uNkrNa3NFIxmoFXb2VDTOKQHX423d5TC0jzHBBJvFdSbEyli
        uYbKp1W5pKYlW99THFFnqq63q60ohYz8J58RaI2VDm1NCdIGvBbyVAqUt+Akmu87
        FYOYy2SOQN3nJZ3+KMglGyO3ehTWQhnGrU2CJrrjekmYh7ZpLYSST8H8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XUYDuGSTFJaf; Thu, 10 Feb 2022 16:09:09 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 605E641846;
        Thu, 10 Feb 2022 16:09:09 +0300 (MSK)
Received: from localhost.localdomain (10.178.114.63) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 10 Feb 2022 16:09:08 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v2 2/3] block: io_uring: add READV_PI/WRITEV_PI operations
Date:   Thu, 10 Feb 2022 16:08:24 +0300
Message-ID: <20220210130825.657520-3-a.buev@yadro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210130825.657520-1-a.buev@yadro.com>
References: <20220210130825.657520-1-a.buev@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Added new READV_PI/WRITEV_PI operations to io_uring.
Added new pi_addr & pi_len fields to SQE struct.
Added new pi_iter field and IOCB_USE_PI flag to kiocb struct.
Make corresponding corrections to io uring trace event.

Signed-off-by: Alexander V. Buev <a.buev@yadro.com>
---
 fs/io_uring.c                   | 209 ++++++++++++++++++++++++++++++++
 include/linux/fs.h              |   2 +
 include/trace/events/io_uring.h |  17 +--
 include/uapi/linux/io_uring.h   |   6 +-
 include/uapi/linux/uio.h        |   3 +-
 5 files changed, 228 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..6e941040f228 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -563,6 +563,19 @@ struct io_rw {
 	u64				len;
 };
 
+struct io_rw_pi_state {
+	struct iov_iter			iter;
+	struct iov_iter_state		iter_state;
+	struct iovec			fast_iov[UIO_FASTIOV_PI];
+};
+
+struct io_rw_pi {
+	struct io_rw			rw;
+	struct iovec			*pi_iov;
+	u32				nr_pi_segs;
+	struct io_rw_pi_state		*s;
+};
+
 struct io_connect {
 	struct file			*file;
 	struct sockaddr __user		*addr;
@@ -716,6 +729,12 @@ struct io_async_rw {
 	struct wait_page_queue		wpq;
 };
 
+struct io_async_rw_pi {
+	struct io_async_rw		async;
+	const struct iovec		*free_iovec;
+	struct io_rw_pi_state		s;
+};
+
 enum {
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
@@ -744,6 +763,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_USE_PI_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -799,6 +819,8 @@ enum {
 	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
 	/* don't post CQEs while failing linked requests */
 	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
+	/* pi metadata present */
+	REQ_F_USE_PI		= BIT(REQ_F_USE_PI_BIT)
 };
 
 struct async_poll {
@@ -855,6 +877,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_rw_pi		rw_pi;
 	};
 
 	u8				opcode;
@@ -1105,6 +1128,24 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_READV_PI] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.needs_async_setup	= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw_pi),
+	},
+	[IORING_OP_WRITEV_PI] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw_pi),
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -3053,6 +3094,18 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static int io_prep_rw_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (!(req->file->f_flags & O_DIRECT))
+		return -EINVAL;
+
+	req->rw.kiocb.ki_flags |= IOCB_USE_PI;
+	req->flags |= REQ_F_USE_PI;
+	req->rw_pi.pi_iov = u64_to_user_ptr(READ_ONCE(sqe->pi_addr));
+	req->rw_pi.nr_pi_segs = READ_ONCE(sqe->pi_len);
+	return 0;
+}
+
 static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 {
 	switch (ret) {
@@ -3505,10 +3558,39 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 		iorw = req->async_data;
 		/* we've copied and mapped the iter, ensure state is saved */
 		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
+		if (req->flags & REQ_F_USE_PI) {
+			struct io_async_rw_pi *iorw_pi = req->async_data;
+
+			/* copy iter from req to async ctx */
+			iorw_pi->s.iter = req->rw_pi.s->iter;
+
+			if (req->rw_pi.s->iter.iov == req->rw_pi.s->fast_iov) {
+				memcpy(iorw_pi->s.fast_iov,  req->rw_pi.s->fast_iov,
+					sizeof(iorw_pi->s.fast_iov));
+				iorw_pi->s.iter.iov = iorw_pi->s.fast_iov;
+				iorw_pi->free_iovec = 0;
+			} else {
+				req->flags |= REQ_F_NEED_CLEANUP;
+				iorw_pi->free_iovec = req->rw_pi.s->iter.iov;
+			}
+
+			iov_iter_save_state(&iorw_pi->s.iter, &iorw_pi->s.iter_state);
+		}
 	}
 	return 0;
 }
 
+static inline
+int io_import_pi_iovec(struct io_kiocb *req, int rw, unsigned int fast_segs,
+			struct iovec **fast_iov, struct iov_iter *iter)
+{
+	void __user *buf = req->rw_pi.pi_iov;
+
+	return __import_iovec(rw, buf, req->rw_pi.nr_pi_segs, fast_segs,
+				fast_iov, iter, req->ctx->compat);
+}
+
+
 static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 {
 	struct io_async_rw *iorw = req->async_data;
@@ -3527,6 +3609,25 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	return 0;
 }
 
+static inline int io_rw_prep_async_pi(struct io_kiocb *req, int rw)
+{
+	int ret = 0;
+	struct io_async_rw_pi *iorw_pi = req->async_data;
+	struct iovec *pi_iov = iorw_pi->s.fast_iov;
+
+	ret = io_import_pi_iovec(req, rw, UIO_FASTIOV_PI, &pi_iov, &iorw_pi->s.iter);
+	if (unlikely(ret < 0))
+		return ret;
+
+	iorw_pi->free_iovec = pi_iov;
+
+	if (pi_iov)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	iov_iter_save_state(&iorw_pi->s.iter, &iorw_pi->s.iter_state);
+
+	return io_rw_prep_async(req, rw);
+}
+
 static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
@@ -3534,6 +3635,15 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_prep_rw(req, sqe);
 }
 
+static int io_read_prep_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret = io_read_prep(req, sqe);
+
+	if (ret)
+		return ret;
+	return io_prep_rw_pi(req, sqe);
+}
+
 /*
  * This is our waitqueue callback handler, registered through __folio_lock_async()
  * when we initially tried to do the IO with the iocb armed our waitqueue.
@@ -3690,6 +3800,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&s->iter, &s->iter_state);
+	if (req->flags & REQ_F_USE_PI)
+		iov_iter_restore(kiocb->pi_iter, &req->rw_pi.s->iter_state);
+
 
 	ret2 = io_setup_async_rw(req, iovec, s, true);
 	if (ret2)
@@ -3714,6 +3827,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			break;
 		rw->bytes_done += ret;
 		iov_iter_save_state(&s->iter, &s->iter_state);
+		if (req->flags & REQ_F_USE_PI)
+			iov_iter_save_state(kiocb->pi_iter, &req->rw_pi.s->iter_state);
 
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
@@ -3733,6 +3848,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
 		iov_iter_restore(&s->iter, &s->iter_state);
+		if (req->flags & REQ_F_USE_PI)
+			iov_iter_restore(kiocb->pi_iter, &req->rw_pi.s->iter_state);
 	} while (ret > 0);
 done:
 	kiocb_done(req, ret, issue_flags);
@@ -3743,6 +3860,34 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_read_pi(struct io_kiocb *req, unsigned int issue_flags)
+{
+	if (req_has_async_data(req)) {
+		struct io_async_rw_pi *iorw_pi = req->async_data;
+
+		iov_iter_restore(&iorw_pi->s.iter, &iorw_pi->s.iter_state);
+		req->rw.kiocb.pi_iter = &iorw_pi->s.iter;
+		req->rw_pi.s = &iorw_pi->s;
+		return io_read(req, issue_flags);
+	} else {
+		int ret;
+		struct io_rw_pi_state __s, *s = &__s;
+		struct iovec *pi_iov = __s.fast_iov;
+
+		ret = io_import_pi_iovec(req, READ, UIO_FASTIOV_PI, &pi_iov, &s->iter);
+		if (unlikely(ret < 0))
+			return ret;
+		iov_iter_save_state(&s->iter, &s->iter_state);
+		req->rw.kiocb.pi_iter = &s->iter;
+		req->rw_pi.s = s;
+
+		ret = io_read(req, issue_flags);
+		if (pi_iov && !(ret == -EAGAIN && req_has_async_data(req)))
+			kfree(pi_iov);
+		return ret;
+	}
+}
+
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
@@ -3751,6 +3896,15 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_prep_rw(req, sqe);
 }
 
+static int io_write_prep_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret = io_write_prep(req, sqe);
+
+	if (ret)
+		return ret;
+	return io_prep_rw_pi(req, sqe);
+}
+
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3836,6 +3990,10 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 copy_iov:
 		iov_iter_restore(&s->iter, &s->iter_state);
+
+		if (req->flags & REQ_F_USE_PI)
+			iov_iter_restore(kiocb->pi_iter, &req->rw_pi.s->iter_state);
+
 		ret = io_setup_async_rw(req, iovec, s, false);
 		return ret ?: -EAGAIN;
 	}
@@ -3846,6 +4004,34 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+static int io_write_pi(struct io_kiocb *req, unsigned int issue_flags)
+{
+	if (req_has_async_data(req)) {
+		struct io_async_rw_pi *iorw_pi = req->async_data;
+
+		req->rw.kiocb.pi_iter = &iorw_pi->s.iter;
+		req->rw_pi.s = &iorw_pi->s;
+		iov_iter_restore(&iorw_pi->s.iter, &iorw_pi->s.iter_state);
+		return io_write(req, issue_flags);
+	} else {
+		int ret;
+		struct io_rw_pi_state __s, *s = &__s;
+		struct iovec *pi_iov = __s.fast_iov;
+
+		ret = io_import_pi_iovec(req, WRITE, UIO_FASTIOV_PI, &pi_iov, &s->iter);
+		if (unlikely(ret < 0))
+			return ret;
+		iov_iter_save_state(&s->iter, &s->iter_state);
+		req->rw.kiocb.pi_iter = &s->iter;
+		req->rw_pi.s = s;
+
+		ret = io_write(req, issue_flags);
+		if (pi_iov && !(ret == -EAGAIN && req_has_async_data(req)))
+			kfree(pi_iov);
+		return ret;
+	}
+}
+
 static int io_renameat_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6500,10 +6686,14 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
 		return io_read_prep(req, sqe);
+	case IORING_OP_READV_PI:
+		return io_read_prep_pi(req, sqe);
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
 		return io_write_prep(req, sqe);
+	case IORING_OP_WRITEV_PI:
+		return io_write_prep_pi(req, sqe);
 	case IORING_OP_POLL_ADD:
 		return io_poll_add_prep(req, sqe);
 	case IORING_OP_POLL_REMOVE:
@@ -6589,6 +6779,10 @@ static int io_req_prep_async(struct io_kiocb *req)
 		return io_rw_prep_async(req, READ);
 	case IORING_OP_WRITEV:
 		return io_rw_prep_async(req, WRITE);
+	case IORING_OP_READV_PI:
+		return io_rw_prep_async_pi(req, READ);
+	case IORING_OP_WRITEV_PI:
+		return io_rw_prep_async_pi(req, WRITE);
 	case IORING_OP_SENDMSG:
 		return io_sendmsg_prep_async(req);
 	case IORING_OP_RECVMSG:
@@ -6670,7 +6864,14 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_WRITE_FIXED:
 		case IORING_OP_WRITE: {
 			struct io_async_rw *io = req->async_data;
+			kfree(io->free_iovec);
+			break;
+			}
+		case IORING_OP_READV_PI:
+		case IORING_OP_WRITEV_PI: {
+			struct io_async_rw_pi *io = req->async_data;
 
+			kfree(io->async.free_iovec);
 			kfree(io->free_iovec);
 			break;
 			}
@@ -6750,11 +6951,17 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_READ:
 		ret = io_read(req, issue_flags);
 		break;
+	case IORING_OP_READV_PI:
+		ret = io_read_pi(req, issue_flags);
+		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
 		ret = io_write(req, issue_flags);
 		break;
+	case IORING_OP_WRITEV_PI:
+		ret = io_write_pi(req, issue_flags);
+		break;
 	case IORING_OP_FSYNC:
 		ret = io_fsync(req, issue_flags);
 		break;
@@ -11218,6 +11425,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+	BUILD_BUG_SQE_ELEM(48, __u64,  pi_addr);
+	BUILD_BUG_SQE_ELEM(56, __u32,  pi_len);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e2d892b201b0..c45ec5073300 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -316,6 +316,7 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+#define IOCB_USE_PI		(1 << 22)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -330,6 +331,7 @@ struct kiocb {
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
+	struct iov_iter		*pi_iter;
 	randomized_struct_fields_end
 };
 
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 7346f0164cf4..8a435df796b9 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -524,8 +524,9 @@ TRACE_EVENT(io_uring_req_failed,
 		__field( u16,	buf_index )
 		__field( u16,	personality )
 		__field( u32,	file_index )
-		__field( u64,	pad1 )
-		__field( u64,	pad2 )
+		__field(u64,	pi_addr)
+		__field(u32,	pi_len)
+		__field(u32,	pad)
 		__field( int,	error )
 	),
 
@@ -541,21 +542,23 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->buf_index	= sqe->buf_index;
 		__entry->personality	= sqe->personality;
 		__entry->file_index	= sqe->file_index;
-		__entry->pad1		= sqe->__pad2[0];
-		__entry->pad2		= sqe->__pad2[1];
+		__entry->pi_addr	= sqe->pi_addr;
+		__entry->pi_len		= sqe->pi_len;
+		__entry->pad		= sqe->__pad2;
 		__entry->error		= error;
 	),
 
 	TP_printk("op %d, flags=0x%x, prio=%d, off=%llu, addr=%llu, "
 		  "len=%u, rw_flags=0x%x, user_data=0x%llx, buf_index=%d, "
-		  "personality=%d, file_index=%d, pad=0x%llx/%llx, error=%d",
+		  "personality=%d, file_index=%d, pi_addr=0x%llx, pi_len=%u, "
+		  "pad=%u, error=%d",
 		  __entry->opcode, __entry->flags, __entry->ioprio,
 		  (unsigned long long)__entry->off,
 		  (unsigned long long) __entry->addr, __entry->len,
 		  __entry->op_flags, (unsigned long long) __entry->user_data,
 		  __entry->buf_index, __entry->personality, __entry->file_index,
-		  (unsigned long long) __entry->pad1,
-		  (unsigned long long) __entry->pad2, __entry->error)
+		  (unsigned long long) __entry->pi_addr, __entry->pi_len,
+		  __entry->pad, __entry->error)
 );
 
 #endif /* _TRACE_IO_URING_H */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..87ea512c2c8d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -60,7 +60,9 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	__u64	pi_addr;  /* pointer to iovec */
+	__u32	pi_len;
+	__u32	__pad2;
 };
 
 enum {
@@ -143,6 +145,8 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_READV_PI,
+	IORING_OP_WRITEV_PI,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/include/uapi/linux/uio.h b/include/uapi/linux/uio.h
index 059b1a9147f4..c9eaaa6cdb0f 100644
--- a/include/uapi/linux/uio.h
+++ b/include/uapi/linux/uio.h
@@ -23,9 +23,10 @@ struct iovec
 /*
  *	UIO_MAXIOV shall be at least 16 1003.1g (5.4.1.1)
  */
- 
+
 #define UIO_FASTIOV	8
 #define UIO_MAXIOV	1024
+#define UIO_FASTIOV_PI	1
 
 
 #endif /* _UAPI__LINUX_UIO_H */
-- 
2.34.1

