Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E174D1C00
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347925AbiCHPnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347947AbiCHPnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:07 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0450C4EF62
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:06 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220308154205epoutp043c56b9dd38cbc23fbe3e6fdbf164ba63~aciblJFXA1148511485epoutp04a
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220308154205epoutp043c56b9dd38cbc23fbe3e6fdbf164ba63~aciblJFXA1148511485epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754125;
        bh=ExpJtTiwCEF1LtD2DrUQNrZudMvTlavOkrHKvYLVMg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Svn6CU/IwSTCQ9wo+39vkqcgWhTeYgCNxl7oGYgW+fYN/hgd3fGzW8lIwBku/om7G
         9wYZRvn/J4PnrkKu8SKyrgnPnYNcAAx9+AFwNrEuzwyPxcYZ2C7taFknnpQpylWRVV
         Bgeh73tLRLlVJkpHAvVPsiWoanbv+DQWOUj8z13w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220308154204epcas5p4a21a4771dc19f3d964bcd2881b176b33~acia1ua-V2070420704epcas5p4Y;
        Tue,  8 Mar 2022 15:42:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfhS5Zw7z4x9Pq; Tue,  8 Mar
        2022 15:42:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.57.06423.84977226; Wed,  9 Mar 2022 00:42:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5~acVOyUPPw0623006230epcas5p3S;
        Tue,  8 Mar 2022 15:26:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152658epsmtrp261e74e158fcc86a46729821df02b8a4a~acVOxXOXA2706527065epsmtrp25;
        Tue,  8 Mar 2022 15:26:58 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-cb-62277948a196
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        24.96.03370.1C577226; Wed,  9 Mar 2022 00:26:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152655epsmtip1327c3fde86c87962eb4b3f60922231fe~acVMwW9Uv3168431684epsmtip1_;
        Tue,  8 Mar 2022 15:26:55 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 03/17] io_uring: add infra and support for
 IORING_OP_URING_CMD
Date:   Tue,  8 Mar 2022 20:50:51 +0530
Message-Id: <20220308152105.309618-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmhq5HpXqSwYGdWhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsav1kXsBacsK3Yd3MfewHhLr4uRk0NCwETix+fzLF2MXBxCArsZJZ7t
        mA/lfGKU+Lt9ESOE85lR4s22zYwwLX9f3GIHsYUEdjFKNG+SgCt6tuQRWxcjBwebgKbEhcml
        IDUiAl4S92+/ZwWpYRboYpJ4u+8+G0hCWCBAorHjHTOIzSKgKtGx7Q/YUF4BS4nnU7ewQiyT
        l5h56TtYnFPASuLnra2sEDWCEidnPmEBsZmBapq3zmYGWSAhcIRD4sW+/WwQzS4Sa/oWMEHY
        whKvjm9hh7ClJD6/2wtVUyzx685RqOYORonrDTNZIBL2Ehf3/GUC+YYZ6Jv1u/QhwrISU0+t
        Y4JYzCfR+/sJ1HxeiR3zYGxFiXuTnkI9IC7xcMYSKNtD4u1dkBpQaPUySnz4tY99AqPCLCQP
        zULy0CyE1QsYmVcxSqYWFOempxabFhjmpZbDozk5P3cTIzhha3nuYLz74IPeIUYmDsZDjBIc
        zEoivPfPqyQJ8aYkVlalFuXHF5XmpBYfYjQFhvhEZinR5HxgzsgriTc0sTQwMTMzM7E0NjNU
        Euc9nb4hUUggPbEkNTs1tSC1CKaPiYNTqoFJoe3NlBLd670880xLj1Tpuq7yeP41ukf73ceL
        DKLzH5q3cB+ts2X//tOUpTW/X+TKPpmQLd96vS6z9cezLq+Yn/by5sF9IqrrmASDnThPzy1V
        i3BY8HeBZlHZvv6zGTvcirr/vniRvzzL8+KWdcvP5vbLljsWqv1L6FBymTlhkS+r2I2a5z9U
        H9q5bRfJW5D7ck1ao9vd+IN8345ba8XKHsydK3ZJeI94l/k8E91ah8TDr1fv/HvAweHEQxln
        iZolq1JnyM6P2qO1VDtNSWw65735C5g90jyFFnKz+tzWDxTffLm84pRXYbOyYozvD66jkY6v
        1nG7L8oKnNpbbLFq0osN81cF8fc5Vl/+yqDEUpyRaKjFXFScCAA3WQZaYQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvdgqXqSQX+PlcX0w4oWTRP+MlvM
        WbWN0WL13X42i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLZa0HmezuDHh
        KaPFmptPWSw+n5nH6sDv8ezqM0aPnbPusns0L7jD4nH5bKnHplWdbB6bl9R77L7ZwOaxbfFL
        Vo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK+NW6iL3glGXFroP72BsYb+l1MXJySAiYSPx9
        cYu9i5GLQ0hgB6PEtZN7WCAS4hLN136wQ9jCEiv/PYcq+sgoMWfZXSCHg4NNQFPiwuRSkBoR
        gQCJg42XwWqYBWYwSfQ0fwYbJCzgJzG56yYziM0ioCrRse0P2FBeAUuJ51O3sEIskJeYeek7
        WJxTwEri562tYHEhoJoV636zQdQLSpyc+QRsJjNQffPW2cwTGAVmIUnNQpJawMi0ilEytaA4
        Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOKK0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHe++dVkoR4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpg2vWCP8hoVnXg
        RXsxw7SNK09KeIrxFmX+/PXlqtePrVXB+w+e998uNCNG+6/G/3N3+SZ9eCvJ9nrqJfn/G3bw
        J7Kq6Iv/SzCLWFr05caa/NtSM1/obXisKZRr++pX04VzWZXmLBOdQ2OOWcdUl+3byqdyJ2N/
        l8Pl56pbU+5OZrqnJM7qn7hUKGbp70VJx0rWMkRn3HGV1Tv+tdzwksib0oKIY9M3Ht4yZdOi
        kNCVGlGJv+p2KF2qiNjhdk9n9pFrdasyrr39vsZIjmOhyRVN/0mmq2XXsT14+npRp43nzUWe
        krK6nRWhzk92zvylUnHxhfyllNQ9u64szpQS0dyy+Oy7jy++71bh/LdkdtWiLi8lluKMREMt
        5qLiRAB6qByWFwMAAA==
X-CMS-MailID: 20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152658epcas5p3929bd1fcf75edc505fec71901158d1b5@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

This is a file private kind of request. io_uring doesn't know what's
in this command type, it's for the file_operations->async_cmd()
handler to deal with.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c                 | 79 +++++++++++++++++++++++++++++++----
 include/linux/io_uring.h      | 29 +++++++++++++
 include/uapi/linux/io_uring.h |  9 +++-
 3 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 241ba1cd6dcf..1f228a79e68f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -200,13 +200,6 @@ struct io_rings {
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
@@ -860,6 +853,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_uring_cmd	uring_cmd;
 	};
 
 	u8				opcode;
@@ -1110,6 +1104,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_URING_CMD] = {
+		.needs_file		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -2464,6 +2461,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, -EFAULT);
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
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
@@ -4109,6 +4122,51 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+/*
+ * Called by consumers of io_uring_cmd, if they originally returned
+ * -EIOCBQUEUED upon receiving the command.
+ */
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret)
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_done);
+
+static int io_uring_cmd_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+
+	if (!req->file->f_op->async_cmd || !(req->ctx->flags & IORING_SETUP_SQE128))
+		return -EOPNOTSUPP;
+	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		return -EOPNOTSUPP;
+	ioucmd->cmd = (void *) &sqe->cmd;
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+	ioucmd->cmd_len = READ_ONCE(sqe->cmd_len);
+	ioucmd->flags = 0;
+	return 0;
+}
+
+static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct file *file = req->file;
+	int ret;
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+
+	ioucmd->flags |= issue_flags;
+	ret = file->f_op->async_cmd(ioucmd);
+	/* queued async, consumer will call io_uring_cmd_done() when complete */
+	if (ret == -EIOCBQUEUED)
+		return 0;
+	io_uring_cmd_done(ioucmd, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6588,6 +6646,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6871,6 +6931,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_URING_CMD:
+		ret = io_uring_cmd(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -11215,6 +11278,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
+	BUILD_BUG_ON(sizeof(struct io_uring_cmd) > 64);
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 649a4d7c241b..cedc68201469 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,7 +5,29 @@
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
+	u16		cmd_len;
+	u16		unused;
+	u8		pdu[28]; /* available inline for free use */
+};
+
 #if defined(CONFIG_IO_URING)
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -26,6 +48,13 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
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
index c5db68433ca5..9bf1d6c0ed7f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -22,10 +22,12 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u32   cmd_op;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
 		__u64	splice_off_in;
+		__u16   cmd_len;
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -60,8 +62,10 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
-
+	union {
+		__u64	__pad2[2];
+		__u64  cmd;
+	};
 	/*
 	 * If the ring is initializefd with IORING_SETUP_SQE128, then this field
 	 * contains 64-bytes of padding, doubling the size of the SQE.
@@ -150,6 +154,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

