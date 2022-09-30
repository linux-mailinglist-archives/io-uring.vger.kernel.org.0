Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67735F0513
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiI3GoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiI3Gnw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:43:52 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC1BC77C9
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:43:51 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220930064349epoutp02503941deb2957b33975ca8066e342e9b~ZkFRp6tJ80356003560epoutp026
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220930064349epoutp02503941deb2957b33975ca8066e342e9b~ZkFRp6tJ80356003560epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520229;
        bh=WITDi33ml99AN+RGdGVtg2lKafCL3RqyWwE1SQoSUh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3fCFxajJ7LCZMpzJmJUpwj7PdCggnnGqnVUk1DIMgxWly9VHc9ROpolURY/iIJFK
         nchtI7UXb8jw0v7Msr/qYjGKuroQ5b5Wf+H9h7V1OTfwYvcjVjgriS6HtpfQpBw7S0
         SFYdgzzpuQt7iyXAv/8T+uHxdcOZWwPHpPZA51qQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220930064348epcas5p1eafe37e427728f0cad44d70610bfb76c~ZkFQ2XQ0m1245912459epcas5p1J;
        Fri, 30 Sep 2022 06:43:48 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mf10J3dZxz4x9QF; Fri, 30 Sep
        2022 06:43:44 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.C1.56352.F1096336; Fri, 30 Sep 2022 15:43:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063818epcas5p4e321f0efa5a53759ea19eb8f1c63deef~ZkAdQ7OlH2578525785epcas5p4Q;
        Fri, 30 Sep 2022 06:38:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220930063818epsmtrp2a492bfbec5c70d3905530c31b54b44aa~ZkAdQGGWy2225522255epsmtrp2G;
        Fri, 30 Sep 2022 06:38:18 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-5b-6336901f972d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.69.14392.ADE86336; Fri, 30 Sep 2022 15:38:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063816epsmtip20492c0efc41135e268a92438ef82aefc~ZkAb3nZUD1763417634epsmtip2E;
        Fri, 30 Sep 2022 06:38:16 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 05/12] nvme: Use blk_rq_map_user_io helper
Date:   Fri, 30 Sep 2022 11:57:42 +0530
Message-Id: <20220930062749.152261-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmuq78BLNkg4lH2C2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdcbF3JmPBMs6KT2dfszYwbmfvYuTgkBAwkfg4zbiLkYtDSGA3o8TW
        /3MYuxg5gZxPjBIH/1tC2N8YJea9ZQexQeqX3z7JCtGwl1FiactDRgjnM6NEy6mfzCBVbALq
        Ekeet4JNEhEwktj/CaKDWWATo8Sv68eYQFYLC7hLrNzhA1LDIqAqMXX3LlYQm1fASmL5sRls
        ENvkJWZe+g52KaeAtUTzohyIEkGJkzOfsIDYzEAlzVtnM4OMlxD4yy7xc9lkZoheF4ltU25D
        XS0s8er4FihbSuLzu71Q89Mlflx+ygRhF0g0H9vHCGHbS7Se6mcG2cssoCmxfpc+RFhWYuqp
        dUwQe/kken8/gWrlldgxD8ZWkmhfOQfKlpDYe64ByvaQ2Pf4JQskrPoYJVZ+W846gVFhFpJ/
        ZiH5ZxbC6gWMzKsYJVMLinPTU4tNC4zzUsvhUZycn7uJEZxGtbx3MD568EHvECMTB+MhRgkO
        ZiURXvEC02Qh3pTEyqrUovz4otKc1OJDjKbA8J7ILCWanA9M5Hkl8YYmlgYmZmZmJpbGZoZK
        4ryLZ2glCwmkJ5akZqemFqQWwfQxcXBKNTC5tVb9mHrIXjr0TFjDaqPAndvP3plt/KSb5aad
        ckFqzpff1aYcIXPUrLs6dhbKG9o8m8h1+cKitOdtUbd/7FWZJuo6+eHHqxt72hxfrJ5RuF5Q
        4dXqH5dOsOl1z167Sd2kTqTG/ojN+9feayfstJRt/SYRycNVUyPKV5/ol+CXsvZY5bxFShPs
        thyY4sHPcqDzvnlD1KSE52JN35r4J5t6+i/zzch9qHJz91vriqB98+bIzn8SuDr3/DHFDJbg
        jrb35VN3OFewH93U4rNvftTvRRxab2M551/4cNVOS0rDjV2X3edwT9ieXFEla34V/tZPBk7L
        y4NcDk4y0tU5kSu0xrbku8+51Pvbly5exqfEUpyRaKjFXFScCAA5K1imLAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO6tPrNkg5ubhS2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mq42DuTsWAZZ8Wns69ZGxi3s3cxcnJICJhI
        LL99krWLkYtDSGA3o8T/z9vYIBISEqdeLmOEsIUlVv57zg5R9JFR4vS55UwgCTYBdYkjz1vB
        ikQEzCSWHl7DAlLELLCDUWLds8VACQ4OYQF3iZU7fEBqWARUJabu3sUKYvMKWEksPzYDapm8
        xMxL39lByjkFrCWaF+WAhIWASj7vec8OUS4ocXLmExYQmxmovHnrbOYJjAKzkKRmIUktYGRa
        xSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHOxamjsYt6/6oHeIkYmD8RCjBAezkgiv
        eIFpshBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1M6U3z
        VuVuyAtQ8bW8mnX+mZIeV40Bd6yrnOyPxXKWZcExAk+fZF3eKBKUdPHfPZ5zx3942rCoLHpe
        F7meZ2dtyaIy8+mb7A+X6F/fHxO75+SFwG2Z307Ub7QXrQ9+t7wz+e68DdKiPRHTIuzqdj7e
        ZcpeffH+lMInzu1ss6LXFx0rPLIt8ef2zoI9olLLHMsExG3blC/oRsxMPnfQs02YMfDjiUvd
        ps+kpqU9V/2hx73/0vH4BVwZHuFxQVOSj56Wdp17XCy0PzpRdXEy7960b+JffJ+7bpghMOnM
        ZsN1r9kk/+SFrG2subS/7+fEifPmvf2g8+nJtqc7HM4or96bsYLLfepDDnv9nh0rLqfFKrEU
        ZyQaajEXFScCAD4LOrTlAgAA
X-CMS-MailID: 20220930063818epcas5p4e321f0efa5a53759ea19eb8f1c63deef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063818epcas5p4e321f0efa5a53759ea19eb8f1c63deef
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063818epcas5p4e321f0efa5a53759ea19eb8f1c63deef@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

User blk_rq_map_user_io instead of duplicating the same code at
different places

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 914b142b6f2b..3746a02a88ef 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -88,22 +88,8 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	nvme_req(req)->flags |= NVME_REQ_USERCMD;
 
 	if (ubuffer && bufflen) {
-		if (!vec)
-			ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
-		else {
-			struct iovec fast_iov[UIO_FASTIOV];
-			struct iovec *iov = fast_iov;
-			struct iov_iter iter;
-
-			ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-					UIO_FASTIOV, &iov, &iter);
-			if (ret < 0)
-				goto out;
-			ret = blk_rq_map_user_iov(q, req, NULL, &iter,
-					GFP_KERNEL);
-			kfree(iov);
-		}
+		ret = blk_rq_map_user_io(req, NULL, ubuffer, bufflen,
+				GFP_KERNEL, vec, 0, 0, rq_data_dir(req));
 		if (ret)
 			goto out;
 		bio = req->bio;
-- 
2.25.1

