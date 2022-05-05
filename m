Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14A851B7D1
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 08:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiEEGRw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 02:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiEEGRv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 02:17:51 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C67746650
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 23:14:10 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220505061405epoutp042650dbb36a7bf8faa3e7bf7ef2142fc9~sINEaZuKA0907709077epoutp04c
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:14:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220505061405epoutp042650dbb36a7bf8faa3e7bf7ef2142fc9~sINEaZuKA0907709077epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651731245;
        bh=SG0rv+fzq+y5lGRhA3Re3PZvbCpBh0wfsH6jXqaiOG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpFQB3aOeOBxuzTApYuW04ryuwJwLzdk4+rCVojzV6O3irWxhanMnUsbdHkNPjSKk
         pGw4Jnan4yg4hhm0RconYFCnwX2shHO3ZxckS9MZ3VBwz1uwp/x+zJrSu17FkcL8FU
         H7YWmiWekeJ+3wNW0qzKe0/t+1F65U++i5QIO18U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220505061405epcas5p22f0cbfd67a0274b8b4ffaa8d085831f7~sIND6hGmn2126321263epcas5p2A;
        Thu,  5 May 2022 06:14:05 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Kv3LH5Tnkz4x9Pq; Thu,  5 May
        2022 06:13:59 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.A7.09762.52B63726; Thu,  5 May 2022 15:13:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df~sILA0j7aJ0533505335epcas5p3S;
        Thu,  5 May 2022 06:11:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220505061144epsmtrp21a4d5a6211b40c6abd5daa20a5a0f13a~sILAzxc441668816688epsmtrp24;
        Thu,  5 May 2022 06:11:44 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-0a-62736b25c87c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.1A.08853.0AA63726; Thu,  5 May 2022 15:11:44 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061142epsmtip2649c83be91692a117add6468d12ff8ba~sIK-M4-b-0719607196epsmtip2U;
        Thu,  5 May 2022 06:11:42 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Date:   Thu,  5 May 2022 11:36:12 +0530
Message-Id: <20220505060616.803816-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505060616.803816-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmpq5qdnGSwZedqhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ3w9vJyx4ItTxbPN
        t1gaGNebdTFyckgImEg0bjvG1sXIxSEksJtRYteuCcwQzidGibWX77FDON8YJc7M/AWU4QBr
        2XtWDyK+l1HiZG8fE4TzmVFi1azp7CBFbAKaEhcml4KsEBGQl/hyey0LSA2zwFlGiWm3DrGC
        JIQFXCU23ZvLAlLPIqAqsXc+I0iYV8BSYuqu00wQ58lLzLz0nR3E5hSwkug42ssCUSMocXLm
        EzCbGaimeetssKslBJZySDw+voIFotlFoqN5AzOELSzx6vgWdghbSuLzu71sEHayROv2y+wQ
        j5VILFmgDhG2l7i45y8TSJgZ6JX1u/QhwrISU0+tY4JYyyfR+/sJ1Jm8EjvmwdiKEvcmPWWF
        sMUlHs5YAmV7SFxuvQAN6V5GicWbD7NMYFSYheSdWUjemYWwegEj8ypGydSC4tz01GLTAuO8
        1HJ4HCfn525iBCdfLe8djI8efNA7xMjEwXiIUYKDWUmE13lpQZIQb0piZVVqUX58UWlOavEh
        RlNgcE9klhJNzgem/7ySeEMTSwMTMzMzE0tjM0Mlcd5T6RsShQTSE0tSs1NTC1KLYPqYODil
        Gph6f6ueSdR22cIzLSZ66rVtnL/3/F7/8Tyb2c0l396tcEjgOPuZp+X8+jkM5vfPn7kfvYff
        UbP/yJ0GNUfebzxX+BZL/mDmeMdpGdqXYLCyVijyz45fF965bN89699+n9jP5RMWzXzZ2rNY
        yDtskvzVWHPj0tTusga+/9PtGgtqtE5zcup6MVlpefZtnxQxRWw37/mVy68t/Hk2/MSir0We
        dwLLJxxNOxsnuTsqYVLXvHUP8rvFmaaX7q1aL5EZNSv3QsiGKx+f3pt4w8joSq9BUslibddJ
        WSpTKr/LXl2z/HHKmhk9OY+qlHTeub8OkJ+kJvLivXdVZmuY1P4Y5yNrPDk3iMzsKZqk/c91
        dn++EktxRqKhFnNRcSIAuna0+EcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSvO6CrOIkg6NfJS2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRnHZpKTmZJalFunb
        JXBlfD28nLHgi1PFs823WBoY15t1MXJwSAiYSOw9q9fFyMUhJLCbUWLH/gksXYycQHFxieZr
        P9ghbGGJlf+eg9lCAh8ZJSZ0eYD0sgloSlyYXAoSFhFQlNj4sYkRZA6zwE1Gicet15hBEsIC
        rhKb7s1lAalnEVCV2DufESTMK2ApMXXXaSaI8fISMy99BxvPKWAl0XG0lwVilaXE/e7VLBD1
        ghInZz4Bs5mB6pu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5
        uZsYwdGhpbmDcfuqD3qHGJk4GA8xSnAwK4nwOi8tSBLiTUmsrEotyo8vKs1JLT7EKM3BoiTO
        e6HrZLyQQHpiSWp2ampBahFMlomDU6qBib3x9c5JjS3cVVGHNh6dtUpe/a5g+Y3LH29UbZhp
        zvbnjeaO/hjGy7kKqvFrI3v4N9mHJzVv/KLGk3/ko0TTd/eWX8+9KnTSZ3ycmrikf9OZ4+yi
        ixMPOezjOPVL7GHpdyfWR9e79vr/SfnnNncNy+4TC6enVRmu7VoRK/SYv/SV8P1nVw4KR1TU
        39QOPsD2R4+N7XjBppDvhTMeVMiavTo3lVlcJPyA21bOV0o+TAyq+4+sWf9ALT/My/3LAcbn
        l6JaZL7eWKOgP4tdwzVb3nf9st+CPHluK/78OHxyQp3bxPd3VJ3XLMiofPw1fu6PDQ7L/xx7
        cvxugZ1onXmtEufmJy4cxnujyza9qEjsmKbEUpyRaKjFXFScCACd8UmC/QIAAA==
X-CMS-MailID: 20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df
References: <20220505060616.803816-1-joshi.k@samsung.com>
        <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

file_operations->uring_cmd is a file private handler.
This is somewhat similar to ioctl but hopefully a lot more sane and
useful as it can be used to enable many io_uring capabilities for the
underlying operation.

IORING_OP_URING_CMD is a file private kind of request. io_uring doesn't
know what is in this command type, it's for the provider of ->uring_cmd()
to deal with. This operation can be issued only on the ring that is
setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags.

Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 82 ++++++++++++++++++++++++++++++++---
 include/linux/fs.h            |  2 +
 include/linux/io_uring.h      | 27 ++++++++++++
 include/uapi/linux/io_uring.h | 21 +++++----
 4 files changed, 117 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7e3f7e74d92..3436507f04eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -202,13 +202,6 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
-enum io_uring_cmd_flags {
-	IO_URING_F_COMPLETE_DEFER	= 1,
-	IO_URING_F_UNLOCKED		= 2,
-	/* int's last bit, sign checks are usually faster than a bit test */
-	IO_URING_F_NONBLOCK		= INT_MIN,
-};
-
 struct io_mapped_ubuf {
 	u64		ubuf;
 	u64		ubuf_end;
@@ -969,6 +962,7 @@ struct io_kiocb {
 		struct io_xattr		xattr;
 		struct io_socket	sock;
 		struct io_nop		nop;
+		struct io_uring_cmd	uring_cmd;
 	};
 
 	u8				opcode;
@@ -1254,6 +1248,10 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_SOCKET] = {
 		.audit_skip		= 1,
 	},
+	[IORING_OP_URING_CMD] = {
+		.needs_file		= 1,
+		.plug			= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -1393,6 +1391,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "GETXATTR";
 	case IORING_OP_SOCKET:
 		return "SOCKET";
+	case IORING_OP_URING_CMD:
+		return "URING_CMD";
 	case IORING_OP_LAST:
 		return "INVALID";
 	}
@@ -4907,6 +4907,67 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
+{
+	req->uring_cmd.task_work_cb(&req->uring_cmd);
+}
+
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *))
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	req->uring_cmd.task_work_cb = task_work_cb;
+	req->io_task_work.func = io_uring_cmd_work;
+	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
+
+/*
+ * Called by consumers of io_uring_cmd, if they originally returned
+ * -EIOCBQUEUED upon receiving the command.
+ */
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete32(req, 0, ret, 0, res2, 0);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_done);
+
+static int io_uring_cmd_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return -EOPNOTSUPP;
+	/* do not support uring-cmd without big SQE/CQE */
+	if (!(ctx->flags & IORING_SETUP_SQE128))
+		return -EOPNOTSUPP;
+	if (!(ctx->flags & IORING_SETUP_CQE32))
+		return -EOPNOTSUPP;
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+	ioucmd->cmd = sqe->cmd;
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+	return 0;
+}
+
+static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct file *file = req->file;
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+
+	if (!req->file->f_op->uring_cmd)
+		return -EOPNOTSUPP;
+	file->f_op->uring_cmd(ioucmd, issue_flags);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -7764,6 +7825,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_getxattr_prep(req, sqe);
 	case IORING_OP_SOCKET:
 		return io_socket_prep(req, sqe);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -8085,6 +8148,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SOCKET:
 		ret = io_socket(req, issue_flags);
 		break;
+	case IORING_OP_URING_CMD:
+		ret = io_uring_cmd(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -12688,6 +12754,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
+	BUILD_BUG_ON(sizeof(struct io_uring_cmd) > 64);
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbde95387a23..30c98d9993df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1953,6 +1953,7 @@ struct dir_context {
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
 struct iov_iter;
+struct io_uring_cmd;
 
 struct file_operations {
 	struct module *owner;
@@ -1995,6 +1996,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	void (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 24651c229ed2..e4cbc80949ce 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,7 +5,26 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
+enum io_uring_cmd_flags {
+	IO_URING_F_COMPLETE_DEFER	= 1,
+	IO_URING_F_UNLOCKED		= 2,
+	/* int's last bit, sign checks are usually faster than a bit test */
+	IO_URING_F_NONBLOCK		= INT_MIN,
+};
+
+struct io_uring_cmd {
+	struct file	*file;
+	const u8	*cmd;
+	/* callback to defer completions to task context */
+	void (*task_work_cb)(struct io_uring_cmd *cmd);
+	u32		cmd_op;
+	u8		pdu[32]; /* available inline for free use */
+};
+
 #if defined(CONFIG_IO_URING)
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -30,6 +49,14 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
+		ssize_t ret2)
+{
+}
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *))
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 881e508767f8..92af2169ef58 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -22,6 +22,7 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u32	cmd_op;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
@@ -61,14 +62,17 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	addr3;
-	__u64	__pad2[1];
-
-	/*
-	 * If the ring is initialized with IORING_SETUP_SQE128, then this field
-	 * contains 64-bytes of padding, doubling the size of the SQE.
-	 */
-	__u64	__big_sqe_pad[0];
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
 };
 
 enum {
@@ -160,6 +164,7 @@ enum io_uring_op {
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

