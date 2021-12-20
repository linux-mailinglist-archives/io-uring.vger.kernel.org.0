Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D9247B8AE
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhLUC4l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42915 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhLUC4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:41 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211221025639epoutp026798dc1f830a813827498576e167e233~CpbJUXzzS2870728707epoutp02J
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211221025639epoutp026798dc1f830a813827498576e167e233~CpbJUXzzS2870728707epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055399;
        bh=2DlgsdVDD8TJPholpkMcAzQvduH7Afep+ScWGG73sRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkq56k4DAdRlRvkiJ0uV+2hmvWEtl1rHSzWoPvP/F+oWAoLywlABqL0XBPgw12ZnU
         VJjva84RyVdkGAFzW/hjaq0SQB8d/TFasqbLCALzAodYQZwqJPT32kfQgypkQit9qX
         ZX/7QmkTaezBNDCS0Xp7nPVJaNlPni4oo8+lZSOw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20211221025639epcas5p2488e211d93d5212947c28175128a9947~CpbI0t8M82224322243epcas5p2b;
        Tue, 21 Dec 2021 02:56:39 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4JJ1Lp0ZG8z4x9QD; Tue, 21 Dec
        2021 02:56:34 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.F1.46822.16241C16; Tue, 21 Dec 2021 11:56:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20211220142239epcas5p3efc3c89bd536f3f5d728c81bc550e143~CfI0LXJGL2729127291epcas5p3O;
        Mon, 20 Dec 2021 14:22:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142239epsmtrp185588a27f5a3594c45f233f4cadcac15~CfI0Kp2mA2445924459epsmtrp1f;
        Mon, 20 Dec 2021 14:22:39 +0000 (GMT)
X-AuditID: b6c32a4a-dfbff7000000b6e6-bc-61c14261fd9b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.65.08738.FA190C16; Mon, 20 Dec 2021 23:22:39 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142237epsmtip186a84a7fff6983188e70229f09aa16c6~CfIyqUKf20040400404epsmtip1h;
        Mon, 20 Dec 2021 14:22:37 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 06/13] io_uring: add support for uring_cmd with fixed-buffer
Date:   Mon, 20 Dec 2021 19:47:27 +0530
Message-Id: <20211220141734.12206-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmpm6S08FEg5sHmCyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnTFn6WbGgibpilsfZjE1MN4U7WLk5JAQ
        MJFYM+k3G4gtJLCbUeLKzOwuRi4g+xOjxL5fx1khEp8ZJdo/pcM07Dr2jQ2iaBejxPTXJ5ng
        ilq7NLsYOTjYBDQlLkwuBQmLCERLXHh+DWwBs0AHo8TOblsQW1jAS+L89c1gcRYBVYk5jafB
        bF4BC4l70z6xQuySl5h56Ts7iM0pYClxePYyqBpBiZMzn7BAzJSXaN46mxmifiqHxMobXBC2
        i8SJtt1QcWGJV8e3sEPYUhIv+9ug7GKJX3eOMoP8IgFy2/WGmSwQCXuJi3v+MoH8wgz0y/pd
        +hBhWYmpp9YxQezlk+j9/YQJIs4rsWMejK0ocW/SU6j7xSUezlgCZXtI7Np2lwkSbj2MEtdW
        bGKfwKgwC8k/s5D8Mwth9QJG5lWMkqkFxbnpqcWmBUZ5qeXwKE7Oz93ECE6yWl47GB8++KB3
        iJGJg/EQowQHs5II75bZ+xOFeFMSK6tSi/Lji0pzUosPMZoCA3wis5Rocj4wzeeVxBuaWBqY
        mJmZmVgamxkqifOeTt+QKCSQnliSmp2aWpBaBNPHxMEp1cC05Jerw4RHlyyZ9B5mair5/+A4
        W37c1dbf7uXydXfyvPZO7RN9+08/Y0PGpOnn8s1aHhrMey8gnPEzzM5ki+cnQfu1Je9+7gjx
        vVL5/bHyPlNH4fz37Ykf8y+8fnmr90eR0hY271frv3I0TDy43VFwq0zJvYxri78YJjYIL/2a
        fvfmHJ0PX/brPF1YXHFO+bH/awY/GdmMQ9k20/qZu/+eTFPryAtsVC39MOfJ2oB5Tds1PXa+
        uzzZQSxMWbk5qWv6hIslDyQZtd9qqol6GC6YeGaiSsS1rNzHxlsnyU+/Fzhn16qnbNuusU55
        /ECLz7zXzeEng/qEK2wz8/s+BSsvVX+RsNdy1kkJk19+FXOPKbEUZyQaajEXFScCAAJY+xA7
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnO76iQcSDbb2Slg0TfjLbLH6bj+b
        xcrVR5ks3rWeY7HoPH2ByeL828NMFpMOXWO02HtL22L+sqfsFmtuPmVx4PLYOesuu0fzgjss
        HpfPlnpsWtXJ5rF5Sb3H7psNbB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVMWfpZsaCJumK
        Wx9mMTUw3hTtYuTkkBAwkdh17BtbFyMXh5DADkaJh9vnskEkxCWar/1gh7CFJVb+e84OUfSR
        UWLG7iaWLkYODjYBTYkLk0tBakQEYiU+/DrGBFLDLDCJUWJD/wOwZmEBL4nz1zeDDWURUJWY
        03gazOYVsJC4N+0TK8QCeYmZl76D1XMKWEocnr0MrEYIqObEhy8sEPWCEidnPgGzmYHqm7fO
        Zp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjB0aCltYNxz6oP
        eocYmTgYDzFKcDArifBumb0/UYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6Yklqdmp
        qQWpRTBZJg5OqQYmv8TQm8989giXRs25f4NfiO+G13MjF92CN2eCV8s5nHi27kvDonW2ucWC
        1Qq6QlVWMsq85899OPR5m8etPjf2FZs/bu65fUFpjWjw/QcfnA7Mm3Xpz8vaOon19566SNXK
        HP99IPzqikWnln2LiLd5ufJpPfepy13FJ26muzY9zC7/ZMW/09yg4nLCjKPNc3iNt09sbjSP
        frXD0V9VtSP6+N8Lf8scPxteqt8swfFIsPL9t+a9e080t6k+2FLEuOb/t1mhygp9sszb3H5G
        Xcl41DD797VZO580HPdc0nQ5/7rkmQf8BUJKM2fa6BUfe6W+4969ZQYR7TY7GkpfT9j4jc+Q
        u/nEh1KzuGeCM0sORCmxFGckGmoxFxUnAgBBUgm19QIAAA==
X-CMS-MailID: 20211220142239epcas5p3efc3c89bd536f3f5d728c81bc550e143
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142239epcas5p3efc3c89bd536f3f5d728c81bc550e143
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142239epcas5p3efc3c89bd536f3f5d728c81bc550e143@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add IORING_OP_URING_CMD_FIXED opcode that enables performing the
operation with previously registered buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c                 | 29 ++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  6 +++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cc6735913c4b..2870a891e441 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1122,6 +1122,10 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.offsets		= 1,
 	},
+	[IORING_OP_URING_CMD_FIXED] = {
+		.needs_file		= 1,
+		.offsets		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4133,6 +4137,7 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 static int io_uring_cmd_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	const struct io_uring_cmd_sqe *csqe = (const void *) sqe;
 	struct io_uring_cmd *cmd = &req->uring_cmd;
 
@@ -4145,7 +4150,13 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 	}
 
 	cmd->op = READ_ONCE(csqe->op);
-	cmd->len = READ_ONCE(csqe->len);
+	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
+		req->imu = NULL;
+		io_req_set_rsrc_node(req, ctx);
+		req->buf_index = READ_ONCE(csqe->buf_index);
+		req->uring_cmd.flags |= URING_CMD_FIXEDBUFS;
+	} else
+		cmd->len = READ_ONCE(csqe->len);
 
 	/*
 	 * The payload is the last 40 bytes of an io_uring_cmd_sqe, with the
@@ -4160,6 +4171,20 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = req->file;
 	int ret;
 
+	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
+		u32 index, buf_index = req->buf_index;
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_mapped_ubuf *imu = req->imu;
+
+		if (likely(!imu)) {
+			if (unlikely(buf_index >= ctx->nr_user_bufs))
+				return -EFAULT;
+			index = array_index_nospec(buf_index, ctx->nr_user_bufs);
+			imu = READ_ONCE(ctx->user_bufs[index]);
+			req->imu = imu;
+		}
+	}
+
 	ret = file->f_op->async_cmd(&req->uring_cmd, issue_flags);
 	/* queued async, consumer will call io_uring_cmd_done() when complete */
 	if (ret == -EIOCBQUEUED)
@@ -6675,6 +6700,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
 	case IORING_OP_URING_CMD:
+	case IORING_OP_URING_CMD_FIXED:
 		return io_uring_cmd_prep(req, sqe);
 	}
 
@@ -6960,6 +6986,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_linkat(req, issue_flags);
 		break;
 	case IORING_OP_URING_CMD:
+	case IORING_OP_URING_CMD_FIXED:
 		ret = io_uring_cmd(req, issue_flags);
 		break;
 	default:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7191419f2236..cb331f201255 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -79,7 +79,10 @@ struct io_uring_cmd_sqe {
 	__u64			user_data;
 	__u16			op;
 	__u16			personality;
-	__u32			len;
+	union {
+		__u32			len;
+		__u16			buf_index;
+	};
 	__u64			pdu[5];
 };
 
@@ -164,6 +167,7 @@ enum {
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
 	IORING_OP_URING_CMD,
+	IORING_OP_URING_CMD_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

