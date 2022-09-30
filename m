Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5461B5F050A
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiI3GnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiI3GnP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:43:15 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE061F8C39
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:43:13 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220930064312epoutp028922765c6f19defb93974cf480154c0e~ZkEu30h8Y0424704247epoutp02T
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220930064312epoutp028922765c6f19defb93974cf480154c0e~ZkEu30h8Y0424704247epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520192;
        bh=GI1cGmjn/uczqFvlY4jKGGH0aTlldptSuRlcNl6S7vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nme0KQWw9re5e1Ropqw2hNhQInfU/4ubvqS9Qb6FsaWlheNQovmg1LsRE8mIboQ2S
         A3U87HdeSf5oa/KMC5+vwLnHkNMfffeWjuddrzvtc12MxbnMvU6NtXxX3XmHmp77cP
         bZF962pVlQph8M3jxH06+jwLBu3vp+AtX4kNWed8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220930064311epcas5p42a2ccb49f18bcef2f579b5eba76df3ee~ZkEuFRPut1262412624epcas5p4A;
        Fri, 30 Sep 2022 06:43:11 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Mf0zb3gLPz4x9Px; Fri, 30 Sep
        2022 06:43:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.2D.39477.BFF86336; Fri, 30 Sep 2022 15:43:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220930063809epcas5p328b9e14ead49e9612b905e6f5b6682f7~ZkAU8XC6J1908719087epcas5p3u;
        Fri, 30 Sep 2022 06:38:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220930063809epsmtrp28cbec7bc6c529cd4d0967173f41a1dcb~ZkAU7Qcia2166321663epsmtrp2Z;
        Fri, 30 Sep 2022 06:38:09 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-d5-63368ffb8d2c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.32.18644.1DE86336; Fri, 30 Sep 2022 15:38:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063807epsmtip233c580625990a69d575ad9f0b553a5c5~ZkATcNc5m1483714837epsmtip2A;
        Fri, 30 Sep 2022 06:38:07 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v12 02/12] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Fri, 30 Sep 2022 11:57:39 +0530
Message-Id: <20220930062749.152261-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmlu7vfrNkgw+3pSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMM9smshb8F614sn81cwNjm1AXIyeHhICJRMfrH6xdjFwc
        QgK7GSWu9S5gg3A+MUp0r1vEClIlJPCZUeLB/GKYjg1dM5gginYxSjyceQiqHahox5lPbCBV
        bALqEkeetzKC2CICRhL7P50EK2IWuMkocWjvM2aQhLBAvETvx3lgDSwCqhL7Pu1mArF5Bawk
        lm/4zQqxTl5i5qXv7F2MHBycAtYSzYtyIEoEJU7OfMICYjMDlTRvnc0MMl9CoJFD4t2Dn1C9
        LhKTz25mhLCFJV4d38IOYUtJfH63lw3CTpf4cfkpE4RdINF8bB9Uvb1E66l+ZpC9zAKaEut3
        6UOEZSWmnlrHBLGXT6L39xOoVl6JHfNgbCWJ9pVzoGwJib3nGqBsD4n/s1dBQ66PUeLd2zfM
        ExgVZiH5ZxaSf2YhrF7AyLyKUTK1oDg3PbXYtMAoL7UcHsvJ+bmbGMFpVctrB+PDBx/0DjEy
        cTAeYpTgYFYS4RUvME0W4k1JrKxKLcqPLyrNSS0+xGgKDO+JzFKiyfnAxJ5XEm9oYmlgYmZm
        ZmJpbGaoJM67eIZWspBAemJJanZqakFqEUwfEwenVAPT+ulHl07+MC2xbOrzOzrNn8ot7O50
        1Pqo/5goukfKX9dzra1cz0XRRWI7XkhOy0jW6dt2y9hCx3OBaSu3xH9+Cxnpd4v+nE5epF54
        tuKlzLzqpxNjkyRaznlZ3Vw6lzn5p51EcOdJjcg8IQmuh6yHTCwut/xfvWpfrZjQ7vha1a7y
        STPMd8+ZWpF4781L3nl73Qz4OeaYHrM5e/kvo+vfqIQV1cEzl7FyrE46+uF3/M/8/FkZDqcn
        +d5qPL37SPuGbxe5mt+Jsq068a/VpeD7m6hZ5rXZnUIix1qVvLSPfGf6fOCCV3aWyqxeqYaf
        StPW/V6/La6NxWNHypKrZ6qXHVd4lNZS8ihAMKH9pM4HJZbijERDLeai4kQAVVMkvTQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO7FPrNkgwcXhSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aZbRNZC/6LVjzZv5q5gbFNqIuR
        k0NCwERiQ9cMpi5GLg4hgR2MEi/3NjJDJCQkTr1cxghhC0us/PecHaLoI6PE7dWLmUASbALq
        Ekeet4IViQiYSSw9vIYFxGYWuM8osaA7BMQWFoiVeHxpKdhQFgFViX2fdoP18gpYSSzf8JsV
        YoG8xMxL34EWcHBwClhLNC/KAQkLAZV83vOeHaJcUOLkzCdQ4+UlmrfOZp7AKDALSWoWktQC
        RqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBYa+ltYNxz6oPeocYmTgYDzFKcDAr
        ifCKF5gmC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cCU
        vpGdVWVvBuOGG+v4Zq1vOcuySadE97r1xytTzpxJWnC9obC95RhXz3rNot/7mlX+9y+1yH8+
        KyEw2K/2TZtt9Afdr7OY7yh2rjebEaDyTPffcx97C80lJ7ictC5qC1/d+GilhK2ufffn+2d2
        uOmy3495G7Gq51dNCs8mX4sem8f5V6ue2Xw1Wlf0U36Zi8w9+w3TVz28sH3mpWT1J9NSSt3b
        xU9M6Z+mu2BjSNuiBIl7PFK2l78/vvQm6lu1mfzFDP41qi5PSsSjT5Ud2l2xT43ZaPYdlsjt
        KTqB7TfubV+SdtfZza1tH9uWx36KD7/b2nyIES69wrD6TMiZLSpnC2XrfNPKXCV0rvxezLpB
        iaU4I9FQi7moOBEAX8uNv+oCAAA=
X-CMS-MailID: 20220930063809epcas5p328b9e14ead49e9612b905e6f5b6682f7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063809epcas5p328b9e14ead49e9612b905e6f5b6682f7
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063809epcas5p328b9e14ead49e9612b905e6f5b6682f7@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_URING_CMD_FIXED flag that is to be used for sending io_uring
command with previously registered buffers. User-space passes the buffer
index in sqe->buf_index, same as done in read/write variants that uses
fixed buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h      |  2 +-
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/uring_cmd.c          | 18 +++++++++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

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
index 6a6d69523d75..05e8ad8cef87 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -4,6 +4,7 @@
 #include <linux/file.h>
 #include <linux/io_uring.h>
 #include <linux/security.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -77,7 +78,22 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->rw_flags || sqe->__pad1)
+	if (sqe->__pad1)
+		return -EINVAL;
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
+	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
 		return -EINVAL;
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
-- 
2.25.1

