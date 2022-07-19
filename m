Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF957AFB7
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 06:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiGTEKl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 00:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTEKk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 00:10:40 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D872D275D1
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 21:10:38 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220720041036epoutp014cac7101738b3afea020a31edca0dbba~Dbi8RAW3-1061010610epoutp019
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 04:10:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220720041036epoutp014cac7101738b3afea020a31edca0dbba~Dbi8RAW3-1061010610epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658290236;
        bh=V6kCFEnNmUA65C9BXm3wlYHngtC9W67zIvUb4TG3zS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJzrxzmRGFZeYyl8EmRU3GIdU3NYh+XCiE27YI4zFWDlko2vFvtMCTGKbPVdeCuF8
         p43jUaROu5L8reZv9fujnDydpKE7wZ3aVlV3BHXlxvgZ2x3q+QubYp3UkhnEcQpiPl
         v+ZRGDK0ROeSIA6C8tOEcqbCdw5+UWiaDBSLUFvI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220720041035epcas5p31e6b12adf3c406e754d80ae35c99a429~Dbi73xH2_0451004510epcas5p3I;
        Wed, 20 Jul 2022 04:10:35 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lnj0n4d0Zz4x9Q9; Wed, 20 Jul
        2022 04:10:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.B6.09566.63087D26; Wed, 20 Jul 2022 13:10:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135837epcas5p1eb4beb20bdfbdaaa7409d7b1f6355909~DP7Eh6UvV1434214342epcas5p1D;
        Tue, 19 Jul 2022 13:58:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220719135837epsmtrp2c68857bc577dc90c0e080a5294ae0636~DP7EhLzEY1852218522epsmtrp2R;
        Tue, 19 Jul 2022 13:58:37 +0000 (GMT)
X-AuditID: b6c32a4a-b8dff7000000255e-3c-62d78036d402
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.7A.08905.D88B6D26; Tue, 19 Jul 2022 22:58:37 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135836epsmtip13b0b8019b86389594781a469ccb47a51~DP7DleMl00140301403epsmtip1H;
        Tue, 19 Jul 2022 13:58:36 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing 5/5] test/io_uring_passthrough: add test case for
 poll IO
Date:   Tue, 19 Jul 2022 19:22:34 +0530
Message-Id: <20220719135234.14039-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719135234.14039-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7bCmhq5Zw/Ukg62bNS3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDUq2yYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbG88O7
        mQu+i1Q8O7GAvYFxn0AXIyeHhICJxI7V61i7GLk4hAR2M0q8mj+dGcL5xCgxu/kCG4TzjVHi
        4Iw9jDAtXz+fhErsZZRYuHkKE4TTyiTRvfg/O0gVm4C2xKu3N5hBbBEBYYn9Ha0sIEXMAu2M
        Eh8WHAErEhYIkfh34R4LiM0ioCrRfW8WUAMHB6+AjcTGJcUQ2+QlVm84ADaHU8BW4sP2l2D3
        SQjsY5c4em81G0SRi8TKtW+gzhOWeHV8CzuELSXx+d1eqJpsiU0PfzJB2AUSR170MkPY9hKt
        p/rB9jILaEqs36UPEZaVmHpqHVg5swCfRO/vJ1CtvBI75sHYqhJ/791mgbClJW6+uwple0ic
        /joRGigTGCUO7F7PPIFRbhbCigWMjKsYJVMLinPTU4tNC4zyUsvh0Zacn7uJEZzKtLx2MD58
        8EHvECMTB+MhRgkOZiUR3qeF15OEeFMSK6tSi/Lji0pzUosPMZoCw28is5Rocj4wmeaVxBua
        WBqYmJmZmVgamxkqifN6Xd2UJCSQnliSmp2aWpBaBNPHxMEp1cC0eJZnWZLOx63NidfkHuyz
        aW9TFn6vV/4s5K55v3TRxJn9Ocynghmua59lyOI19XO/y3pW5mf0vtgXWy6aq8vPym7Qdbjd
        GLhZtcF1uZ/Y0hshvtO1n9vV5e9huv1++e0cQy6z/mPyqZvfT1vXsfJ81r1Tfr/sTswR9nSd
        PG0LQ9Xv7Fm2rws+Os7RXqp8Z0V53hPh5u6urwlfuPa2vhU7VXH1T+hv/4zfKtPrc041V7jI
        17/f6X/04ScPeyunOfM+HLobecLc70vKRPEFC3PXFvvc11n6wlX27I0LMQVexo+vr13oeXRR
        1qrr755cnHt8vsYjjtWST/7I1io+v6bG9Trb3e+2VFPxq7OFXo8TlViKMxINtZiLihMBVU+r
        yu4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42LZdlhJTrd3x7Ukg0MHdS3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDWKyyYl
        NSezLLVI3y6BK+P54d3MBd9FKp6dWMDewLhPoIuRk0NCwETi6+eTbF2MXBxCArsZJZ41NDJ1
        MXIAJaQlFq5PhKgRllj57zk7RE0zk8TESXuYQBJsAtoSr97eYAaxRYCK9ne0soAUMQv0Mkqs
        /H8EbJCwQJBEV5MJSA2LgKpE971ZzCBhXgEbiY1LiiHmy0us3nAAbAyngK3Eh+0vwWwhoJJv
        d2ayT2DkW8DIsIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzjMtDR3MG5f9UHvECMT
        B+MhRgkOZiURXpHay0lCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MM3+rJiwzmtzx7InChduC6bbLHVUWGKSzK24KKkg/UCiqdee9cJGMz9Ncdyuy1j0
        rvrX4zi1eZbPQ4vtngZ3LTylvVm0d9/q4+eSuOrOmVgfXZAulqGuFXb5Q8CGS+d89Xc6b1vN
        P2WT6YxvOzNiFIuWcmU+Sb5jYO8zeXJwQnp/h7GtZ2L9t8rPF9Iq1s3Uk3G93b1eMSFvuj9v
        euwvKzHxT1M36uj03r10ZVUDT/+C16ZmKdb7DVZEfTdYcrzUiVGL941MlNaxrR8y2tZ5fkpP
        279+Qlj5o+t76sQt9YqfivlLhmvwaOgUL/tcpS0X+fCTuNrFW56JFcHqrT6PV+zsfyO6Rrxg
        8VN+wWfdSizFGYmGWsxFxYkAZ7qSrKICAAA=
X-CMS-MailID: 20220719135837epcas5p1eb4beb20bdfbdaaa7409d7b1f6355909
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135837epcas5p1eb4beb20bdfbdaaa7409d7b1f6355909
References: <20220719135234.14039-1-ankit.kumar@samsung.com>
        <CGME20220719135837epcas5p1eb4beb20bdfbdaaa7409d7b1f6355909@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

