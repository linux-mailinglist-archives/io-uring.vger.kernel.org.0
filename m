Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4AB4EEEE8
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 16:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346699AbiDAOMm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 10:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiDAOMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 10:12:41 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D8812AEB
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 07:10:50 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220401141048epoutp0228d20acb28baed4f3b17ab9a6c7746ff~hyxl7N1_a1725817258epoutp02h
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 14:10:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220401141048epoutp0228d20acb28baed4f3b17ab9a6c7746ff~hyxl7N1_a1725817258epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648822248;
        bh=7+1Dq8yrmW6fow23FjCjNcBxU4f/v8mbCaJP+tB7F/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpsbnOXo3owZfPhj0205X6sS9GOGJE/zRPyd2q/R1E2ujTyCI+3j9/vCSO9tKA97y
         EFypY8DP+2hel8rEl8JmhkYZbPAQ5fqEjAtwyq+ZAiSY8rueSKBM7lM8NQk0Hkx5+K
         EQaP9Cakcs3FtRldnj3QfnInxvEQG/jBoEGata1g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220401141047epcas5p31587bad1e013c58eab84a346c706dc68~hyxk7C_NA1855818558epcas5p3i;
        Fri,  1 Apr 2022 14:10:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KVMX25vxvz4x9Pw; Fri,  1 Apr
        2022 14:10:42 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.92.06423.2E707426; Fri,  1 Apr 2022 23:10:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77~hwSexs-4V0831808318epcas5p4g;
        Fri,  1 Apr 2022 11:08:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220401110834epsmtrp2b1fcf121754edb997abfd0cbb217f7b7~hwSew33i12799827998epsmtrp2o;
        Fri,  1 Apr 2022 11:08:34 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-ef-624707e26cb6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.63.24342.23DD6426; Fri,  1 Apr 2022 20:08:34 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220401110833epsmtip1f505a4caa3c785b5ba47d434bb76fbe5~hwSdHZt5n0870608706epsmtip1x;
        Fri,  1 Apr 2022 11:08:32 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        pankydev8@gmail.com, javier@javigon.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [RFC 3/5] io_uring: add infra and support for IORING_OP_URING_CMD
Date:   Fri,  1 Apr 2022 16:33:08 +0530
Message-Id: <20220401110310.611869-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401110310.611869-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmhu4jdvckgw9z9S2aJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZxx4JV7QaVnR/v4N
        ewPjar0uRg4OCQETiX2vI7oYuTiEBHYzSvzav4gZwvnEKLG7/w8ThPONUWLNuh3sXYycYB3v
        N75ng0jsZZQ4ee0kI0hCSOAzo8SpJcwgY9kENCUuTC4FCYsIyEt8ub2WBaSeWeAao8TjV4fY
        QBLCAl4SZxdsYAaxWQRUJW7Nvc4CYvMKWEos/fORDWKZvMTMS9/BFnMKWEkc+reRDaJGUOLk
        zCdg9cxANc1bZ4OdLSEwl0Piw7ll7BC/uUgsu6UGMUdY4tXxLVAPSEl8frcXan6yROv2y1Dl
        JRJLFqhDhO0lLu75ywQSZgZ6Zf0ufYiwrMTUU+uYILbySfT+fsIEEeeV2DEPxlaUuDfpKSuE
        LS7xcMYSKNtDYuLa2yyQYOtllOjd+p15AqPCLCTfzELyzSyE1QsYmVcxSqYWFOempxabFhjm
        pZbDYzg5P3cTIzjxannuYLz74IPeIUYmDsZDjBIczEoivFdjXZOEeFMSK6tSi/Lji0pzUosP
        MZoCg3sis5Rocj4w9eeVxBuaWBqYmJmZmVgamxkqifOeTt+QKCSQnliSmp2aWpBaBNPHxMEp
        1cDEXuFjcj57WcG0XnWLmmuVey3NzLKCdOdOz9ubPEGwun7NnWVOwX6r5322D+AWWjLLxua3
        98yjQlen+MsZSvVM09v9p2KTlfr3bwnJ3bxhEaH9T8+7BzxyN9Odt/lbusJKr80B2bVzXrQL
        tMsIKgfs6ylJUnxen254INA9y8RRqvFGj4Bb8tmLTI0sVyZqP17s+F1OIGHLZcf5P5drq13h
        zMtLneR1wt4xRXjfruXTZ4kvlrtttWrTztP1vteuHMmfU8TK/HThGoF/C352WzcyPkyS3a1+
        9dlJjsslWoE7TjO4fjS5IF8/+UHEjF1Zapk6LifjPokxTf2aoKZ+iXWKlt91B943LatXl+f2
        TVBiKc5INNRiLipOBACja7CuRQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnK7RXbckgy07tS2aJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyDrwSL+i0rGh//4a9gXG1XhcjJ4eEgInE+43v2UBsIYHdjBLd/QoQcXGJ5ms/2CFsYYmV
        /54D2VxANR8ZJa61X2buYuTgYBPQlLgwuRSkRkRAUWLjxyZGkBpmgQeMEven/wYbKizgJXF2
        wQZmEJtFQFXi1tzrLCA2r4ClxNI/H9kgFshLzLz0HWwZp4CVxKF/G6EOspTYP3UeVL2gxMmZ
        T8BsZqD65q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZw
        fGhp7mDcvuqD3iFGJg7GQ4wSHMxKIrxXY12ThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZ
        LySQnliSmp2aWpBaBJNl4uCUamBq+H0lI3btDm/TPyLfsu4mLjtWN2PJ/ApDYWPenoUWF0z/
        Pbm4cWtNuyL/VwlLrTOf5eVD+vcYHEi6lXGyISVaxFK3ymYze2RVy0K+oDDNPIWy/qZFM15u
        Wn3/jpXzpuun0pfdd3kcHniPUSohlfPDAtWD/OcvKCnenK5+uC+E14bzta/pyi0Tpjd5llyc
        GinQfKreuvyKxDej6X4Mf1bsWltgYC2f0nNNZfPLgtds2a9CJ5oxPys+atVl8ye5udOl+p/n
        F7flJQobXXoS3Z/ot7E5rTXZ/H7x22W3Gq1LA/6Fu01/aWZWtjCqR3hK0+qMu2nt5ncyLtoc
        9PjXcmyVfcCKW9bCkSKbpRqn9yixFGckGmoxFxUnAgAfX9WL/gIAAA==
X-CMS-MailID: 20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77
References: <20220401110310.611869-1-joshi.k@samsung.com>
        <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
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
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c                 | 79 +++++++++++++++++++++++++++++++----
 include/linux/io_uring.h      | 29 +++++++++++++
 include/uapi/linux/io_uring.h |  8 +++-
 3 files changed, 108 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 241ba1cd6dcf..bd0e6b102a7b 100644
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
+	if (!req->file->f_op->async_cmd)
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
index c5db68433ca5..d7a4bdb9bf3b 100644
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
@@ -60,7 +62,10 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	union {
+		__u64	__pad2[2];
+		__u64	cmd;
+	};
 
 	/*
 	 * If the ring is initializefd with IORING_SETUP_SQE128, then this field
@@ -150,6 +155,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

