Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33355EF55C
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiI2MZJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbiI2MYx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:24:53 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22D526AD5
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:24:48 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220929122446epoutp03da575733182cd0feeba8bb53fa8761aa~ZVFr5Z8Ca2068720687epoutp03k
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:24:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220929122446epoutp03da575733182cd0feeba8bb53fa8761aa~ZVFr5Z8Ca2068720687epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454287;
        bh=kslegbVgJtIIf+TJbQuizRtJPWkwJq7sepMKs3FyoAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6k9gGdBj2immi03/ArMkQnKrm0sMHHyoTTPR/5EIBMes3qy1RHroCRgjCo0/d/MP
         6a5FQ5bpDM6z27FwZzyC1DIXpBtZaeGOqH2/B0Nl4MtcWoElOU53huwCuDhh1nZmBL
         SddZk+2cm/Rrv3SBJe01V4XCeFvWFzXKa139SFFo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220929122446epcas5p2353f2f2284a5c794ab883c28b63ea082~ZVFrlMHKe2510225102epcas5p23;
        Thu, 29 Sep 2022 12:24:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MdXcD13mbz4x9Pp; Thu, 29 Sep
        2022 12:24:44 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.43.26992.B8E85336; Thu, 29 Sep 2022 21:24:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929121715epcas5p488759f34f6e55d940c6dca523e24f464~ZU-Hb9wl03132331323epcas5p4J;
        Thu, 29 Sep 2022 12:17:15 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220929121715epsmtrp1cae91d15790f2c4884ffe2d3ef5f48e6~ZU-HbMwLp1820918209epsmtrp1_;
        Thu, 29 Sep 2022 12:17:15 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-a4-63358e8b83e7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.3C.18644.BCC85336; Thu, 29 Sep 2022 21:17:15 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121714epsmtip1513c033d52b1dce33f68bee347e1822d~ZU-GHrcqK3029230292epsmtip11;
        Thu, 29 Sep 2022 12:17:13 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 13/13] nvme: Use blk_rq_map_user_io helper
Date:   Thu, 29 Sep 2022 17:36:32 +0530
Message-Id: <20220929120632.64749-14-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmum53n2mywe4TWhZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYjHp0DVGi723tC3mL3vKbtF9fQebA6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOaD0xibXgBWfF2xf7GRsYf7B3MXJySAiYSBy8vZS5i5GLQ0hgN6PE
        sp8NbBDOJ0aJfR1dTBDOZ0aJt6ePwbVsPfweKrGLUWL5kVcIVWdPTQWrYhNQlzjyvJURxBYR
        MJLY/+kkK0gRs8AmRolf148xgSSEBdwlNm+5D1bEIqAq8ejtG1YQm1fASuLFzpVMEOvkJWZe
        +g42lBMovvjaHKgaQYmTM5+wgNjMQDXNW2eDfSEh8JVd4tKHJhaIZheJW8+OQ90tLPHq+BYo
        W0riZX8blJ0u8ePyU6hlBRLNx/YxQtj2Eq2n+oGGcgAt0JRYv0sfIiwrMfXUOiaIvXwSvb+f
        QLXySuyYB2MrSbSvnANlS0jsPdcAZXtIHGzZDQ3gXkaJcx0PmCcwKsxC8s8sJP/MQli9gJF5
        FaNkakFxbnpqsWmBYV5qOTyek/NzNzGCE6qW5w7Guw8+6B1iZOJgPMQowcGsJMIrXmCaLMSb
        klhZlVqUH19UmpNafIjRFBjgE5mlRJPzgSk9ryTe0MTSwMTMzMzE0tjMUEmcd/EMrWQhgfTE
        ktTs1NSC1CKYPiYOTqkGptr/n/cqFlwwOt8+b128bE0pj/E877md8zd2cn5T8LsXZXE051Ch
        FfNDh+WXH3/00dzyfoGsR4eK0/Elh/JDmK+eO3Je6uvRewoBbzk3Mc8VNbpWkLsu1Yld8Zj7
        PoUtHDuWHlc/GH5E1vPV5lu8CTYSTumr2BPcGfpq+hY85NY71GZxYsWE4HxPIW/f5xriu/wN
        72ksvDi/+pCo7IW9+1LPzd/ecW7CUxFtTtamVK06C+t3n9+bzVpf9l12v7FAROb/zFb+S+WR
        AkH2pgfeXt68VuJAfP3uy45s+jE27JceWbD9nHJWh6/aeuunAJcr+w1uTvu8pyxC49nmoyl7
        lD04+B99EfeLVNmXPlnugxJLcUaioRZzUXEiAO9l1FwxBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO7pHtNkg/fnpC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MpoPTGJteAFZ8XbF/sZGxh/sHcxcnJICJhI
        bD38ngnEFhLYwSgx4wAXRFxC4tTLZYwQtrDEyn/Pgeq5gGo+Mkosv3QTrJlNQF3iyPNWsCIR
        ATOJpYfXsIAUMYMMWvdsMVhCWMBdYvOW+2A2i4CqxKO3b1hBbF4BK4kXO1cyQWyQl5h56TvY
        UE6g+OJrc4BqOIC2WUpsv6kAUS4ocXLmExYQmxmovHnrbOYJjAKzkKRmIUktYGRaxSiZWlCc
        m55bbFhglJdarlecmFtcmpeul5yfu4kRHOxaWjsY96z6oHeIkYmD8RCjBAezkgiveIFpshBv
        SmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1Mi3clRk0SYV4b
        kPrVI2qif/GzhKa2z/qCC+vU0/9P+X7tZfBhzz7f3fdymnR0lMT+FudO2vD0evUj10kvlstX
        /5Hp/emSafP2icr2ZXttjx0P19TLnCPTn/tBYuGWxI9GmtY7Z3IdWGmj5jnVb9+phf8CFWt2
        xfNsU/dd8SdePqqf9XXv0gD7g/Jzbs1a1+uzW6v8xWXJxOmTt329fe36jlX9Wx/yJq3R/1h4
        5Pz/VaosB0+YrNk2d8H2bdwienN7J3bvXNkrzLJQtC8gKbfP8dpPx7Kf9esveBSJX5Tlm3P4
        a87j9IBnqp+bmk4HcDR/fPrw4W/TaP+tizZmZDtdyxWIFGsvn39A8k/I/AlJvkosxRmJhlrM
        RcWJALotnFDlAgAA
X-CMS-MailID: 20220929121715epcas5p488759f34f6e55d940c6dca523e24f464
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121715epcas5p488759f34f6e55d940c6dca523e24f464
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121715epcas5p488759f34f6e55d940c6dca523e24f464@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

User blk_rq_map_user_io instead of duplicating the same code at
different places

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 25a68e8c60db..a3f22bbe511a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -106,21 +106,12 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		if (ret < 0)
 			goto out;
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
-	} else if (vec) {
-		struct iovec fast_iov[UIO_FASTIOV];
-		struct iovec *iov = fast_iov;
-		struct iov_iter iter;
-
-		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
-				bufflen, UIO_FASTIOV, &iov, &iter);
-		if (ret < 0)
-			goto out;
-		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
-		kfree(iov);
 	} else {
-		ret = blk_rq_map_user(q, req, NULL,
-				nvme_to_user_ptr(ubuffer), bufflen, GFP_KERNEL);
+		ret = blk_rq_map_user_io(req, NULL, nvme_to_user_ptr(ubuffer),
+				bufflen, GFP_KERNEL, vec, 0, 0,
+				rq_data_dir(req));
 	}
+
 	if (ret)
 		goto out;
 	bio = req->bio;
-- 
2.25.1

