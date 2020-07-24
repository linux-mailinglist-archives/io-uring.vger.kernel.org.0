Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBB22CAFE
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgGXQYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:24:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11938 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXQYI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:24:08 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200724162405epoutp019a90f1ecbab1fab6c3d446b5ef041c04~kvOGm5CT_1639216392epoutp01W
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:24:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200724162405epoutp019a90f1ecbab1fab6c3d446b5ef041c04~kvOGm5CT_1639216392epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607845;
        bh=KeFwOYrInKU609vftU4EN0rxqpWu0rMpyqf8XT/yacE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yg+zRx2VZbjcjICwEdV2cNmHtRMLHRygm2F6nzcL2xcqceT3HGdrpxLkRdAlU/SJZ
         bZzbNv/nyVibEkqKXU/U7Cbidd+PxC8lf3t7AaV+pKnvG4tdPU4R3YAKo0hWoCm4my
         YqQEtWzUb0f8N7t+YCR7+utqFyH1vyw9k9dVTBPM=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200724162404epcas5p21d4420cd725d79755515dce085c47495~kvOGFwfgZ0166301663epcas5p2l;
        Fri, 24 Jul 2020 16:24:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.DE.40333.42B0B1F5; Sat, 25 Jul 2020 01:24:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6~kuzsaFGFN2159221592epcas5p3p;
        Fri, 24 Jul 2020 15:53:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724155350epsmtrp2568e442acbfa8216b95a7bd6d4fffab5~kuzsZNZ2Z3047030470epsmtrp2I;
        Fri, 24 Jul 2020 15:53:50 +0000 (GMT)
X-AuditID: b6c32a4a-991ff70000019d8d-93-5f1b0b24a73d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.02.08382.E040B1F5; Sat, 25 Jul 2020 00:53:50 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155347epsmtip1888a12b2f1b4a91068b9c468f211fa2f~kuzpxyPVc0513905139epsmtip15;
        Fri, 24 Jul 2020 15:53:47 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, SelvaKumar S <selvakuma.s1@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v4 6/6] io_uring: add support for zone-append
Date:   Fri, 24 Jul 2020 21:19:22 +0530
Message-Id: <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWy7bCmuq4Kt3S8weNebYvf06ewWsxZtY3R
        YvXdfjaLrn9bWCxa278xWZyesIjJ4l3rORaLx3c+s1sc/f+WzWLKtCZGi83fO9gs9t7Sttiz
        9ySLxeVdc9gstv2ez2xxZcoiZovXP06yWZz/e5zV4vePOWwOwh47Z91l99i8Qsvj8tlSj02f
        JrF79G1ZxejxeZOcR/uBbiaPTU/eMgVwRHHZpKTmZJalFunbJXBl3Pn5iK3giHbFts2XmRoY
        5yl3MXJySAiYSLTfnczcxcjFISSwm1Fi4tzDTBDOJ0aJ0y/fskI43xgl5j48ygzTsmzTU6jE
        XkaJ3X3T2SCcz4wSh/89AKri4GAT0JS4MLkUxBQRsJHYuUQFpIRZYDmzxISOH6wgg4QFbCVO
        f+lhAalhEVCVWPEwBCTMK+As0f5rDyPELjmJm+c6wfZyCrhIXLh4Fyq+hUOi6QcHhO0isef6
        VDYIW1ji1fEt7BC2lMTnd3uh4sUSv+4cBXtTQqCDUeJ6w0wWiIS9xMU9f5lAbmAGOnn9Ln2I
        sKzE1FPrmEBsZgE+id7fT5gg4rwSO+bB2IoS9yY9ZYWwxSUezlgCZXtI7Pv3gRESJNOBQTJl
        GvsERrlZCCsWMDKuYpRMLSjOTU8tNi0wykst1ytOzC0uzUvXS87P3cQITlBaXjsYHz74oHeI
        kYmD8RCjBAezkgjvim9S8UK8KYmVValF+fFFpTmpxYcYpTlYlMR5lX6ciRMSSE8sSc1OTS1I
        LYLJMnFwSjUwZd0/5c64+GKs8xzLixfiHcuX66pJr3wl4Z51wetJeejG1cHb33Nf2PG3ZOuc
        5dXTckuzee6/E/jmfon98a0sl6QbpX7ThIyPS7RltSw6lTL3lt98+SU8X/aki2sxlEclCm62
        k8m9KHfsvtK/e35MT3Zocpv6bX5wyNksXab3x/eCrtp6z6nzKlzlrzxfdvvlxY7yFb8yq4R6
        A2c6Tg5h//Zv7y0FVRFXz83Vv3T2Rqv4Gd4+fmdCUWDI+eSWY3eyzTjel3PfyBNawBtmsTSi
        bcFR7+e7fxw9Yq0wj7HYn22Xhrm9+ZScmb8SPZSjzzBbZ7Mcdeh9mPu48raDxBnN7YpVpby5
        ptydtxS3TfuvxFKckWioxVxUnAgAu5ESLL8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnC4fi3S8wfLD4ha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFpu/d7BZ7L2lbbFn
        70kWi8u75rBZbPs9n9niypRFzBavf5xkszj/9zirxe8fc9gchD12zrrL7rF5hZbH5bOlHps+
        TWL36NuyitHj8yY5j/YD3Uwem568ZQrgiOKySUnNySxLLdK3S+DKuPPzEVvBEe2KbZsvMzUw
        zlPuYuTkkBAwkVi26SlrFyMXh5DAbkaJk+/eM0EkxCWar/1gh7CFJVb+e84OUfSRUWL/3knM
        XYwcHGwCmhIXJpeC1IgIOEh0HX/MBFLDLLCdWWLm0bmsIAlhAVuJ0196WEDqWQRUJVY8DAEJ
        8wo4S7T/2sMIMV9O4ua5TmYQm1PAReLCxbuMIOVCQDUXf5RPYORbwMiwilEytaA4Nz232LDA
        MC+1XK84Mbe4NC9dLzk/dxMjOAa0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHeFd+k4oV4UxIrq1KL
        8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpgkjmXmh3W+66Lw/DZQh7P
        m2sce9frr56q9OTjryaV2R9f/jlrkVpRmlDgJzePWcm8ZY+xLT+P+raqOwsU99cv06tjPyNj
        MSvE9rZV1Npr5Y48KwXZ7l3UkOLuULb705yS/0naOLqxkstBXNRx/9FD7K7eubpTNvy7YSVR
        wWZqYZ0Y2Ru388GnN12xwhWawRLqJWsk5tx+lzvbzcK1qWhOxD7rbC3l2cx5C/76PwmPMJo1
        UUIjyGR6nnrJyc5TPWonAs9f0F4eyKH2KERzdcZ89gs6W6QUOS59PlixYNL3A6EH9QrKpf5t
        aC5JPM/AeahYxWgaR/OtJ4llh9W2TE35MM3E1PBYnZ1S98eHi5VYijMSDbWYi4oTAeU0e+Tw
        AgAA
X-CMS-MailID: 20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
        <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: SelvaKumar S <selvakuma.s1@samsung.com>

Repurpose [cqe->res, cqe->flags] into cqe->res64 (signed) to report
64bit written-offset for zone-append. The appending-write which requires
reporting written-location (conveyed by IOCB_ZONE_APPEND flag) is
ensured not to be a short-write; this avoids the need to report
number-of-bytes-copied.
append-offset is returned by lower-layer to io-uring via ret2 of
ki_complete interface. Make changes to collect it and send to user-space
via cqe->res64.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/io_uring.c                 | 49 ++++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  9 ++++++--
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7809ab2..6510cf5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -401,7 +401,14 @@ struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
 	u64				addr;
-	u64				len;
+	union {
+		/*
+		 * len is used only during submission.
+		 * append_offset is used only during completion.
+		 */
+		u64			len;
+		u64			append_offset;
+	};
 };
 
 struct io_connect {
@@ -541,6 +548,7 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_QUEUE_TIMEOUT_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
+	REQ_F_ZONE_APPEND_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -598,6 +606,8 @@ enum {
 	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
+	/* to return zone append offset */
+	REQ_F_ZONE_APPEND = BIT(REQ_F_ZONE_APPEND_BIT),
 };
 
 struct async_poll {
@@ -1244,8 +1254,15 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
-			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, req->cflags);
+			if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
+				if (likely(req->result > 0))
+					WRITE_ONCE(cqe->res64, req->rw.append_offset);
+				else
+					WRITE_ONCE(cqe->res64, req->result);
+			} else {
+				WRITE_ONCE(cqe->res, req->result);
+				WRITE_ONCE(cqe->flags, req->cflags);
+			}
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 	cqe = io_get_cqring(ctx);
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, req->user_data);
-		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, cflags);
+		if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
+			if (likely(res > 0))
+				WRITE_ONCE(cqe->res64, req->rw.append_offset);
+			else
+				WRITE_ONCE(cqe->res64, res);
+		} else {
+			WRITE_ONCE(cqe->res, res);
+			WRITE_ONCE(cqe->flags, cflags);
+		}
 	} else if (ctx->cq_overflow_flushed) {
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1943,7 +1967,7 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-static void io_complete_rw_common(struct kiocb *kiocb, long res)
+static void io_complete_rw_common(struct kiocb *kiocb, long res, long long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	int cflags = 0;
@@ -1955,6 +1979,9 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
+	if (req->flags & REQ_F_ZONE_APPEND)
+		req->rw.append_offset = res2;
+
 	__io_cqring_add_event(req, res, cflags);
 }
 
@@ -1962,7 +1989,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	io_complete_rw_common(kiocb, res);
+	io_complete_rw_common(kiocb, res, res2);
 	io_put_req(req);
 }
 
@@ -1976,8 +2003,11 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long long res2)
 	if (res != req->result)
 		req_set_fail_links(req);
 	req->result = res;
-	if (res != -EAGAIN)
+	if (res != -EAGAIN) {
+		if (req->flags & REQ_F_ZONE_APPEND)
+			req->rw.append_offset =  res2;
 		WRITE_ONCE(req->iopoll_completed, 1);
+	}
 }
 
 /*
@@ -2739,6 +2769,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 						SB_FREEZE_WRITE);
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
+		/* zone-append requires few extra steps during completion */
+		if (kiocb->ki_flags & IOCB_ZONE_APPEND)
+			req->flags |= REQ_F_ZONE_APPEND;
 
 		if (!force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c2269..2580d93 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -156,8 +156,13 @@ enum {
  */
 struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
-	__s32	res;		/* result code for this event */
-	__u32	flags;
+	union {
+		struct {
+			__s32	res;	/* result code for this event */
+			__u32	flags;
+		};
+		__s64	res64;	/* appending offset for zone append */
+	};
 };
 
 /*
-- 
2.7.4

