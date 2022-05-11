Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD17522C52
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiEKGbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiEKGb2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:28 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B1C27FC4
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:24 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220511063119epoutp01165973bfe03512a474fda4b8f83d77e9~t_T0v36MM2773027730epoutp01q
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220511063119epoutp01165973bfe03512a474fda4b8f83d77e9~t_T0v36MM2773027730epoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250679;
        bh=px45EHnQElLqY7zOxGhb4AhKytPOXXGM02llU29rPiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XurxOkOTItZVY4yjmUh7KjGR3kfOzUXUqEsCguSeOvY/mbQCb1SZe//EyuHc2AQms
         iq7C5Ti42ayjQQ8xcYMXJV+6kPZsWCK4AWvrgrqsFUU+K4Ft8TIC5mh+y8LvnOi0Lf
         yk07oJJaVv17SdTKd1p3Atcw3WJeTwWrkYak0PIk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220511063118epcas5p3ec3ee870dce9802f5991d11984e5450c~t_T0MMHyy3251432514epcas5p3d;
        Wed, 11 May 2022 06:31:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KylRP1dFqz4x9Q7; Wed, 11 May
        2022 06:31:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.A0.09762.F285B726; Wed, 11 May 2022 15:31:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220511055308epcas5p3627bcb0ec10d7a2222e701898e9ad0db~t9yfPrXl62942729427epcas5p3R;
        Wed, 11 May 2022 05:53:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220511055308epsmtrp24328a76f18f1c7a2d11f3c8d10da344f~t9yfOplW81209712097epsmtrp20;
        Wed, 11 May 2022 05:53:08 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-03-627b582f2a17
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CE.C2.08924.44F4B726; Wed, 11 May 2022 14:53:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055306epsmtip102587b3c8931760a662b04a9c07f810e~t9ydbV8Se2613326133epsmtip15;
        Wed, 11 May 2022 05:53:06 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 1/6] fs,io_uring: add infrastructure for uring-cmd
Date:   Wed, 11 May 2022 11:17:45 +0530
Message-Id: <20220511054750.20432-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmlq5+RHWSwb7/zBZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ7w/epypYIlfxa25
        FxkbGDfadzFyckgImEj0Hn/O2sXIxSEksJtR4kvnBxYI5xOjxNUll5khnM+MEk9nX2KCaXl9
        ZTMjRGIXo8TPdw1scFXrbzcADePgYBPQlLgwuRSkQURAXuLL7bVgY5kFzjJKTLt1iBUkISzg
        KtF6oA2snkVAVWLDbyGQMK+AhcTU7esZIZbJS8y89J0dxOYUsJTYsnkeO0SNoMTJmU9YQGxm
        oJrmrbOZIeoXckh8WOINMlJCwEXi6C9WiLCwxKvjW9ghbCmJz+/2skHYyRKt2y+zQ5SXSCxZ
        oA4Rtpe4uOcvE0iYGeiR9bv0IcKyElNPrWOCWMon0fv7CTREeCV2zIOxFSXuTXoKtVVc4uGM
        JVC2h0RbRxM0oHoYJWZvPcM6gVFhFpJnZiF5ZhbC6gWMzKsYJVMLinPTU4tNC4zzUsvhUZyc
        n7uJEZx6tbx3MD568EHvECMTB+MhRgkOZiUR3v19FUlCvCmJlVWpRfnxRaU5qcWHGE2BgT2R
        WUo0OR+Y/PNK4g1NLA1MzMzMTCyNzQyVxHlPpW9IFBJITyxJzU5NLUgtgulj4uCUamDKS9bl
        S2apWSf424alwuOGbC17/OGMxtUr92/0dJdQqy6vlawU33j6Qe1x+V/9ea6u9x04viSc189+
        qZky8e6PzUnTY4JEpS4fkzV0MOZrjCnpEY3deW1JMe8epzVPmtOjvdfMnFgefaLg9YqVmZdk
        F/7UEZgb+/dkYkpJynuWIvOXT8Kr/kkI7LBef39BR7YBz7pJn+XCPi5KkxPd1NojJv19l4Xj
        fusTV+Vajy1hlXA2eymcWfWTYb+8xrMwzQ8fdqsVe29iP3RdVCc95ovrps2hho+7j9qk3yjw
        dnUzlf7MNGkq8/8X8T2Ft/XOXitYK6G7Mbnj6Kf6/9wa7zvfzn75VuK20V+LRyffHVViKc5I
        NNRiLipOBAByE6ZPRgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSnK6Lf3WSwafJ8hZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        Ergy3h89zlSwxK/i1tyLjA2MG+27GDk5JARMJF5f2czYxcjFISSwg1Hi7MKTjBAJcYnmaz/Y
        IWxhiZX/nrNDFH1klNj2+zlLFyMHB5uApsSFyaUgNSICihIbPzaBDWIWuMko8bj1GjNIQljA
        VaL1QBsrSD2LgKrEht9CIGFeAQuJqdvXQ+2Sl5h56TvYLk4BS4ktm+eB2UJANUeXTGSDqBeU
        ODnzCQuIzQxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P
        3cQIjhAtrR2Me1Z90DvEyMTBeIhRgoNZSYR3f19FkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
        C10n44UE0hNLUrNTUwtSi2CyTBycUg1Ma55asV+rbj69tv5Mks68LrWFAnZMRy+7WUvIuN2S
        v23xYKrQ70nBhrPfl0kd0K2zz4yw5n7k43LooJy/HKtKofHsvLz9Wk9d6huMcmxN1MJVZ9Xy
        7P9x/cIyrTQG0W+r05jeaKy+qpWR4bDR2/p2Xs5M/ZZlk6ccPDYnS75h8ZLiHeeMQzpSIsUe
        TrBepSdeZJhd/bk0fNrjB5rqF/w1Fmxo2ZpcnhBwdcpct9hiNYkm3ou1/8OWOn4+aSdx84L4
        ge5LM6dsfJLS/FmkQ45xlxKX6YlWiUd6lkndfurHj3zccH+h6Y07ph8DzTdtN53wfP/hTwzq
        LRfvHJ9qMql6b/CcKOe+2DwH8a6EVSuUWIozEg21mIuKEwHwDaza/wIAAA==
X-CMS-MailID: 20220511055308epcas5p3627bcb0ec10d7a2222e701898e9ad0db
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055308epcas5p3627bcb0ec10d7a2222e701898e9ad0db
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055308epcas5p3627bcb0ec10d7a2222e701898e9ad0db@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
to deal with.

Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 123 ++++++++++++++++++++++++++++++++--
 include/linux/fs.h            |   2 +
 include/linux/io_uring.h      |  33 +++++++++
 include/uapi/linux/io_uring.h |  21 +++---
 4 files changed, 164 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ceaf7826ed71..592be5b89add 100644
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
@@ -972,6 +965,7 @@ struct io_kiocb {
 		struct io_xattr		xattr;
 		struct io_socket	sock;
 		struct io_nop		nop;
+		struct io_uring_cmd	uring_cmd;
 	};
 
 	u8				opcode;
@@ -1050,6 +1044,14 @@ struct io_cancel_data {
 	int seq;
 };
 
+/*
+ * The URING_CMD payload starts at 'cmd' in the first sqe, and continues into
+ * the following sqe if SQE128 is used.
+ */
+#define uring_cmd_pdu_size(is_sqe128)				\
+	((1 + !!(is_sqe128)) * sizeof(struct io_uring_sqe) -	\
+		offsetof(struct io_uring_sqe, cmd))
+
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -1289,6 +1291,12 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_SOCKET] = {
 		.audit_skip		= 1,
 	},
+	[IORING_OP_URING_CMD] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.needs_async_setup	= 1,
+		.async_size		= uring_cmd_pdu_size(1),
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -1428,6 +1436,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "GETXATTR";
 	case IORING_OP_SOCKET:
 		return "SOCKET";
+	case IORING_OP_URING_CMD:
+		return "URING_CMD";
 	case IORING_OP_LAST:
 		return "INVALID";
 	}
@@ -4910,6 +4920,96 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
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
+	if (req->ctx->flags & IORING_SETUP_CQE32)
+		__io_req_complete32(req, 0, ret, 0, res2, 0);
+	else
+		io_req_complete(req, ret);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_done);
+
+static int io_uring_cmd_prep_async(struct io_kiocb *req)
+{
+	size_t cmd_size;
+
+	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
+
+	memcpy(req->async_data, req->uring_cmd.cmd, cmd_size);
+	return 0;
+}
+
+static int io_uring_cmd_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+	ioucmd->cmd = sqe->cmd;
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+	return 0;
+}
+
+static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = req->file;
+	int ret;
+
+	if (!req->file->f_op->uring_cmd)
+		return -EOPNOTSUPP;
+
+	if (ctx->flags & IORING_SETUP_SQE128)
+		issue_flags |= IO_URING_F_SQE128;
+	if (ctx->flags & IORING_SETUP_CQE32)
+		issue_flags |= IO_URING_F_CQE32;
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		issue_flags |= IO_URING_F_IOPOLL;
+
+	if (req_has_async_data(req))
+		ioucmd->cmd = req->async_data;
+
+	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
+	if (ret == -EAGAIN) {
+		if (!req_has_async_data(req)) {
+			if (io_alloc_async_data(req))
+				return -ENOMEM;
+			io_uring_cmd_prep_async(req);
+		}
+		return -EAGAIN;
+	}
+
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(ioucmd, ret, 0);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -7755,6 +7855,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_getxattr_prep(req, sqe);
 	case IORING_OP_SOCKET:
 		return io_socket_prep(req, sqe);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -7787,6 +7889,8 @@ static int io_req_prep_async(struct io_kiocb *req)
 		return io_recvmsg_prep_async(req);
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep_async(req);
 	}
 	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
 		    req->opcode);
@@ -8081,6 +8185,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SOCKET:
 		ret = io_socket(req, issue_flags);
 		break;
+	case IORING_OP_URING_CMD:
+		ret = io_uring_cmd(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -12699,6 +12806,8 @@ static int __init io_uring_init(void)
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
+	BUILD_BUG_ON(sizeof(struct io_uring_cmd) > 64);
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbde95387a23..87b5af1d9fbe 100644
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
+	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 24651c229ed2..4a2f6cc5a492 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,7 +5,32 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
+enum io_uring_cmd_flags {
+	IO_URING_F_COMPLETE_DEFER	= 1,
+	IO_URING_F_UNLOCKED		= 2,
+	/* int's last bit, sign checks are usually faster than a bit test */
+	IO_URING_F_NONBLOCK		= INT_MIN,
+
+	/* ctx state flags, for URING_CMD */
+	IO_URING_F_SQE128		= 4,
+	IO_URING_F_CQE32		= 8,
+	IO_URING_F_IOPOLL		= 16,
+};
+
+struct io_uring_cmd {
+	struct file	*file;
+	const void	*cmd;
+	/* callback to defer completions to task context */
+	void (*task_work_cb)(struct io_uring_cmd *cmd);
+	u32		cmd_op;
+	u32		pad;
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
@@ -30,6 +55,14 @@ static inline void io_uring_free(struct task_struct *tsk)
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
index ac2d90d669c3..23618be55dd2 100644
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
@@ -175,6 +179,7 @@ enum io_uring_op {
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

