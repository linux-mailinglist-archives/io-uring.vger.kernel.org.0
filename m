Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9B57AFB4
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 06:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiGTEJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 00:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTEJ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 00:09:58 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02AA29C88
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 21:09:56 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220720040955epoutp04645e199a30c20001b1ca504b78f725de~DbiWGDOgq0293202932epoutp04-
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 04:09:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220720040955epoutp04645e199a30c20001b1ca504b78f725de~DbiWGDOgq0293202932epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658290195;
        bh=kyAA358jqlstBbNyA9+oy76mPJppkBr+mBZEwR/dHO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0WJK18K4Zja4EUsJkxf/0Hu/YzVSeTvMty6g/shSe7/EABrOKz04v05+6ritjLog
         kITayRVVMCXCWpXtaRvdWhAVJC9wQL0w8Gza2HDnjY7SkG51pKdq8wqVsVGmH+1CjD
         kkQaurm+1BBKRVErMv0YSl2mFYz3kJrMT6OLVvVs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220720040954epcas5p10b2db719d41694dc304e17f8101363ba~DbiVua1JI0854608546epcas5p17;
        Wed, 20 Jul 2022 04:09:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lnhzz3jrzz4x9Q6; Wed, 20 Jul
        2022 04:09:51 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.8A.09639.B0087D26; Wed, 20 Jul 2022 13:09:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220719135834epcas5p2f63a49277322756394f19e23a1c4e4ce~DP7A-c2570590105901epcas5p2h;
        Tue, 19 Jul 2022 13:58:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220719135833epsmtrp26ddcd3bf3f3f66708a72138039bd9356~DP7A_ms7c1852218522epsmtrp2P;
        Tue, 19 Jul 2022 13:58:33 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-ca-62d7800bc7be
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.7A.08905.988B6D26; Tue, 19 Jul 2022 22:58:33 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135832epsmtip11553f3e945d4e088b393e51fd43ec461~DP6--WdCc3033030330epsmtip1q;
        Tue, 19 Jul 2022 13:58:32 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing 2/5] io_uring.h: sync sqe entry with 5.20 io_uring
Date:   Tue, 19 Jul 2022 19:22:31 +0530
Message-Id: <20220719135234.14039-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719135234.14039-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsWy7bCmpi53w/Ukg47tKhZrrvxmt1h9t5/N
        4t62X2wW71rPsVgc/f+WzeL2pOksDmwel8+Weqzd+4LRo2/LKkaPo/sXsXl83iQXwBqVbZOR
        mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
        KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj15LL
        TAWzOCp+3D7N1sC4lK2LkZNDQsBEov/JB5YuRi4OIYHdjBIdO2axQjifGCUufd/KDuF8Y5Q4
        c/McUIYDrGXqAUWI+F5Gif/vZzGBjBISaGWSuLfKGMRmE9CWePX2BjOILSIgLLG/oxVsBbNA
        O6PEhwVH2EEGCQt4S5z/kgNSwyKgKrHtRBs7iM0rYCMx69YMJojz5CVWbzgANodTwFbiw/aX
        zCBzJAQOsUssa1jNDlHkIvHp9jFmCFtY4tXxLVBxKYnP7/ZC/ZktsenhT6ihBRJHXvRC1dtL
        tJ7qZwa5h1lAU2L9Ln2IsKzE1FPrwMqZBfgken8/gWrlldgxD8ZWlfh77zYLhC0tcfPdVSjb
        Q6LrYQc0SCcwStxpvMc2gVFuFsKKBYyMqxglUwuKc9NTi00LjPNSy+GRlpyfu4kRnMa0vHcw
        PnrwQe8QIxMH4yFGCQ5mJRHep4XXk4R4UxIrq1KL8uOLSnNSiw8xmgIDcCKzlGhyPjCR5pXE
        G5pYGpiYmZmZWBqbGSqJ83pd3ZQkJJCeWJKanZpakFoE08fEwSnVwBTZ9+aqLEe++NGpO7Xe
        +MgtFrcKbhZil1E3fnVC2bRawuuQtcPzwMv5THP3CNbsW/zr/qPULcvy5R5JFooFn0k4yXPn
        69pnjycLyiRvmX1VQ8D24N71bDLNWQp3NoQsM/ju+vNM+tQagdbHF6yr/m+sPG0gyTHN1vLi
        sT9+V9XPPzm8IPHeLl35zJaY+b2TFcz2NJx04914827LKUM5S+d+gdSVK4/Enih5vkHbpbjd
        JaBR55Hm3jO785RvRhu8yWmZW9znrZUWwhn3oXZbhES8i/iVnZOPpfhPSVt+oGHegwWRUx8s
        sPzFrFSqXXtcMXy5zUybVNlkXfMePSvTEKu1Qpv3MZZ7Vm7bJSZ3WImlOCPRUIu5qDgRANgx
        xXrsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42LZdlhJTrdzx7Ukg/6z5hZrrvxmt1h9t5/N
        4t62X2wW71rPsVgc/f+WzeL2pOksDmwel8+Weqzd+4LRo2/LKkaPo/sXsXl83iQXwBrFZZOS
        mpNZllqkb5fAlfFryWWmglkcFT9un2ZrYFzK1sXIwSEhYCIx9YBiFyMnh5DAbkaJn0tKIcLS
        EgvXJ4KEJQSEJVb+e87excgFVNLMJPH1eC8bSIJNQFvi1dsbzCC2CFDR/o5WFpAiZoFeRomV
        /48wgQwSFvCWOP8lB6SGRUBVYtuJNnYQm1fARmLWrRlMEAvkJVZvOAA2h1PAVuLD9pfMEPfY
        SHy7M5N9AiPfAkaGVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwUGmpbmDcfuqD3qH
        GJk4GA8xSnAwK4nwitReThLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampB
        ahFMlomDU6qBiTfz9X6JrNXHt717qpm12rv4zpp7l/J9UmULGrlMdEtact/1vPmlsmd16sXg
        kBiOJvdD+44eneer+qdou8w93lUP/tmcOjGjLmr9bfuA9CnFc3bLHTgecaKXbanOjLb58/4Y
        doUcOf/mlOtF8UrZiWkvzq/8FLC9/94/kbgEzp1+E2a8S79gavP28S/THz/kFzlsVnCvO3hc
        7dQjmd19QUt3SnhUZDemppdMvTTDKnSr6+1FEakv7299Hntjx1zlm/cFa11yflWvb6lmulem
        KV+9Zuf5RGt3XXPe01MEf9++p7crKshc502lualhbp9YZ61FiTvHXhueyanbKicLMX8U26yR
        dXrpv1kloWkqv5RYijMSDbWYi4oTAe+sU2KhAgAA
X-CMS-MailID: 20220719135834epcas5p2f63a49277322756394f19e23a1c4e4ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135834epcas5p2f63a49277322756394f19e23a1c4e4ce
References: <20220719135234.14039-1-ankit.kumar@samsung.com>
        <CGME20220719135834epcas5p2f63a49277322756394f19e23a1c4e4ce@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a few missing fields which was added for uring command

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 src/include/liburing/io_uring.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 51126c4..581381d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -26,6 +26,10 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		struct {
+			__u32	cmd_op;
+			__u32	__pad1;
+		};
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
@@ -65,8 +69,17 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	addr3;
-	__u64	__pad2[1];
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
 };
 
 /*
-- 
2.17.1

