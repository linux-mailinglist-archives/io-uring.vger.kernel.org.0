Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57DE5AD465
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbiIEN7C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiIEN67 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:58:59 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0515A149
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:58:57 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220905135853epoutp01c1a44233d57183ad063c31000f635fa0~R_5AGHcaz3032130321epoutp01b
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 13:58:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220905135853epoutp01c1a44233d57183ad063c31000f635fa0~R_5AGHcaz3032130321epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662386333;
        bh=BnlRTbNNqn7Th77tQTzZ10cK7Qt10nSdZnE6JtLTcEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jligVjV64hRZIhiHEfUiW/+rjiRykNeK/B5YKhZ5ISgpB70wXqMGr2B1GCFDotAAV
         d7R+vuRqzuJXtY6zs0xpMZPONSKgJ6K/Y/HYKf0ddrsujHupb0RxbjGUUQs5cQXy6Y
         UmPggbAcT7b3b3wBroKBTpMU5j77xMDxWiFYgV4E=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220905135852epcas5p3ac21c78f3a33be3347a2c1a614123ebf~R_4_-pEI62360423604epcas5p32;
        Mon,  5 Sep 2022 13:58:52 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MLqqs5dBWz4x9Pr; Mon,  5 Sep
        2022 13:58:49 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.8A.59633.99006136; Mon,  5 Sep 2022 22:58:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220905135848epcas5p445275a3af56a26a036878fe8a8bcb55f~R_472k8-r0621806218epcas5p4l;
        Mon,  5 Sep 2022 13:58:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220905135848epsmtrp1d1cb1cf8dcc170b1da6514c4a74d4eef~R_470-mk91158011580epsmtrp1j;
        Mon,  5 Sep 2022 13:58:48 +0000 (GMT)
X-AuditID: b6c32a49-06ffe7000000e8f1-bc-63160099ceee
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.39.14392.89006136; Mon,  5 Sep 2022 22:58:48 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220905135847epsmtip1085e513c5b90049fd34fda2f4a05529e~R_46V1pjE1139411394epsmtip1H;
        Mon,  5 Sep 2022 13:58:47 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v4 2/4] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Mon,  5 Sep 2022 19:18:31 +0530
Message-Id: <20220905134833.6387-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905134833.6387-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmlu5MBrFkg53fNSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM64cqyJreC1ZMXCN54NjD2iXYycHBICJhL/d11j
        7GLk4hAS2M0ocfTPNWYI5xOjRPOWuSwQzjdGiTcr1rLBtOw7sQEqsZdRomffbXYI5zOjxNPL
        R4GGcXCwCWhKXJhcCtIgIuAlcf/2e1aQGmaQHW9vNLKDJIQFYiQOTNzABGKzCKhKvNm8EizO
        K2AucXT3FxaIbfISMy99B4tzClhITOq6zwZRIyhxcuYTsBpmoJrmrbPB7pYQaOWQOHNxHTNE
        s4tE58FZULawxKvjW9ghbCmJl/1tUHayxKWZ55gg7BKJx3sOQtn2Eq2n+plBnmEGemb9Ln2I
        XXwSvb+fMIGEJQR4JTrahCCqFSXuTXrKCmGLSzycsQTK9pDoeT2JDRI+3YwS57fcZ57AKD8L
        yQuzkLwwC2HbAkbmVYySqQXFuempxaYFhnmp5fCITc7P3cQITqNanjsY7z74oHeIkYmD8RCj
        BAezkghvyg6RZCHelMTKqtSi/Pii0pzU4kOMpsAwnsgsJZqcD0zkeSXxhiaWBiZmZmYmlsZm
        hkrivFO0GZOFBNITS1KzU1MLUotg+pg4OKUamDJehiY46fh8y5ez8D88S9dpoU7UltvODxU0
        D/MXrT+Y5xXRNivbWOx2O+eDRJez7tLTf9u9l0vZtCvu/InCI0ymU9cYaH9MiHz3VObs4zKl
        Cxt/Zi6Nt7u36YnR1/T5zAsZzaalmDjpXvV/zfhZs+uBzielD8IqaySWXPM7sXfm8+YFsycv
        ONWjlMZoVb312J9Hgg9Wrv3D/trvbPWME2GHZ5pahp9cevaIi3H2Wa4Fzlr9W35mX8g7orB1
        YXJ5a9770Pu2q1jYij9y7bkzW2mmMivTCfFP6b8c95RlewdPuHtssoDUP4MpeZVqwYcSGvdu
        yUx3Clh6T2pD+JqURpaLSz/+nnjg7G7DSSoLzdYrsRRnJBpqMRcVJwIAdTgNACwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSnO4MBrFkg22rdC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZVw51sRW8FqyYuEbzwbG
        HtEuRk4OCQETiX0nNrCA2EICuxkl+u6LQ8TFJZqv/WCHsIUlVv57DmRzAdV8ZJT427iMsYuR
        g4NNQFPiwuRSkBoRgQCJg42XwWqYBQ4ySlx+9gRsqLBAlMSlJ//ZQGwWAVWJN5tXgg3lFTCX
        OLr7CwvEAnmJmZe+g8U5BSwkJnXdZ4M4yFxiz4ynjBD1ghInZ0LMZAaqb946m3kCo8AsJKlZ
        SFILGJlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEh7+W5g7G7as+6B1iZOJgPMQo
        wcGsJMKbskMkWYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5O
        qQYmDv9r/nm/TmlM3pvw2vKU14s9tvM+LWrnXLXVSiVxgv7Fnxcmhpy6aPRz84wggY/SHzYa
        bnLrXWh2YqcD0++E+a5LVmvc8NujxdOX8aEu+fSzlfvWXXBm/bZK8MSXqUm1Lo81Je3LCrcV
        ehp8zdy197/tCjettZc4L0Ze+vfB/xavitZXHZOt+b4T02Z5tXv8nXZ0QsohV6eUyB/nTy3t
        Ov3+91sFhfS/HRUbJbsql4SXGE3futny4OXXNyqfn9dg4w9kCRDwWv7z6Lm51523FjRPb3zp
        7r/3tgPHmqKqmb6yuUqaj0v3zLr9jmUzq80KFrdb4ZtNBc9ffN7xlGEby4Qm+WCt+JiCkENK
        zlvZ4pRYijMSDbWYi4oTAT99on3uAgAA
X-CMS-MailID: 20220905135848epcas5p445275a3af56a26a036878fe8a8bcb55f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220905135848epcas5p445275a3af56a26a036878fe8a8bcb55f
References: <20220905134833.6387-1-joshi.k@samsung.com>
        <CGME20220905135848epcas5p445275a3af56a26a036878fe8a8bcb55f@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add IORING_URING_CMD_FIXED flag that is to be used for sending io_uring
command with previously registered buffers. User-space passes the buffer
index in sqe->buf_index, same as done in read/write variants that uses
fixed buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h      |  3 ++-
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/uring_cmd.c          | 18 +++++++++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index dba6fb47aa6c..6ca633b88816 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -16,6 +16,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+	IO_URING_F_FIXEDBUFS		= 32,
 };
 
 struct io_uring_cmd {
@@ -28,7 +29,7 @@ struct io_uring_cmd {
 		void *cookie;
 	};
 	u32		cmd_op;
-	u32		pad;
+	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
 };
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 48e5c70e0baf..34be8dd31f17 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -56,6 +56,7 @@ struct io_uring_sqe {
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
+		__u32		uring_cmd_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -219,6 +220,14 @@ enum io_uring_op {
 	IORING_OP_LAST,
 };
 
+/*
+ * sqe->uring_cmd_flags
+ * IORING_URING_CMD_FIXED	use registered buffer; pass thig flag
+ *				along with setting sqe->buf_index.
+ */
+#define IORING_URING_CMD_FIXED	(1U << 0)
+
+
 /*
  * sqe->fsync_flags
  */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8cddd18ad10b..ea989a348d98 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -76,8 +77,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->rw_flags || sqe->__pad1)
+	if (sqe->__pad1)
 		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
@@ -102,6 +116,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);
 	}
+	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+		issue_flags |= IO_URING_F_FIXEDBUFS;
 
 	if (req_has_async_data(req))
 		ioucmd->cmd = req->async_data;
-- 
2.25.1

