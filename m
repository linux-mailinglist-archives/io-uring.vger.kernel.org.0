Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7641FD373
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFQR1T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 13:27:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41058 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgFQR1T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 13:27:19 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200617172716epoutp020453fd2770368f6c97c07d9190fa66dd~ZZNs7ItHn2436424364epoutp02J
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 17:27:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200617172716epoutp020453fd2770368f6c97c07d9190fa66dd~ZZNs7ItHn2436424364epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592414836;
        bh=63VBCGU/0ntQ7nedglOpC7zYZy8fqZsAEdxHsErn/AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtESYsZQx9eLZsDBLy/va2jnyvIj0AE+VPn5N2RK4XLB8VHQ+CoCLOdzTbjN/jSfq
         cEmPH4Yoei+sLscXDTOmupdH93PNfYvAVd7LpbalO7CFRm2S4nwx8ljItNBau0cT3c
         dOUTsGcBNl1Qyxp9OQhysG6f1A/bkFCe5juO1ezo=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200617172714epcas5p1fe972604ea8b24f8f56d96196e0b0eab~ZZNrgz2Ll1054310543epcas5p1B;
        Wed, 17 Jun 2020 17:27:14 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.66.09475.2725AEE5; Thu, 18 Jun 2020 02:27:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e~ZZNqw0bGY2692326923epcas5p3e;
        Wed, 17 Jun 2020 17:27:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200617172713epsmtrp21f71c5731452333edc77419e8f5a90c5~ZZNqv-Dj80603706037epsmtrp2W;
        Wed, 17 Jun 2020 17:27:13 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-3a-5eea52723055
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.7E.08303.1725AEE5; Thu, 18 Jun 2020 02:27:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200617172711epsmtip1f74a209597ea26fe133e1bc32c360cfa~ZZNotmn7c1160511605epsmtip1l;
        Wed, 17 Jun 2020 17:27:11 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 3/3] io_uring: add support for zone-append
Date:   Wed, 17 Jun 2020 22:53:39 +0530
Message-Id: <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7bCmlm5R0Ks4gzNPpSxW3+1ns+j6t4XF
        4l3rORaLx3c+s1sc/f+WzWLhxmVMFlOmNTFa7L2lbbFn70kWi8u75rBZbPs9n9niypRFzBav
        f5xkszj/9zirA5/H5bOlHps+TWL36NuyitHj8yY5j01P3jIFsEZx2aSk5mSWpRbp2yVwZRzZ
        PpG9YK5pxdQ5F1kbGNdpdTFyckgImEgsXPmfuYuRi0NIYDejxJy/D6CcT4wSt3ceZoJwPjNK
        XJj7hr2LkQOs5VizOkR8F6PEru+9CEU3jk9kBCliE9CUuDC5FMQUEbCR2LlEBWQbs0ADk8T/
        7zogYWEBK4nOZTogYRYBVYnbN3czg9i8Ak4Se1fOZYY4Tk7i5rlOMJtTwFli9uZLrCCbJAT+
        sku0Pe1lgShykbg+cRE7hC0s8er4FihbSuLzu71sEHaxxK87R5khmjsYJa43zIRqtpe4uOcv
        E8hBzEAnr9+lD3Enn0Tv7ydMEO/ySnS0CUFUK0rcm/SUFcIWl3g4YwmU7SFx9e1VdkgoTGOU
        WP/oHvsERtlZCFMXMDKuYpRMLSjOTU8tNi0wzkst1ytOzC0uzUvXS87P3cQIThta3jsYHz34
        oHeIkYmD8RCjBAezkgiv8+8XcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5lX6ciRMSSE8sSc1O
        TS1ILYLJMnFwSjUwOU78+4ljLs8SNpXaHWbT9ZpO7rhn0G22Yf9ag/SiGbcOsZgte6Cz6jrz
        EsWjl1486Lrr1JfpEif9W2CNQaR4NEsL84Wy1parS6vD13Y7Te/zss6P21XpVWXoXnv4vsLT
        97UzZhne1i/zfGQj0F/pxLc/55z67rfPFvLfn8mxdk7eFX+1yq9ze+ryzJ/df3bwistzkQNL
        tnZvK+A/ddvF1P+V3aeSWVd0377NSrrKEy7NG8lx5631lMkP/r3/y372y7p71WLbKloeVLte
        bvXNyxQUUPOYOe1BTQtr7af/nQbyqp2/6lbPTsg5sud58qoLP1m9Ez9d2X+xypXVy2PjiUmT
        rvnd2c5Yt3HqAoGkAiWW4oxEQy3mouJEAI/zUdCKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnG5h0Ks4g3fTVSxW3+1ns+j6t4XF
        4l3rORaLx3c+s1sc/f+WzWLhxmVMFlOmNTFa7L2lbbFn70kWi8u75rBZbPs9n9niypRFzBav
        f5xkszj/9zirA5/H5bOlHps+TWL36NuyitHj8yY5j01P3jIFsEZx2aSk5mSWpRbp2yVwZRzZ
        PpG9YK5pxdQ5F1kbGNdpdTFycEgImEgca1bvYuTiEBLYwSgxY1IvWxcjJ1BcXKL52g92CFtY
        YuW/5+wQRR8ZJVatO8oC0swmoClxYXIpSI2IgINE1/HHTCA1zAJdTBInbu5iAqkRFrCS6Fym
        A1LDIqAqcfvmbmYQm1fASWLvyrnMEPPlJG6e6wSzOQWcJWZvvsQKYgsB1fxZNIt1AiPfAkaG
        VYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwUGrpbWDcc+qD3qHGJk4GA8xSnAwK4nw
        Ov9+ESfEm5JYWZValB9fVJqTWnyIUZqDRUmc9+ushXFCAumJJanZqakFqUUwWSYOTqkGporN
        oqv+JNvrXprQpXQy3jKhMvbwF5VgB44/C1c2LUxxi8uuieosvxM7bV78r/zeOR56R1ecqAx+
        EpzXKuF7PKP9mvlVi04th99S09uLncVXuilP+bb83zb1/10+q1Ki/lU+ujNZNNL//4+kB+YL
        dwVOaxZ2qXSZnsPI/L97+75A3g/Li9W6p7PaLZ4kbNouljlRp39NjWvAf9/2/Z+fZYQIpLHt
        3Jt97WrnJclvkypYTFrrnz6Iv2fuvzrP/NWUdbMyV+34dKyyIXnH/n+ioUxWxXej3P+sL+RY
        aNmqrVMgs4rjU7NHmfABw4zTdxdI7Ld4ne/nYrf6UnHSKaNZa25tXZYtwz454uj1mxuMlViK
        MxINtZiLihMB8rpxuckCAAA=
X-CMS-MailID: 20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Selvakumar S <selvakuma.s1@samsung.com>

Introduce three new opcodes for zone-append -

   IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
   IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
   IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers

Repurpose cqe->flags to return zone-relative offset.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  8 ++++-
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d8..c14c873 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -649,6 +649,10 @@ struct io_kiocb {
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
+#ifdef CONFIG_BLK_DEV_ZONED
+	/* zone-relative offset for append, in bytes */
+	u32			append_offset;
+#endif
 	u32			sequence;
 
 	struct list_head	link_list;
@@ -875,6 +879,26 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_ZONE_APPEND] = {
+		.needs_mm               = 1,
+		.needs_file             = 1,
+		.unbound_nonreg_file    = 1,
+		.pollout		= 1,
+	},
+	[IORING_OP_ZONE_APPENDV] = {
+	       .async_ctx              = 1,
+	       .needs_mm               = 1,
+	       .needs_file             = 1,
+	       .hash_reg_file          = 1,
+	       .unbound_nonreg_file    = 1,
+	       .pollout			= 1,
+	},
+	[IORING_OP_ZONE_APPEND_FIXED] = {
+	       .needs_file             = 1,
+	       .hash_reg_file          = 1,
+	       .unbound_nonreg_file    = 1,
+	       .pollout			= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -1285,7 +1309,16 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
+#ifdef CONFIG_BLK_DEV_ZONED
+		if (req->opcode == IORING_OP_ZONE_APPEND ||
+				req->opcode == IORING_OP_ZONE_APPENDV ||
+				req->opcode == IORING_OP_ZONE_APPEND_FIXED)
+			WRITE_ONCE(cqe->res2, req->append_offset);
+		else
+			WRITE_ONCE(cqe->flags, cflags);
+#else
 		WRITE_ONCE(cqe->flags, cflags);
+#endif
 	} else if (ctx->cq_overflow_flushed) {
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1961,6 +1994,9 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+#ifdef CONFIG_BLK_DEV_ZONED
+	req->append_offset = (u32)res2;
+#endif
 
 	io_complete_rw_common(kiocb, res);
 	io_put_req(req);
@@ -1976,6 +2012,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (res != req->result)
 		req_set_fail_links(req);
 	req->result = res;
+#ifdef CONFIG_BLK_DEV_ZONED
+	req->append_offset = (u32)res2;
+#endif
 	if (res != -EAGAIN)
 		WRITE_ONCE(req->iopoll_completed, 1);
 }
@@ -2408,7 +2447,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	u8 opcode;
 
 	opcode = req->opcode;
-	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
+	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED ||
+			opcode == IORING_OP_ZONE_APPEND_FIXED) {
 		*iovec = NULL;
 		return io_import_fixed(req, rw, iter);
 	}
@@ -2417,7 +2457,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 
-	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
+	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE ||
+			opcode == IORING_OP_ZONE_APPEND) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
 			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
 			if (IS_ERR(buf)) {
@@ -2704,6 +2745,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
 
 	req->result = 0;
+#ifdef CONFIG_BLK_DEV_ZONED
+	req->append_offset = 0;
+#endif
 	io_size = ret;
 	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
@@ -2738,6 +2782,13 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 			__sb_writers_release(file_inode(req->file)->i_sb,
 						SB_FREEZE_WRITE);
 		}
+#ifdef CONFIG_BLK_DEV_ZONED
+		if (req->opcode == IORING_OP_ZONE_APPEND ||
+				req->opcode == IORING_OP_ZONE_APPENDV ||
+				req->opcode == IORING_OP_ZONE_APPEND_FIXED)
+			kiocb->ki_flags |= IOCB_ZONE_APPEND;
+#endif
+
 		kiocb->ki_flags |= IOCB_WRITE;
 
 		if (!force_nonblock)
@@ -4906,6 +4957,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
+#ifdef CONFIG_BLK_DEV_ZONED
+	fallthrough;
+	case IORING_OP_ZONE_APPEND:
+	case IORING_OP_ZONE_APPENDV:
+	case IORING_OP_ZONE_APPEND_FIXED:
+#endif
 		ret = io_write_prep(req, sqe, true);
 		break;
 	case IORING_OP_POLL_ADD:
@@ -5038,6 +5095,12 @@ static void io_cleanup_req(struct io_kiocb *req)
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
+#ifdef CONFIG_BLK_DEV_ZONED
+	fallthrough;
+	case IORING_OP_ZONE_APPEND:
+	case IORING_OP_ZONE_APPENDV:
+	case IORING_OP_ZONE_APPEND_FIXED:
+#endif
 		if (io->rw.iov != io->rw.fast_iov)
 			kfree(io->rw.iov);
 		break;
@@ -5086,6 +5149,11 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_read(req, force_nonblock);
 		break;
+#ifdef CONFIG_BLK_DEV_ZONED
+	case IORING_OP_ZONE_APPEND:
+	case IORING_OP_ZONE_APPENDV:
+	case IORING_OP_ZONE_APPEND_FIXED:
+#endif
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c2269..6c8e932 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -130,6 +130,9 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_ZONE_APPEND,
+	IORING_OP_ZONE_APPENDV,
+	IORING_OP_ZONE_APPEND_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -157,7 +160,10 @@ enum {
 struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
-	__u32	flags;
+	union {
+		__u32	res2; /* res2 like aio, currently used for zone-append */
+		__u32	flags;
+	};
 };
 
 /*
-- 
2.7.4

