Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B89E4D1BF6
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347921AbiCHPm5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347968AbiCHPmy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:42:54 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5A54ECE1
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:41:56 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154153epoutp03dc3adfb70afbed0d349106fb7e745d6c~aciQl4WMk2455624556epoutp037
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:41:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154153epoutp03dc3adfb70afbed0d349106fb7e745d6c~aciQl4WMk2455624556epoutp037
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754113;
        bh=ZieorIZ+j5h8EI+90pdzpAhBaEPS1ZjtIJkbUiQYYd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kz/OH60pw9rSaW8HcqQOiT1KrsUaXL6zSecZc/aDABFXO51GJF5TyVlC2TQcUo8WO
         WhVKpMmEmIJ8exh8Bopxt7qRvJdUO6Eeb1I6NH8vaJRLjmD/PP3y9kxmpWipIhQicQ
         ADzqDPUxgtOX2ovR6ho83SZnsJbBEnmX2/fm+cho=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220308154152epcas5p21f1563d14c5155be4fdc7dd755c235ed~aciP6dkU42884128841epcas5p2M;
        Tue,  8 Mar 2022 15:41:52 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfhF0vthz4x9Pv; Tue,  8 Mar
        2022 15:41:49 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.AB.05590.C3977226; Wed,  9 Mar 2022 00:41:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152653epcas5p10c31f58cf6bff125cc0baa176b4d4fac~acVKklf6q1816518165epcas5p1Y;
        Tue,  8 Mar 2022 15:26:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152653epsmtrp1fe07683fdc8270ace03a527428d4b61e~acVKjfmC00125001250epsmtrp1L;
        Tue,  8 Mar 2022 15:26:53 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-0b-6227793cd86c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.51.29871.DB577226; Wed,  9 Mar 2022 00:26:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152651epsmtip16d484f8aaaa4d3e5114ee5cf029c8893~acVIgR9hJ3168431684epsmtip19;
        Tue,  8 Mar 2022 15:26:51 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 01/17] io_uring: add support for 128-byte SQEs
Date:   Tue,  8 Mar 2022 20:50:49 +0530
Message-Id: <20220308152105.309618-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmlq5tpXqSwVQui+mHFS2aJvxltpiz
        ahujxeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZTDp0jdFi7y1ti/nLnrJbLGk9zmZxY8JT
        Ros1N5+yWHw+M4/Vgd/j2dVnjB47Z91l92hecIfF4/LZUo9NqzrZPDYvqffYfbOBzWPb4pes
        Hn1bVjF6fN4kF8AVlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
        4hOg65aZA/SCkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8v
        tcTK0MDAyBSoMCE74/2dfywFMyUqulZ2sTQwXhTuYuTgkBAwkbj7I7eLkYtDSGA3o8TZLZdZ
        IZxPjBIfbu9n7mLkBHK+MUpM210EYoM0XGxtZYco2sso8b5hARuE85lRYsqvv+wgY9kENCUu
        TC4FaRAR8JK4f/s92FRmgS4mibf77rOBJIQF7CRmfT7BBGKzCKhKtC/6ywzSyytgKdH4vxBi
        mbzEzEvf2UFsTgEriZ+3trKC2LwCghInZz5hAbGZgWqat85mBpkvIXCEQ2LToX42iGYXiYc7
        V7JA2MISr45vYYewpSRe9rdB2cUSv+4chWruYJS43jATqsFe4uKev0wgBzEDPbN+lz5EWFZi
        6ql1TBCL+SR6fz9hgojzSuyYB2MrStyb9JQVwhaXeDhjCZTtIbGx7yM0eHsZJR79u8M+gVFh
        FpKHZiF5aBbC6gWMzKsYJVMLinPTU4tNC4zzUsvhkZycn7uJEZyqtbx3MD568EHvECMTB+Mh
        RgkOZiUR3vvnVZKEeFMSK6tSi/Lji0pzUosPMZoCA3wis5Rocj4wW+SVxBuaWBqYmJmZmVga
        mxkqifOeSt+QKCSQnliSmp2aWpBaBNPHxMEp1cD0MHDLs9Nioit6Pt/6vrQx7920vS8K6laG
        vH42+ZeXf+z8g7WLVspvnc7/J/C576VpD10/qhW+sC/YtvHJg4pdFcenLJE+f2SqrNdHhq67
        N91ev3r+R3V6des/b5UsjdNpQkpu7ltL+47VSogpNmU2TI/+H/6V3zDh8jueTRyhj/ddX373
        S3THxuz49l+nZwZfCHjY6r/7q97ZXLaDeUxHVgi2mjNveuLjM3cz2xuzNR0NU8qFj3XzGDVa
        +9QwP7nJInPWOiz71cpp4iXZW93e/bg+x4d3RcSdF/dfzJ2woIrn7Tkhhaa7d66JHU7JSg2/
        /Kv/QJjtou011rfnd3Xt4FhakvlnepTNhhvq/jWxc5RYijMSDbWYi4oTAXX1s9JeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTndvqXqSwa/74hbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr4/2dfywFMyUqulZ2sTQwXhTuYuTkkBAwkbjY
        2soOYgsJ7GaU6FiRBxEXl2i+9oMdwhaWWPnvOZDNBVTzkVHi3aJLbF2MHBxsApoSFyaXgtSI
        CARIHGy8DFbDLDCDSaKn+TMLSEJYwE5i1ucTTCA2i4CqRPuiv8wgvbwClhKN/wsh5stLzLz0
        HWwXp4CVxM9bW1kh7rGUWLHuNxuIzSsgKHFy5hOwkcxA9c1bZzNPYBSYhSQ1C0lqASPTKkbJ
        1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4GjS0tzBuH3VB71DjEwcjIcYJTiYlUR4759X
        SRLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBSeKUWarr
        ErZUxrCzEc/t864c+vnE9JjV8xDhHPMddhcmb0zujdEV74tr2+F7oL42suDhtik3D87eIdfa
        nr1eYL2BJfdZhgSrXwZFuQp7GLVFzhb8SzkWtmxT190ZR7K0rNRPzvOcb7hB44QN9+tVCgc+
        HHzLc0/9SL38chHOQ2ZK2358WS6259LGYs5X5xw377e4pj3jgeGOPVyra5bk1DhuUYve+Naw
        m7VX5fuWHUf3JzDuFPAIfv359buZgicXuxQHNsYvyOdXTfjM4eKqF3u45nn5kcmx7Rqq7II/
        1hZ4ljKvWGN0/t2LjwefSkx7URS3d5Gk2xPzOeVh4fqijV6WJ46Fe3a+e/XjHu8iByWW4oxE
        Qy3mouJEAD3/bYoVAwAA
X-CMS-MailID: 20220308152653epcas5p10c31f58cf6bff125cc0baa176b4d4fac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152653epcas5p10c31f58cf6bff125cc0baa176b4d4fac
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152653epcas5p10c31f58cf6bff125cc0baa176b4d4fac@epcas5p1.samsung.com>
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

