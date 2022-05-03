Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1E7518C95
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 20:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiECSxB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 14:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241657AbiECSww (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 14:52:52 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1093F891
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 11:49:17 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220503184915euoutp01c7cce803285f8a73df6885ff886e9530~rrN1y0WuA2372823728euoutp01V
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 18:49:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220503184915euoutp01c7cce803285f8a73df6885ff886e9530~rrN1y0WuA2372823728euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651603755;
        bh=/QpaLw73Sdk4QV+7nOuf3FsoTjLZ8rbkpdPu+0NuBo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhm+B1HZ6IxRdO7cZyP9XWRD9UGUcTRpmQL1eq4FGf7m728qtV8lhpUUFRH33YFd5
         iMWy5V1o/UoRylfa5L4orOulcayBAkuI/Y1G2W7h2gmwr7x5bt01sR+6/TOjZFYrwk
         LSOE/lNiqDERIrS3B0J+2RWDt2oLZZ6QjaFZd+JA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220503184913eucas1p29dcd1dd032c4e5834baf2de7cc86e4d2~rrNzpAqwT0195601956eucas1p2N;
        Tue,  3 May 2022 18:49:13 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id E3.2E.10009.92971726; Tue,  3
        May 2022 19:49:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32~rrNzNDjhS1431714317eucas1p1O;
        Tue,  3 May 2022 18:49:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220503184912eusmtrp199c313d2e57176255d56b2c54f8614c3~rrNzMQ9ac2552825528eusmtrp1W;
        Tue,  3 May 2022 18:49:12 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-92-62717929e9bc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 3A.F6.09404.82971726; Tue,  3
        May 2022 19:49:12 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220503184912eusmtip1dc75830958130ecb815478073d8cf686~rrNy8YicY0995809958eusmtip1C;
        Tue,  3 May 2022 18:49:12 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 1/5] fs,io_uring: add infrastructure for uring-cmd
Date:   Tue,  3 May 2022 20:48:27 +0200
Message-Id: <20220503184831.78705-2-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503184831.78705-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7djP87qalYVJBq0nWSzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxkMX/ZU3aLGxOeMlocmtzMZHH15QF2B26Pic3v
        2D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgjOKySUnNySxLLdK3
        S+DKeHDqGFtBu0PFg9ZpzA2Mb427GDk5JARMJL6+vM3cxcjFISSwglHi4obT7BDOF0aJ++9n
        QTmfGSX65k5hhWlZO+8IO4gtJLCcUeL6X1uIopeMEucvPgUq4uBgE9CSaOwEqxERkJf4cnst
        C0gNs8A9RonTcxrAEsICrhJT1l5lA7FZBFQlWu62sIDYvAKWEs2fXzFBLJOXmHnpOzvITE4B
        K4kd85khSgQlTs58AlbODFTSvHU22AsSAh84JOZuO8gO0esiMW3yM0YIW1ji1fEtUHEZidOT
        e1gg7GqJpzd+QzW3MEr071zPBrJMQsBaou9MDojJLKApsX6XPkS5o8S92xcYISr4JG68FYQ4
        gU9i0rbpzBBhXomONiGIaiWJnT+fQC2VkLjcNAdqqYfElDW32ScwKs5C8swsJM/MQti7gJF5
        FaN4amlxbnpqsWFearlecWJucWleul5yfu4mRmDKOv3v+KcdjHNffdQ7xMjEwXiIUYKDWUmE
        13lpQZIQb0piZVVqUX58UWlOavEhRmkOFiVx3uTMDYlCAumJJanZqakFqUUwWSYOTqkGpqSD
        VSWn0v4Em+3dEZqRWNGkdnzh/D27rQr/H9ziG7mZ5cx6AclX+p7LDrR7/XknZvfvz4f23cbM
        v3z3116dEOzUsP6ly9b5Putqn6x1DvzouMzzgPZij3O++xTeuaYKWr1SWZJkMZ8xc3lGl96T
        yKUXfY8U/j4neO7IvI/C9tLs2xoSbsk+j63qdHmsIP7p3IIg6Y1vjBjeqLTMysu7sECn2Zpv
        /UL7Zv+IisrWj68m7n+3widilfr6p5eMOJ2SUp+qTdwYFmysJZ9WK+s8VfGsxK2HyTfCLoUk
        /+w9lMI1379ttYPVkcfrHRN3L7b7U7rT991lsbwNfEvjb85QPCx+1L7uRbva1b8N83QCbyux
        FGckGmoxFxUnAgCduSK0yAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t/xu7oalYVJBvPfqFrMWbWN0WL13X42
        i5sHdjJZrFx9lMniXes5Fouj/9+yWZx/e5jJYv6yp+wWNyY8ZbQ4NLmZyeLqywPsDtweE5vf
        sXvsnHWX3ePy2VKPTas62Tw2L6n32H2zgc3j/b6rbB59W1YxenzeJBfAGaVnU5RfWpKqkJFf
        XGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CX8eDUMbaCdoeKB63TmBsY
        3xp3MXJySAiYSKydd4S9i5GLQ0hgKaNE66OnbBAJCYnbC5sYIWxhiT/Xutggip4zSvx9Nxso
        wcHBJqAl0djJDlIjIqAosfEjSD0XB7PAC0aJl/dvs4AkhAVcJaasvQo2lEVAVaLlbgtYnFfA
        UqL58ysmiAXyEjMvfWcHmckpYCWxYz4zSFgIqKRt4mJ2iHJBiZMzn4C1MgOVN2+dzTyBUWAW
        ktQsJKkFjEyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAuNr27GfW3Ywrnz1Ue8QIxMH4yFG
        CQ5mJRFe56UFSUK8KYmVValF+fFFpTmpxYcYTYHOnsgsJZqcD4zwvJJ4QzMDU0MTM0sDU0sz
        YyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGpkkbhCKPss9UO3NT0CXt4vvPnTOni/JKrDoU
        c+7+qW5Dn2f7ln2eJrgj8Mem0m03d3IIy9z66OfxOuHVchbeaQWr3/e/OBR7/cPkhdq8i6p4
        11WnvW/6ExegFL190goZm5tluywqGfI7X6u6uLXuSLeVfuarZLRwn2XOHP9LW1+Z2cgvEj4k
        e9vkC9s6nWJPUeWdS4W2N+xk7F/GWa9TN6k87a/tgnXl3CxLheb9CNpawxxes6DZbWJTXvqR
        nBv8T3k1b8jc1p6yjvfesnymr3I5xRt/z4mrsFQLnrfodF35o9rY9VIxBp7mt+/celZf9bm9
        WjI5T2J66q5Tt6S54t0k3SQDnNM3pbRzGutcVWIpzkg01GIuKk4EALYX3684AwAA
X-CMS-MailID: 20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32
References: <20220503184831.78705-1-p.raghav@samsung.com>
        <CGME20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

file_operations->uring_cmd is a file private handler, similar to ioctls
but hopefully a lot more sane and useful.

IORING_OP_URING_CMD is a file private kind of request. io_uring doesn't
know what is in this command type, it's for the provider of ->uring_cmd()
to deal with. This operation can be issued only on the ring that is
setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags.

Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 81 ++++++++++++++++++++++++++++++++---
 include/linux/fs.h            |  2 +
 include/linux/io_uring.h      | 29 +++++++++++++
 include/uapi/linux/io_uring.h |  8 +++-
 4 files changed, 112 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7e3f7e74d92..b774e6eac538 100644
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
@@ -4907,6 +4907,66 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
+{
+	req->uring_cmd.driver_cb(&req->uring_cmd);
+}
+
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	req->uring_cmd.driver_cb = driver_cb;
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
+
+	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		return -EOPNOTSUPP;
+	/* do not support uring-cmd without big SQE/CQE */
+	if (!(req->ctx->flags & IORING_SETUP_SQE128))
+		return -EOPNOTSUPP;
+	if (!(req->ctx->flags & IORING_SETUP_CQE32))
+		return -EOPNOTSUPP;
+	ioucmd->cmd = (void *) &sqe->cmd;
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+	ioucmd->flags = 0;
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
+	ioucmd->flags |= issue_flags;
+	file->f_op->uring_cmd(ioucmd);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -7764,6 +7824,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_getxattr_prep(req, sqe);
 	case IORING_OP_SOCKET:
 		return io_socket_prep(req, sqe);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -8085,6 +8147,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SOCKET:
 		ret = io_socket(req, issue_flags);
 		break;
+	case IORING_OP_URING_CMD:
+		ret = io_uring_cmd(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -12688,6 +12753,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
+	BUILD_BUG_ON(sizeof(struct io_uring_cmd) > 64);
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbde95387a23..6b64c07efcf4 100644
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
+	void (*uring_cmd)(struct io_uring_cmd *ioucmd);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 24651c229ed2..a4ff4696cbea 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,7 +5,28 @@
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
+	struct file     *file;
+	void            *cmd;
+	/* for irq-completion - if driver requires doing stuff in task-context*/
+	void (*driver_cb)(struct io_uring_cmd *cmd);
+	u32             flags;
+	u32             cmd_op;
+	u32		unused;
+	u8		pdu[28]; /* available inline for free use */
+};
+
 #if defined(CONFIG_IO_URING)
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -30,6 +51,14 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
+		ssize_t ret2)
+{
+}
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 881e508767f8..c081511119bf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -22,10 +22,12 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u32	cmd_op;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
 		__u64	splice_off_in;
+		__u16	cmd_len;
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -61,7 +63,10 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	addr3;
+	union {
+		__u64	addr3;
+		__u64	cmd;
+	};
 	__u64	__pad2[1];
 
 	/*
@@ -160,6 +165,7 @@ enum io_uring_op {
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

