Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86470ED67
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 07:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbjEXFzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 01:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbjEXFzG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 01:55:06 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6C1189
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 22:55:02 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230524055500epoutp017a7ddcec585a5a623449a139efb9c4ca~h-qBTsFCo0756907569epoutp01n
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 05:55:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230524055500epoutp017a7ddcec585a5a623449a139efb9c4ca~h-qBTsFCo0756907569epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684907700;
        bh=J4+LQ/UAKS8+jVjqkeJWuZbYOOgodEqPFkZK+cZDsWU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=LTvVvqURnqmE9bgBhwWbvqGSWvlKleZ3WTp1HrIBYl+WFQONhZ6H9Kw4fhfXIzCEJ
         9EG0zYGw80bXOhYhue7P6dfN+YtKvNm3hxgjqYfKP6i0cTE5WsL4pJEQMSJ3O+C/n4
         wzzU8CyLH2ZW3AguZ8qSMrvJSFdWdPyfz3eDvH/I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230524055459epcas5p4a1b415e4d38e355cf83a50d8b4c6d382~h-qA9Fp_L1898118981epcas5p4F;
        Wed, 24 May 2023 05:54:59 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QR0l64vVmz4x9Pt; Wed, 24 May
        2023 05:54:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.5A.16380.1B6AD646; Wed, 24 May 2023 14:54:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230524052154epcas5p313d92a9cbf0fa7e9555f8dd00125539e~h-NIFeian0102801028epcas5p3S;
        Wed, 24 May 2023 05:21:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230524052154epsmtrp21e1757f7590fa453964b96bce8dd896c~h-NIEvmUy1813918139epsmtrp2I;
        Wed, 24 May 2023 05:21:54 +0000 (GMT)
X-AuditID: b6c32a4b-7dffd70000013ffc-2f-646da6b1e5ec
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.E6.27706.2FE9D646; Wed, 24 May 2023 14:21:54 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.125]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230524052153epsmtip19bcad476527030e698c9ff7f23a9be08~h-NHTCb0h0438204382epsmtip1b;
        Wed, 24 May 2023 05:21:53 +0000 (GMT)
From:   Wenwen Chen <wenwen.chen@samsung.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Wenwen Chen <wenwen.chen@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH] io_uring: unlock sqd->lock before sq thread release CPU
Date:   Wed, 24 May 2023 13:28:01 +0800
Message-Id: <20230524052801.369798-1-wenwen.chen@samsung.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmhu7GZbkpBl2H5CzmrNrGaLH6bj+b
        xbvWcywWR/+/ZbP41X2X0eLshA+sFlO37GByYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
        mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
        KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtjwcqN
        TAW9XBWPv1s1MC7n6GLk4JAQMJE43xLaxcjFISSwm1Gi/fELdgjnE6PEzC1NUM43RomuDSuB
        HE6wjoVrrrBAJPYySvztvgzlfGWUOLHpKFgVm4C2xPu1LYwgtgiQ/frxVBYQm1kgS+LS229g
        NcICHhLrtk5gA7FZBFQlWubeAKvhFbCVWLwaoldCQF5i4uy7jBBxQYmTM59AzZGXaN46mxmi
        5hi7xJ+nHBC2i8TuvuNsELawxKvjW6CulpL4/G4vVLxYYuLBL2CvSQg0MEocv/iVBSJhLfHv
        yh4WUMAwC2hKrN+lDxGWlZh6ah0TxF4+id7fT5gg4rwSO+bB2KoSZ5+fY4WwpSVa5jRAxT0k
        Jpy/DHaDkECsxL4N+9gnMMrPQvLOLCTvzELYvICReRWjZGpBcW56arFpgXFeajk8XpPzczcx
        gpOhlvcOxkcPPugdYmTiYDzEKMHBrCTCe6I8O0WINyWxsiq1KD++qDQntfgQoykwjCcyS4km
        5wPTcV5JvKGJpYGJmZmZiaWxmaGSOK+67clkIYH0xJLU7NTUgtQimD4mDk6pBia9ObHywusz
        30+pylYtdz5zhn/9NV4W849Gye5HdzmzWNt087M3fmxW2pK+7dusW1Hhpw7ceM7otrCY9fZX
        q+vLn3DNOxEYfHqpk8DbA6HLnVb6MJSJpYR2bLbdMElsKguP57Fcts/a0m5mN8O6N9RJRJpU
        nltpWSJ8uZN5w27x71PLVzxbznwlyMnMMJN7p+OVDXkMi/UEPUPm+ayYIjY3y2e2YYzxD4Yt
        7bbmPe1yDVV5fxxf7JY9ms2ze0e4x1Hlu64CH69OePWMpWPBfsf8t5Es1VYC/jMrA3PPT+Sd
        Vq7gFJdXd4LXa3qmOX/Xx+Mz225ob83Sv6Orof3URKGToyD1oNCPNO9P+2oXKLEUZyQaajEX
        FScCAMHsXTMPBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsWy7bCSnO6nebkpBh/WyVrMWbWN0WL13X42
        i3et51gsjv5/y2bxq/suo8XZCR9YLaZu2cHkwO6xc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYl
        NSezLLVI3y6BK2PByo1MBb1cFY+/WzUwLufoYuTkkBAwkVi45gpLFyMXh5DAbkaJBe82MkEk
        pCUOXfvMCmELS6z895wdougzo8SR45PAitgEtCXer21h7GLk4BAR0JVovKsAEmYWyJG4ee09
        C4gtLOAhsW7rBDYQm0VAVaJl7g2wOK+ArcTi1SCtIPPlJSbOvssIEReUODnzCQvEHHmJ5q2z
        mScw8s1CkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwWGpp7mDcvuqD
        3iFGJg7GQ4wSHMxKIrwnyrNThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2a
        WpBaBJNl4uCUamBi3O8YZisYxR1vd6zr8e/eeecLzv7VUbPyd7o810V+Yvvp3oSyJQrn01R+
        3zK/yx666OYJxgWfVhtt8vPy3W+z8ueZZQyvv5TtadvvdkZ8FpfMmTXhvYcjEj9+nxKge6ji
        D7vyb9G6x0s99mRtWeeRxRu2h8s/Xdtp6Znchq2KX0y6bnjOlfXk5TULCf7x48I25bOW4RvT
        /no+nPrRtna6QdrG8sJkGbWVvf8Ohmh+W7X65uLGluZEzXCWcu4pv5ac7ykPn2RdJ7phg7Dv
        45y5+RdlHvK0nf2+sCjV4OK5c8V7osPNUt+d432TlXv4oUtV4QOPskmbvl99wf0jTIk19Pq6
        x5d/uG1ZlXHT5MsPJZbijERDLeai4kQA0A8k0boCAAA=
X-CMS-MailID: 20230524052154epcas5p313d92a9cbf0fa7e9555f8dd00125539e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230524052154epcas5p313d92a9cbf0fa7e9555f8dd00125539e
References: <CGME20230524052154epcas5p313d92a9cbf0fa7e9555f8dd00125539e@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The sq thread actively releases CPU resources by calling the 
cond_resched() and schedule() interfaces when it is idle. Therefore,
more resources are available for other threads to run.

There exists a problem in sq thread: it does not unlock sqd->lock before
releasing CPU resources every time. This makes other threads pending on
sqd->lock for a long time. For example, the following interfaces all 
require sqd->lock: io_sq_offload_create(), io_register_iowq_max_workers()
and io_ring_exit_work().
       
Before the sq thread releases CPU resources, unlocking sqd->lock will 
provide the user a better experience because it can respond quickly to
user requests.

Signed-off-by: Kanchan Joshi<joshi.k@samsung.com>
Signed-off-by: Wenwen Chen<wenwen.chen@samsung.com>
---
 io_uring/sqpoll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..759c80fb4afa 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -255,7 +255,9 @@ static int io_sq_thread(void *data)
 			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
+			mutex_unlock(&sqd->lock);
 			cond_resched();
+			mutex_lock(&sqd->lock);
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
 			continue;
