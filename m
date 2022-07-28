Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E0B583E74
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbiG1MQx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237841AbiG1MQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:16:51 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F51E65814
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:16:50 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220728121648epoutp0133d9f03dd198db307ef4a523c5cc25c3~F-Vvi2-d90977209772epoutp01m
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 12:16:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220728121648epoutp0133d9f03dd198db307ef4a523c5cc25c3~F-Vvi2-d90977209772epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659010608;
        bh=xItjwbmIKrRiHs1GBAuxCOnNwKcVUUkDgc8KDr5FcQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj6ztXzFmbQpyv1aA3ZdVMT1kgPyB9uoEW3VDxekw7Klq5k/ucI7qBYh5kCe0PVEY
         wbozLSSP4/skCx2PyjmB9+8ebbOzTEc+g6pP7S69zq4S2eqJNCn1zFMy+R597b7hHK
         dcKDPYMD8YLk03aaPM6EshpsLu0gsGBm5h5hZ3zI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220728121648epcas5p3bff19ffabd528a83b71233e7b2d71536~F-VvBQBRE2339023390epcas5p3q;
        Thu, 28 Jul 2022 12:16:48 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LtqQ53SPcz4x9Pr; Thu, 28 Jul
        2022 12:16:45 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.7C.09639.D2E72E26; Thu, 28 Jul 2022 21:16:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220728093908epcas5p4d6318b0f037f0ccf9e5422b6b63f217c~F9MFSI5VV0692706927epcas5p4o;
        Thu, 28 Jul 2022 09:39:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220728093908epsmtrp2818206cd9171c9162f83aeb2be0a6601~F9MFRe9DP3160531605epsmtrp2K;
        Thu, 28 Jul 2022 09:39:08 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-5f-62e27e2dcb63
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.7B.08802.C3952E26; Thu, 28 Jul 2022 18:39:08 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220728093908epsmtip11a075fc62b19405ef923983b659001b0~F9MEg2YBT1332713327epsmtip1t;
        Thu, 28 Jul 2022 09:39:07 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v3 5/5] test/io_uring_passthrough: add test case
 for poll IO
Date:   Thu, 28 Jul 2022 15:03:27 +0530
Message-Id: <20220728093327.32580-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmuq5u3aMkgwc9EhZrrvxmt1h9t5/N
        4l3rORaLo//fsjmweFw+W+rRt2UVo8fnTXIBzFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGm
        ZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAy5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqp
        BSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2Rmbe7axF6wTrZg1fw5TA+N7gS5GTg4JAROJ
        CQ1HGLsYuTiEBHYzSjx4epoNwvnEKDH5SDsLhPOZUWLplxVsMC3PJi5mhkjsYpTYMGU+E4TT
        yiSxfnEPE0gVm4C2xKu3N5hBbBEBYYn9Ha0sIDazQJTEmldnGUFsYYFwiQlNvWD1LAKqEr8O
        XQTbwCtgI3H9cicjxDZ5idUbDoDN4RSwlfj06ATYsRICi9glljY8Y4YocpFofnaEFcIWlnh1
        fAs7hC0l8fndXqizsyU2PfzJBGEXSBx50QvVay/ReqofyOYAOk5TYv0ufYiwrMTUU+uYIG7m
        k+j9/QSqlVdixzwYW1Xi773bLBC2tMTNd1ehbA+JxlNvoIE6gVHi9ucPTBMY5WYhrFjAyLiK
        UTK1oDg3PbXYtMA4L7UcHm3J+bmbGMEpSst7B+OjBx/0DjEycTAeYpTgYFYS4U2Ivp8kxJuS
        WFmVWpQfX1Sak1p8iNEUGIATmaVEk/OBSTKvJN7QxNLAxMzMzMTS2MxQSZzX6+qmJCGB9MSS
        1OzU1ILUIpg+Jg5OqQYmya2C1Q0v7+b9KebsdvnVyluh7HBH9PshVU7pbUb8wXdEzHXbOx6v
        u6Bwfx9f1FPjlnWH/3PKTRVd+al8grSAg4TMjjkH7veWdifNqSw/+ry0iH9JMeu516HbCnLq
        jm1/tmixyF2f5VtX71gz4Y/A/iW7E/fcPeKsJbNGJDFfojhnvsx+xhudu3uEKzL953pOd3Gt
        /Xet5dv3+7krK4NiHC2nlXwIu149zVe82WvCz4CFsU80X3boxUu26zs8Ft8W6p6a75XYOl/r
        84lFX1bkLjkesrtCxfadmOy+iRVP98qXB4u9nHdbaXU5t+aiSTN1Yh6c8lAKe5DAZeK3+OTB
        aXnLJz9Ll9l1+veJ39cvKLEUZyQaajEXFScCAK8RxDjaAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSnK5N5KMkg+3z9C3WXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4Mjb3bGMvWCdaMWv+
        HKYGxvcCXYycHBICJhLPJi5m7mLk4hAS2MEoMWfHYZYuRg6ghLTEwvWJEDXCEiv/PWeHqGlm
        krh3vp0dJMEmoC3x6u0NZhBbBKhof0crC4jNLBAjMfXIYTBbWCBUovXDHDCbRUBV4tehi2wg
        Nq+AjcT1y52MEAvkJVZvOAA2h1PAVuLToxNgcSGgmteTtjNNYORbwMiwilEytaA4Nz232LDA
        KC+1XK84Mbe4NC9dLzk/dxMjOIC0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHehOj7SUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwKWdwmCWzr0k2X9haKyjo
        muo4o0/d5MqVH62pNpHuy8RD5k2WWbzDodP/3xW1s79vz+gu/nFl9n9P84Xqj9aIi3yTl5/O
        anp+dSev0ta1E1/POeExM2vBj2DdneJ+SbMNM396fJ6jlcO75FTv3fjrKzIsXFNdz0hcL0zt
        f3o3mMnxlvcHuxvyq6J2vnLb9jZANqjDcs31xxydyounn3XgeSzx7Zt/98kjzgmNTCeN+WSl
        LBb5O73uFS3NeeNUdF4ud+rFBVGGiU8vubzi+clq7bLubJxye36Yemqm2fEthpZFdzycFNwn
        SMktcnf6ELzwz9PFMkdvfdE1njOr1ZTP7+qq8J9iJqaSLCe6E84osRRnJBpqMRcVJwIApM3m
        vI8CAAA=
X-CMS-MailID: 20220728093908epcas5p4d6318b0f037f0ccf9e5422b6b63f217c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093908epcas5p4d6318b0f037f0ccf9e5422b6b63f217c
References: <20220728093327.32580-1-ankit.kumar@samsung.com>
        <CGME20220728093908epcas5p4d6318b0f037f0ccf9e5422b6b63f217c@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For uring passthrough add test case for poll IO completion.
If poll IO is not supported return success.

Tested-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 test/io_uring_passthrough.c | 76 +++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 03043b7..d4a2169 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -10,6 +10,7 @@
 
 #include "helpers.h"
 #include "liburing.h"
+#include "../src/syscall.h"
 #include "nvme.h"
 
 #define FILE_SIZE	(256 * 1024)
@@ -278,6 +279,75 @@ static int test_io(const char *file, int tc, int read, int sqthread,
 	return ret;
 }
 
+extern int __io_uring_flush_sq(struct io_uring *ring);
+
+/*
+ * if we are polling io_uring_submit needs to always enter the
+ * kernel to fetch events
+ */
+static int test_io_uring_submit_enters(const char *file)
+{
+	struct io_uring ring;
+	int fd, i, ret, ring_flags, open_flags;
+	unsigned head;
+	struct io_uring_cqe *cqe;
+
+	ring_flags = IORING_SETUP_IOPOLL;
+	ring_flags |= IORING_SETUP_SQE128;
+	ring_flags |= IORING_SETUP_CQE32;
+
+	ret = io_uring_queue_init(64, &ring, ring_flags);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	open_flags = O_WRONLY;
+	fd = open(file, open_flags);
+	if (fd < 0) {
+		perror("file open");
+		goto err;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		struct io_uring_sqe *sqe;
+		off_t offset = BS * (rand() % BUFFERS);
+
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_writev(sqe, fd, &vecs[i], 1, offset);
+		sqe->user_data = 1;
+	}
+
+	/* submit manually to avoid adding IORING_ENTER_GETEVENTS */
+	ret = __sys_io_uring_enter(ring.ring_fd, __io_uring_flush_sq(&ring), 0,
+						0, NULL);
+	if (ret < 0)
+		goto err;
+
+	for (i = 0; i < 500; i++) {
+		ret = io_uring_submit(&ring);
+		if (ret != 0) {
+			fprintf(stderr, "still had %d sqes to submit, this is unexpected", ret);
+			goto err;
+		}
+
+		io_uring_for_each_cqe(&ring, head, cqe) {
+			if (cqe->res == -EOPNOTSUPP)
+				fprintf(stdout, "Device doesn't support polled IO\n");
+			goto ok;
+		}
+		usleep(10000);
+	}
+err:
+	ret = 1;
+	if (fd != -1)
+		close(fd);
+
+ok:
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	int i, ret;
@@ -308,6 +378,12 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	ret = test_io_uring_submit_enters(fname);
+	if (ret) {
+		fprintf(stderr, "test_io_uring_submit_enters failed\n");
+		goto err;
+	}
+
 	return T_EXIT_PASS;
 err:
 	return T_EXIT_FAIL;
-- 
2.17.1

