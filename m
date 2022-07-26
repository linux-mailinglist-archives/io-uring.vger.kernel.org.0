Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FD658125D
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiGZLvt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiGZLvr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:51:47 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A14532EEF
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:51:43 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220726115142epoutp02ac0e94c2bd0f0268865cc200390157b5~FXtP-r47_1280612806epoutp02u
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:51:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220726115142epoutp02ac0e94c2bd0f0268865cc200390157b5~FXtP-r47_1280612806epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658836302;
        bh=V6kCFEnNmUA65C9BXm3wlYHngtC9W67zIvUb4TG3zS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRpOYrmzCMF+2nHVHESDU0xuWecG9O56eUzXLC4GIZz90nAm5RrkO8bZymB9K+7WC
         rgdGvFRwWBLGVLejgVRNCbALNcpMrJXYZz1P/erFtjb/DkjeeWWwmvw1AfUGAlSrla
         Te28YirEHKmfcWsvCl01g4P3xCDAVGemH4vGch0w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220726115141epcas5p4d09348f5b00833c217e671a2b47753c7~FXtPBZj211440814408epcas5p4z;
        Tue, 26 Jul 2022 11:51:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LsZy1691yz4x9Pp; Tue, 26 Jul
        2022 11:51:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.F9.09639.345DFD26; Tue, 26 Jul 2022 20:51:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220726105817epcas5p450a87008879689894b187924a854d513~FW_nbIhiy2203422034epcas5p4F;
        Tue, 26 Jul 2022 10:58:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220726105817epsmtrp26072304396871fa51dfcf96784e98af1~FW_naho-E3043430434epsmtrp2c;
        Tue, 26 Jul 2022 10:58:17 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-68-62dfd5435238
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.6E.08802.9C8CFD26; Tue, 26 Jul 2022 19:58:17 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220726105816epsmtip12f38265ec35e873037f5e1e7b71e91cb~FW_mqkNgA1956919569epsmtip11;
        Tue, 26 Jul 2022 10:58:16 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v2 5/5] test/io_uring_passthrough: add test case
 for poll IO
Date:   Tue, 26 Jul 2022 16:22:30 +0530
Message-Id: <20220726105230.12025-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmpq7z1ftJBtdaxC3WXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjOeH97NXPBdpOLZiQXsDYz7BLoYOTkkBEwk
        ejccYe9i5OIQEtjNKNF1ewoLhPOJUWLOuwYmCOczo8TVCXfYYFqOfz7JDJHYxSjxfMJ6Rgin
        lUli4tbn7CBVbALaEq/e3mAGsUUEhCX2d7SygNjMAlESa16dZQSxhQXCJX7cWsUEYrMIqEq8
        eb+QFcTmFbCRWHinH2qbvMTqDQfA5nAK2Eo0vZzCCrJMQmARu8TPuceZIIpcJI69+s0MYQtL
        vDq+hR3ClpL4/G4v1KBsiU0Pf0LVF0gcedELVW8v0XqqH8jmADpOU2L9Ln2IsKzE1FPrmCBu
        5pPo/f0EqpVXYsc8GFtV4u+92ywQtrTEzXdXoWwPie4L+6DhOIFRYm/jccYJjHKzEFYsYGRc
        xSiZWlCcm55abFpgnJdaDo+25PzcTYzgFKXlvYPx0YMPeocYmTgYDzFKcDArifAmRN9PEuJN
        SaysSi3Kjy8qzUktPsRoCgzAicxSosn5wCSZVxJvaGJpYGJmZmZiaWxmqCTO63V1U5KQQHpi
        SWp2ampBahFMHxMHp1QDk77C3+6fi6UfyZz68+vc8nl+zbe1jFw/JOaVT6+PTirZtWuXk4oQ
        D1tX6/JnR7p/Pi10k66YrfL/wSrt40obs/nL977c2u2635FFtdkr3mVWwo+p7yyrt2X0TPjZ
        MC9gkgjni9crentcAxRFU1+3N1j0J7swK0eppXKnRd5PXvRiV9Sbufa/shpMkrRuzg/UUNLn
        vWv9z6z8TuAb72t5MTPlFBVVTLYqPcq5s2Jjk/Kyz0lzLqh9Ydaep7xOav812WMqXalRT974
        G3FtTuP4fS1bWlLiKEv8qna2tbrhhgujn2ywTtiqMuFTE9Mnvbk+CSKnwlXNvWZPqeic58r8
        8UV73NLIBSumrV4sHp6qxFKckWioxVxUnAgAFxEKlNoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSnO7JE/eTDLYtVrFYc+U3u8Xqu/1s
        Fu9az7FYHP3/ls2BxePy2VKPvi2rGD0+b5ILYI7isklJzcksSy3St0vgynh+eDdzwXeRimcn
        FrA3MO4T6GLk5JAQMJE4/vkkcxcjF4eQwA5GiVerv7N3MXIAJaQlFq5PhKgRllj57zk7RE0z
        k8TKF++YQBJsAtoSr97eYAaxRYCK9ne0soDYzAIxElOPHAazhQVCJf7chrBZBFQl3rxfyApi
        8wrYSCy8088GsUBeYvWGA2BzOAVsJZpeTgGrEQKq+XvoGNsERr4FjAyrGCVTC4pz03OLDQuM
        8lLL9YoTc4tL89L1kvNzNzGCA0hLawfjnlUf9A4xMnEwHmKU4GBWEuFNiL6fJMSbklhZlVqU
        H19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVANTt8H6heVs7rN8tF67Mj4t
        8Ttn1j03QyV+SZ3RlNYXcyef3idiXyJ16RiXlVTwTYub02wnTDV71bLzS2qg+r6mVxuuBeh/
        Cw7pv/lLSyJUz/CP+6/lZrGv5lyYt/RdNI/mu37fL+ltrGWMF/ffV1lwVHT1BIH0f4qOyx7M
        ue6SMc09zOumn8R6XlsL3/fH3tYcznX4Mv3QmeLjcYdWWKv9vJuxRy0i9tG8yd6LVzPkCIrH
        yBUU5cvdzfQ9Y2//O5XRJunlXq+Fez/5K85yFpn/O0nDnMV17emE+Mn71knb3pzRY2ircLeH
        RSR57po53coR0s1qCpqHRGU25f6YO/9g6pfdTTfWFuzzemZ57TGjEktxRqKhFnNRcSIAih8W
        r48CAAA=
X-CMS-MailID: 20220726105817epcas5p450a87008879689894b187924a854d513
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105817epcas5p450a87008879689894b187924a854d513
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
        <CGME20220726105817epcas5p450a87008879689894b187924a854d513@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For uring passthrough add test case for poll IO completion.
If poll IO is not supported return success.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 test/io_uring_passthrough.c | 76 +++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 2e2b806..acb57f8 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -10,6 +10,7 @@
 
 #include "helpers.h"
 #include "liburing.h"
+#include "../src/syscall.h"
 #include "nvme.h"
 
 #define FILE_SIZE	(256 * 1024)
@@ -279,6 +280,75 @@ static int test_io(const char *file, int tc, int read, int sqthread,
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
+				fprintf(stdout, "doesn't support polled IO\n");
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
@@ -313,6 +383,12 @@ int main(int argc, char *argv[])
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

