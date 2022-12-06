Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D7A644322
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiLFMaQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 07:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFMaP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 07:30:15 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD54029806
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 04:30:13 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221206123012epoutp01224cbb2fbb6a2b3e0cb962b05b28f05c~uNB1P9Tzb0754007540epoutp01u
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 12:30:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221206123012epoutp01224cbb2fbb6a2b3e0cb962b05b28f05c~uNB1P9Tzb0754007540epoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670329812;
        bh=roC5AGYnzf8QVqNY7i2ZmkgrWI89pUYYTw5QCbBfAS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5kySeOYXeouW6onGE0RAGfG3WTn0uR4H3S3KuYizS0uwgW7z0s05h5uyBW0x7vSH
         2reiz5QHioXyy4DwhjXDqiyZa6bCO/EW4Wmbr1E2Vz0FVmiejmquZL2Dhtbdyym6tM
         gMQ3ISsrkiZoddkNBzVLxwRidbdcrGxohTQPuCSY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221206123011epcas5p48c9f8de2fa3db5fe4358e01424a23a76~uNB08Ptpy1128511285epcas5p4E;
        Tue,  6 Dec 2022 12:30:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NRKW65zGBz4x9Pt; Tue,  6 Dec
        2022 12:30:10 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.B6.56352.1D53F836; Tue,  6 Dec 2022 21:30:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221206123009epcas5p4d65eca3320f9845e190fc425a06799a6~uNBySsFA90906209062epcas5p46;
        Tue,  6 Dec 2022 12:30:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221206123009epsmtrp1049f97e812f573aab7447420a22cdc8a~uNBySFYhM0728207282epsmtrp1F;
        Tue,  6 Dec 2022 12:30:09 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-63-638f35d14c3f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.9E.18644.0D53F836; Tue,  6 Dec 2022 21:30:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221206123008epsmtip216a83ea9ae94423a36d346bd6a22284d~uNBxeFT2D3142831428epsmtip2F;
        Tue,  6 Dec 2022 12:30:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH liburing 1/2] test/io_uring_passthrough: fix iopoll test
Date:   Tue,  6 Dec 2022 17:48:30 +0530
Message-Id: <20221206121831.5528-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206121831.5528-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7bCmlu5F0/5kg5kzZS1W3+1ns3jXeo7F
        4uj/t2wOzB6Xz5Z69G1ZxejxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
        gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGzUvTGAse8VbM6nzK2MA4ibuLkZNDQsBE4s+ra4xd
        jFwcQgK7GSUOrG5nhXA+MUq0tt1kB6kSEvjMKDHlUjFMx4X3L1kginYxSnTOOckG4QAVffx8
        kqmLkYODTUBT4sLkUpAGEQFhif0drSwgYWYBR4n1x1RBwsICHhKd55cygdgsAqoSl5feZQSx
        eQXMJf7fW80EsUteYual7+wgrZwCFhJNHy0hSgQlTs58wgJiMwOVNG+dzQxygYTANnaJJdM/
        sUH0ukjMfP6CEcIWlnh1fAs7hC0l8bK/DcpOlrg08xzUrhKJx3sOQtn2Eq2n+pkhTtaUWL9L
        H2IXn0Tv7ydgD0oI8Ep0tAlBVCtK3Jv0lBXCFpd4OGMJlO0h8eB7PzMkcLoZJR4ePs02gVF+
        FpIXZiF5YRbCtgWMzKsYJVMLinPTU4tNC4zzUsvhsZqcn7uJEZzWtLx3MD568EHvECMTB+Mh
        RgkOZiUR3hcbe5OFeFMSK6tSi/Lji0pzUosPMZoCg3gis5Rocj4wseaVxBuaWBqYmJmZmVga
        mxkqifMundKRLCSQnliSmp2aWpBaBNPHxMEp1cDEl7kxxvZ2doWY9/tbl2Y3nbyc6bN+keBP
        vQsymTdShabFGgttvbvuWPAay8I7Sfd1JrmEtzf9emwt9OmBycKV29oNGy/tMtfWUhW+q5k1
        sV7FuvHcpKjd9yNP+ETvCmg7EJ85V88047BWzOnLIV3rBfsCtG7mBOtcVROTaDR4o+n16fDf
        aw+nGT/py0h0u3/skrH9vUOaTPOOBAjcdj/7y0tIPZvThHvx8g2vrztf6V9buuVL0oSwHZsN
        r5nFfffuadb6Uj1tzSyOzJcOZ6dwqK+SWPho577of35TFU9uEn84YWJx7uY2F9HmiL5P8al7
        T/lw1f3lzmY1PLmWYWLQNU1vvaNzoqzcXQrPp5UpsRRnJBpqMRcVJwIAeeODxfQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSvO5F0/5kg/fyFqvv9rNZvGs9x2Jx
        9P9bNgdmj8tnSz36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+alaYwFj3grZnU+ZWxgnMTd
        xcjJISFgInHh/UuWLkYuDiGBHYwSR1ZvY4ZIiEs0X/vBDmELS6z895wdougjo8Txue1ADgcH
        m4CmxIXJpSA1IkA1+ztaWUBsZgFniUl/XzGC2MICHhKd55cygdgsAqoSl5feBYvzCphL/L+3
        mglivrzEzEvfwUZyClhINH20BAkLAZWcvrQUqlxQ4uTMJ1Dj5SWat85mnsAoMAtJahaS1AJG
        plWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMEhqaW1g3HPqg96hxiZOBgPMUpwMCuJ
        8L7Y2JssxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA1P6
        nx3b74T92W9Y+iWdo+34187v5bmvBYK7Hjvsu/C+b5ly/flqlYapi459q+q9+mqHU+GF95Ok
        vFvFXbgXsZVliz5omdbxc19o9b3wn2eV5F90TM7/LRjn1NyZtNaEMWn98rocmyPnzqqWhV17
        adlktqj19oMfHs9aXp7hsNiSYTqlYp9C7oZLd1NlfT8umPc3PUUj9Mwbhg2TfE8zHjix2Gtj
        Z63vvzeCT80/WU/w2tjUNWvy/X4fB3Mjp+g7ogUeC69sLN67d7vLnVoTJe5008WB79MVN9+w
        ffv1f2Qao+zBl6+W3Oh/+MJK0ujJ/kMKtw+c39tQ9/xeRqVzwYX38lNFQv4U3lrec7GmMfOR
        EktxRqKhFnNRcSIAOzXHKLgCAAA=
X-CMS-MailID: 20221206123009epcas5p4d65eca3320f9845e190fc425a06799a6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221206123009epcas5p4d65eca3320f9845e190fc425a06799a6
References: <20221206121831.5528-1-joshi.k@samsung.com>
        <CGME20221206123009epcas5p4d65eca3320f9845e190fc425a06799a6@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iopoll test is broken as it does not initialize the command/sqe properly
before submission.
Add the necessary initialization to set this right.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 test/io_uring_passthrough.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 9c71586..b58feae 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -350,6 +350,8 @@ static int test_io_uring_submit_enters(const char *file)
 	int fd, i, ret, ring_flags, open_flags;
 	unsigned head;
 	struct io_uring_cqe *cqe;
+	struct nvme_uring_cmd *cmd;
+	struct io_uring_sqe *sqe;
 
 	ring_flags = IORING_SETUP_IOPOLL;
 	ring_flags |= IORING_SETUP_SQE128;
@@ -369,12 +371,28 @@ static int test_io_uring_submit_enters(const char *file)
 	}
 
 	for (i = 0; i < BUFFERS; i++) {
-		struct io_uring_sqe *sqe;
 		off_t offset = BS * (rand() % BUFFERS);
+		__u64 slba;
+		__u32 nlb;
 
 		sqe = io_uring_get_sqe(&ring);
-		io_uring_prep_writev(sqe, fd, &vecs[i], 1, offset);
-		sqe->user_data = 1;
+		io_uring_prep_readv(sqe, fd, &vecs[i], 1, offset);
+		sqe->user_data = i;
+		sqe->opcode = IORING_OP_URING_CMD;
+		sqe->cmd_op = NVME_URING_CMD_IO;
+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+
+		slba = offset >> lba_shift;
+		nlb = (BS >> lba_shift) - 1;
+
+		cmd->opcode = nvme_cmd_read;
+		cmd->cdw10 = slba & 0xffffffff;
+		cmd->cdw11 = slba >> 32;
+		cmd->cdw12 = nlb;
+		cmd->addr = (__u64)(uintptr_t)&vecs[i];
+		cmd->data_len = 1;
+		cmd->nsid = nsid;
 	}
 
 	/* submit manually to avoid adding IORING_ENTER_GETEVENTS */
-- 
2.25.1

