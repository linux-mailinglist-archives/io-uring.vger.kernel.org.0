Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968F95ECB8F
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiI0Rta (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiI0Rs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:48:59 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAC71D3589
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:46:34 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220927174633epoutp0378626d2268a0bc6b1785cb9ce3005a29~YyMDsOnLx3168031680epoutp03C
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:46:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220927174633epoutp0378626d2268a0bc6b1785cb9ce3005a29~YyMDsOnLx3168031680epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664300793;
        bh=2f95MMw1JaP2a2qx6h2pgrT8vnSnYyP4Ul8WVop1exo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAYR9N16uW6TydQQ47rPf3EDd5FHo5A1xi9JAR4IphjcwKxfClKl4eu7Nb2T47arf
         hbiaWUxqWIiXJencq0hfP8QESlRuqBxmYAihSzLHKGUN6OHByngj4oyar6a+lJo3NH
         vm2ZtZ5Wo278J70UMKcluYIt6KdVnK6i0Dbmq7ls=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220927174632epcas5p4dd6448ae88ebad9737e3589bf0e1f4be~YyMCltHJ72946929469epcas5p4_;
        Tue, 27 Sep 2022 17:46:32 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4McRrP44FSz4x9Pv; Tue, 27 Sep
        2022 17:46:29 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.1F.39477.5F633336; Wed, 28 Sep 2022 02:46:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220927174628epcas5p21beda845f26eedeb538cb67e286954d4~YyL-pGxQ51324413244epcas5p2z;
        Tue, 27 Sep 2022 17:46:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220927174628epsmtrp23f8d0307799fd395005bf7627abf1dae~YyL-oZzhm3251332513epsmtrp2e;
        Tue, 27 Sep 2022 17:46:28 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-8c-633336f5910b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.86.18644.4F633336; Wed, 28 Sep 2022 02:46:28 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174627epsmtip13333a33747e87502e44e237be49767b0~YyL_O04190699506995epsmtip1i;
        Tue, 27 Sep 2022 17:46:27 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v10 2/7] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Tue, 27 Sep 2022 23:06:05 +0530
Message-Id: <20220927173610.7794-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927173610.7794-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTQ/ermXGywesHshZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdcWTLRMaCj6IVt3/NYmtg/C7YxcjJISFgIrFh/Uu2LkYuDiGB3YwS
        d9+3M0E4n4CcibugnM+MEo9ObWSFaZl/ZwqYLSSwi1Fi7xlfuKLWI+eBZnFwsAloSlyYXApS
        IyJgJLH/00lWkBpmkBVvbzSygySEBWIlPv8+yARiswioSmw6NI8ZxOYVMJe4fHYGI8QyeYmZ
        l76zg8zkFLCQOPwxE6JEUOLkzCcsIDYzUEnz1tnMEOV/2SUOLOODsF0kDi1fCRUXlnh1fAs7
        hC0l8fndXjYIO1ni0sxzTBB2icTjPQehbHuJ1lP9zCBrmYFeWb9LH2IVn0Tv7ydMIGEJAV6J
        jjYhiGpFiXuTnkJDR1zi4YwlULaHxPMHj9ghodPNKPHmxWzGCYzys5B8MAvJB7MQti1gZF7F
        KJlaUJybnlpsWmCUl1oOj9bk/NxNjOB0qeW1g/Hhgw96hxiZOBgPMUpwMCuJ8P4+apgsxJuS
        WFmVWpQfX1Sak1p8iNEUGMITmaVEk/OBCTuvJN7QxNLAxMzMzMTS2MxQSZx38QytZCGB9MSS
        1OzU1ILUIpg+Jg5OqQambcJpVwos11pZeL/t+W+4K2Z31xtV7suHzE89SNdrnGGqfeDN5UAb
        WZsi3rBnnyr8LtepzjTjrGLYfHrPrt11NzZxt36t7gyTmckcfrRx7bwXp3fdU3/wey7T0ftn
        cs//Snlwy+KJv3bNma3P9FuPdX4qOt8X7i58YK1F2fMletJ33tdNs/kXIZl/ZHbH8hLZkIlH
        RHM532a1Nee6W7280JleEWIlOmsr/7RHgavX5IZeWqkW/75207yFj1seNjxpnj3lzp5LKzhZ
        b3pGz1KP6V1muOX1lLvsv6wWb7fg+t4sxNf+9MO85vdbNCds2xArtLlk31rebXvm7DJf/jzK
        SPzfKZ5nC9NW1BZ6zvnTOlOJpTgj0VCLuag4EQCDreA4IAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO4XM+Nkg7/zDC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJVxZMtExoKPohW3f81ia2D8LtjFyMkhIWAi
        Mf/OFNYuRi4OIYEdjBL3305jhUiISzRf+8EOYQtLrPz3nB2i6COjxKxTk5i7GDk42AQ0JS5M
        LgWpEREwk1h6eA0LSA2zwEFGicvPnrCAJIQFoiUaF/5gA7FZBFQlNh2axwxi8wqYS1w+O4MR
        YoG8xMxL39lBZnIKWEgc/pgJEhYCKtm66QMLRLmgxMmZECOZgcqbt85mnsAoMAtJahaS1AJG
        plWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHBrqW1g3HPqg96hxiZOBgPMUpwMCuJ
        8P4+apgsxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9OK
        G+avP2116Tqc8S9+4nyWDB03x898shNXdxYnqO//XLHiX5bqbKOuzU4FAQmpqZ5nnYq2RcaY
        yE871Ou0x+nNqkLzu+8Stmorx1+smfarT6k71/jotbSz01IPMn2eclZZuXc3S59UwLn53Exa
        9q+3idQEczFMMH643ounQW+SxKl766VaxbwaL/BMFDJcbV99+ojc/2o/hctN/B0Krkt5Imwr
        j0yed295i8KTpaGPDuclhr5ceGBpZ/Nsdr7jkjUR994kvHwg3CL6k6GeZVrV2bPLDU99Fi4W
        umB8cEP8xeIHnR/vGjyP2msR+UExcYm4lPlsc3Hndd93q9yfKyy9pL2fnze25YF644959Uos
        xRmJhlrMRcWJAGlfBJTlAgAA
X-CMS-MailID: 20220927174628epcas5p21beda845f26eedeb538cb67e286954d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174628epcas5p21beda845f26eedeb538cb67e286954d4
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174628epcas5p21beda845f26eedeb538cb67e286954d4@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/io_uring.h      |  2 +-
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/uring_cmd.c          | 16 +++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 1dbf51115c30..e10c5cc81082 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -28,7 +28,7 @@ struct io_uring_cmd {
 		void *cookie;
 	};
 	u32		cmd_op;
-	u32		pad;
+	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
 };
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92f29d9505a6..ab7458033ee3 100644
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
index 6a6d69523d75..faefa9f6f259 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -4,6 +4,7 @@
 #include <linux/file.h>
 #include <linux/io_uring.h>
 #include <linux/security.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -77,8 +78,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->rw_flags || sqe->__pad1)
+	if (sqe->__pad1)
 		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		req->buf_index = READ_ONCE(sqe->buf_index);
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
-- 
2.25.1

