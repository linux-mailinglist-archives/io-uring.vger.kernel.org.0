Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946094EEEE5
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 16:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346697AbiDAOM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 10:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346679AbiDAOM1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 10:12:27 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C810F5C641
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 07:10:37 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220401141032epoutp03f6e2f618fed34e32d2a4cf0c0881ce23~hyxWrujgB2364823648epoutp03G
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 14:10:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220401141032epoutp03f6e2f618fed34e32d2a4cf0c0881ce23~hyxWrujgB2364823648epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648822232;
        bh=ZieorIZ+j5h8EI+90pdzpAhBaEPS1ZjtIJkbUiQYYd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rsv2RypkU6bP1U9OWDLFSEBPMuTZDZ0HyHy36iemtu5wC0rjtOmLhsq+++AQ2jf8O
         xgVTF+7rciaEdtyCI95/TxpfV+nGxZXzLPB5zeCIp9J2b9kynPNi+9Z5ppPOT3+nkO
         3RX64Ns47iir7INFyRYMnyisf5nyzcJ4zr3I9DQs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220401141031epcas5p26b4503f7d38b9021f4585c5ddb0d5942~hyxV4t08q2063220632epcas5p2D;
        Fri,  1 Apr 2022 14:10:31 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KVMWl6ftyz4x9Px; Fri,  1 Apr
        2022 14:10:27 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.C7.09952.3D707426; Fri,  1 Apr 2022 23:10:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220401110831epcas5p403bacabe8f7e5262356fdc1a2e66df90~hwSbS8B980828108281epcas5p4d;
        Fri,  1 Apr 2022 11:08:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220401110831epsmtrp106228c8675820b674e06a5a586f3336b~hwSbSCD8B1309213092epsmtrp1V;
        Fri,  1 Apr 2022 11:08:31 +0000 (GMT)
X-AuditID: b6c32a4b-4b5ff700000226e0-e0-624707d34abd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.49.03370.E2DD6426; Fri,  1 Apr 2022 20:08:30 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220401110829epsmtip1f446390a3c50cca8f81bb8180c5f5be4~hwSZoiN3A0870008700epsmtip1z;
        Fri,  1 Apr 2022 11:08:29 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        pankydev8@gmail.com, javier@javigon.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [RFC 1/5] io_uring: add support for 128-byte SQEs
Date:   Fri,  1 Apr 2022 16:33:06 +0530
Message-Id: <20220401110310.611869-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401110310.611869-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmhu5ldvckg7XrDC2aJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ7y/84+lYKZERdfK
        LpYGxovCXYwcHBICJhIXr9h0MXJxCAnsZpSY9ugsK4TziVHiWv9idgjnM6PEyimdTF2MnGAd
        M1dNZYNI7GKUmHLuHgtc1fUJK1hA5rIJaEpcmFwK0iAiIC/x5fZasBpmgWuMEo9fHWIDSQgL
        WEnsPbaKHcRmEVCVWDr9OlicV8BSYtL+lVDb5CVmXvoOVsMJVH/o30aoGkGJkzOfsIDYzEA1
        zVtnM4MskBBYyCExb+lGqGYXiQnP5kLZwhKvjm9hh7ClJF72t0HZyRKt2y+zQwKjRGLJAnWI
        sL3ExT1/mUDCzEC/rN+lDxGWlZh6ah0TxFo+id7fT6Cm80rsmAdjK0rcm/SUFcIWl3g4Ywkr
        xHQPiW9zOUDCQgK9jBJHbsdMYFSYheSZWUiemYWweAEj8ypGydSC4tz01GLTAuO81HJ4FCfn
        525iBKdeLe8djI8efNA7xMjEwXiIUYKDWUmE92qsa5IQb0piZVVqUX58UWlOavEhRlNgaE9k
        lhJNzgcm/7ySeEMTSwMTMzMzE0tjM0Mlcd5T6RsShQTSE0tSs1NTC1KLYPqYODilGpgmc7oJ
        JhpdTX/o8OCsZya7nkn7wfDynVxiDauiZH50pJ62MYne4at6ynz/y451BeGJwi+ajhXP+3Bu
        ikaPUVHchJhHwpXbGU8/XKL34nVd2NPjubL7SoWmFFa7GxUs4d3w5jFvoWa/yflt8QqJkwoe
        XjPUs3X5KBy7m+1ZptK7Pd8/rr8l7j8lxHi518X3K4ze/S1S9nP6b1xi6rHJaJbftLnL9h7P
        VzNxq5mmHnSBm6n7gHLikhlHDCWabpZsX/ko6+Xx09JWZxfunGOp++RRnvdi5sT/qaplvna9
        n+8nL5wmc7g/qOuSkjt7eFNVoEhG8kS/KuWeR/xxnS/OnrDcF/lep7y2N2D1ys18FUosxRmJ
        hlrMRcWJALGaSxZGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnK7eXbckg84mK4umCX+ZLeas2sZo
        sfpuP5vFytVHmSzetZ5jseg8fYHJ4vzbw0wW85c9Zbe4MeEpo8Whyc1MFmtuPmVx4PbYOesu
        u0fzgjssHpfPlnpsWtXJ5rF5Sb3H7psNbB7v911l8+jbsorR4/MmuQDOKC6blNSczLLUIn27
        BK6M93f+sRTMlKjoWtnF0sB4UbiLkZNDQsBEYuaqqWxdjFwcQgI7GCW+9hxlg0iISzRf+8EO
        YQtLrPz3nB2i6COjxIaJL1m6GDk42AQ0JS5MLgWpERFQlNj4sYkRpIZZ4AGjxP3pv8EGCQtY
        Sew9tgpsEIuAqsTS6dfB4rwClhKT9q9kglggLzHz0newGk6g+kP/NoLVCAHV7J86jwWiXlDi
        5MwnYDYzUH3z1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cT
        IzhGtLR2MO5Z9UHvECMTB+MhRgkOZiUR3quxrklCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90
        nYwXEkhPLEnNTk0tSC2CyTJxcEo1MJ1uOCK7Ne3Y07SXMuYvXm99m/4w/I5C+cGNEnO2Vi6/
        Hz9h2sG925uM1A44/ZiVHJ8fIz8ptPXgWo3n8tyTjJ/rlxTGMP47veEst/+zSdPVRE+uPnrw
        RYpoZewDw8n8gRaH3vHNWPhTR3N/9YdH3zUNvLTvhsnax7fufBk7Ndt5itPGKzVOJu4nu1ua
        PrB3BQd579epsFrRNX3BE0Oe2XM+HNyfK2zkvG6tzvMyma+ut4qmvvtifMlUS5Brr2moe4r+
        t86HlTebcw7FbzqXvVPANbeV6dwcNUfWgx3N0ss7dmjfvd7D5f9VQorxbtfTZwKRiUsei/dy
        dhuvDNkoxDfhtt2r7AdVU7gna8pNlFViKc5INNRiLipOBABP3WZCAAMAAA==
X-CMS-MailID: 20220401110831epcas5p403bacabe8f7e5262356fdc1a2e66df90
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401110831epcas5p403bacabe8f7e5262356fdc1a2e66df90
References: <20220401110310.611869-1-joshi.k@samsung.com>
        <CGME20220401110831epcas5p403bacabe8f7e5262356fdc1a2e66df90@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Normal SQEs are 64-bytes in length, which is fine for all the commands
we support. However, in preparation for supporting passthrough IO,
provide an option for setting up a ring with 128-byte SQEs.

We continue to use the same type for io_uring_sqe, it's marked and
commented with a zero sized array pad at the end. This provides up
to 80 bytes of data for a passthrough command - 64 bytes for the
extra added data, and 16 bytes available at the end of the existing
SQE.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 13 ++++++++++---
 include/uapi/linux/io_uring.h |  7 +++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a7412f6862fc..241ba1cd6dcf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7431,8 +7431,12 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	 *    though the application is the one updating it.
 	 */
 	head = READ_ONCE(ctx->sq_array[sq_idx]);
-	if (likely(head < ctx->sq_entries))
+	if (likely(head < ctx->sq_entries)) {
+		/* double index for 128-byte SQEs, twice as long */
+		if (ctx->flags & IORING_SETUP_SQE128)
+			head <<= 1;
 		return &ctx->sq_sqes[head];
+	}
 
 	/* drop invalid entries */
 	ctx->cq_extra--;
@@ -10431,7 +10435,10 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
 
-	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
+	if (p->flags & IORING_SETUP_SQE128)
+		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
+	else
+		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
 		io_mem_free(ctx->rings);
 		ctx->rings = NULL;
@@ -10643,7 +10650,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SQE128))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..c5db68433ca5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -61,6 +61,12 @@ struct io_uring_sqe {
 		__u32	file_index;
 	};
 	__u64	__pad2[2];
+
+	/*
+	 * If the ring is initializefd with IORING_SETUP_SQE128, then this field
+	 * contains 64-bytes of padding, doubling the size of the SQE.
+	 */
+	__u64	__big_sqe_pad[0];
 };
 
 enum {
@@ -101,6 +107,7 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SQE128	(1U << 7)	/* SQEs are 128b */
 
 enum {
 	IORING_OP_NOP,
-- 
2.25.1

