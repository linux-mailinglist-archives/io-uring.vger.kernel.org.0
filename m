Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE430605E
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 16:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhA0P6X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 10:58:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18791 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhA0PCj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 10:02:39 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210127150145epoutp024afcc701094a32d28dd03b7fbf244dfa~eHum2DK-70176501765epoutp02l
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 15:01:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210127150145epoutp024afcc701094a32d28dd03b7fbf244dfa~eHum2DK-70176501765epoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611759705;
        bh=qDFCbUu7mCmhIQNv7XiLqxaYQTf9AOTX3utazaqJrYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGS0kR++QZe4O1Zq1hNZRXrX1OilDFr/+pycsQlZhe+PxwmWevtYCTtAvULekJafC
         5luLqsV34ZQACY5M/XauTl2XIi4bg6cThlOfRkJrJSPHIMG2QegbJAtH0KwBG2f3OW
         tM0gXrCrLT74l/79yGXy4V2dHYpTVb8NB+iZPa/Y=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210127150145epcas5p38b2fbd59dddcb8a6d91326fd5b74ce9a~eHumRu10w0898508985epcas5p3Z;
        Wed, 27 Jan 2021 15:01:45 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.F8.50652.95081106; Thu, 28 Jan 2021 00:01:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150144epcas5p29ccb35d7e7170aba7947b5ee16fd2db0~eHulPqUp80627206272epcas5p2I;
        Wed, 27 Jan 2021 15:01:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210127150144epsmtrp12f6e3f4430a280ee7acb8444459c6b28~eHulOzQAq0033500335epsmtrp1o;
        Wed, 27 Jan 2021 15:01:44 +0000 (GMT)
X-AuditID: b6c32a4a-6b3ff7000000c5dc-98-60118059bdc0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.05.13470.75081106; Thu, 28 Jan 2021 00:01:43 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150141epsmtip22609fef0295d7e19992f935dc198e3c3~eHujKTNWv2088420884epsmtip2M;
        Wed, 27 Jan 2021 15:01:41 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 2/4] kernel: export task_work_add
Date:   Wed, 27 Jan 2021 20:30:27 +0530
Message-Id: <20210127150029.13766-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127150029.13766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmum5kg2CCwbnnLBa/p09htVh9t5/N
        YuXqo0wW71rPsVg8vvOZ3eLo/7dsFpMOXWO02LP3JIvF5V1z2CzmL3vKbrHt93xmiytTFjFb
        rHv9nsXi9Y+TbA58HufvbWTxuHy21GPTqk42j81L6j1232xg8+jbsorR4/MmuQD2KC6blNSc
        zLLUIn27BK6Ml4vXsBccYa040LqEuYHxOEsXIyeHhICJxKrt39hBbCGB3YwSjWcMIexPjBKP
        p3F3MXIB2d8YJTbef84I03DjQQsrRGIvo8SVa1+gnM+MEkd63wON5eBgE9CUuDC5FKRBRMBF
        4sLvA+wgNcwC7xglzt/bAjZJWMBUYtbpDjCbRUBV4vj500wgNq+AhcScH9vZILbJS8y89B3s
        PE4BS4kr2zaxQtQISpyc+QTsBWagmuats5lBFkgIrOSQODFxAtRvLhKnb0xghbCFJV4d38IO
        YUtJvOxvg7KLJX7dOQrV3MEocb1hJlSzvcTFPX+ZQL5hBvpm/S59iGV8Er2/n4CFJQR4JTra
        hCCqFSXuTXoKtUpc4uGMJVC2h8SqKUdYIAHUwyix9sc79gmM8rOQ/DALyQ+zELYtYGRexSiZ
        WlCcm55abFpglJdarlecmFtcmpeul5yfu4kRnK60vHYwPnzwQe8QIxMH4yFGCQ5mJRFeOwXB
        BCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8OwwexAsJpCeWpGanphakFsFkmTg4pRqYTPgtL5xv
        eXQ4VywtP53rYWXGkS6JdenunPtm2ld+/X3iUdEXO3PGkAtJ+jN5t+suaOncUWantU+H95wk
        85dDAQIvw0965ex7f3TW8rC134NNZ7QvunSMI0c+LSRR/fzMv8+PNs8KF2w/fGbK+m/L9RXs
        xCr7ckqkNHb/1d46QbOhYf2xWhVlRSVmrskcwg8D/u1sahebXmA9tyZBykI3eeGnL0XWi2Y4
        eYXN5vur8fRRyScDpp18K65NdqpbsO6ycqxABxv3PBftr2/zjnc8duLPElb7ZN6f4jnnpatR
        p+Lx2XYm65MPvanQuaaiIRNUuyfjl/FdGfaEYpU7h+fvOu5/PnmZ1krtba8lZzMrsRRnJBpq
        MRcVJwIAget2JsYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSvG54g2CCwew9Zha/p09htVh9t5/N
        YuXqo0wW71rPsVg8vvOZ3eLo/7dsFpMOXWO02LP3JIvF5V1z2CzmL3vKbrHt93xmiytTFjFb
        rHv9nsXi9Y+TbA58HufvbWTxuHy21GPTqk42j81L6j1232xg8+jbsorR4/MmuQD2KC6blNSc
        zLLUIn27BK6Ml4vXsBccYa040LqEuYHxOEsXIyeHhICJxI0HLaxdjFwcQgK7GSXO7vrFDJEQ
        l2i+9oMdwhaWWPnvOTtE0UdGiZ0rzgB1cHCwCWhKXJhcCmKKCHhJbFtqCFLCLPCNUWLN2lOs
        IL3CAqYSs053MILYLAKqEsfPn2YCsXkFLCTm/NjOBjFfXmLmpe9guzgFLCWubNsE1isEVPN+
        wkM2iHpBiZMzn4AdzQxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0u
        zUvXS87P3cQIjhUtzR2M21d90DvEyMTBeIhRgoNZSYTXTkEwQYg3JbGyKrUoP76oNCe1+BCj
        NAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQam49ppVx/bRb5XXlqZLV+cb734WUqHGWfw
        6vCnG+JW/9OYJeBokP/CrrF727vU79eTWRovpk0/eONun+TvuCVrmg6qL/97TbrmWc7khR7F
        f7LbXTnevQ/al7n8RkZBhoTZH1XL/VxPWV55L8lZmr+2YGftuT9NFXscLN7v9Fu3gPWMs9DV
        fyx7rS5OKX+Q/K3fxGL2jKOn7b1fvitxWNHmXX6asVrOz8D93L/TKWw5y36ueZ9X/l7U8fn1
        iQFChv9elK00ar12OnvX/Jcv66esZrS4wSLnxPx6fvFrz42rRaM3HQ4WiX78t/HPDNstToKu
        yrt0P75Sfu923S7/9IYPGScFfQz3ZTCZbpaf/8+FSYmlOCPRUIu5qDgRACIMJm4EAwAA
X-CMS-MailID: 20210127150144epcas5p29ccb35d7e7170aba7947b5ee16fd2db0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210127150144epcas5p29ccb35d7e7170aba7947b5ee16fd2db0
References: <20210127150029.13766-1-joshi.k@samsung.com>
        <CGME20210127150144epcas5p29ccb35d7e7170aba7947b5ee16fd2db0@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Task-work infra is required to introduce async-ioctl in nvme driver.
Without this being exported, NVMe needs to be built statically.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 kernel/task_work.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 9cde961875c0..3cf413c89639 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -57,7 +57,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(task_work_add);
 /**
  * task_work_cancel - cancel a pending work added by task_work_add()
  * @task: the task which should execute the work
-- 
2.25.1

