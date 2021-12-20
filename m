Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01CB47B8B6
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhLUC5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:57:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43253 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhLUC46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:58 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211221025657epoutp02bc7e7b931408299dcb05ad6330e265c2~CpbZoI2VT2870228702epoutp02Y
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211221025657epoutp02bc7e7b931408299dcb05ad6330e265c2~CpbZoI2VT2870228702epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055417;
        bh=rfpmkXvtBx85hRvQm9aTlYTjkImDVAUlbe+HZabwpAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEvyjsB5SLS1YJ9r6dDvNnu5Nva85ghwvQJXUPalQ5U13eKCzVfa25X6chQBFCBJ9
         hHxJwlHb4LVIQnuiludHqwG14q/Aldxzi0OVKzY5NJ2Poo7ljDYnzqRBqa7y7hE7ZV
         /VKLQcC3xx2M0wC2WdXp4TlEqQXxaUrhFohCcYm0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20211221025656epcas5p35ebb22a17637f6ebec2e55376f046c35~CpbZKwkJO1655516555epcas5p30;
        Tue, 21 Dec 2021 02:56:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4JJ1M55HCZz4x9Q7; Tue, 21 Dec
        2021 02:56:49 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.12.46822.17241C16; Tue, 21 Dec 2021 11:56:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20211220142246epcas5p303c64b6b1b832c7fcd5ac31fc79c91d1~CfI6mkxip0906209062epcas5p3C;
        Mon, 20 Dec 2021 14:22:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211220142246epsmtrp2306cb12bf125091665ae9fc0e3b32dac~CfI6lxQIF1266312663epsmtrp27;
        Mon, 20 Dec 2021 14:22:46 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-f7-61c142717702
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.85.29871.6B190C16; Mon, 20 Dec 2021 23:22:46 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142244epsmtip177f41ad25b8108696b2cf53fd1c239c9~CfI4txnRE0637606376epsmtip1b;
        Mon, 20 Dec 2021 14:22:44 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 09/13] block: wire-up support for plugging
Date:   Mon, 20 Dec 2021 19:47:30 +0530
Message-Id: <20211220141734.12206-10-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmum6h08FEg/67WhZNE/4yW6y+289m
        sXL1USaLd63nWCw6T19gsjj/9jCTxaRD1xgt9t7Stpi/7Cm7xZqbT1kcuDx2zrrL7tG84A6L
        x+WzpR6bVnWyeWxeUu+x+2YDm0ffllWMHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7
        x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
        VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzlj6+ylzwQG5irWnp7I1MM6R7GLk5JAQ
        MJFY13uCsYuRi0NIYDejxIHuZ1DOJ0aJ7Q/7WSGcb4wSm5ramGBaOjfPZYdI7GWUeHb8OBOE
        85lRYvXTJpYuRg4ONgFNiQuTS0EaRASiJS48v8YGYjMLdDBK7Oy2BbGFBSwkvj6/wQJiswio
        Smz6cosdxOYVsJTou3SMHWKZvMTMS9/BbE6g+OHZy9ggagQlTs58wgIxU16ieetsZpAbJAQm
        ckhc61/ADNHsIvFmxnoWCFtY4tXxLVBDpSQ+v9vLBmEXS/y6cxSqGei46w0zoRrsJS7u+csE
        8gwz0DPrd+lDhGUlpp5axwSxmE+i9/cTaKjwSuyYB2MrStyb9JQVwhaXeDhjCSvIGAkBD4mm
        qwmQsOphlLh4+y3zBEaFWUj+mYXkn1kImxcwMq9ilEwtKM5NTy02LTDKSy2Hx3Jyfu4mRnCq
        1fLawfjwwQe9Q4xMHIyHGCU4mJVEeLfM3p8oxJuSWFmVWpQfX1Sak1p8iNEUGOATmaVEk/OB
        yT6vJN7QxNLAxMzMzMTS2MxQSZz3dPqGRCGB9MSS1OzU1ILUIpg+Jg5OqQYm6TUS9SZXM03v
        VQpOfH0y2uSyX7OepVbDfl8B9ba5Jq+WCXd+fjNbK14iWfiP8B0uhyzb+ZcvHNtULPg+Knlz
        dJ5xbcnWfw37/5c5OKovj5U4bOVV9Xtl4Llv1ceslTKTjpU3ewl2TXv+O3zLgffbJs8yyHSf
        2R0nFdk/4eqVu7EJl6NF74lwnJ62yqqvfGfY2RciYhKrm2+Wryi/Mck6pdJSf2+CwZUP3PXf
        04MfToqfunGGwaoTW1xtg9kXfLSrrL1gd6t4y/0Zi5rTehoqRRo8ThrMOn7lTleylFp9tvKP
        2RdlvvMsUvbuX7erM/VXsC/fM7Yvm1Y//VG6UXdL9P2JKy7vijy76PDe3rVHlViKMxINtZiL
        ihMBKWrOXT4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnO62iQcSDd5vELBomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY+nvp8wFB+Qq
        1p6eytbAOEeyi5GTQ0LARKJz81z2LkYuDiGB3YwSN96/Z4ZIiEs0X/vBDmELS6z89xyq6COj
        xJ6dfUxdjBwcbAKaEhcml4LUiAjESnz4dYwJpIZZYBKjxIb+B2DNwgIWEl+f32ABsVkEVCU2
        fbkFFucVsJTou3QMaoG8xMxL38FsTqD44dnL2EBsIaDeEx++sEDUC0qcnPkEzGYGqm/eOpt5
        AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBEeDluYOxu2rPugd
        YmTiYDzEKMHBrCTCu2X2/kQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YW
        pBbBZJk4OKUamKor3OqVCmtKN50qW//zcpr3Vd+sya7y+3gmivS8ex5rwNPx4v3BSdwhxp+7
        ZHq/C3SlbVjEx6brNm+xjdtR3e9zzXuKjye/ycv8yFp/M9hTr+xb2iPtWOM/XOvkS+v2NLO7
        GV2b8zui6aO3zb+/Bq8XveiaUzVndsSc4K18qcIvr6xe4np1d1ZC0bZderM8JvadPnSN4WD5
        xd9xq8RMZ02ZJ/F9qfkKP8n1c5InWIvNrTV96sXHPL8spo37wIUC78oDscvaYj4WPt954EDm
        7tcrG35uCj4gvV5866/5L/Wvvvi/89hatwafS1YLza9FVB641fk/NPhCbWlGbb9IbHXbc9nP
        zmoq52X2TZC8uU2JpTgj0VCLuag4EQC1zYEN9QIAAA==
X-CMS-MailID: 20211220142246epcas5p303c64b6b1b832c7fcd5ac31fc79c91d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142246epcas5p303c64b6b1b832c7fcd5ac31fc79c91d1
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142246epcas5p303c64b6b1b832c7fcd5ac31fc79c91d1@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Add support to use plugging if it is enabled, else use default path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c | 90 ++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0ebd09492aa5..c77991688bfd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2326,6 +2326,40 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 }
 
+/*
+ * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * queues. This is important for md arrays to benefit from merging
+ * requests.
+ */
+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+	if (plug->multiple_queues)
+		return BLK_MAX_REQUEST_COUNT * 2;
+	return BLK_MAX_REQUEST_COUNT;
+}
+
+static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
+{
+	struct request *last = rq_list_peek(&plug->mq_list);
+
+	if (!plug->rq_count) {
+		trace_block_plug(rq->q);
+	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
+		   (!blk_queue_nomerges(rq->q) &&
+		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
+		blk_mq_flush_plug_list(plug, false);
+		trace_block_plug(rq->q);
+	}
+
+	if (!plug->multiple_queues && last && last->q != rq->q)
+		plug->multiple_queues = true;
+	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
+		plug->has_elevator = true;
+	rq->rq_next = NULL;
+	rq_list_add(&plug->mq_list, rq);
+	plug->rq_count++;
+}
+
 /**
  * blk_mq_request_bypass_insert - Insert a request at dispatch list.
  * @rq: Pointer to request to be inserted.
@@ -2339,16 +2373,20 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
 				  bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
+	struct blk_plug *plug = current->plug;
 
-	spin_lock(&hctx->lock);
-	if (at_head)
-		list_add(&rq->queuelist, &hctx->dispatch);
-	else
-		list_add_tail(&rq->queuelist, &hctx->dispatch);
-	spin_unlock(&hctx->lock);
-
-	if (run_queue)
-		blk_mq_run_hw_queue(hctx, false);
+	if (plug) {
+		blk_add_rq_to_plug(plug, rq);
+	} else {
+		spin_lock(&hctx->lock);
+		if (at_head)
+			list_add(&rq->queuelist, &hctx->dispatch);
+		else
+			list_add_tail(&rq->queuelist, &hctx->dispatch);
+		spin_unlock(&hctx->lock);
+		if (run_queue)
+			blk_mq_run_hw_queue(hctx, false);
+	}
 }
 
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
@@ -2658,40 +2696,6 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		hctx->queue->mq_ops->commit_rqs(hctx);
 }
 
-/*
- * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
- * queues. This is important for md arrays to benefit from merging
- * requests.
- */
-static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
-{
-	if (plug->multiple_queues)
-		return BLK_MAX_REQUEST_COUNT * 2;
-	return BLK_MAX_REQUEST_COUNT;
-}
-
-static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
-{
-	struct request *last = rq_list_peek(&plug->mq_list);
-
-	if (!plug->rq_count) {
-		trace_block_plug(rq->q);
-	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
-		   (!blk_queue_nomerges(rq->q) &&
-		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
-		blk_mq_flush_plug_list(plug, false);
-		trace_block_plug(rq->q);
-	}
-
-	if (!plug->multiple_queues && last && last->q != rq->q)
-		plug->multiple_queues = true;
-	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
-		plug->has_elevator = true;
-	rq->rq_next = NULL;
-	rq_list_add(&plug->mq_list, rq);
-	plug->rq_count++;
-}
-
 static bool blk_mq_attempt_bio_merge(struct request_queue *q,
 				     struct bio *bio, unsigned int nr_segs)
 {
-- 
2.25.1

