Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5C3E1582
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 15:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhHENQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 09:16:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30322 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241674AbhHENQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 09:16:32 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210805131617epoutp03cdc59ce82a2ac6a7f4f1fbc716c84cb8~Ya2wMHmDi0297502975epoutp03m
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 13:16:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210805131617epoutp03cdc59ce82a2ac6a7f4f1fbc716c84cb8~Ya2wMHmDi0297502975epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628169377;
        bh=Q+rT0yCB/2IZmMD9Tg4LavILsDGcYtWDoS4/AenPnDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCwhRQ/43WMjGkFeuu0gsAqr3Lok9zyWUxLQLzuz8/R1OW2HiWqCqz2JUwC3YtmxM
         /X3FGzETAO1Ufaaf/DSoKAgsgHPI5nLFp+zTjQFckC0RaTCDDkf6JXhGsKV80lampx
         6CyxBw9zkwg1GMql9TT7Ev5sRoqdcW+I4v0b+y7E=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210805131615epcas5p4d72ed90d3785b628fae9c2a01674afb3~Ya2vFKETC2580725807epcas5p4i;
        Thu,  5 Aug 2021 13:16:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GgTdP64Pjz4x9Pw; Thu,  5 Aug
        2021 13:16:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.EC.41701.994EB016; Thu,  5 Aug 2021 22:16:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210805125934epcas5p4ff88e95d558ad9f65d77a888a4211b18~YaoKijKmz2461324613epcas5p4E;
        Thu,  5 Aug 2021 12:59:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210805125934epsmtrp2bc558175f68e910f0801ae4b9096a0cf~YaoKh1QG_2066920669epsmtrp2-;
        Thu,  5 Aug 2021 12:59:34 +0000 (GMT)
X-AuditID: b6c32a4b-0c1ff7000001a2e5-b6-610be499a628
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.84.32548.6B0EB016; Thu,  5 Aug 2021 21:59:34 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125932epsmtip1c7b2656578e60ba8d909a3cac01e02b4~YaoI9vMpg1080510805epsmtip1B;
        Thu,  5 Aug 2021 12:59:32 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 5/6] io_uring: add support for uring_cmd with
 fixed-buffer
Date:   Thu,  5 Aug 2021 18:25:38 +0530
Message-Id: <20210805125539.66958-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805125539.66958-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmhu7MJ9yJBj2ntCyaJvxltlh9t5/N
        Ys+iSUwWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S2uTFnE7MDlcflsqcemVZ1s
        HpuX1HvsvtnA5tG3ZRWjx+bT1R6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM64viqzYI9Exc81a1gbGK8LdzFycEgImEg0HLLq
        YuTiEBLYzShxcsICpi5GTiDnE6PEhV16EInPjBIHJixiB0mANFx4c5kNIrGLUWL34hOscFWn
        m38ygYxlE9CUuDC5FKRBRMBIYv+nk2A1zAKLGCW23v/NDFIjLBAgcbPdCaSGRUBV4uSVSWwg
        YV4BC4mL600hdslLzLz0HWwvp4ClxOdDe1lBbF4BQYmTM5+wgNjMQDXNW2czg4yXEOjlkHh8
        /CMTRLOLxPnX05ghbGGJV8e3QD0gJfH53V42CLtY4tedo1DNHYwS1xtmskAk7CUu7vkL9gsz
        0C/rd+lDhGUlpp5axwSxmE+i9/cTqF28EjvmwdiKEvcmPWWFsMUlHs5YAmV7SJy78pgJElY9
        jBJzn05gnMCoMAvJQ7OQPDQLYfUCRuZVjJKpBcW56anFpgXGeanl8ChOzs/dxAhOrVreOxgf
        Pfigd4iRiYPxEKMEB7OSCG/yYq5EId6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPTO55JfGG
        JpYGJmZmZiaWxmaGSuK87PFfE4QE0hNLUrNTUwtSi2D6mDg4pRqYuFcXvn7bsFX7fanWqu/C
        1xO5BIwENiuEBj2eGb19m8vC595J/OW7g78+LRDYX3UlcmfEOcu53zf/eL7kqZ2ViOzr/7Wf
        D99MtGLgzc9/9ffRFl0L1fi4iC7+5OcbXth/yQ3bbuLtoiv+pkFjxaKt1wM2zN0Xr7WyzSMu
        4civf0/e3DTnretdZXKLT39C6/Glr2tajifsMQqq+2O25cv1wD8z3OtVgy033ZvOsivldu2d
        +lu3954unLBjbmpvdt614+odf7/sCMkrOB3YFrbwy9e0swdbzt+bXet+6aFXYvqyF+fb09Rc
        bxW3Py7bFpDfPKPLaNfaPXPvrJlsmVHdsej3ee5NmWIeovv2OH7aEqPEUpyRaKjFXFScCABM
        rxo3NgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSnO62B9yJBlvvyVk0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLY7+f8tmMenQNUaL+cuesltcmbKI2YHL4/LZUo9NqzrZ
        PDYvqffYfbOBzaNvyypGj82nqz0+b5ILYI/isklJzcksSy3St0vgyri+KrNgj0TFzzVrWBsY
        rwt3MXJySAiYSFx4c5mti5GLQ0hgB6PE/Ad3mSES4hLN136wQ9jCEiv/PWeHKPrIKPHu4WSg
        Ig4ONgFNiQuTS0FqRATMJJYeXsMCUsMssIJRYnffb0aQhLCAn8S0O+vZQGwWAVWJk1cmsYH0
        8gpYSFxcbwoxX15i5qXvYLs4BSwlPh/aywpSIgRUMnNrBEiYV0BQ4uTMJywgNjNQefPW2cwT
        GAVmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOPi1tHYw7ln1Qe8Q
        IxMH4yFGCQ5mJRHe5MVciUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1I
        LYLJMnFwSjUwzeZruy3z4NLJBZ/C379kufVsY9PRKayPnm5em6AjY1GzN0rnZ/OZmBePntf8
        rjD+NXG74m5jg/nxcv+VilRrhLVLv18o+JH2n6v6Wm2MsVnBSrb/h/Ojdhhu26b4Q2pnxPmG
        oGr1p5dUBCZe9av926t1YRe/2tqXnb8E5Fc5977h+Z7olKv7Xlrr7o7FG3edt+P+VrMnSkNZ
        Yvv/+i2HIqoqzDh2Hr7z6QibmmX6ZNargRd4X3cntxvGzo2xyJyZPr9QqOWxSl4Jp+aDCVOV
        evUCLn/7OGN9bm9U1Uwnnck+Z+Z+cmJa8q7/uljjJFe5SJ/EJWmiwVpqczbb7FGzu62q+/7q
        ugKTGc86v75pU2Ipzkg01GIuKk4EAJ8VHu3tAgAA
X-CMS-MailID: 20210805125934epcas5p4ff88e95d558ad9f65d77a888a4211b18
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210805125934epcas5p4ff88e95d558ad9f65d77a888a4211b18
References: <20210805125539.66958-1-joshi.k@samsung.com>
        <CGME20210805125934epcas5p4ff88e95d558ad9f65d77a888a4211b18@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add IORING_OP_URING_CMD_FIXED opcode that enables performing the
operation with previously registered buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c                 | 27 ++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  6 +++++-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f2263a78c8e..a80f4c98ea86 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1060,6 +1060,10 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.offsets		= 1,
 	},
+	[IORING_OP_URING_CMD_FIXED] = {
+		.needs_file		= 1,
+		.offsets		= 1,
+	},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3602,7 +3606,12 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 	}
 
 	cmd->op = READ_ONCE(csqe->op);
-	cmd->len = READ_ONCE(csqe->len);
+	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
+		req->imu = NULL;
+		io_req_set_rsrc_node(req);
+		req->buf_index = READ_ONCE(csqe->buf_index);
+	} else
+		cmd->len = READ_ONCE(csqe->len);
 
 	/*
 	 * The payload is the last 40 bytes of an io_uring_cmd_sqe, with the
@@ -3617,6 +3626,20 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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
 	ret = file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
 	/* queued async, consumer will call io_uring_cmd_done() when complete */
 	if (ret == -EIOCBQUEUED)
@@ -6031,6 +6054,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_URING_CMD:
+	case IORING_OP_URING_CMD_FIXED:
 		return io_uring_cmd_prep(req, sqe);
 	}
 
@@ -6322,6 +6346,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_unlinkat(req, issue_flags);
 		break;
 	case IORING_OP_URING_CMD:
+	case IORING_OP_URING_CMD_FIXED:
 		ret = io_uring_cmd(req, issue_flags);
 		break;
 	default:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92565e17bfd9..1a10ebd4ca0a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -75,7 +75,10 @@ struct io_uring_cmd_sqe {
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
 
@@ -154,6 +157,7 @@ enum {
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
 	IORING_OP_URING_CMD,
+	IORING_OP_URING_CMD_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

