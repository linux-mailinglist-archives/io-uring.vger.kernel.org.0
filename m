Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08D59EA15
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiHWRmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 13:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiHWRlA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 13:41:00 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC84165557
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 08:38:16 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220823153814epoutp04f74be26d56d978b59425a3c94b66477b~OA3CexAyg2021820218epoutp04e
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 15:38:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220823153814epoutp04f74be26d56d978b59425a3c94b66477b~OA3CexAyg2021820218epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661269094;
        bh=4EGNAtKQ6M1ilxlpl95N+UVDB6p6TXpAtZ1Y8ILlwQ8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=IJyWVlUxFtW5d8rKcq1kAC8zY6dfOoxzBog3iX7sQPY7td5ngVikPvNA9rQZ5xkRB
         CGMTlGxALWODR8uUCZK/Vhbk545XpApMiH4l/QdjBylBK9WTf5KEX4X/VoFLZWdABo
         zf8R3SSY7Gw0GbhCc7915b6QXyoSw2+3DzlBFjWE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220823153814epcas5p2e0bafb3875f11aa6d2bbb27817f45a8b~OA3B7OmEQ0030900309epcas5p2G;
        Tue, 23 Aug 2022 15:38:14 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MBtfX3CK9z4x9Pq; Tue, 23 Aug
        2022 15:38:12 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.64.25709.464F4036; Wed, 24 Aug 2022 00:38:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220823153811epcas5p3e9262beb5b6dc0ae58f4bcf7486473de~OA2-bNpYe0421704217epcas5p38;
        Tue, 23 Aug 2022 15:38:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823153811epsmtrp17ccff15be42cddef905d0eeb29bfe09f~OA2-aj59m2679226792epsmtrp1H;
        Tue, 23 Aug 2022 15:38:11 +0000 (GMT)
X-AuditID: b6c32a49-a71ff7000000646d-d7-6304f464fe46
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.61.18644.364F4036; Wed, 24 Aug 2022 00:38:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220823153810epsmtip1afe12591c45268a8d051b66bf4a5aa4b~OA2_dViVQ0673706737epsmtip1D;
        Tue, 23 Aug 2022 15:38:10 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, ankit.kumar@samsung.com,
        anuj20.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH liburing] test/io_uring_passthrough: add test case for
 submission failure
Date:   Tue, 23 Aug 2022 20:57:25 +0530
Message-Id: <20220823152725.5211-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7bCmhm7KF5Zkgx2TxSzWXPnNbtE04S+z
        xeq7/WwW71rPsVgc/f+WzYHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzng19wJ7wXyxisXvLrM0MHYIdTFy
        ckgImEgsWPmIpYuRi0NIYDejxMPWx6wQzidGiU0Pb7BBOJ8ZJeZ0XmaCaVnz7T87RGIXo0TX
        7B3MIAmwqltXdbsYOTjYBDQlLkwuBQmLCAhL7O9oZQEJMwsUSRw7HgcSFhaIlnhwbyUbSJhF
        QFVi6rJakDCvgLnE8p/HWCA2yUvMvPSdHSIuKHFy5hOwODNQvHnrbGaQCyQEVrFLXH24nx2i
        wUXix/GjUM3CEq+Ob4GKS0m87G+DspMlLs08B/VKicTjPQehbHuJ1lP9zBBnakqs36UPsYtP
        ovf3EyaQsIQAr0RHGzTcFCXuTXrKCmGLSzycsQTK9pCYfvAAOyQ8YiVeL7nHOoFRbhaSD2Yh
        +WAWwrIFjMyrGCVTC4pz01OLTQsM81LL4RGZnJ+7iRGc0LQ8dzDeffBB7xAjEwfjIUYJDmYl
        EV6rYyzJQrwpiZVVqUX58UWlOanFhxhNgaE6kVlKNDkfmFLzSuINTSwNTMzMzEwsjc0MlcR5
        p2gzJgsJpCeWpGanphakFsH0MXFwSjUwTauxvSVcynJI5SK71X0/6dOPLOyuB/UYqzKc+h/q
        02nB8v7JmcePyt38upTMBNKYPiirFan1XJU7FPieh/Fro+UasSkvFeI815X8cK7YXOPEevOk
        1Y7U15p/XZ2/cNwp+/FsrabmgoYOZ+Vzm0+fjBB8bODL5H791YxNCVMVt3sfvGd+l/GfXYo1
        77a2z+kbxdyyDu5W2qtVVtjtyLnKX91I5kjptMU394p+P2eQM+u1yf2CFROX8O73DZ3y7Mzy
        t2z/1r1kS6yp2uFa8b/rxMdDYlzdx12PK6UserqgSa+qyJszYMUe69lTNshHtSxoWveoIl3E
        8vepxwEiHWtTpRX0Q2frHfnMVj+30+OXEktxRqKhFnNRcSIAaihIf/EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsWy7bCSnG7yF5Zkgz89UhZrrvxmt2ia8JfZ
        YvXdfjaLd63nWCyO/n/L5sDqcflsqUffllWMHp83yQUwR3HZpKTmZJalFunbJXBlvJp7gb1g
        vljF4neXWRoYO4S6GDk5JARMJNZ8+8/excjFISSwg1Hi7+dZLBAJcYnmaz/YIWxhiZX/nkMV
        fWSUaJ+9mLmLkYODTUBT4sLkUpAaEaCa/R2tYL3MAmUS547/BusVFoiU2Ht8PxtIOYuAqsTU
        ZbUgYV4Bc4nlP49BrZKXmHnpOztEXFDi5MwnUGPkJZq3zmaewMg3C0lqFpLUAkamVYySqQXF
        uem5xYYFRnmp5XrFibnFpXnpesn5uZsYwYGnpbWDcc+qD3qHGJk4GA8xSnAwK4nwWh1jSRbi
        TUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qByfum0rWCDQEh
        3hf7X5+6XnPwyalT7XZvWQ/tLyncUc0sMXnbTI4cc8MZf60nJvGs3HvtisqfqMjj3yc1Gm2/
        LvDbZbrG3BPNGe5R2aEZXWZRK15mFy5d5G26VuCVcFopn/WyP/pm/NYLM/daBSiK+tUufX4p
        4Jb47+Cav2/z+n+fuNu7XNrP/dnSFn8eQ89FTvdMQjUjXtnq8b826bf/2CS569PE/O1NIRpF
        1R/9dDc2/LBVvTyDo9i2yLvx30GLRAMGuXjdXXOYp15V035g8Cb51vW//vuPcq7KsbkqF1Mt
        9mTn4fcTuI9zf/5z+UJzM8On7bIRW45pLO7WW+ynGOY8vYnF38vUuy6GbyubEktxRqKhFnNR
        cSIAwq4+A6sCAAA=
X-CMS-MailID: 20220823153811epcas5p3e9262beb5b6dc0ae58f4bcf7486473de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823153811epcas5p3e9262beb5b6dc0ae58f4bcf7486473de
References: <CGME20220823153811epcas5p3e9262beb5b6dc0ae58f4bcf7486473de@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Increase the coverage by adding a test which triggers submission-failure
from nvme side.
Issue an ill-formed passthrough command by populating invalid nsid
value. If cqe->res is zero, report failure of the test.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 test/io_uring_passthrough.c | 72 +++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index c545f3f..9024a8f 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -270,6 +270,72 @@ static int test_io(const char *file, int tc, int read, int sqthread,
 
 extern int __io_uring_flush_sq(struct io_uring *ring);
 
+/*
+ * Send a passthrough command that nvme will fail during submission.
+ * This comes handy for testing error handling.
+ */
+static int test_invalid_passthru_submit(const char *file)
+{
+	struct io_uring ring;
+	int fd, ret, ring_flags, open_flags;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct nvme_uring_cmd *cmd;
+
+	ring_flags = IORING_SETUP_IOPOLL | IORING_SETUP_SQE128;
+	ring_flags |= IORING_SETUP_CQE32;
+
+	ret = t_create_ring(1, &ring, ring_flags);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	open_flags = O_RDONLY;
+	fd = open(file, open_flags);
+	if (fd < 0) {
+		perror("file open");
+		goto err;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, fd, vecs[0].iov_base, vecs[0].iov_len, 0);
+	sqe->cmd_op = NVME_URING_CMD_IO;
+	sqe->opcode = IORING_OP_URING_CMD;
+	sqe->user_data = 1;
+	cmd = (struct nvme_uring_cmd *)sqe->cmd;
+	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+	cmd->opcode = nvme_cmd_read;
+	cmd->addr = (__u64)(uintptr_t)&vecs[0].iov_base;
+	cmd->data_len = vecs[0].iov_len;
+	/* populate wrong nsid to force failure */
+	cmd->nsid = nsid + 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit got %d, wanted %d\n", ret, 1);
+		goto err;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe=%d\n", ret);
+		goto err;
+	}
+	if (cqe->res == 0) {
+		fprintf(stderr, "cqe res %d, wanted failure\n", cqe->res);
+		goto err;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+	close(fd);
+	io_uring_queue_exit(&ring);
+	return 0;
+err:
+	if (fd != -1)
+		close(fd);
+	io_uring_queue_exit(&ring);
+	return 1;
+}
+
 /*
  * if we are polling io_uring_submit needs to always enter the
  * kernel to fetch events
@@ -373,6 +439,12 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	ret = test_invalid_passthru_submit(fname);
+	if (ret) {
+		fprintf(stderr, "test_invalid_passthru_submit failed\n");
+		goto err;
+	}
+
 	return T_EXIT_PASS;
 err:
 	return T_EXIT_FAIL;
-- 
2.25.1

